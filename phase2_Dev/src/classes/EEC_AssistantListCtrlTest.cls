@isTest
public class EEC_AssistantListCtrlTest { 
  
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
  public static testmethod void testAssistantInfoStepCtrl(){
        Account acc = EEC_AssistantInfoStepCtrlTest.loadTestData(Page.EEC_Transaction_AssistantInfo, 'Apply for a New License', '1');
      	System.assertNotEquals(null, acc);
  }
  public static testmethod void testAssistantUpdateListCtrl(){
        Account acc = EEC_AssistantUpdateListCtrlTest.loadTestData(Page.EEC_Transaction_AssistantInfo, 'Apply for a New License', '1');
      	System.assertNotEquals(null, acc);
  }  

  public static testmethod void testGetAssistansList() {
    Account accnt = loadTestData(Page.EEC_Transaction_AssistantInfo, 'Apply for a New License', '1');
    Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
    ApexPages.currentPage().getParameters().put('ltId', lic.Id);

    EEC_AssistantListCtrl ctrl = new EEC_AssistantListCtrl(); 
    ctrl.aif = new EEC_AssistantInfoStepCtrl();

    System.assertNotEquals(null, ctrl.aif);
    System.assertEquals(0, ctrl.getAssistantsList().size());
  }

  public static testMethod void testGetAssistantsListCount() {
    Account accnt = loadTestData(Page.EEC_Transaction_AssistantInfo, 'Apply for a New License', '1');
    Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
    ApexPages.currentPage().getParameters().put('ltId', lic.Id);

    EEC_AssistantListCtrl ctrl = new EEC_AssistantListCtrl(); 
    ctrl.aif = new EEC_AssistantInfoStepCtrl();
    ctrl.getNewestTransaction();  
    System.assert(!ctrl.getAssistantsListCount());
  }

  public static testMethod void testRemoveAddAssistant() {
    Account accnt = loadTestData(Page.EEC_Transaction_AssistantInfo, 'Apply for a New License', '1');
    Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
    ApexPages.currentPage().getParameters().put('ltId', lic.Id);
    ApexPages.currentPage().getParameters().put('accountId', accnt.Id);

    EEC_AssistantListCtrl ctrl = new EEC_AssistantListCtrl(); 
    EEC_AssistantInfoStepCtrl ctrl2 = new EEC_AssistantInfoStepCtrl();
    
    ctrl.aif = new EEC_AssistantInfoStepCtrl();
    System.assertEquals(null, ctrl.addAssistantToList());
    System.assert(ctrl.getAssistantsListCount());

    List<EEC_AssistantListCtrl.AssistantInfoWrap> tempList = ctrl.getAssistantsList();
    tempList.sort();

    ApexPages.currentPage().getParameters().put('wrapperId', '0');
    ctrl.removeAddedAssistant();
    System.assert(ctrl.getAssistantsListCount());
  }
}