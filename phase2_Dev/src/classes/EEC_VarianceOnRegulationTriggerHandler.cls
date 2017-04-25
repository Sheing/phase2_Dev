public class EEC_VarianceOnRegulationTriggerHandler {
    
    List<Variance_on_Regulation__c> newVRList;
    Map<Id, Variance_on_Regulation__c> oldVRMap;
    Map<Id, Regulation__c> arMap;
    Map<Id, Account> providerMap;
    List<ID> arIDs = new List<ID>();
    List<ID> providerIDs = new List<ID>();
    public EEC_VarianceOnRegulationTriggerHandler(List<Variance_on_Regulation__c > newList, Map<Id, Variance_on_Regulation__c > oldList){
        this.newVRList = newList;
        this.oldVRMap = oldList;
        
        for(Variance_on_Regulation__c vr : newVRList){
            arIDs.add(vr.Associated_Regulation__c);
            providerIDs.add(vr.Provider__c);
        }
        if(arIDs.size() > 0){
            arMap = new Map<Id, Regulation__c>([SELECT ID,Applicable_To__c FROM Regulation__c  WHERE ID IN : arIDs]);
        }
        if(providerIds.size() > 0){
            providerMap = new Map<Id,Account>([SELECT ID, RecordType.Name FROM Account WHERE ID IN: providerIds]);
        }
                
    }
    
    
    public void checkRegulationProvider(){
        for(Variance_on_Regulation__c vr : newVRList){
            if(arMap.size() > 0){
                Regulation__c  ar = arMap.get(vr.Associated_Regulation__c);
                Account acc = providerMap.get(vr.Provider__c);
                System.debug('Regulation--->' + acc.RecordType.Name);
                System.debug('Regulation--->' + ar.Applicable_To__c.Contains(acc.RecordType.Name));
                if(!ar.Applicable_To__c.Contains(acc.RecordType.Name)){
                    vr.addError('Regulations should be applicable to the Provider type associated to the variance');
                }
            }
        }
    }
    
    
}