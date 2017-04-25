public class EEC_TransactionDocumentTriggerHandler {
    public static void doAfterInsert(List<Transaction_Document__c> listTransactionDocument){
        updateMissingDocuments(listTransactionDocument);	
    }
    
    public static void doAfterUpdate(List<Transaction_Document__c> listTransactionDocument){
        system.debug('start updateMissingDocuments');
        updateMissingDocuments(listTransactionDocument);
        system.debug('start updateMissingDocuments');
    }
    
    public static void doAfterUnDelete(List<Transaction_Document__c> listTransactionDocument){
        updateMissingDocuments(listTransactionDocument);
    }
    
    public static void doAfterDelete(List<Transaction_Document__c> listTransactionDocument){
        updateMissingDocuments(listTransactionDocument);
    }
    
    private static void updateMissingDocuments(List<Transaction_Document__c> listTransactionDocument){        
        Set<Id> setTransactionId = new Set<Id>();
        
        for(Transaction_Document__c transactionDocument : listTransactionDocument){
            if(transactionDocument.Document_Type__c != null && transactionDocument.Document__c != null){
                setTransactionId.add(transactionDocument.Licensing_Transaction__c);
            }
        }
        List<Licensing_Transaction__c> listTransactions = [select Id, List_of_Missing_Mandatory_Document__c, List_of_Rejected_Document_Not_Submitted__c,
                                                           Provider__r.Config_Record__c,
                                                           RecordType.Name,
                                                           (select Id, Document_Type__c,Document__c,Document_Type__r.Name, Status__c,Mode__c from Transaction_Documents__r)
                                                           from Licensing_Transaction__c where Id in : setTransactionId  and
                                                           Status__c <> 'To Submit' and
                                                           (not Status__c like '%Closed%') and
                                                           (not Status__c like '%Cancelled%')];
        
        
        Set<Id> setLeadConfiguration = new Set<Id>();
        for(Licensing_Transaction__c licesingTransaction : listTransactions){
            setLeadConfiguration.add(licesingTransaction.Provider__r.Config_Record__c);
        }
        
        List<Document_Type__c> listDocumentType = [select Id, LEAD_Configuration__c, Allow_use_of_Umbrella_Level_Document__c, Description__c,Name,Individual_Document__c,Library_Level__c,Need_to_be_Updated_at_each_new_Transacti__c,
                                                   Optional_for_Transactio_Type__c,Related_Role__c,Required_For_Transaction_Type__c from Document_Type__c 
                                                   where LEAD_Configuration__c in : setLeadConfiguration];
        
        Map<Id, List<Document_Type__c>> mapLeadDocumentType = new Map<Id, List<Document_Type__c>>();
        for(Document_Type__c documentType : listDocumentType){
            List<Document_Type__c> listDocumentTypes;
            if(mapLeadDocumentType.get(documentType.LEAD_Configuration__c) == null){
                listDocumentTypes = new List<Document_Type__c>();
            }
            else{
                listDocumentTypes = mapLeadDocumentType.get(documentType.LEAD_Configuration__c);
            }
            listDocumentTypes.add(documentType);
            mapLeadDocumentType.put(documentType.LEAD_Configuration__c, listDocumentTypes);
        }
        
        for(Licensing_Transaction__c licensingTransaction : listTransactions){
            
            List<Document_Type__c> listDocumentTypes = mapLeadDocumentType.get(licensingTransaction.Provider__r.Config_Record__c);
            
            string missingDocuments = '';
            for(Document_Type__c documentType : listDocumentTypes){
                if(string.isNotEmpty(documentType.Required_For_Transaction_Type__c) && documentType.Individual_Document__c == false && documentType.Required_For_Transaction_Type__c.contains(licensingTransaction.RecordType.Name)){
                    for(Transaction_Document__c transactionDocument : licensingTransaction.Transaction_Documents__r){
                        if(transactionDocument.Document_Type__c == documentType.Id && transactionDocument.Mode__c == 'Required' && transactionDocument.Status__c == 'To Upload' && transactionDocument.Document_Type__c != null && transactionDocument.Document__c != null){
                            missingDocuments = missingDocuments + ', ' + documentType.Name;
                        }
                    }
                }
                else if(string.isNotEmpty(documentType.Required_For_Transaction_Type__c) && documentType.Individual_Document__c == true && documentType.Required_For_Transaction_Type__c.contains(licensingTransaction.RecordType.Name)){
                    for(Transaction_Document__c transactionDocument : licensingTransaction.Transaction_Documents__r){
                        if(transactionDocument.Document_Type__c == documentType.Id && transactionDocument.Mode__c == 'Individual' && transactionDocument.Status__c == 'To Upload' && transactionDocument.Document_Type__c != null && transactionDocument.Document__c != null){                                
                            missingDocuments = missingDocuments + ', ' + documentType.Name;
                        }
                    }
                }
            }
            if(missingDocuments.length() > 0)
                licensingTransaction.List_of_Missing_Mandatory_Document__c = missingDocuments.removeStart(', ');
            else
                licensingTransaction.List_of_Missing_Mandatory_Document__c = '';
            
            string rejectedDocuments = '';
            for(Transaction_Document__c transactionDocument : licensingTransaction.Transaction_Documents__r){
                if(transactionDocument.Status__c == 'Returned for Revision' && transactionDocument.Document_Type__c != null && transactionDocument.Document__c != null){
                    rejectedDocuments = rejectedDocuments + ', ' + transactionDocument.Document_Type__r.Name;
                }
            }
            if(rejectedDocuments.length() > 0)
                licensingTransaction.List_of_Rejected_Document_Not_Submitted__c = rejectedDocuments.removeStart(', ');
            else
                licensingTransaction.List_of_Rejected_Document_Not_Submitted__c = '';
        }
        update listTransactions;
    }
}