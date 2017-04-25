public with sharing class BatchableUtil {
  
  public static void abortSelf(String cronJobName, Boolean isFailure) {
    System.debug('----> [BatchableUtil] Abort Job: ' + cronJobName);
    List<CronTrigger> cronTriggerList = [Select Id, CronJobDetail.Name From CronTrigger Where CronJobDetail.Name = :cronJobName Limit 1];

    for (CronTrigger t : cronTriggerList) {
      System.abortJob(t.Id);
    }
  }

  public static void abortSelf(String cronJobName, AsyncApexJob a) {
    // Call the parent version to abort the job.
    abortSelf(cronJobName, true);
  }

  public static String generateBatchableName(String prefix, Integer counter, String ownerId) {
    DateTime dt = DateTime.now();
    String formattedDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss.SSS\'Z\'');
    return prefix + ' (' + ownerId + '_' + formattedDt + ') - ' + counter;
  }

  public static boolean hasSObjectField(String fieldName, SObject so){
    return so.getSobjectType().getDescribe().fields.getMap().keySet().contains(fieldName);
  }

  public static List<ProcessingStepResult__c> processSteps(List<Intake__c> intakeList, String typeStr, Map<String, List<Response__c>> intakeResponsesMap, Set<Id> formVersionIdList) {
    List<ProcessingStepResult__c> mStepResults = new List<ProcessingStepResult__c>();
    // Get a list of all the processing steps for PRE processing based on the given intakes form versions.
    List<FormVersion__c> formVersionList = [
        Select 
          Id, Name, (
            Select 
              Id, Name, Config__c, Order__c, Type__r.Name, Type__r.ClassName__c, Type__r.Type__c 
            From 
              Processing_Steps__r 
            Where 
              Type__r.Type__c = :typeStr
          ) 
        From 
          FormVersion__c 
        Where 
          Id In :formVersionIdList
      ];
    Map<Id, FormVersion__c> formVersionsMap = new Map<Id, FormVersion__c>(formVersionList);
    // Loop through the FormVersions and start processing the Steps for each version.
    for (Intake__c intake : intakeList) {
      Boolean stepError = false;
      Savepoint sp = Database.setSavepoint();
      try {
        // Loop through the steps and convert them into the Processing Step Interface.   
        for (ProcessingStep__c pStep : formVersionsMap.get(intake.FormVersion__c).Processing_Steps__r) {
          // Get the type of the Processing Step based on the saved class name.
          Type t = Type.forName(pStep.Type__r.ClassName__c);
          // Create an instance of the interface based on the ne type.
          ProcessingStep stepInterface = (ProcessingStep) t.newInstance();
          // Call to process the intake.
          ProcessingStepResult__c result = stepInterface.process(intake, intakeResponsesMap, pStep.Config__c);
          // Set the results step Id.
          result.ProcessingStep__c = pStep.Id;
          mStepResults.add(result);
          // If the result was a failure then we wish to cancel the processing of this intake and revert all changes from it. 
          if (result.Result__c != 'Success') {
            stepError= true;
            break;
          }
        }
        System.debug('----> Results: ' + mStepResults);
        // If an error occured during the step process then drop this exzanoke,
        if (stepError) {
          System.debug('----> [BatchableUtil] Error during step progression. Reverting DB changes and skipping step.');
          Database.rollback(sp);
        }
      } catch (Exception e) {
        System.debug('----> Processing Intake Failed. Error: ' + e.getMessage());
        Database.rollback(sp);
      }
    }
    return mStepResults;    
  } 
}