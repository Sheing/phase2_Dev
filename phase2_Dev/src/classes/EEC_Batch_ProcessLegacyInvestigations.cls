global class EEC_Batch_ProcessLegacyInvestigations implements Database.Batchable<sObject>{
    
    global List<Historical_Investigation_Staging__c> dataListSize = null;
      
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id,name,Investigation_Processed__c,Error_Text__c,AG1__c,AG2__c,AG3__c,Assign_Date__c,Corrective_Action_Due_Days__c,Cover_Letter_Custom_CC_List__c,
                                         Cover_Letter_Custom_From_Name__c,Cover_Letter_Custom_From_Title__c,Cover_Letter_Custom_Text__c,Cover_Letter_Custom_To_Name__c,Due_Date__c,
                                         Duplicate_Rule__c,Filed_with_51A__c,Intake_Id__c,Investigation_Number__c,Agencies_Involved__c,Leader__c,Program_Id__c,Related_to_51A__c
                                         From Historical_Investigation_Staging__c WHERE Investigation_Processed__c = false]);
        
    }

    global void execute(Database.BatchableContext BC,List<Historical_Investigation_Staging__c> scope){
    	
        dataListSize = scope;
        
        for(Historical_Investigation_Staging__c v : scope){
        	 EEC_ProcessLegacyInvestigationData.processLegacyInvestigations(v);
        }
        update scope; 
        
    }

    global void finish(Database.BatchableContext BC){
    	
    	try{
	    	if(dataListSize != null){
		    	AsyncApexJob batchJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
	       
		        Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Queued' or Status = 'Processing' or Status = 'Preparing' )];   
		        
		        if(jobs <= 1){
		            EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyInvestigations'); 
		        }
		
		        //If NumberOfErrors is "0" - if the execute method processed all records without errors - then call next contact batch.
			    if (batchJob.NumberOfErrors == 0)
			    {     
			        EEC_Batch_ProcessLegacyInvestigations batchLegacyInv = new EEC_Batch_ProcessLegacyInvestigations();   
			        Id batchProcessId = Database.executeBatch(batchLegacyInv,1);    //finish method logic here
			    }
			    else
			    {
			        //process other code
			        if ((batchJob.NumberOfErrors == 0) && (jobs < 5)){
		
		        		 EEC_Batch_ProcessLegacyInvestigations batchLegacyInv = new EEC_Batch_ProcessLegacyInvestigations();   
			             Id batchProcessId = Database.executeBatch(batchLegacyInv,1);    //finish method logic here
		         		}
		        	else{
		         		//wait for 1 hour
		          	}
			    }
	         }
	         else{
	         	EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyInvestigations'); 
	         }
    	}
    	catch(exception ex){
    		System.debug('----> Error Processing the EEC_Batch_ProcessLegacyInvestigations job: ' + ex.getMessage());
    	}
    }

}