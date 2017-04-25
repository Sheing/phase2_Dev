trigger IntakeTrigger on Intake__c (after insert, after update) {
  Set<Id> participants = new Set<Id>();

  if (Trigger.isInsert) {
    IntakeTriggerHandler.PreProcessingFlow(Trigger.new);
  }
	
  if (Trigger.isUpdate) {
    // If the change on Intake is an update then verify the status.
    for (Intake__c intake : Trigger.new) {
      // Get the current Intake__c's status. 
      String status = intake.Status__c;
      String oldStatus = Trigger.oldMap.get(intake.Id).Status__c;
      // If the status is submitted we want to prep the id for batch processing.
      if (status.equalsIgnoreCase('submitted') && !oldStatus.equalsIgnoreCase('submitted')) {
        participants.add(intake.Id);
      }
    }
  	IntakeTriggerHandler.VerifyAndScheduleIntakeResponseBatch(participants);
  }
}