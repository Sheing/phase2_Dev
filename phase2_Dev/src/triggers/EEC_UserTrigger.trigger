trigger EEC_UserTrigger on User (before update, before insert, after insert, after update) {
    
    EEC_UserTriggerHandler eut = new EEC_UserTriggerHandler(Trigger.new,Trigger.oldMap);
    eut.bulkAfter();
    if(Trigger.isAfter && Trigger.isUpdate){
        EEC_UserTriggerHandler.updatecontact(Trigger.old,Trigger.New,Trigger.oldMap, Trigger.newMap);
    }
	if(Trigger.isInsert && Trigger.isAfter){
		eut.updateActiveAccounts();
	}
	else if(Trigger.isUpdate && Trigger.isAfter){
		eut.updateInActiveAccounts();
	}
}