trigger EEC_NonComplaintItemTrigger on Non_Compliant__c (before insert, before update, before delete, after update) {

   EEC_NonComplaintItemTriggerHandler nocomp = new EEC_NonComplaintItemTriggerHandler(trigger.new,trigger.OldMap);
   if (Trigger.isUpdate && Trigger.isAfter) {
      nocomp.updateRequireFeedback();
      nocomp.SubmissionHistory();
   }
   if(Trigger.isBefore && !Trigger.isDelete){
       nocomp.updateStatus();
   }
   /*else if(Trigger.isinsert && Trigger.isAfter){ 
     nocomp.SubmissionHistory();
   }*/
   if(Trigger.isDelete){
    system.debug('deleting records');
    EEC_NonComplaintItemTriggerHandler.verifyDeleteForLegacyData(Trigger.old, Trigger.oldMap);
   }
   
}