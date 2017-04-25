@isTest
public class EEC_ProviderEmailBatchtest {
    static testMethod void testMethod1(){
        
        Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Small Group', null);
        
        Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Small_Group');
        accnt.Config_Record__c = config2.Id;
        update accnt;
       	Test.startTest();    
        
        EEC_ProviderEmailBatch email = new EEC_ProviderEmailBatch();    
        ID batchprocessid = Database.executeBatch(email);
        
        Test.stopTest(); 
    }
}