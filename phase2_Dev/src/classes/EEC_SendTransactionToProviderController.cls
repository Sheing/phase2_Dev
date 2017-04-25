public with sharing class EEC_SendTransactionToProviderController {
	public Licensing_Transaction__c licensingTransaction{get;set;}
	public string mode{get;set;}
	public string parent{get;set;}
	
    public EEC_SendTransactionToProviderController(ApexPages.StandardController std){
    try {
      licensingTransaction = [select Id, EEC_Note_For_Revision__c, 
      Attachments_Returned_for_Revision__c, Transaction_Returned_for_Revision__c from Licensing_Transaction__c where Id=: std.getId()];
      mode = ApexPages.currentPage().getParameters().get('mode');
      parent = ApexPages.currentPage().getParameters().get('parent');
    } catch(Exception e) {
      System.debug('----> Error: ' + e.getMessage());
    }
  }
  
  public void sendForRevision(){
  	try{
  		licensingTransaction.Transaction_Returned_for_Revision__c = true;
  		update licensingTransaction;
  		
  		List<Transaction_Document__c> listTransactionDocument = [select Id, Status__c from Transaction_Document__c where
  		Status__c = 'Rejected' and Licensing_Transaction__c=: licensingTransaction.Id];
  		
  		system.debug('listTransactionDocument: ' + listTransactionDocument);
  		for(Transaction_Document__c transactionDocument : listTransactionDocument){
  			transactionDocument.Status__c = 'Returned for Revision';
  		}
  		update listTransactionDocument;
  		
  		system.debug('listTransactionDocument: ' + listTransactionDocument);
  	}
  	catch(Exception ex){
  		system.debug('error from sendForRevision: ' + ex.getMessage());
  	}
  }
  
  public void sendRejectedDocuments(){
  	try{
  		licensingTransaction.Attachments_Returned_for_Revision__c = true;
  		update licensingTransaction;
  		
  		List<Transaction_Document__c> listTransactionDocument = [select Id, Status__c from Transaction_Document__c where
  		Status__c = 'Rejected' and Licensing_Transaction__c=: licensingTransaction.Id];
  		
  		system.debug('listTransactionDocument: ' + listTransactionDocument);
  		for(Transaction_Document__c transactionDocument : listTransactionDocument){
  			transactionDocument.Status__c = 'Returned for Revision';
  		}
  		update listTransactionDocument;
  		
  		system.debug('listTransactionDocument: ' + listTransactionDocument);
  	}
  	catch(Exception ex){
  		system.debug('error from sendRejectedDocuments: ' + ex.getMessage());
  	}
  }
}