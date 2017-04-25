//Author - Latha Davuluri
//Batch job to Load Placement DL Tools - LEAD-4726
global class EEC_Batch_LoadPlacementTools implements Database.Batchable<sObject>{

    global List<VisitItemsStaging__c> dataListSize = null;
      
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select v.VisitItemToolAssignment__c, v.VisitItemRegulation__c, v.VisitItemDomain__c, v.RandomItemDomain__c, v.ProviderType__c, v.Override__c, v.Name, v.LastModifiedById, v.IsRandomItem__c, v.Id, v.Guidance__c, v.Description__c, v.Processed__c 
                                                From VisitItemsStaging__c v 
                                                Where v.Processed__c = false
                                                And (v.VisitItemToolAssignment__c like 'Foster Care%' Or v.VisitItemToolAssignment__c like 'Adoption%')]);
        
    }

    global void execute(Database.BatchableContext BC,List<VisitItemsStaging__c> scope){
    	
        dataListSize = scope;
        
        for(VisitItemsStaging__c v : scope){
        	//try{
        	   EEC_LoadDLTools.loadFCCDLTools(v);
               v.Processed__c = true;  
        	//}
        	/*catch(exception ex){
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
		            EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_LoadPlacementTools'); 
		        }
		
		        //If NumberOfErrors is "0" - if the execute method processed all records without errors - then call next contact batch.
			    if (batchJob.NumberOfErrors == 0)
			    {     
			        EEC_Batch_LoadPlacementTools batchDLTools = new EEC_Batch_LoadPlacementTools();   
			        Id batchProcessId = Database.executeBatch(batchDLTools,1);    //finish method logic here
			    }
			    else
			    {
			        //process other code
			        if ((batchJob.NumberOfErrors == 0) && (jobs < 5)){
		
		        		 EEC_Batch_LoadPlacementTools batchDLTools = new EEC_Batch_LoadPlacementTools();   
			             Id batchProcessId = Database.executeBatch(batchDLTools,1);    //finish method logic here
		         		}
		        	else{
		         		//wait for 1 hour
		          	}
			    }
	         }
	         else{
	         	EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_LoadPlacementTools'); 
	         }
    	}
    	catch(exception ex){
    		System.debug('----> Error Processing the EEC_Batch_LoadPlacementTools job: ' + ex.getMessage());
    	}
    }
}