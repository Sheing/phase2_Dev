trigger EEC_S3FileTrigger on S3_File__c (after insert, after undelete, after update, after delete) {
    if(trigger.isInsert && trigger.isAfter){
    	EEC_S3FileTriggerHandler.doAfterInsert(trigger.New);
    }
    else if(trigger.isUpdate && trigger.isAfter){
    	EEC_S3FileTriggerHandler.doAfterUpdate(trigger.New);
    }
    else if(trigger.isUnDelete && trigger.isAfter){
    	EEC_S3FileTriggerHandler.doAfterUnDelete(trigger.New);
    }
    else if(trigger.isDelete && trigger.isAfter){
    	EEC_S3FileTriggerHandler.doAfterDelete(trigger.Old);
    }
}