trigger VisitItemStagingTrigger on VisitItemsStaging__c (after insert) {
   
   if (trigger.isInsert){
      VisitItemStagingTriggerHelper.bulkInsertStandardVisitItems(trigger.new); 
   }
   

}