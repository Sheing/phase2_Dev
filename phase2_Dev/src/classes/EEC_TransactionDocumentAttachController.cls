public with sharing class EEC_TransactionDocumentAttachController{
  public List<S3_File__c> attachments { get; set; }
  public string generateFileId{get;set;}
  public Transaction_Document__c transactionDocument{get;set;}
       
  public EEC_TransactionDocumentAttachController(ApexPages.StandardController std){
    try {
      transactionDocument = [select Id, Document__c from Transaction_Document__c where Id=: std.getId()];
      attachments = [Select Id, Acl__c, Bucket__c, Content_Type__c, Description__c, Document__c,
      Filename__c,Locked__c,Object_Id__c,Object_Name__c,Prefix__c, CreatedDate
       From S3_File__c Where Document__c = :transactionDocument.Document__c];
    } catch(Exception e) {
      System.debug('----> Error: ' + e.getMessage());
    }
  }
    
  public String genetateS3Link() {
   	String filename = '';
    S3_File__c file = [Select Id, Filename__c, Prefix__c, Bucket__c From S3_File__c Where Id = :generateFileId];

    if (!String.isBlank(file.Prefix__c)) {
      filename += file.Prefix__c + '/';
    }
    filename += file.Filename__c;

    return EEC_S3ComponentCtrl.generateTempS3Url(file.Bucket__c, filename);
  }
}