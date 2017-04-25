trigger StandardVisitItemTrigger on Standard_Inspection_Item__c (before update, after insert) {
   
    
    if (trigger.isInsert && trigger.isAfter){
       StandardVisitItemTriggerHelper.bulkInsertStandardVisitItems(trigger.New);
       system.debug('#####Insert List' + trigger.New);
     }
     
     if(trigger.isBefore && trigger.isUpdate){
       StandardVisitItemTriggerHelper.bulkUpdateStandardVisitItems(trigger.newMap);
       system.debug('#####Update List' + trigger.new);
     }
        

}