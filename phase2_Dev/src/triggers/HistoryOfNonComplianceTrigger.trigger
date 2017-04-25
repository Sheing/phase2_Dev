trigger HistoryOfNonComplianceTrigger on HistoryOfNonCompliance__c (after insert) {
	
	HistoryOfNonComplianceTriggerHelper.bulkVisitInsert(trigger.new); 

}