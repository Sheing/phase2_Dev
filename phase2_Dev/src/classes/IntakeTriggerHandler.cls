public class IntakeTriggerHandler {

  public static void PreProcessingFlow(List<Intake__c> newIntakeList) {
    Set<Id> formVersionIdList = new Set<Id>();

    for (Intake__c intake : newIntakeList) {
      formVersionIdList.add(intake.FormVersion__c);
    }
    BatchableUtil.processSteps(newIntakeList, 'Pre', null, formVersionIdList);    
  }

  public static void VerifyAndScheduleIntakeResponseBatch(Set<Id> mIntakeLst) {
    if (mIntakeLst != null && mIntakeLst.size() > 0) {      
      // Create the scheduable and send it the required data processing.
      ProcessingStepSchedulable scheduable = new ProcessingStepSchedulable(mIntakeLst);
      
      // Generate new batch name.
      String newBatchName = BatchableUtil.generateBatchableName('Intake', 0, UserInfo.getUserId());
      scheduable.batchableName = newBatchName;
      
      // Prep the cron to run 60 Seconds from now.
      Datetime sysTime = System.now().addSeconds(10);
      String cronTiming = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
      
      // Schedule the cron under the new batch name to run.
      System.schedule(newBatchName, cronTiming, scheduable);
    }
  }
}