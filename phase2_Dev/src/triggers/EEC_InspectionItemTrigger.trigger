trigger EEC_InspectionItemTrigger on Inspection_Item__c (before insert, before update, before delete, after update) {
   if(Trigger.isDelete){
     EEC_InspectionItemTriggerHandler.beforeDeleteCheck(Trigger.old, Trigger.oldMap);
   } else {
       EEC_InspectionItemTriggerHandler insp = new EEC_InspectionItemTriggerHandler(trigger.new,trigger.OldMap);
   
       if (Trigger.isUpdate && Trigger.isAfter) {
          insp.updateRequireFeedback();
          insp.SubmissionHistory();
       }else if(Trigger.isinsert && Trigger.isAfter){ 
         insp.SubmissionHistory();
       
       }
       
       if(!EEC_InspectionItemTriggerHelper.flag){
            EEC_InspectionItemTriggerHelper.flag = true;
            if(trigger.isInsert){
                EEC_InspectionItemTriggerHelper.callVisitItems(trigger.new,null);        
            }else{
                EEC_InspectionItemTriggerHelper.callVisitItems(trigger.new,trigger.oldMap);        
            }
        }
   }
}