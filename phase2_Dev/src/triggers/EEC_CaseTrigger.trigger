trigger EEC_CaseTrigger on Case (before insert, after insert, before update,after update) {
    
    EEC_CaseTriggerHandler ect = new EEC_CaseTriggerHandler(Trigger.new, Trigger.oldMap);
    
    /*if(Trigger.isInsert){
        if(Trigger.isBefore){
           ect.updateCaseRegion();
        }
        
    }*/
    if(EEC_CaseTriggerHandler.FirstRun){
        ect.bulkBefore();
    }
    if(Trigger.isInsert || Trigger.isUpdate){
        if(EEC_CaseTriggerHandler.FirstRun ){
            //ect.bulkBefore();
            if(Trigger.isUpdate & Trigger.isBefore){
                ect.checkProviderEditAccess();
                ect.sendInTriageEmail();
                ect.assignCaseOwnerByStatus();
                ect.sendCaseEscalatedEmailToManagerOutofOffice();
            }
            if((Trigger.isUpdate && Trigger.isAfter)){
                ect.closeTasksOnStatusChange();
                ect.sendNonComplianceInjuryCaseClosureOutofOffice();
                ect.sendPortalInjuryIncidentSubmissionForOutOfOffice();
                EEC_CaseTriggerHandler.FirstRun = false;
            }
            if(Trigger.IsInsert && Trigger.isAfter){
                EEC_CaseTriggerHandler.FirstRun = false;
            }
            if(Trigger.isBefore){
                ect.updateCaseStatus();
                ect.updateCaseRegion();
                ect.assignCaseOwner();  
            }
            else{
                ect.sendCaseEmail();
            }
            //EEC_CaseTriggerHandler.FirstRun = false;
        }
    }
    
    if(Trigger.isUpdate && Trigger.isBefore && UserInfo.getUserType() == 'Standard'){
        ect.updateApprovalManager();
        ect.sendApprovalTriageResultEmail();
    }
    
}