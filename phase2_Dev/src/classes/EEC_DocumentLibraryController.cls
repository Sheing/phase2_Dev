public with sharing class EEC_DocumentLibraryController {	
    public LEAD_Configuration__c leadConfiguration {get;set;}
    public List<Document__c> listDocument{get;set;}
    public string selectedDocumentId{get;set;}
    
    private string accountId{get;set;}
    
    public EEC_DocumentLibraryController() {
    	User loggedUser = [select Id, Name, contactId from User where Id = :UserInfo.getUserId()];    	
    	Contact contact = [select Id, Account.Id, Account.RecordType.Name from Contact where Id =: loggedUser.contactId];    	
    	string providerRecordType = contact.Account.RecordType.Name;
    	List<Lead_Configuration__c> listleadConfiguration = [Select Id, Library_Introduction__c from LEAD_Configuration__c where 
    												Name = :providerRecordType];
    												
		if(listleadConfiguration.size() > 0)    												
    		leadConfiguration = listleadConfiguration[0];
    	
    	accountId = contact.Account.Id;
    	listDocument = new List<Document__c>();
    }
    
    public void doCreateDocs(){    	
    	if(leadConfiguration != null){
	    	List<Document_Type__c> listDocumentType = [select Id, Allow_use_of_Umbrella_Level_Document__c,
	    	Description__c,Name,Individual_Document__c,Library_Level__c,
	    	Need_to_be_Updated_at_each_new_Transacti__c,Optional_for_Transactio_Type__c,Related_Role__c,
	    	Required_For_Transaction_Type__c from Document_Type__c where 
	    	LEAD_Configuration__c =: leadConfiguration.Id and Library_Level__c = true];
	    	
	    	List<Document__c> listExistingDocuments = [select Id, Document_Name__c, Document_Type__c, Document_Type__r.Name,
	    	Document_Type__r.Description__c, Attachment_Status__c, Notes__c,Valid_From__c,Valid_To__c from 
	    	Document__c where Provider__c=: accountId];
	    	
	    	Map<Id, List<Document__c>> mapDocumentTypeDocs = new Map<Id, List<Document__c>>();
	    	
	    	for(Document__c document : listExistingDocuments){
	    		List<Document__c> listDocs;
	    		if(mapDocumentTypeDocs.get(document.Document_Type__c) == null){
	    			listDocs = new List<Document__c>();
	    		}
	    		else{
	    			listDocs = mapDocumentTypeDocs.get(document.Document_Type__c);
	    		}
	    		listDocs.add(document);
	    		mapDocumentTypeDocs.put(document.Document_Type__c, listDocs);
	    	}
	    	List<Document__c> listNewDocs = new List<Document__c>();
	    	
	    	boolean isDocumentExist = false;
	    	for(Document_Type__c documentType : listDocumentType){
	    		isDocumentExist = false;
	    		List<Document__c> listDocs = mapDocumentTypeDocs.get(documentType.Id);
	    		if(listDocs != null){
	    			for(Document__c document : listDocs){
	    				if(document.Valid_To__c == null){
	    					isDocumentExist = true;
	    					break;
	    				}
	    			}
	    			if(isDocumentExist == false){
	    				Document__c newDocument = createDocument(documentType.Id , accountId);
		    			listNewDocs.add(newDocument);
	    			}
	    		}
	    		else{
	    			Document__c newDocument = createDocument(documentType.Id , accountId);
	    			listNewDocs.add(newDocument);
	    		}
	    	}
	    	if(listNewDocs.size() > 0){
	    		insert listNewDocs;
	    	}
    	}
		listDocument = [select Id, Document_Name__c, Document_Type__c, Document_Type__r.Name,
			Document_Type__r.Description__c, Attachment_Status__c, Notes__c,Valid_From__c,Valid_To__c from 
			Document__c where Provider__c=: accountId and Current__c = true and Document_Type__r.Library_Level__c = true];
    }
    
    public void doMarkAsOutOfDate(){
    	Document__c documents = [select Id, Valid_To__c, Document_Type__c, Approved_for_Future_Usage__c from 
        Document__c where Id =: selectedDocumentId];

        documents.Valid_To__c = datetime.now();
        documents.Approved_for_Future_Usage__c = false;    
        update documents;
        
        Document__c newDocument = createDocument(documents.Document_Type__c , accountId);
        insert newDocument;
        
        listDocument = [select Id, Document_Name__c, Document_Type__c, Document_Type__r.Name,
			Document_Type__r.Description__c, Attachment_Status__c, Notes__c,Valid_From__c,Valid_To__c from 
			Document__c where Provider__c=: accountId and Current__c = true and Document_Type__r.Library_Level__c = true];
    }
    
    private  Document__c createDocument(string documentType, string accountId){    	
        Document__c newDocument = new Document__c();
        newDocument.Document_Type__c = documentType;
		newDocument.Provider__c = accountId;
	    return newDocument;	    
    }
    
    public PageReference doBack(){
    	PageReference pageReference = Page.EEC_PortalLandingPage_2;
    	pageReference.setRedirect(true);
    	return pageReference;
    }
}