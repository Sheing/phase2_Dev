public class EEC_DocumentLookupController {

  public String queryStr { get; set; }
  public String docType;
  public String errorMessage { get; set; }
  public String documentId {get; set;}
  public String documentName {get; set;}
  public List<Document__c> queryResults { get; set; }
  public List<DocumentWrapper> listDocumentWrapper { get; set; }
  public String providerId  {get;set;}
  public  String licenseTransationId {get;set;} 
  public Account accDocs{get;set;}
  public Map<Id,Document__c> documentMap;
  public String level{get; set;}  
  public string documentType{get;set;}
  public List<SelectOption> documentTypes{get;set;}
  public string providerType{get;set;}
  
  public class DocumentWrapper{
  	public Document__c document{get;set;}
  	public string levelName{get;set;}
  }  
  
  public EEC_DocumentLookupController() {
    providerId  = ApexPages.currentPage().getParameters().get('providerId');
    licenseTransationId  = ApexPages.currentPage().getParameters().get('licenseTransationId');
    providerType = ApexPages.currentPage().getParameters().get('providerType');
    level = '--None--';
    documentType = '--None--';
    query();
  }
    
  public PageReference query() {
        try {
            accDocs = new Account();
            
            documentTypes = new List<SelectOption>();
        	
        	List<Document_Type__c> listDocumentType = [select Id, Name from Document_Type__c where  LEAD_Configuration__r.Name =: providerType];
        	
        	documentTypes.add(new SelectOption('--None--','--None--'));
        	for(Document_Type__c documentType : listDocumentType){
        		documentTypes.add(new SelectOption(documentType.Id,documentType.Name));	
        	}
        	 listDocumentWrapper = new List<DocumentWrapper>();
            queryResults = new List<Document__c>();
          errorMessage = '';
              if (!String.isBlank(queryStr)) {
               queryStr = '%'+queryStr+'%';
              }
              
        if(level == 'Provider'){
            if(queryStr == null || queryStr == ''){
            	if(documentType != '--None--')
            		accDocs = [select id,Name,(select id,Name,Notes__c,Document_Type__c,Document_Type__r.Name,Document_Type__r.createdDate,Approved_for_Future_Usage__c,Provider__c from Documents__r where Document_Type__c =: documentType and Approved_for_Future_Usage__c=true ) from Account where id =:providerId];
            	else
                accDocs = [select id,Name,(select id,Name,Notes__c,Document_Type__c,Document_Type__r.Name,Document_Type__r.createdDate,Approved_for_Future_Usage__c,Provider__c from Documents__r where Approved_for_Future_Usage__c=true ) from Account where id =:providerId];           
            }else{  
            	if(documentType != '--None--')
            		accDocs = [select id,Name,(select id,Name,Notes__c,Document_Type__c,Document_Type__r.Name,Document_Type__r.createdDate,Approved_for_Future_Usage__c,Provider__c from Documents__r where Document_Type__c =: documentType and (Name Like : queryStr) AND Approved_for_Future_Usage__c=true) From Account where id =:providerId];
            	else
                	accDocs = [select id,Name,(select id,Name,Notes__c,Document_Type__c,Document_Type__r.Name,Document_Type__r.createdDate,Approved_for_Future_Usage__c,Provider__c from Documents__r where (Name Like : queryStr) AND Approved_for_Future_Usage__c=true) From Account where id =:providerId];    
   }
                queryResults = accDocs.Documents__r;
                
                for(Document__c document : accDocs.Documents__r){
            	DocumentWrapper DocumentWrapper = new DocumentWrapper();
            	DocumentWrapper.document = document;
            	DocumentWrapper.levelName = 'Provider';
            	listDocumentWrapper.add(DocumentWrapper);
            }
        }else if(level == 'Umbrella') {
            Id umbrellaRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Umbrella').getRecordTypeId();

            Account umbrellaAcc = [select id,Name,Umbrella_Members__c,RecordTypeId from Account where Id =: providerId  Limit 1];
                if(queryStr == ''|| queryStr == null){
                	if(documentType != '--None--')
                    accDocs = [select id,Name,Umbrella_Members__c,RecordTypeId,(select id,Name,Notes__c,Document_Type__c,Document_Type__r.createdDate,Document_Type__r.Name,Approved_for_Future_Usage__c,Provider__c from Documents__r where Document_Type__c =: documentType and Approved_for_Future_Usage__c=true)  From Account where Id =: umbrellaAcc.Umbrella_Members__c And RecordTypeId =: umbrellaRecId Limit 1 ];
                    else
                    accDocs = [select id,Name,Umbrella_Members__c,RecordTypeId,(select id,Name,Notes__c,Document_Type__c,Document_Type__r.createdDate,Document_Type__r.Name,Approved_for_Future_Usage__c,Provider__c from Documents__r where Approved_for_Future_Usage__c=true)  From Account where Id =: umbrellaAcc.Umbrella_Members__c And RecordTypeId =: umbrellaRecId Limit 1 ];
                }else{
                	if(documentType != '--None--')
                	accDocs = [select id,Name,Umbrella_Members__c,RecordTypeId,(select id,Name,Notes__c,Document_Type__c,Document_Type__r.createdDate,Document_Type__r.Name,Approved_for_Future_Usage__c,Provider__c from Documents__r where Document_Type__c =: documentType and (Name Like : queryStr) AND Approved_for_Future_Usage__c=true)  From Account where Id =: umbrellaAcc.Umbrella_Members__c And RecordTypeId =: umbrellaRecId Limit 1 ];
                	else
                    accDocs = [select id,Name,Umbrella_Members__c,RecordTypeId,(select id,Name,Notes__c,Document_Type__c,Document_Type__r.createdDate,Document_Type__r.Name,Approved_for_Future_Usage__c,Provider__c from Documents__r where Document_Type__c =: documentType and (Name Like : queryStr) AND Approved_for_Future_Usage__c=true)  From Account where Id =: umbrellaAcc.Umbrella_Members__c And RecordTypeId =: umbrellaRecId Limit 1 ];
    }
                    queryResults = accDocs.Documents__r;
                    
                     for(Document__c document : accDocs.Documents__r){
            	DocumentWrapper DocumentWrapper = new DocumentWrapper();
            	DocumentWrapper.document = document;
            	DocumentWrapper.levelName = 'Umbrella';
            	listDocumentWrapper.add(DocumentWrapper);
            }
        }else {
               Id umbrellaRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Umbrella').getRecordTypeId();

               Account umbrellaAcc = [select id,Name,Umbrella_Members__c,RecordTypeId from Account where Id =: providerId  Limit 1];
   Account accDocs1 = new Account();
      Account accDocs2 = new Account();
    if(queryStr == null || queryStr == ''){
    	if(documentType != '--None--'){
    		accDocs1 = [select id,Name,(select id,Name,Notes__c,Document_Type__c,Document_Type__r.Name,Document_Type__r.createdDate,Approved_for_Future_Usage__c,Provider__c from Documents__r where Document_Type__c =: documentType and Approved_for_Future_Usage__c=true) from Account where id =:providerId];           
     accDocs2 = [select id,Name,Umbrella_Members__c,RecordTypeId,(select id,Name,Notes__c,Document_Type__c,Document_Type__r.Name,Document_Type__r.createdDate,Approved_for_Future_Usage__c,Provider__c from Documents__r where Document_Type__c =: documentType and Approved_for_Future_Usage__c=true)  From Account where Id =: umbrellaAcc.Umbrella_Members__c And RecordTypeId =: umbrellaRecId Limit 1 ];
    	}
    	else{
     accDocs1 = [select id,Name,(select id,Name,Notes__c,Document_Type__c,Document_Type__r.Name,Document_Type__r.createdDate,Approved_for_Future_Usage__c,Provider__c from Documents__r where Approved_for_Future_Usage__c=true) from Account where id =:providerId];           
     accDocs2 = [select id,Name,Umbrella_Members__c,RecordTypeId,(select id,Name,Notes__c,Document_Type__c,Document_Type__r.Name,Document_Type__r.createdDate,Approved_for_Future_Usage__c,Provider__c from Documents__r where Approved_for_Future_Usage__c=true)  From Account where Id =: umbrellaAcc.Umbrella_Members__c And RecordTypeId =: umbrellaRecId Limit 1 ];
    	}
                }else{
                	if(documentType != '--None--'){
                		accDocs1 = [select id,Name,(select id,Name,Notes__c,Document_Type__c,Document_Type__r.Name,Document_Type__r.createdDate,Approved_for_Future_Usage__c,Provider__c from Documents__r where Document_Type__c =: documentType and (Name Like : queryStr) AND Approved_for_Future_Usage__c=true) from Account where id =:providerId];           
     accDocs2 = [select id,Name,Umbrella_Members__c,RecordTypeId,(select id,Name,Notes__c,Document_Type__c,Document_Type__r.Name,Document_Type__r.createdDate,Approved_for_Future_Usage__c,Provider__c from Documents__r where Document_Type__c =: documentType and (Name Like : queryStr) AND Approved_for_Future_Usage__c=true)  From Account where Id =: umbrellaAcc.Umbrella_Members__c And RecordTypeId =: umbrellaRecId Limit 1 ];
                	}
                	else{
     accDocs1 = [select id,Name,(select id,Name,Notes__c,Document_Type__c,Document_Type__r.Name,Document_Type__r.createdDate,Approved_for_Future_Usage__c,Provider__c from Documents__r where (Name Like : queryStr) AND Approved_for_Future_Usage__c=true) from Account where id =:providerId];           
     accDocs2 = [select id,Name,Umbrella_Members__c,RecordTypeId,(select id,Name,Notes__c,Document_Type__c,Document_Type__r.Name,Document_Type__r.createdDate,Approved_for_Future_Usage__c,Provider__c from Documents__r where (Name Like : queryStr) AND Approved_for_Future_Usage__c=true)  From Account where Id =: umbrellaAcc.Umbrella_Members__c And RecordTypeId =: umbrellaRecId Limit 1 ];
                	}     
    }
    queryResults = accDocs1.Documents__r;
                for(Document__c doc: accDocs2.Documents__r){
                    queryResults.add(doc);
                }
        
        
	            for(Document__c document : accDocs1.Documents__r){
	            	DocumentWrapper DocumentWrapper = new DocumentWrapper();
	            	DocumentWrapper.document = document;
	            	DocumentWrapper.levelName = 'Provider';
	            	listDocumentWrapper.add(DocumentWrapper);
	            }
	            
	            for(Document__c document : accDocs2.Documents__r){
	            	DocumentWrapper DocumentWrapper = new DocumentWrapper();
	            	DocumentWrapper.document = document;
	            	DocumentWrapper.levelName = 'Umbrella';
	            	listDocumentWrapper.add(DocumentWrapper);
	            }
            system.debug('value in query results'+queryResults);
                
        }  
        documentMap = new Map<Id,Document__c>();
        for(Document__c doc : queryResults){
            documentMap.put(doc.id,doc);
        }
        
          if (queryResults.size() == 0) {
            errorMessage = 'No results found.';
          }
        } catch(Exception e) {
          System.debug('Error: ' + e.getMessage());
          errorMessage = 'An error has occured attempting to get your results. Please try again later.';
        }
        system.debug('value in query results22222'+queryResults);
    return null;
  }
 
}