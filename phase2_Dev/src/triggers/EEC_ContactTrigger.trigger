trigger EEC_ContactTrigger on Contact (before insert,before update,after update, after insert) {
       
        EEC_ContactTriggerHandler ch = new EEC_ContactTriggerHandler(Trigger.New, Trigger.oldMap);
	if(trigger.isinsert && Trigger.IsBefore){
            ch.AccountMandatory();
        }
        if(trigger.isupdate && Trigger.IsBefore){
            ch.createTransaction();
            ch.AccountMandatory();
        }
        if(Trigger.isUpdate && Trigger.isBefore){
            
            ch.createTransaction();
            
        }
        if(Trigger.isInsert && Trigger.isafter){
            
            ch.createContactRole();
            
        }
        if(Trigger.isUpdate && Trigger.isAfter){EEC_ContactTriggerHandler.updateUser(Trigger.New, Trigger.old,Trigger.oldMap, Trigger.newMap);}

}