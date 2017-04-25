trigger EEC_ProviderTrigger on Account (before update, before insert,after update ) {

    if(trigger.isBefore){
    EEC_ProviderTriggerHandler th = new EEC_ProviderTriggerHandler(Trigger.New, Trigger.isUpdate ? Trigger.oldMap : new Map<Id, Account>());
    th.updateConfigRecord();
    th.updateProviderRegion();
    }
    else if(trigger.isUpdate &&  trigger.isAfter){
    EEC_ProviderTriggerHandler.accountupdate(Trigger.old, Trigger.new,Trigger.oldMap, Trigger.newMap); 
    }
    
}