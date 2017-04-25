trigger EEC_LicenseTransactionTrigger on Licensing_Transaction__c (before insert, before update, after update) {
   if(!EEC_LicenseTransactionTriggerHandler.flag){ 
    if(trigger.isBefore){
        EEC_LicenseTransactionTriggerHandler ltt = new EEC_LicenseTransactionTriggerHandler(Trigger.new, Trigger.oldMap);
        if(!EEC_LicenseTransactionTriggerHandler.checkRecursive()){
             EEC_LicenseTransactionTriggerHandler.bulkAfter();
             EEC_LicenseTransactionTriggerHandler.updateOnChangeOfRegion();
             EEC_LicenseTransactionTriggerHandler.updateRegion();
        }
        else{
        	EEC_LicenseTransactionTriggerHandler.bulkAfter();
        }
    }
	
	if(trigger.isInsert && trigger.isBefore){
		EEC_LicenseTransactionTriggerHandler ltt = new EEC_LicenseTransactionTriggerHandler(Trigger.new, Trigger.oldMap);
		if(!EEC_LicenseTransactionTriggerHandler.checkRecursive()){
		}
	}
    if (trigger.isUpdate && trigger.isAfter){
        EEC_LicenseTransactionTriggerHandler ltt = new EEC_LicenseTransactionTriggerHandler(Trigger.new, Trigger.oldMap);
        ltt.licenseMapVisit();
        if(!EEC_LicenseTransactionTriggerHandler.checkRecursive()){
            EEC_LicenseTransactionTriggerHandler.bulkAfter();
        }
        
        ltt.updateHouseHoldMembers();
        EEC_LicenseTransactionTriggerHandler.createConditionFccUpto8(Trigger.new);
        EEC_LicenseTransactionTriggerHandler.flag=true;
    } 
    
    if(trigger.isBefore && trigger.isUpdate){
        EEC_LicenseTransactionTriggerHandler ltt = new EEC_LicenseTransactionTriggerHandler(Trigger.new, Trigger.oldMap);
        EEC_LicenseTransactionTriggerHandler.checkTransactionStatus(trigger.new);
        if(!EEC_LicenseTransactionTriggerHandler.checkRecursiveME()){      
        	EEC_LicenseTransactionTriggerHandler.checkMissingElementsForLicensor(trigger.new);
        }
        
        if(!EEC_LicenseTransactionTriggerHandler.checkRecursive()){
           EEC_LicenseTransactionTriggerHandler.bulkAfter();
        }
    }
 } 
}