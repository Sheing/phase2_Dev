global class EEC_Batch_InvestigationConclusion implements Database.Batchable<sObject> {
	
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
    	
		return Database.getQueryLocator([Select Id, AccountID 
                                         from CASE 
                                         WHERE RecordType.Name = 'Foster Home 51A or Incident' 
                                         AND Investigation_Conclusion_Submitted_Date__c = NULL
                                         AND	Status != 'Closed' AND Status != 'Not Submitted'
                                         AND Incident_Reported_Date__c < LAST_N_DAYS:28
                                         AND ( Account.Last_Investigation_Conclusion_Notificati__c = NULL OR Account.Last_Investigation_Conclusion_Notificati__c < LAST_N_DAYS:28 )
                                         ]);
    }

    global void execute(Database.BatchableContext bc, List<Case> scope) {
    	
    	if(scope.Size()>0)
    	{
    		
    		Set<Id> setAccount = new Set<Id>();
        
	        for(Case c : scope)
	        {
	            setAccount.add(c.AccountId);
	        }
	       
	        List<Account> accountList = [SELECT ID,Notify_for_Investigation_Conclusion__c FROM Account WHERE ID in :setAccount];
	        
	        if(accountList.Size()>0)
	        {
	        	
	        	for(Account acc : accountList)
		        {
		            acc.Notify_for_Investigation_Conclusion__c = true;
		        }
		        
		        Database.update(accountList);
	        }
    	}
		
    }

    global void finish(Database.BatchableContext bc) {
		

    }



}