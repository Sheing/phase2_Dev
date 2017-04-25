//Author - Latha Davuluri
//Batch job to convert Contacts to Contact Roles on ONLY GSA and R&P Providers  - LEAD-4721

global class EEC_Batch_ConvertContactToContactRole implements Database.Batchable<sObject>{

    global List<Contact> dataListSize = null;
      
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT c.Id, c.Role__c, c.Name,  c.Contact_Processed__c, c.AccountId FROM Contact c WHERE c.AccountId != null AND c.AccountId in
                     (SELECT id FROM account WHERE is_GSA__c = true OR is_R_P__c = true OR RecordType.Name like '%umbrella%') AND c.Contact_Processed__c = false]);
    }

    global void execute(Database.BatchableContext BC,List<Contact> scope){
    	
        dataListSize = scope;
        
        for(Contact c : scope){
        	   EEC_ConvertContactToContactRole.convertContactToContactRole(c);
               c.Contact_Processed__c = true;  
       	}       
        
        update scope; 
        
    }

    global void finish(Database.BatchableContext BC){
    	
    	try{
	    	if(dataListSize != null){
		    	AsyncApexJob batchJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
	       
		        Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Queued' or Status = 'Processing' or Status = 'Preparing' )];   
		        
		        if(jobs <= 1){
		            EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ConvertContactToContactRole'); 
		        }
		
		        //If NumberOfErrors is "0" - if the execute method processed all records without errors - then call next contact batch.
			    if (batchJob.NumberOfErrors == 0)
			    {     
			        EEC_Batch_ConvertContactToContactRole batchCreateContactRole = new EEC_Batch_ConvertContactToContactRole();   
			        Id batchProcessId = Database.executeBatch(batchCreateContactRole,1);    //finish method logic here
			    }
			    else
			    {
			        //process other code
			        if ((batchJob.NumberOfErrors == 0) && (jobs < 5)){
		
		        		 EEC_Batch_ConvertContactToContactRole batchCreateContactRole = new EEC_Batch_ConvertContactToContactRole();   
			             Id batchProcessId = Database.executeBatch(batchCreateContactRole,1);    //finish method logic here
		         		}
		        	else{
		         		//wait for 1 hour
		          	}
			    }
	         }
	         else{
	         	EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ConvertContactToContactRole'); 
	         }
    	}
    	catch(exception ex){
    		System.debug('----> Error Processing the EEC_Batch_ConvertContactToContactRole job: ' + ex.getMessage());
    	}
    	
    }

}