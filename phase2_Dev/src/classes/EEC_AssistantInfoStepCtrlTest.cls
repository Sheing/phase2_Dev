@isTest
public class EEC_AssistantInfoStepCtrlTest {

  public static Account loadTestData(PageReference lPageRef, String buttonLabel, String index) {
    Account accnt = EEC_TestUtil.loadLicenseTransaction();
    PageReference pageRef = lPageRef;
    pageRef.getParameters().put('accountId', accnt.Id);
    pageRef.getParameters().put('buttonLabel', buttonLabel);
    pageRef.getParameters().put('index', index);
    Test.setCurrentPage(pageRef);
    EEC_TestUtil.mockAWSKeys();
    return accnt;
  }
  
  public static testmethod void testAssistantListCtrl(){
        Account acc = EEC_AssistantListCtrlTest.loadTestData(Page.EEC_Transaction_AssistantInfo, 'Apply for a New License', '1');
      	System.assertNotEquals(null, acc);
  }  

  public static testMethod void testGetCtrlInstance() {
    Account accnt = loadTestData(Page.EEC_Transaction_AssistantInfo, 'Apply for a New License', '1');
    Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
    ApexPages.currentPage().getParameters().put('ltId', lic.Id);

    EEC_AssistantInfoStepCtrl ctrl = new EEC_AssistantInfoStepCtrl();
    System.assertEquals(ctrl, ctrl.getCtrlInstance());
  }

  static testmethod void testAssistantInfoSave() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_Transaction_AssistantInfo,'Apply for a New License','1');
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
      ApexPages.currentPage().getParameters().put('saveType', '1');
      ApexPages.currentPage().getParameters().put('ltId', lic.Id);

      EEC_AssistantInfoStepCtrl controller = new EEC_AssistantInfoStepCtrl();
      controller.AssistantInfoSave();
      System.assertEquals('Background Information', controller.getBaseLicenseTransaction().Last_Reached_Step__c);

      ApexPages.currentPage().getParameters().put('saveType', '3');
      controller.AssistantInfoSave();
      System.assertEquals('Assistant Information', controller.getBaseLicenseTransaction().Last_Reached_Step__c);

      // This flow needs to have the page reference tested as well due to multiple conditions.
      ApexPages.currentPage().getParameters().put('saveType', '2');
      controller.AssistantInfoSave();
      System.assertEquals('Assistant Information', controller.getBaseLicenseTransaction().Last_Reached_Step__c);
    }

    public static testmethod void testInterfaceMethods() {
      Account accnt = loadTestData(Page.EEC_Transaction_AssistantInfo, 'Apply for a New License', '1');
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
      ApexPages.currentPage().getParameters().put('ltId', lic.Id);

      EEC_AssistantInfoStepCtrl ctrl = new EEC_AssistantInfoStepCtrl();
      System.assertEquals(ctrl.getBaseLicenseRecordTypeName(), 'FCC_Renewal');

      List<EEC_AssistantListCtrl.AssistantInfoWrap> tempList = new List<EEC_AssistantListCtrl.AssistantInfoWrap>();
      ctrl.updateAssistantWrapperList(tempList);
    }
}