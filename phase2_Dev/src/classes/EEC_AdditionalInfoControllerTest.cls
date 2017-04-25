@isTest
public class EEC_AdditionalInfoControllerTest {
    public static testMethod void EEC_AdditionalInfoCtrlTestMain() {
        Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'FCC');
    Licensing_Transaction__c lic = EEC_TestUtil.mockLiscence(accnt);
    
    List<RecordType> aiRtList = [select Id, DeveloperName from RecordType Where SobjectType = 'Additional_Information__c'];
    List<Additional_Information__c> aiList = new List<Additional_Information__c>();
    
    for(RecordType aiRt : aiRtList){
      Additional_Information__c ai = new Additional_Information__c(RecordTypeId = aiRt.id
                                          , Name_of_Licensee__c = 'Test Name'
                                          , Licensing_Transaction__c = lic.id
                                          , Provider__c = accnt.id);
      aiList.add(ai);
    }
    
    Insert aiList;
    ApexPages.StandardController sc = new ApexPages.StandardController(lic);
    EEC_AdditionalInfoController controller = new EEC_AdditionalInfoController(sc);

    System.assertEquals(true, controller.renderOtherLicenses);
    }
}