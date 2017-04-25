//Author - Latha Davuluri
//Batch job to Load FCC DL Tools - LEAD-4726
global class EEC_Batch_LoadFCCDLTools implements Database.Batchable<sObject>{
    
    global List<VisitItemsStaging__c> dataListSize = null;
      
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select v.VisitItemToolAssignment__c, v.VisitItemRegulation__c, v.VisitItemDomain__c, v.RandomItemDomain__c, v.ProviderType__c, v.Override__c, v.Name, v.IsRandomItem__c, v.Id, v.Guidance__c, v.Description__c, v.Processed__c 
                                                From VisitItemsStaging__c v 
                                                Where v.Processed__c = false And v.To_Delete__c = false And v.VisitItemToolAssignment__c like 'FCC%']);
        
    }

    global void execute(Database.BatchableContext BC,List<VisitItemsStaging__c> scope){
    	
        dataListSize = scope;
        
        for(VisitItemsStaging__c v : scope){
        //	try{
        	   EEC_LoadDLTools.loadFCCDLTools(v);
               v.Processed__c = true;  
        	/*}
        	catch(exception ex){
        		string errText = ex.getMessage();
        	
            }*/
        }
        update scope; 
        
    }

    global void finish(Database.BatchableContext BC){
    	
    	try{
	    	if(dataListSize != null){
		    	AsyncApexJob batchJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
	       
		        Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Queued' or Status = 'Processing' or Status = 'Preparing' )];   
		        
		        if(jobs <= 1){
		            EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_LoadFCCDLTools'); 
		        }
		
		        //If NumberOfErrors is "0" - if the execute method processed all records without errors - then call next contact batch.
			    if (batchJob.NumberOfErrors == 0)
			    {     
			        EEC_Batch_LoadFCCDLTools batchFCCDLTools = new EEC_Batch_LoadFCCDLTools();   
			        Id batchProcessId = Database.executeBatch(batchFCCDLTools,1);    //finish method logic here
			    }
			    else
			    {
			        //process other code
			        if ((batchJob.NumberOfErrors == 0) && (jobs < 5)){
		
		        		 EEC_Batch_LoadFCCDLTools batchFCCDLTools = new EEC_Batch_LoadFCCDLTools();   
			             Id batchProcessId = Database.executeBatch(batchFCCDLTools,1);    //finish method logic here
		         		}
		        	else{
		         		//wait for 1 hour
		          	}
			    }
	         }
	         else{
	         	EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_LoadFCCDLTools'); 
	         }
    	}
    	catch(exception ex){
    		System.debug('----> Error Processing the EEC_Batch_LoadFCCDLTools job: ' + ex.getMessage());
    	}
    }
}