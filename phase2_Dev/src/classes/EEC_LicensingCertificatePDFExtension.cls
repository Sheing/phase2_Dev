public class EEC_LicensingCertificatePDFExtension {
    
    protected final Licensing_Transaction__c trans;
    public Licensing_Transaction__c lt {get;set;}
    public List<Conditions_and_Limitations__c> lstConditions {get;set;}
    public Boolean HasConditions {get;set;}
        public Boolean HasVariance {get;set;}

    public List<Variance_on_Regulation__c> lstVariance {get;set;}

    public EEC_LicensingCertificatePDFExtension(ApexPages.StandardController ctr){
        this.trans = (Licensing_Transaction__c) ctr.getRecord();
        getProviderConditions();
        getVarianceOnReg();
    }
    
    public List<Conditions_and_Limitations__c> getProviderConditions()
    {
        Licensing_Transaction__c lt = [SELECT Id,Capacity__c, Date_Closed__c FROM Licensing_Transaction__c
                                      WHERE Id =: trans.Id];
        lstConditions = [SELECT Conditions__c,Condition_Additional_Information__c,
                         Condition_Name__c,Condition_On_License__c,CreatedById,
                         CreatedDate,Current__c,Expiration_Date__c,Id,
                         Name,Provider__c,Source_Transaction__c,
                         Start_Date__c FROM Conditions_and_Limitations__c 
                         WHERE Provider__c =: trans.Provider__c 
                         AND 
                         (
                             (Start_Date__c <=: lt.Date_Closed__c AND Expiration_Date__c >=: lt.Date_Closed__c) 
                          OR 
                             (Expiration_Date__c = null AND Start_Date__c <=: lt.Date_Closed__c)
                         )];
        HasConditions=!lstConditions.isEmpty();
        
        return lstConditions;
    }
    
    public list<Variance_on_Regulation__c> getVarianceOnReg()
    {
        Licensing_Transaction__c lt = [SELECT Id,Capacity__c, Date_Closed__c FROM Licensing_Transaction__c
                                      WHERE Id =: trans.Id];
        
        lstVariance = [SELECT Decision__c, Brief_explanation_for_license__c, Source_Transaction__c, Provider__c, Id, 
                       Associated_Regulation__r.Name
                       FROM Variance_on_Regulation__c 
                       WHERE Provider__c =: trans.Provider__c
                       AND (Decision__c = 'Granted')
                      ];
        
        HasVariance=  !lstVariance.isEmpty();
              
        return lstVariance;
        
    }
}