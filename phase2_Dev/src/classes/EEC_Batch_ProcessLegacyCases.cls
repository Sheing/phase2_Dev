//Author - Latha Davuluri
//Batch job to process Legacy Cases - LEAD-4375

global class EEC_Batch_ProcessLegacyCases implements Database.Batchable<sObject>{

    global List<Historical_Cases_Staging__c> dataListSize = null;
      
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select h.Unlicensed_ID__c, h.Summary_of_Allegation__c, h.Summary_Type_of_case__c, h.Status__c, h.Responsible__c, h.Reporter_ZipCode__c, 
                                                h.Reporter_Work_Phone__c, h.Reporter_Street__c, h.Reporter_State__c, h.Reporter_Relationship_To_Provider__c, h.Reporter_Last_Name__c, 
                                                h.Reporter_ID__c, h.Reporter_Home_Phone__c, h.Reporter_First_Name__c, h.Reporter_Data_Entry__c, h.Reporter_City__c, h.Reporter_Anonymous__c, 
                                                h.Program_ID__c, h.Nature_of_complaint__c, h.Nature_of_complaint_Description__c, h.Name, h.IsDeleted, h.Intake_Method__c, h.Intake_ID__c, 
                                                h.Id, h.Filed_with_DCF__c, h.Duplicate_Rule_1__c, h.Date_Opened__c, h.Date_Event_Occurred__c, h.Date_Closed__c, h.DCF_File_Submitter__c, h.DCF_File_Submission_Date__c, 
                                                h.Complaint_Disposition__c, h.Case_Processed__c, h.Case_Owner__c, h.Allegation_Description__c, h.Allegation_Code__c, h.Case_Owner_Name__c,
                                                h.Additional_Description__c From Historical_Cases_Staging__c h WHERE h.Case_Processed__c = false]);
        
    }

    global void execute(Database.BatchableContext BC,List<Historical_Cases_Staging__c> scope){
    	
        dataListSize = scope;
        
        for(Historical_Cases_Staging__c v : scope){
        	 EEC_ProcessLegacyCaseData.processLegacyCases(v);
        }
        update scope; 
        
    }

    global void finish(Database.BatchableContext BC){
    	
    	try{
	    	if(dataListSize != null){
		    	AsyncApexJob batchJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
	       
		        Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Queued' or Status = 'Processing' or Status = 'Preparing' )];   
		        
		        if(jobs <= 1){
		            EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyCases'); 
		        }
		
		        //If NumberOfErrors is "0" - if the execute method processed all records without errors - then call next contact batch.
			    if (batchJob.NumberOfErrors == 0)
			    {     
			        EEC_Batch_ProcessLegacyCases batchLegacyCases = new EEC_Batch_ProcessLegacyCases();   
			        Id batchProcessId = Database.executeBatch(batchLegacyCases,1);    //finish method logic here
			    }
			    else
			    {
			        //process other code
			        if ((batchJob.NumberOfErrors == 0) && (jobs < 5)){
		
		        		 EEC_Batch_ProcessLegacyCases batchLegacyCases = new EEC_Batch_ProcessLegacyCases();   
			             Id batchProcessId = Database.executeBatch(batchLegacyCases,1);    //finish method logic here
		         		}
		        	else{
		         		//wait for 1 hour
		          	}
			    }
	         }
	         else{
	         	EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyCases'); 
	         }
    	}
    	catch(exception ex){
    		System.debug('----> Error Processing the EEC_Batch_ProcessLegacyCases job: ' + ex.getMessage());
    	}
    }

}