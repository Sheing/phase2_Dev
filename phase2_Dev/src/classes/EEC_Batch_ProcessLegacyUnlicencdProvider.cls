//Author - Latha Davuluri
//Batch job to process Legacy Cases - LEAD-4375

global class EEC_Batch_ProcessLegacyUnlicencdProvider implements Database.Batchable<sObject>{

    global List<Historical_Unlicen_Providers_Staging__c> dataListSize = null;
      
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id, Name, Unlicensed_Name__c, Unlicensed_Address1__c, Unlicensed_City__c, Unlicensed_ZipCode__c, Unlicensed_Phone__c, Unlicensed_ID__c, Unlicensed_Licensor__c, Unlicensed_Licensor_Name__c, ErrorText__c, Provider_Processed__c From Historical_Unlicen_Providers_Staging__c h WHERE h.Provider_Processed__c = false]);        
    }

    global void execute(Database.BatchableContext BC,List<Historical_Unlicen_Providers_Staging__c> scope){
    	
        dataListSize = scope;
        
        for(Historical_Unlicen_Providers_Staging__c v : scope){
       	   EEC_ProcessLegacyCaseData.processLegacyUnlicensdProviders(v);
        }
        update scope; 
        
    }

    global void finish(Database.BatchableContext BC){
    	
    	try{
	    	if(dataListSize != null){
		    	AsyncApexJob batchJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
	       
		        Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Queued' or Status = 'Processing' or Status = 'Preparing' )];   
		        
		        if(jobs <= 1){
		            EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyUnlicencdProvider'); 
		        }
		
		        //If NumberOfErrors is "0" - if the execute method processed all records without errors - then call next contact batch.
			    if (batchJob.NumberOfErrors == 0)
			    {     
			        EEC_Batch_ProcessLegacyUnlicencdProvider batchLegacyProviders = new EEC_Batch_ProcessLegacyUnlicencdProvider();   
			        Id batchProcessId = Database.executeBatch(batchLegacyProviders,1);    //finish method logic here
			    }
			    else
			    {
			        //process other code
			        if ((batchJob.NumberOfErrors == 0) && (jobs < 5)){
		
		        		 EEC_Batch_ProcessLegacyUnlicencdProvider batchLegacyProviders = new EEC_Batch_ProcessLegacyUnlicencdProvider();   
			             Id batchProcessId = Database.executeBatch(batchLegacyProviders,1);    //finish method logic here
		         		}
		        	else{
		         		//wait for 1 hour
		          	}
			    }
	         }
	         else{
	         	EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyUnlicencdProvider'); 
	         }
    	}
    	catch(exception ex){
    		System.debug('----> Error Processing the EEC_Batch_ProcessLegacyUnlicencdProvider job: ' + ex.getMessage());
    	}
    }

}