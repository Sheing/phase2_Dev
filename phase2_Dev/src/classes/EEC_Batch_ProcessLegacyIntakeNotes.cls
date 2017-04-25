//Author - Latha Davuluri
//Batch job to process Legacy Intake Notes on Cases - LEAD-4375

global class EEC_Batch_ProcessLegacyIntakeNotes implements Database.Batchable<sObject>{

    global List<Historical_Intake_Notes_Staging__c> dataListSize = null;
      
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id, Name, Notes__c, Notes_CreatedBy__c,  Notes_Date__c, Notes_Id__c, Program_Id__c, ErrorText__c, Notes_Processed__c, Duplicate_Rule_1__c From Historical_Intake_Notes_Staging__c h WHERE h.Notes_Processed__c = false]);        
    }

    global void execute(Database.BatchableContext BC,List<Historical_Intake_Notes_Staging__c> scope){
    	
        dataListSize = scope;
        
        for(Historical_Intake_Notes_Staging__c v : scope){
       	   EEC_ProcessLegacyCaseData.processLegacyIntakeNotes(v);
        }
        update scope; 
        
    }

    global void finish(Database.BatchableContext BC){
    	
    	try{
	    	if(dataListSize != null){
		    	AsyncApexJob batchJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
	       
		        Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Queued' or Status = 'Processing' or Status = 'Preparing' )];   
		        
		        if(jobs <= 1){
		            EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyIntakeNotes'); 
		        }
		
		        //If NumberOfErrors is "0" - if the execute method processed all records without errors - then call next contact batch.
			    if (batchJob.NumberOfErrors == 0)
			    {     
			        EEC_Batch_ProcessLegacyIntakeNotes batchLegacyIntakeNotes = new EEC_Batch_ProcessLegacyIntakeNotes();   
			        Id batchProcessId = Database.executeBatch(batchLegacyIntakeNotes,1);    //finish method logic here
			    }
			    else
			    {
			        //process other code
			        if ((batchJob.NumberOfErrors == 0) && (jobs < 5)){
		
		        		 EEC_Batch_ProcessLegacyIntakeNotes batchLegacyIntakeNotes = new EEC_Batch_ProcessLegacyIntakeNotes();   
			             Id batchProcessId = Database.executeBatch(batchLegacyIntakeNotes,1);    //finish method logic here
		         		}
		        	else{
		         		//wait for 1 hour
		          	}
			    }
	         }
	         else{
	         	EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyIntakeNotes'); 
	         }
    	}
    	catch(exception ex){
    		System.debug('----> Error Processing the EEC_Batch_ProcessLegacyIntakeNotes job: ' + ex.getMessage());
    	}
    }

}