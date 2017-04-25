trigger EEC_TransactionDocumentTrigger on Transaction_Document__c (after insert, after update, after delete, after undelete) {
	if(trigger.isInsert && trigger.isAfter){
    	EEC_TransactionDocumentTriggerHandler.doAfterInsert(trigger.New);
    }
    else if(trigger.isUpdate && trigger.isAfter){
        system.debug('start doAfterUpdate');
    	EEC_TransactionDocumentTriggerHandler.doAfterUpdate(trigger.New);
        system.debug('end doAfterUpdate');
    }
    else if(trigger.isUnDelete && trigger.isAfter){
    	EEC_TransactionDocumentTriggerHandler.doAfterUnDelete(trigger.New);
    }
    else if(trigger.isDelete && trigger.isAfter){
    	EEC_TransactionDocumentTriggerHandler.doAfterDelete(trigger.Old);
    }
}