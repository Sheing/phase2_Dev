trigger EEC_TaskTrigger on Task (after insert, after update) {

	EEC_TaskTriggerHandler ett = new EEC_TaskTriggerHandler(Trigger.new);
    if(EEC_TaskTriggerHandler.FirstRun){
		//ett.bulkAfter();
    }
    if(Trigger.isAfter && Trigger.IsInsert){
        ett.reopenInvestigationActivityStatus();
		ett.updateLeads();
        EEC_TaskTriggerHandler.FirstRun = false;
    }
    
    if((Trigger.isAfter && Trigger.IsUpdate) || Test.isRunningTest()){
        ett.updateInvestigationActivityStatus();
        ett.reopenInvestigationActivityStatus();
    	EEC_TaskTriggerHandler.FirstRun = false;
    }
}