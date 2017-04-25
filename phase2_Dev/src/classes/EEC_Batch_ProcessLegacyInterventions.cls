//Author - Latha Davuluri
//Batch job to process Legacy Interventions on Investigation - LEAD-4961

global class EEC_Batch_ProcessLegacyInterventions implements Database.Batchable<sObject>{

    global List<Historical_Intervention_Staging__c> dataListSize = null;
      
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id, Name, Duplicate_Rule__c, Error_Text__c,Date_Completed__c, Intervention_Code__c, Intake_Id__c, Intervention_Id__c, Intervention_Processed__c, Intervention_Type__c, Program_Id__c From Historical_Intervention_Staging__c  Where Intervention_Processed__c = false]);        
    }

    global void execute(Database.BatchableContext BC,List<Historical_Intervention_Staging__c> scope){
        
        dataListSize = scope;
        
        for(Historical_Intervention_Staging__c v : scope){
           EEC_ProcessLegacyInvestigationData.processLegacyIntervention(v);
        }
        update scope; 
        
    }

    global void finish(Database.BatchableContext BC){
        
        try{
            if(dataListSize != null){
                AsyncApexJob batchJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
           
                Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Queued' or Status = 'Processing' or Status = 'Preparing' )];   
                
                if(jobs <= 1){
                    EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyInterventions'); 
                }
        
                //If NumberOfErrors is "0" - if the execute method processed all records without errors - then call next contact batch.
                if (batchJob.NumberOfErrors == 0)
                {     
                    EEC_Batch_ProcessLegacyInterventions batchLegacyInterventions = new EEC_Batch_ProcessLegacyInterventions();   
                    Id batchProcessId = Database.executeBatch(batchLegacyInterventions,1);    //finish method logic here
                }
                else
                {
                    //process other code
                    if ((batchJob.NumberOfErrors == 0) && (jobs < 5)){
        
                         EEC_Batch_ProcessLegacyInterventions batchLegacyInterventions = new EEC_Batch_ProcessLegacyInterventions();   
                         Id batchProcessId = Database.executeBatch(batchLegacyInterventions,1);    //finish method logic here
                        }
                    else{
                        //wait for 1 hour
                    }
                }
             }
             else{
                EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyInterventions'); 
             }
        }
        catch(exception ex){
            System.debug('----> Error Processing the EEC_Batch_ProcessLegacyInterventions job: ' + ex.getMessage());
        }
    }

}