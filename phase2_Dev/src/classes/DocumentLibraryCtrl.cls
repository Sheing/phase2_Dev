public class DocumentLibraryCtrl {
    
    public List<Document__c> documentsList { get; set; }
    public List<DocumentWrapper> documentWrapperList { get; set; }
    public Document__c activeDocument { get; set; }
    public String docId { get; set; }
    public String mode { get; set; }
    public String accessKey { get; set; }
    public String s3FileJson { get; set; }
    public String documentJson { get; set; }
    public String origFile { get; set; }
      
    private Account provider { get; set; }
    
    public class DocumentWrapper{
        public Document__c document{get;set;}
        public integer trandocCount{get;set;}
    }
    public DocumentLibraryCtrl() {  
      this.accessKey = new AWSKeys('eec').key; 
      this.docId = ApexPages.currentPage().getParameters().get('id');  
      this.mode = ApexPages.currentPage().getParameters().get('mode');  
      this.provider = [
        SELECT 
          Id,
          Name, 
          Recordtype.Name, 
          OwnerId 
        FROM 
          Account 
        WHERE 
          ID IN (
            SELECT 
              AccountId 
            FROM 
              USER 
            WHERE 
              id = :Userinfo.getUserId()
          ) 
        LIMIT 1
      ];
      // If a document id is present then present the edit/new component with a new/exisiting document in place.
      if (String.isEmpty(this.docId) || String.isEmpty(this.mode)) {
        retrieveDocumentsForUser();
      } else {
        Document__c doc = retrieveDocument(this.docId);
        this.activeDocument = (doc != null ? doc : new Document__c());
      }
    }
    
    /**
     * retrieveDocumentsForUser
     * 
     * @description This function will reteieve all the documents for a given user logged into the portal.
     *              It will filter out any docs that are out of date
     * @author Darkis
     */
    public void retrieveDocumentsForUser() {
      
      List<Document__c> retList = new List<Document__c>();
      for (Document__c doc : [Select Id, Name, Document_Type__r.Name, Notes__c, 
                                CreatedDate, Approved_for_Future_Usage__c, 
                                 Provider__c From Document__c 
                              Where CreatedById = :UserInfo.getUserId()]) {
           /*if (doc.Out_Of_Date__c == null) { 
               retList.add(doc); 
           } else {
               if (doc.Out_Of_Date__c >= System.now()) {
                   retList.add(doc);
               }
           }*/
      }
      
      AggregateResult[] listTranDocument = [select count(Id),Document__c  from Transaction_Document__c where Document__c in : retList
      group by Document__c];
      
      Map<Id, integer> mapDocCount = new Map<Id, integer>();
      for(AggregateResult aggregateResult : listTranDocument ){
          mapDocCount.put(aggregateResult.Id, integer.valueof(aggregateResult.get('expr0')));
      }
      documentWrapperList  = new List<DocumentWrapper>();
      
      for(Document__c document : retList){
          DocumentWrapper documentWrapper = new DocumentWrapper();
          documentWrapper.document = document;
          documentWrapper.trandocCount = mapDocCount.get(document.Id);
          documentWrapperList.add(documentWrapper);
      }
      this.documentsList = retList;
    }
    
    /**
     * retrieveDocument
     * 
     * @description Get a single document.
     * @author Darkis
     */
    public Document__c retrieveDocument(String docId) {
      return [Select Id, Name, Document_Type__r.Name, Notes__c, CreatedDate, Approved_for_Future_Usage__c, Provider__c From Document__c Where Id = :docId];
    }
    
    /**
    * generateS3Link
    * 
    * This function will accept a param and generate the necessary link for presenting the S3 file.
    * @author Nettles
    * @param String origFile The Original File Name of the File that needs to be generated.
    */
    public String generateS3Link() {
      String filename = '';
      S3_File__c file = [Select Id, Filename__c, Prefix__c, Bucket__c From S3_File__c Where filename__c = :origFile];

      if (!String.isBlank(file.Prefix__c)) {
        filename += file.Prefix__c + '/';
      }
      filename += file.Filename__c;

      return EEC_S3ComponentCtrl.generateTempS3Url(file.Bucket__c, filename);
    }
    
    /**
     * markDocumentAsOutOfDate
     * 
     * @description This function will mark the given document as out of date starting today.
     * @author Darkis
     * @param documentId String The ID of the document in question passed in by the UI.
     */
    public PageReference markDocumentAsOutOfDate() {
      String documentId = ApexPages.currentPage().getParameters().get('documentId');
      //System.debug('----> Document Id: ' + documentId);
      try {
          Document__c docToUpdate = new Document__c(
            Id = documentId
            //Out_of_Date__c = Date.today()
          );
          update docToUpdate;
          PageReference p = new PageReference('/PortalDocumentLibrary');
          p.setRedirect(true);
          return p;
      } catch(Exception e) {
        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
        ApexPages.addMessage(errMsg);
        return null;
      }  
      
      
        
    }
    
    /**
     * Save
     * 
     * @description This function will save the updated/new data received from the form.
     * @author Darkis
     */
    public PageReference save() {
      Savepoint sp = Database.setSavepoint();  
        
      try {          
        if (!String.isBlank(s3FileJson) && String.isNotBlank(documentJson)) {
          // Convert the json into S3_Files.
          S3_File__c s3File = (S3_File__c) JSON.deserialize(s3FileJson, S3_File__c.class);
          Document__c newDoc = (Document__c) JSON.deserialize(documentJson, Document__c.class);
          // Create document and link the S3_File__c object to it.   
          newDoc.Content_Type__c = s3File.Content_Type__c;
          //newDoc.Original_File_Name__c = s3File.Filename__c;
          newDoc.Provider__c = provider.Id;
          //System.debug('----> S3 File [New]: ' + s3File);
          //System.debug('----> Active Document [New]: ' + newDoc);
          upsert newDoc;  
          // Upsert the new s3 file object with the document Id in place.
          s3File.Document__c = newDoc.Id;  
          upsert s3File;
        } else {
          //System.debug('----> Active Document [Edit]: ' + this.activeDocument);
          upsert this.activeDocument;    
        }
      } catch(Exception e) {
        //System.debug('-----> Error: ' + e.getMessage());
        Database.rollback(sp);
        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
        ApexPages.addMessage(errMsg);
      }  
      PageReference p = new PageReference('/PortalDocumentLibrary');
      p.setRedirect(true);
      return p;
    }
    
   
    
    public PageReference deleteDocument() {
      String documentId = ApexPages.currentPage().getParameters().get('documentId');
      
      List<Document__c> docToDelete = [Select Id From Document__c Where Id = :documentId];
      List<S3_File__c> s3FileToDelete = [Select Id, Bucket__c, Prefix__c, Filename__c From S3_File__c Where Document__c = :documentId];
              
      delete s3FileToDelete;
      delete docToDelete;
        
      if (s3FileToDelete.size() > 0) {
        // Invoke the future method to delete the object in S3 using the SOAP API.
        deleteS3FileReference(s3FileToDelete.get(0).Bucket__c, s3FileToDelete.get(0).Prefix__c + '/' + s3FileToDelete.get(0).Filename__c);
      }
      // Refresh the page.
      PageReference p = new PageReference('/PortalDocumentLibrary');
      p.setRedirect(true);
      return p;   
    }
    
     /**
   * generateMultiplePolicySignature
   * 
   * This function will call the S3ComponentCtrl to generate multiple or single policy and signature combos for specified files to upload to S3.
   * @author Darkis
   * @param String bucket The name of the bucket to save to.
   * @param String acl The permission level of the file. Typically this would be 'authenticated-read' for our purposes. 
   * @param String fileJson A JSON string of all the files to be uploaded from the Angular Controller.
   */
  @RemoteAction
  public static List<Map<String, String>> generateMultiplePolicySignature(String bucket, String acl, String fileJson) {
    List<Map<String, String>> returnJson = new List<Map<String, String>> ();
    List<EEC_S3ComponentCtrl.FileTypeJsonWrapper> fileTypeWrapperList = (List<EEC_S3ComponentCtrl.FileTypeJsonWrapper>) JSON.deserialize(fileJson, List<EEC_S3ComponentCtrl.FileTypeJsonWrapper>.class);
    // Loop through the files given and get all the necessary policy/sig combos.
    for (EEC_S3ComponentCtrl.FileTypeJsonWrapper wrapper : fileTypeWrapperList) {
      returnJson.add(EEC_S3ComponentCtrl.generatePolicySignature(bucket, acl, wrapper.filename, wrapper.type, null));
    }
    return returnJson;
  }
    
  /**
   * @future
   * deleteS3FileReference
   * 
   * This future function will do a SOAP callout to S3 to delete the file reference provided. 
   * @author Darkis
   * @param String bucketName The name of the bucket the file resides in.
   * @param String filename The name of the file along with any prefixs necessary.
   */
  @future(callout = true)
  public static void deleteS3FileReference(String bucketName, String filename) {
    // Delete the file from S3 using the SOAP API.  
    if (!Test.isRunningTest()) {
      EEC_S3ComponentCtrl.deleteFile(bucketName, filename);
    }
  }
}