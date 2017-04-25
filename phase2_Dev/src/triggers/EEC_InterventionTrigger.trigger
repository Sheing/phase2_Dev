trigger EEC_InterventionTrigger on Intervention__c (after insert, after update) {

    EEC_InterventionTriggerHandler ect = new EEC_InterventionTriggerHandler(Trigger.new, Trigger.oldMap);
    
    if(Trigger.IsAfter && Trigger.IsUpdate){
        ect.sendInterventionSubmittedOutOfOffice();
    }
}