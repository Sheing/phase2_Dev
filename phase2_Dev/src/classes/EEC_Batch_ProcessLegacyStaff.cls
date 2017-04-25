global class EEC_Batch_ProcessLegacyStaff implements Database.Batchable<sObject> {
	
	
    
    global List<Historical_Staff_Staging__c> dataListSize = null;
      
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id,name,Active__c,Date_Assigned__c,Duplicate_Rule__c,Error_Text__c,Intake_Id__c,Licensor_Name__c,Licensor_Number__c,Program_Id__c,Role__c,Staff_Processed__c,Total_Number__c
                                         From Historical_Staff_Staging__c WHERE Staff_Processed__c = false]);
        
    }

    global void execute(Database.BatchableContext BC,List<Historical_Staff_Staging__c> scope){
    	
        dataListSize = scope;
        
        for(Historical_Staff_Staging__c v : scope){
        	 EEC_ProcessLegacyInvestigationData.processLegacyStaff(v);
        }
        update scope; 
        
    }

    global void finish(Database.BatchableContext BC){
    	
    	try{ 
	    	if(dataListSize != null){
		    	AsyncApexJob batchJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
	       
		        Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Queued' or Status = 'Processing' or Status = 'Preparing' )];   
		        
		        if(jobs <= 1){
		            EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyStaff'); 
		        }
		
		        //If NumberOfErrors is "0" - if the execute method processed all records without errors - then call next contact batch.
			    if (batchJob.NumberOfErrors == 0)
			    {     
			        EEC_Batch_ProcessLegacyStaff batchLegacyStaff = new EEC_Batch_ProcessLegacyStaff();   
			        Id batchProcessId = Database.executeBatch(batchLegacyStaff,1);    //finish method logic here
			    }
			    else
			    {
			        //process other code
			        if ((batchJob.NumberOfErrors == 0) && (jobs < 5)){
		
		        		 EEC_Batch_ProcessLegacyStaff batchLegacyStaff = new EEC_Batch_ProcessLegacyStaff();   
			             Id batchProcessId = Database.executeBatch(batchLegacyStaff,1);    //finish method logic here
		         		}
		        	else{
		         		//wait for 1 hour
		          	}
			    }
	         }
	         else{
	         	EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyStaff'); 
	         }
    	}
    	catch(exception ex){
    		System.debug('----> Error Processing the EEC_Batch_ProcessLegacyStaff job: ' + ex.getMessage());
    	}
    }

	
    
}