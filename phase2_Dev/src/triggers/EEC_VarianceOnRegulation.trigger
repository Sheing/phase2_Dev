trigger EEC_VarianceOnRegulation on Variance_on_Regulation__c (before update) {

    EEC_VarianceOnRegulationTriggerHandler ect = new EEC_VarianceOnRegulationTriggerHandler(Trigger.new, Trigger.oldMap);
    
    if(Trigger.isBefore && Trigger.isUpdate){
        ect.checkRegulationProvider();
    }
    
}