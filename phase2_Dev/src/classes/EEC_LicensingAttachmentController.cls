public with sharing class EEC_LicensingAttachmentController {
    public LEAD_Configuration__c leadConfiguration {get;set;}
    public Licensing_Transaction__c licenseTransaction {get;set;}
    public String accessKey { get; set; }
    public string informationText{get;set;}
    public List<TransactionDocumenWrapper> listRequiredDocument{get;set;}
    public List<TransactionDocumenWrapper> listOptionalDocument{get;set;}
    public List<TransactionDocumenWrapper> listIndividualDocument{get;set;}
    public List<TransactionDocumenWrapper> listAdditionalDocument{get;set;}
    public Map<Id, List<TransactionDocumenWrapper>> mapVarianceDocument{get;set;}
    public Map<string, string> mapVarianceIds{get;set;}
    public string formattedLicenseRecordTypeLabel{get;set;}
    public User loggedUser{get;set;}
    
	
    private string accountId{get;set;}
    private string ltId{get;set;}    
    private AWS_Config__c aws{get;set;}
    private AWSKeys credentials{get;set;}
    private string bucket{get;set;}
	public string previousPageName{get;set;}
	
	private String AWSCredentialName = 'eec';
	
	public class TransactionDocumenWrapper{
		public Transaction_Document__c transctionDocument{get;set;}
		public string mandatory{get;set;}
		public string s3FileId{get;set;}
		public string s3FileName{get;set;}
		public boolean displayUmbrella{get;set;}
		public boolean displayProvider{get;set;}
	} 
    public EEC_LicensingAttachmentController(){   
    	loggedUser = [select Id, Name, contactId, UserType from User where Id = :UserInfo.getUserId()];
    	
    	ltId = ApexPages.currentPage().getParameters().get('ltId');
        string memberId = ApexPages.currentPage().getParameters().get('member');

		if(String.isNotBlank(ApexPages.currentPage().getParameters().get('previouspagename')))
		{
			previousPageName= ApexPages.currentPage().getParameters().get('previouspagename');
		}
    	

    	if (String.isNotBlank(memberId)) {
            accountId = memberId;
        }
        else {
            List<Account> tempAccount = [Select Id From Account Where ID in(Select Accountid From User Where id = :Userinfo.getUserId()) Limit 1];
            if (tempAccount != null && tempAccount.size() == 1) {
                accountId = tempAccount.get(0).Id;
            }
        }
        
		aws = AWS_Config__c.getInstance();
        bucket = aws.S3_Bucket_Name__c;
        string signedUrl = aws.S3_Endpoint_Url__c;
        
        credentials = new AWSKeys(AWSCredentialName);
                
        accessKey = credentials.key;        
    }
    
    public void doGetDocuments(){
    	List<Licensing_Transaction__c> ltList = [Select Id, Provider__c, 
    			RecordType.Name, RecordType.DeveloperName,
    			RecordTypeId,
    			Provider__r.RecordType.Name,
    			Provider__r.RecordType.DeveloperName,
    			Provider__r.Config_Record__c,
    			Transaction_Configuration__c,
		    	Provider__r.Umbrella_Members__c,Status__c,(Select Id,
		    	Associated_Regulation__c,Associated_Regulation__r.Name,
		    	Associated_Regulation__r.Regulation_Number__c,Associated_Regulation__r.Article__c,
		    	Provider_Alternative_Method_to_Comply__c,Provider_Understanding_of_Regulation__c From Variance_on_Regulations__r)
             	From Licensing_Transaction__c l where Id = :ltId];
        
        if(ltList.size() > 0){
        	licenseTransaction = ltList[0];
        	if(licenseTransaction.RecordType.DeveloperName == 'R_P_Change_of_Admin_Authority'){
                formattedLicenseRecordTypeLabel = 'R&P Change of Admin Authority';
            }else{
                formattedLicenseRecordTypeLabel = licenseTransaction.RecordType.DeveloperName.replaceAll('_', ' ');   
            }
        }
        
    	leadConfiguration = [Select Id, Transaction_Attachments_New__c, Transaction_Attachments_Renewal__c,
					Transaction_Attachments_Upgrade__c from LEAD_Configuration__c where 
											Name =: licenseTransaction.RecordType.Name];
		
		if(licenseTransaction.RecordType.DeveloperName == 'FCC_New_License' || licenseTransaction.RecordType.DeveloperName == 'GSA_New_License' || licenseTransaction.RecordType.DeveloperName == 'Placement_New_License' || licenseTransaction.RecordType.DeveloperName == 'Residential_New_License'){
			informationText = leadConfiguration.Transaction_Attachments_New__c;
		}
		else if(licenseTransaction.RecordType.DeveloperName == 'FCC_Renewal' || licenseTransaction.RecordType.DeveloperName == 'GSA_Renewal' || licenseTransaction.RecordType.DeveloperName == 'Placement_Renewal' || licenseTransaction.RecordType.DeveloperName == 'Residential_License_Renewal'){
			informationText = leadConfiguration.Transaction_Attachments_Renewal__c;
		}
		else if(licenseTransaction.RecordType.DeveloperName == 'FCC_License_Upgrade' || licenseTransaction.RecordType.DeveloperName == 'GSA_License_Change' || licenseTransaction.RecordType.DeveloperName == 'Placement_Change_in_License' || licenseTransaction.RecordType.DeveloperName == 'Residential_Change_in_License'){
			informationText = leadConfiguration.Transaction_Attachments_Upgrade__c;
		}

        string query = 'select Id, Allow_use_of_Umbrella_Level_Document__c, Description__c,Name,Individual_Document__c,Library_Level__c,Need_to_be_Updated_at_each_new_Transacti__c,Optional_for_Transactio_Type__c,Related_Role__c,Required_For_Transaction_Type__c from Document_Type__c WHERE LEAD_Configuration__c = \''
        + licenseTransaction.Provider__r.Config_Record__c + '\' AND (Required_For_Transaction_Type__c INCLUDES (\'' + licenseTransaction.RecordType.Name + '\') OR Optional_for_Transactio_Type__c INCLUDES(\'' + licenseTransaction.RecordType.Name +'\'))';
        
        List<Document_Type__c> listDocumentType = database.query(query);
        
        List<Transaction_Document__c> listTransactionDocument = [select Comments__c,Document__c,Document_Type__c,
        Document_Type__r.Individual_Document__c,
        Document__r.Contact_Role__c,
        Document__r.Contact_Role__r.Role__c,
        Last_Status_Date__c,Licensing_Transaction__c,Mode__c,Note_For_Revision__c,Status__c,Transaction_Notes__c,
        Variance_on_Regulation__c from Transaction_Document__c where Licensing_Transaction__c =: licenseTransaction.Id];

        List<Contact_Role__c> listContactRole = [select id, Name,Current_Formula__c,Contact__c,Contact__r.FirstName,Contact__r.LastName,Contact__r.MailingStreet,Contact__r.MailingCity,Contact__r.MailingPostalCode,Contact__r.MailingState,Contact__r.Phone,Contact__r.Email,Contact__r.Holds_FCC_License__c,End_Date__c,End_Role_Licensing_Transaction__c,Portal_Access__c,Provider__c,Role__c,Schedule_Administrative_Hours__c,Schedule_Teaching_Hours__c,Start_Date__c,Start_Role_Licensing_Transaction__c,Contact__r.Title,Contact__r.Role__c FROM Contact_Role__c
        WHERE Provider__c =: licenseTransaction.Provider__c and Start_Role_Licensing_Transaction__c =: licenseTransaction.Id order by Start_Date__c ASC NULLS FIRST];
		
		Map<string, List<Contact_Role__c>> mapContactRole = new Map<string, List<Contact_Role__c>>();
		
		for(Contact_Role__c contactRole : listContactRole){
			List<Contact_Role__c> listRoles;
			if(mapContactRole.get(contactRole.Role__c) == null){
				listRoles = new List<Contact_Role__c>();
			}
			else{
				listRoles = mapContactRole.get(contactRole.Role__c);
			}
			listRoles.add(contactRole);
			mapContactRole.put(contactRole.Role__c, listRoles);
		}
		
        Map<Id, List<Transaction_Document__c>> mapTransactionDocs = new Map<Id, List<Transaction_Document__c>>();
        Map<Id, List<Transaction_Document__c>> mapIndividualTransactionDocs = new Map<Id, List<Transaction_Document__c>>();
        
        for(Transaction_Document__c transactionDocument : listTransactionDocument){
        	if(transactionDocument.Document_Type__r.Individual_Document__c == true){
        		List<Transaction_Document__c> listTranDoc;
	        	if(mapIndividualTransactionDocs.get(transactionDocument.Document_Type__c) == null){
	        		listTranDoc = new List<Transaction_Document__c>();
	        	}
	        	else{
	        		listTranDoc = mapIndividualTransactionDocs.get(transactionDocument.Document_Type__c);
	        	}
	        	listTranDoc.add(transactionDocument);
	        	mapIndividualTransactionDocs.put(transactionDocument.Document_Type__c, listTranDoc);
        	}
        	else{
	        	List<Transaction_Document__c> listTranDoc;
	        	if(mapTransactionDocs.get(transactionDocument.Document_Type__c) == null){
	        		listTranDoc = new List<Transaction_Document__c>();
	        	}
	        	else{
	        		listTranDoc = mapTransactionDocs.get(transactionDocument.Document_Type__c);
	        	}
	        	listTranDoc.add(transactionDocument);
	        	mapTransactionDocs.put(transactionDocument.Document_Type__c, listTranDoc);
        	}
        }
        
        List<Document__c> listDocuments;
        if(licenseTransaction.Provider__r.Umbrella_Members__c != null){
        	listDocuments = [select Id, Document_Name__c, Approved_for_Future_Usage__c, Document_Type__c, Document_Type__r.Name,
	    	Document_Type__r.Description__c, Attachment_Status__c, Notes__c,Valid_From__c,Valid_To__c,Provider__c,
	    	Contact_Role__c,
	    	(select Id,Filename__c from S3_Files__r) from 
	    	Document__c where 
	    	(Provider__c =: licenseTransaction.Provider__c or Provider__c =: licenseTransaction.Provider__r.Umbrella_Members__c)
	    	and Current__c = true];
        }
        else{
	        listDocuments = [select Id, Document_Name__c, Approved_for_Future_Usage__c, Document_Type__c, Document_Type__r.Name,
	    	Document_Type__r.Description__c, Attachment_Status__c, Notes__c,Valid_From__c,Valid_To__c,Provider__c,
	    	Contact_Role__c,
	    	(select Id,Filename__c from S3_Files__r) from 
	    	Document__c where Provider__c =: licenseTransaction.Provider__c
	    	and Current__c = true];
        }
        
        Map<Id, List<Document__c>> mapProviderDocuments = new Map<Id, List<Document__c>>();
        Map<Id, List<Document__c>> mapUmbrellaDocuments = new Map<Id, List<Document__c>>();
        Map<Id, List<Document__c>> mapIndividualDocuments = new Map<Id, List<Document__c>>();
        
        for(Document__c document : listDocuments){
        	if(document.Provider__c == licenseTransaction.Provider__c && document.Contact_Role__c == null){
        		List<Document__c> listDoc;
	        	if(mapProviderDocuments.get(document.Document_Type__c) == null){
	        		listDoc = new List<Document__c>();
	        	}
	        	else{
	        		listDoc = mapProviderDocuments.get(document.Document_Type__c);
	        	}
	        	listDoc.add(document);
	        	mapProviderDocuments.put(document.Document_Type__c, listDoc);
        	}
        	else if(document.Provider__c == licenseTransaction.Provider__r.Umbrella_Members__c && document.Contact_Role__c == null){
        		List<Document__c> listDoc;
	        	if(mapUmbrellaDocuments.get(document.Document_Type__c) == null){
	        		listDoc = new List<Document__c>();
	        	}
	        	else{
	        		listDoc = mapUmbrellaDocuments.get(document.Document_Type__c);
	        	}
	        	listDoc.add(document);
	        	mapUmbrellaDocuments.put(document.Document_Type__c, listDoc);
        	}
        	if(document.Contact_Role__c != null){
        		List<Document__c> listDoc;
	        	if(mapIndividualDocuments.get(document.Document_Type__c) == null){
	        		listDoc = new List<Document__c>();
	        	}
	        	else{
	        		listDoc = mapIndividualDocuments.get(document.Document_Type__c);
	        	}
	        	listDoc.add(document);
	        	mapIndividualDocuments.put(document.Document_Type__c, listDoc);
        	}
        }
        
        List<Document__c> listNewDocument = new List<Document__c>();

        List<Transaction_Document__c> listNewTransactionDocument = new List<Transaction_Document__c>();
        
        for(Document_Type__c documentType : listDocumentType){
        	if(documentType.Individual_Document__c == false){
	        	if(mapTransactionDocs.get(documentType.Id) == null || mapTransactionDocs.get(documentType.Id).size() == 0){
	        		
	        		if(documentType.Need_to_be_Updated_at_each_new_Transacti__c == true){
	        			 Document__c newDocument = createDocument(documentType.Id , licenseTransaction.Provider__c);
						 listNewDocument.add(newDocument);
	        		}
	        		else{
	        			if(licenseTransaction.Provider__r.Umbrella_Members__c != null){
	        				if(mapUmbrellaDocuments.get(documentType.Id) != null && mapUmbrellaDocuments.get(documentType.Id).size() > 0){
								 Document__c newDocument = createDocument(documentType.Id , licenseTransaction.Provider__c);
								 listNewDocument.add(newDocument);
	        				}
	        				else{
	        					if(mapProviderDocuments.get(documentType.Id) == null || mapProviderDocuments.get(documentType.Id).size() == 0){
	        					 	Document__c newDocument = createDocument(documentType.Id , licenseTransaction.Provider__c);
									listNewDocument.add(newDocument);
	        					}
	        				}
	        			}
	        			else{
	        				if(mapProviderDocuments.get(documentType.Id) == null || mapProviderDocuments.get(documentType.Id).size() == 0){
								Document__c newDocument = createDocument(documentType.Id , licenseTransaction.Provider__c);
								listNewDocument.add(newDocument);
	        				}
	        			}
	        		}
	        	}
        	}
        	else{
        		List<Contact_Role__c> listRoles = mapContactRole.get(documentType.Related_Role__c);
        		
        		if(listRoles != null && listRoles.size() > 0){
        			List<Transaction_Document__c> listTraDocs = mapIndividualTransactionDocs.get(documentType.Id);
        			boolean isDocExist = false;
        			if(listTraDocs != null && listTraDocs.size() > 0){
        				for(Contact_Role__c contactRole : listRoles){
        					for(Transaction_Document__c transactionDoc : listTraDocs){
        						if(transactionDoc.Document__r.Contact_Role__c == contactRole.Id){
        							isDocExist = true;
        							break;	
        						}
        					}
        					if(isDocExist == false){
        						Document__c newDocument = createDocument(documentType.Id , licenseTransaction.Provider__c);
	        					newDocument.Contact_Role__c = contactRole.Id;
								listNewDocument.add(newDocument);
        					}
	        			}	
        			}
        			else{
        				for(Contact_Role__c contactRole : listRoles){
        					Document__c newDocument = createDocument(documentType.Id , licenseTransaction.Provider__c);
        					newDocument.Contact_Role__c = contactRole.Id;
							listNewDocument.add(newDocument);
	        			}
        			}        			
        		}
        	}
        }
        
        if(listNewDocument.size() > 0){
        	insert listNewDocument;
        }
        
        Map<Id, List<Document__c>> mapNewDocuments = new Map<Id, List<Document__c>>();
        for(Document__c document : listNewDocument){
        	List<Document__c> listDocs;
        	if(mapNewDocuments.get(document.Document_Type__c) == null){
        		listDocs = new List<Document__c>();
        	}
        	else{
        		listDocs = mapNewDocuments.get(document.Document_Type__c);
        	}
        	listDocs.add(document);
        	mapNewDocuments.put(document.Document_Type__c, listDocs);
        }
        
        for(Document_Type__c documentType : listDocumentType){
    		List<Document__c> listDocs = mapNewDocuments.get(documentType.Id);
	        if(documentType.Individual_Document__c == false){
	        	if(mapTransactionDocs.get(documentType.Id) == null || mapTransactionDocs.get(documentType.Id).size() == 0){
	        		Transaction_Document__c newTransactionDocument = new Transaction_Document__c();
	        		newTransactionDocument.Document_Type__c = documentType.Id;
	        		newTransactionDocument.Licensing_Transaction__c = licenseTransaction.Id;
	        		if(string.isNotBlank(documentType.Required_For_Transaction_Type__c) && documentType.Required_For_Transaction_Type__c.contains(licenseTransaction.RecordType.Name)){
	        			newTransactionDocument.Mode__c = 'Required';
	        		}
	        		else if(string.isNotBlank(documentType.Optional_for_Transactio_Type__c) && documentType.Optional_for_Transactio_Type__c.contains(licenseTransaction.RecordType.Name)){
	        			newTransactionDocument.Mode__c = 'Optional';
	        		}
	        		if(documentType.Need_to_be_Updated_at_each_new_Transacti__c == true){
	        			 for(Document__c document : listDocs){
	        			 	if(document.Contact_Role__c == null){
	        			 		newTransactionDocument.Document__c = document.Id;
	        			 		break;
	        			 	}
	        			 }
	        			 newTransactionDocument.Status__c = 'To Upload';
	        			 listNewTransactionDocument.add(newTransactionDocument);
	        		}
	        		else{
	        			if(licenseTransaction.Provider__r.Umbrella_Members__c != null){
	        				if(mapUmbrellaDocuments.get(documentType.Id) != null && mapUmbrellaDocuments.get(documentType.Id).size() > 0){
	        					 Document__c document = mapUmbrellaDocuments.get(documentType.Id)[0];
	        					 
	        					 newTransactionDocument.Document__c = document.Id;
	        					 if(document.Approved_for_Future_Usage__c){
	        					 	newTransactionDocument.Status__c = 'Approved';
	        					 }
	        					 else{
	        					 	if(document.S3_Files__r != null && document.S3_Files__r.size() > 0){
	        					 		newTransactionDocument.Status__c = 'To Submit';
	        					 	}
	        					 	else{
	        					 		newTransactionDocument.Status__c = 'To Upload';
	        					 	}
	        					 }
	        					 listNewTransactionDocument.add(newTransactionDocument);
	        				}
	        				else{
	        					if(mapProviderDocuments.get(documentType.Id) != null && mapProviderDocuments.get(documentType.Id).size() > 0){
	        						Document__c document = mapProviderDocuments.get(documentType.Id)[0];
	        					 
		        					newTransactionDocument.Document__c = document.Id;	        					 
		        					if(document.Approved_for_Future_Usage__c){
		        						newTransactionDocument.Status__c = 'Approved';
		        					}
		        					else{
	        					 		if(document.S3_Files__r != null && document.S3_Files__r.size() > 0){
		        					 		newTransactionDocument.Status__c = 'To Submit';
		        					 	}
		        					 	else{
		        					 		newTransactionDocument.Status__c = 'To Upload';
		        					 	}
	        					 	}
	        					 	listNewTransactionDocument.add(newTransactionDocument);
	        					}
	        					else{
	        						 for(Document__c document : listDocs){
				        			 	if(document.Contact_Role__c == null){
				        			 		newTransactionDocument.Document__c = document.Id;
				        			 		break;
				        			 	}
				        			 }
	        						newTransactionDocument.Status__c = 'To Upload';
	        						listNewTransactionDocument.add(newTransactionDocument);
	        					}
	        				}
	        			}
	        			else{
	        				if(mapProviderDocuments.get(documentType.Id) != null && mapProviderDocuments.get(documentType.Id).size() > 0){
	    						Document__c document = mapProviderDocuments.get(documentType.Id)[0];
	    					 
	        					newTransactionDocument.Document__c = document.Id;	        					 
	        					if(document.Approved_for_Future_Usage__c)
	        						newTransactionDocument.Status__c = 'Approved';
	        					else{
	    					 		if(document.S3_Files__r != null && document.S3_Files__r.size() > 0){
	        					 		newTransactionDocument.Status__c = 'To Submit';
	        					 	}
	        					 	else{
	        					 		newTransactionDocument.Status__c = 'To Upload';
	        					 	}
	    					 	}
	    					 	listNewTransactionDocument.add(newTransactionDocument);
	    					}
	    					else{
	    						for(Document__c document : listDocs){
			        			 	if(document.Contact_Role__c == null){
			        			 		newTransactionDocument.Document__c = document.Id;
			        			 		break;
			        			 	}
			        			 }
	    						newTransactionDocument.Status__c = 'To Upload';
	    						listNewTransactionDocument.add(newTransactionDocument);
	    					}
	        			}
	        		}
	        	}
        	}
        	else{
        		List<Contact_Role__c> listRoles = mapContactRole.get(documentType.Related_Role__c);
        		if(listRoles != null && listRoles.size() > 0){
        			List<Transaction_Document__c> listTraDocs = mapIndividualTransactionDocs.get(documentType.Id);
        			boolean isDocExist = false;
        			if(listTraDocs != null && listTraDocs.size() > 0){
        				for(Contact_Role__c contactRole : listRoles){
        					for(Transaction_Document__c transactionDoc : listTraDocs){
        						if(transactionDoc.Document__r.Contact_Role__c == contactRole.Id){
        							isDocExist = true;
        							break;	
        						}
        					}
        					if(isDocExist == false){
        						Transaction_Document__c newTransactionDocument = new Transaction_Document__c();
        						newTransactionDocument.Licensing_Transaction__c = licenseTransaction.Id;
	        					newTransactionDocument.Document_Type__c = documentType.Id;
	        					newTransactionDocument.Status__c = 'To Upload';
	        					newTransactionDocument.Mode__c = 'Individual';
	        					for(Document__c document : listDocs){
			        			 	if(document.Contact_Role__c == contactRole.Id){
	        							newTransactionDocument.Document__c = document.Id;
	        							break;
			        			 	}
	        					}
	        					listNewTransactionDocument.add(newTransactionDocument);
        					}
	        			}	
        			}
        			else{
        				for(Contact_Role__c contactRole : listRoles){
    						Transaction_Document__c newTransactionDocument = new Transaction_Document__c();
    						newTransactionDocument.Licensing_Transaction__c = licenseTransaction.Id;
        					newTransactionDocument.Document_Type__c = documentType.Id;
        					newTransactionDocument.Status__c = 'To Upload';
        					newTransactionDocument.Mode__c = 'Individual';
        					for(Document__c document : listDocs){
		        			 	if(document.Contact_Role__c == contactRole.Id){
        							newTransactionDocument.Document__c = document.Id;
        							break;
		        			 	}
        					}
        					listNewTransactionDocument.add(newTransactionDocument);
	        			}
        			}        			
        		}
        	}
        }
        
        if(listNewTransactionDocument.size() > 0){
        	insert listNewTransactionDocument;
        }
        
        listRequiredDocument = new List<TransactionDocumenWrapper>();
        listOptionalDocument = new List<TransactionDocumenWrapper>();
        listIndividualDocument = new List<TransactionDocumenWrapper>();
        listAdditionalDocument = new List<TransactionDocumenWrapper>();
        mapVarianceDocument = new Map<Id, List<TransactionDocumenWrapper>>(); 
        mapVarianceIds = new Map<string, string>();
            	
        listTransactionDocument = [select Id, Name, Comments__c,Document__c,Document_Type__c,
        Document_Type__r.Individual_Document__c,
        Document_Type__r.Name,
        Document_Type__r.Description__c,
        Document__r.Contact_Role__c,Document_Level__c,
        Document__r.Valid_From__c,
        Document__r.Contact_Role__r.Contact__r.FirstName,Document__r.Contact_Role__r.Contact__r.LastName,
        Document__r.Contact_Role__r.Contact__r.Role__c,
        Document__r.Contact_Role__r.Role__c,
        Document__r.Document_Name__c,
        Document__r.Provider__r.Umbrella_Members__c,
        Document_Type__r.Required_For_Transaction_Type__c,
        Document_Type__r.Optional_for_Transactio_Type__c,
        Last_Status_Date__c,Licensing_Transaction__c,Mode__c,Note_For_Revision__c,Status__c,Transaction_Notes__c,
        Variance_on_Regulation__r.Associated_Regulation__r.Regulation_Number__c,
        Variance_on_Regulation__c from Transaction_Document__c where Licensing_Transaction__c =: licenseTransaction.Id];
    	
    	List<Variance_on_Regulation__c> listVariance = licenseTransaction.Variance_on_Regulations__r;
    	
    	for(Variance_on_Regulation__c variance : listVariance){
    		mapVarianceIds.put(variance.Id, variance.Associated_Regulation__r.Name);
    		mapVarianceDocument.put(variance.Id, new List<TransactionDocumenWrapper>());
    	}
    	
    	for(Transaction_Document__c transactionDocument : listTransactionDocument){
    		TransactionDocumenWrapper TransactionDocumenWrapper = new TransactionDocumenWrapper();
    		TransactionDocumenWrapper.transctionDocument = transactionDocument;
    		if(transactionDocument.Mode__c == 'Required' && transactionDocument.Document_Type__r.Individual_Document__c == false){
    			List<Document__c> listDoc = mapUmbrellaDocuments.get(transactionDocument.Document_Type__c);
    			
    			if(listDoc != null && listDoc.size() > 0){
    				TransactionDocumenWrapper.displayUmbrella = true;
    			}
    			else{
    				TransactionDocumenWrapper.displayUmbrella = false;
    			}
    			
    			listDoc = mapProviderDocuments.get(transactionDocument.Document_Type__c);
    			
    			if(listDoc != null && listDoc.size() > 0){
    				TransactionDocumenWrapper.displayProvider = true;
    			}
    			else{
    				TransactionDocumenWrapper.displayProvider = false;
    			}
    			listRequiredDocument.add(TransactionDocumenWrapper);
    		}
    		else if(transactionDocument.Mode__c == 'Optional' && transactionDocument.Document_Type__r.Individual_Document__c == false){
    			listOptionalDocument.add(TransactionDocumenWrapper);
    		}
    		else if(transactionDocument.Mode__c == 'Individual' && transactionDocument.Document_Type__r.Individual_Document__c == true){
    			if(transactionDocument.Document_Type__r.Required_For_Transaction_Type__c.contains(licenseTransaction.RecordType.Name)){
    				TransactionDocumenWrapper.mandatory = 'Mandatory';
    			}
    			else{
    				TransactionDocumenWrapper.mandatory = 'Optional';
    			}
    			listIndividualDocument.add(TransactionDocumenWrapper);
    		}
    		else if(transactionDocument.Mode__c == 'Additional'){
    			for(Document__c document : listDocuments){
	    			if(document.Id ==  transactionDocument.Document__c){
	    				List<S3_File__c> listFiles = document.S3_Files__r;
	    				
	    				for(S3_File__c s3File : listFiles){
	    					TransactionDocumenWrapper = new TransactionDocumenWrapper();
    						TransactionDocumenWrapper.transctionDocument = transactionDocument;
	    					TransactionDocumenWrapper.s3FileName = s3File.Filename__c;
	    					TransactionDocumenWrapper.s3FileId = s3File.Id;
	    					listAdditionalDocument.add(TransactionDocumenWrapper);
	    				}
	    				break;
	    			}
    			}
    		}
    		
    		else if(transactionDocument.Mode__c == 'Variance'){
    			List<TransactionDocumenWrapper> listVarianceDocs;
    			if(mapVarianceDocument.get(transactionDocument.Variance_on_Regulation__c) == null){
    				listVarianceDocs = new List<TransactionDocumenWrapper>();
    			}
    			else{
    				listVarianceDocs = mapVarianceDocument.get(transactionDocument.Variance_on_Regulation__c);
    			}
    			for(Document__c document : listDocuments){
	    			if(document.Id ==  transactionDocument.Document__c){
	    				List<S3_File__c> listFiles = document.S3_Files__r;
	    				
	    				for(S3_File__c s3File : listFiles){
	    					TransactionDocumenWrapper = new TransactionDocumenWrapper();
    						TransactionDocumenWrapper.transctionDocument = transactionDocument;
	    					TransactionDocumenWrapper.s3FileName = s3File.Filename__c;
	    					TransactionDocumenWrapper.s3FileId = s3File.Id;
	    					listVarianceDocs.add(TransactionDocumenWrapper);
	    				}
	    				mapVarianceDocument.put(transactionDocument.Variance_on_Regulation__c, listVarianceDocs);
	    				break;
	    			}
    			}
    		}
    	}
    }

    private  Document__c createDocument(string documentType, string accountId){    	
        Document__c newDocument = new Document__c();
        newDocument.Document_Type__c = documentType;
		newDocument.Provider__c = accountId;
	    return newDocument;	    
    }
    
    public void doUpdateComments(){        
        String trandocId = ApexPages.currentPage().getParameters().get('trandocId');
        String trandocComments = ApexPages.currentPage().getParameters().get('trandocComments');
        Transaction_Document__c transactionDocument = [select Id, Comments__c from Transaction_Document__c where Id=: trandocId];
        transactionDocument.Comments__c = trandocComments;        
        update transactionDocument;
    }
    
	public Pagereference CancelAttachment() {

		if(string.IsNotBlank(previousPageName))
		{
			if(previousPageName == 'Provider')
			{
				PageReference pPage = page.EEC_PortalProviderPage;
				return pPage;
			}
			else
			{
				return null;
			}
		}
		else
		{
			return null;
		}
		
	}
    public Pagereference CancelTransaction() {        
        if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
	        licenseTransaction.Status__c = 'Cancelled (by Applicant)';
	        licenseTransaction.Reason_Closed_Cancelled__c = 'Cancelled by portal user';
	        update licenseTransaction;	        
        	PageReference pPage = page.EEC_PortalProviderPage;
	        addMemberIDPageParameter(pPage, true);
	        return pPage;
        }
        else{
        	licenseTransaction.Status__c = 'Cancelled (by EEC User)';
	        licenseTransaction.Reason_Closed_Cancelled__c = 'Cancelled by EEC user';
       	 	update licenseTransaction;
        	return new PageReference('javascript:window.close()');
        }
    }

	public PageReference SaveAndBackAttachment() {
        try {
                     
            licenseTransaction = EEC_ContactRoleUtil.updateLicensingTransaction(licenseTransaction);
			
			PageReference pPage;
			if(string.IsNotBlank(previousPageName)){
	        	if(previousPageName == 'Provider')
				{
					pPage = page.EEC_PortalProviderPage;
					
				}
				else
				{
					pPage = null;
				}
	        }
	        else{
            	pPage = null;
	        }
            //pPage.getParameters().put('ltId', licenseTransaction.Id);
            //addMemberIDPageParameter(pPage, false);
            //pPage.setRedirect(true);
            return pPage;
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public PageReference SaveAndPreviousAttachment() {
        try {
            licenseTransaction.Last_Reached_Step__c = 'Attachments';           
            licenseTransaction = EEC_ContactRoleUtil.updateLicensingTransaction(licenseTransaction);
			
			PageReference pPage;
			if(string.IsNotBlank(previousPageName)){
	        	if(licenseTransaction.Provider__r.RecordType.Name == 'Family Child Care' || licenseTransaction.Provider__r.RecordType.Name == 'FCC Assistant'){
	                pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
	                system.debug('previousPageName: ' + previousPageName);
	            }
	            else if(licenseTransaction.Provider__r.RecordType.Name == 'Large Group' || licenseTransaction.Provider__r.RecordType.Name == 'Small Group' || licenseTransaction.Provider__r.RecordType.Name == 'Large and Small Group Umbrella' ){
	                pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
	            }
	            else if(licenseTransaction.Provider__r.RecordType.Name == 'R&P Umbrella' || licenseTransaction.Provider__r.RecordType.Name == 'Temporary Shelter' || licenseTransaction.Provider__r.RecordType.Name == 'Group Care'
	                    || licenseTransaction.Provider__r.RecordType.Name == 'Foster Care Agency' || licenseTransaction.Provider__r.RecordType.Name == 'Adoption Agency'){
	            	pPage = EEC_Util.lastRPStepMap.get(previousPageName);
	            }
	        }
	        else{
            	pPage = Page.EEC_TechnicalAssistance;
	        }
            pPage.getParameters().put('ltId', licenseTransaction.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public PageReference SaveAndReturnAttachment() {
        try {
            licenseTransaction.Last_Reached_Step__c = 'Attachments';
            licenseTransaction = EEC_ContactRoleUtil.updateLicensingTransaction(licenseTransaction);

            if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
	        	PageReference pPage = page.EEC_PortalProviderPage;
		        addMemberIDPageParameter(pPage, true);
		        return pPage;                    	
	        }
	        else{
	        	return new PageReference('javascript:window.close()');
	        }
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
	public PageReference SaveAndSubmitAttachment() {
        try {
            
			licenseTransaction = EEC_ContactRoleUtil.updateLicensingTransaction(licenseTransaction);

			List<Transaction_Document__c> listTransactionDocument = [SELECT Id,Status__c FROM Transaction_Document__c
																	WHERE Document_Attachment_Status__c='Attachment(s) Available'
																	AND Status__c='To Submit'
																	AND Licensing_Transaction__c=:licenseTransaction.Id];
            
			for(Transaction_Document__c transactionDocument : listTransactionDocument)
			{
				transactionDocument.Status__c = 'Submitted - EEC to Review';
			}

			EEC_ContactRoleUtil.upsertTransactionDocument(listTransactionDocument);
            
			PageReference pPage;
			if(string.IsNotBlank(previousPageName)){
	        	if(previousPageName == 'Provider')
				{
					pPage = page.EEC_PortalProviderPage;
					
				}
				else
				{
					pPage = null;
				}
	        }
	        else{
            	pPage = null;
	        }
            //pPage.getParameters().put('ltId', licenseTransaction.Id);
            //addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;

        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }

    public PageReference SaveAndNextAttachment() {
        try {
            licenseTransaction.Last_Reached_Step__c = 'Review Summary and Submission';
            
            licenseTransaction = EEC_ContactRoleUtil.updateLicensingTransaction(licenseTransaction);

            if(licenseTransaction.RecordType.DeveloperName == 'Placement_New_License' || 
	             licenseTransaction.RecordType.DeveloperName == 'Residential_New_License' || 
	             licenseTransaction.RecordType.DeveloperName == 'Placement_Renewal' ||
	             licenseTransaction.RecordType.DeveloperName == 'Residential_License_Renewal' ||
	             licenseTransaction.RecordType.DeveloperName == 'Placement_Change_in_License' ||
	             licenseTransaction.RecordType.DeveloperName == 'Residential_Change_in_License' ||
	             licenseTransaction.RecordType.DeveloperName == 'Placement_Move' ||
	             licenseTransaction.RecordType.DeveloperName == 'Residential_Move' ||
	             licenseTransaction.RecordType.DeveloperName == 'R_P_Change_of_Admin_Authority'){
	             PageReference pPage = Page.EEC_RP_ReviewSummary;
	             pPage.getParameters().put('ltId', licenseTransaction.Id);
	             addMemberIDPageParameter(pPage, false);
	             pPage.setRedirect(true);
	             return pPage;
            }else if(licenseTransaction.RecordType.DeveloperName == 'GSA_New_License' || 
	             licenseTransaction.RecordType.DeveloperName == 'GSA_Renewal' || 
	             licenseTransaction.RecordType.DeveloperName == 'GSA_License_Change' ||
	             licenseTransaction.RecordType.DeveloperName == 'GSA_Move' ||
	             licenseTransaction.RecordType.DeveloperName == 'GSA_Change_of_Admin_Authority' ){
	             PageReference pPage = Page.EEC_GSAReviewSummary;
	             pPage.getParameters().put('ltId', licenseTransaction.Id);
	             addMemberIDPageParameter(pPage, false);
	             pPage.setRedirect(true);
	             return pPage;
            }else{
	            PageReference pPage = Page.EEC_ReviewSummarySubmission;
	            pPage.getParameters().put('ltId', licenseTransaction.Id);
	            addMemberIDPageParameter(pPage, false);
	            pPage.setRedirect(true);
	            return pPage;
             }
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public void addMemberIDPageParameter(PageReference pPage, Boolean encrypt) {
        if (String.isNotBlank(accountId)) {
            if (encrypt)
                pPage.getParameters().put('member', EEC_Util.encryptGetParam(accountId));
            else
                pPage.getParameters().put('member', accountId);
        }
    }
    
    public void UpdateDocument(){
    	string docId = apexpages.currentpage().getparameters().get('docId');
    	string commandType = apexpages.currentpage().getparameters().get('commandType');
    	
    	Transaction_Document__c transactionDoc = [select Id, Document_Type__c,
    	Document__c, Document__r.Provider__r.Umbrella_Members__c, Document__r.Provider__c from Transaction_Document__c
    	where Id =: docId];
    	
    	List<Document__c> listDocument;
    	if(commandType == 'Umbrella'){
    		listDocument = [select Id from Document__c where Document_Type__c =: transactionDoc.Document_Type__c
    		and Provider__c =: licenseTransaction.Provider__r.Umbrella_Members__c and Current__c = true];
    	}
    	else if(commandType == 'Provider'){
    		listDocument = [select Id from Document__c where Document_Type__c =: transactionDoc.Document_Type__c
    		and Provider__c =: licenseTransaction.Provider__c and Current__c = true];
    	}
    	
    	if(listDocument.size() > 0){
    		transactionDoc.Document__c = listDocument[0].Id;
    		update transactionDoc;
    	}
    	
    	doGetDocuments();
    }

    public void delAttachment(){
    	string docId = apexpages.currentpage().getparameters().get('index');    	
    	S3_File__c s3File = [select Id from S3_File__c where Id =: docId];    	
    	delete s3File;
    	
    	doGetDocuments();
    }
}