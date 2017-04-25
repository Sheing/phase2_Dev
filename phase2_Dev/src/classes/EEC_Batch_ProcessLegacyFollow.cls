global class EEC_Batch_ProcessLegacyFollow implements Database.Batchable<sObject>{
    
    global List<Historical_Follow_Staging__c> dataListSize = null;
      
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id,name,Follow_Processed__c,Completed_Date__c,Due_Date__c,Created_Date__c,Description__c,Error_Text__c,FollowUp_Code__c,FollowUp_Id__c,Intake_Id__c,
                                         Legal_Issue_Date__c,Licensor__c,Licensor_Name__c,Modification_Date__c,Program_Id__c,Refer_to_Legal_Date__c,Duplicate_Rule__c
                                         From Historical_Follow_Staging__c WHERE Follow_Processed__c = false]);
        
    }

    global void execute(Database.BatchableContext BC,List<Historical_Follow_Staging__c> scope){
        
        dataListSize = scope;
        
        for(Historical_Follow_Staging__c v : scope){
             EEC_ProcessLegacyInvestigationData.processLegacyFollow(v);
        }
        update scope; 
        
    }

    global void finish(Database.BatchableContext BC){
        
        try{ 
            if(dataListSize != null){
                AsyncApexJob batchJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
           
                Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Queued' or Status = 'Processing' or Status = 'Preparing' )];   
                
                if(jobs <= 1){
                    EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyFollow'); 
                }
        
                //If NumberOfErrors is "0" - if the execute method processed all records without errors - then call next contact batch.
                if (batchJob.NumberOfErrors == 0)
                {     
                    EEC_Batch_ProcessLegacyFollow batchLegacyFollow = new EEC_Batch_ProcessLegacyFollow();   
                    Id batchProcessId = Database.executeBatch(batchLegacyFollow,1);    //finish method logic here
                }
                else
                {
                    //process other code
                    if ((batchJob.NumberOfErrors == 0) && (jobs < 5)){
        
                         EEC_Batch_ProcessLegacyFollow batchLegacyFollow = new EEC_Batch_ProcessLegacyFollow();   
                         Id batchProcessId = Database.executeBatch(batchLegacyFollow,1);    //finish method logic here
                        }
                    else{
                        //wait for 1 hour
                    }
                }
             }
             else{
                EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyFollow'); 
             }
        }
        catch(exception ex){
            System.debug('----> Error Processing the EEC_Batch_ProcessLegacyFollow job: ' + ex.getMessage());
        }
    }
    
}