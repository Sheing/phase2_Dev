@isTest
public class EEC_AssistantUpdateListCtrlTest {

  public static Account loadTestData(PageReference lPageRef, String buttonLabel, String index) {
    Account accnt = EEC_TestUtil.loadLicenseTransaction();
    PageReference pageRef = lPageRef;
    String encryptedAccountId = EncodingUtil.urlEncode(EEC_Util.encryptGetParam(accnt.Id),'UTF-8');
    pageRef.getParameters().put('param', encryptedAccountId);
    Test.setCurrentPage(pageRef);
    EEC_TestUtil.mockAWSKeys();
    return accnt;
  }

  static testMethod void testInterfaceMethods() {
    Account acc = EEC_AssistantUpdateListCtrlTest.loadTestData(Page.EEC_AssistantUpdateList, '', '');

    EEC_AssistantUpdateListCtrl ctrl = new EEC_AssistantUpdateListCtrl();
    System.assertEquals(ctrl.getBaseLicenseRecordTypeName(), null);
    System.assertEquals(ctrl.getBaseLicenseTransaction(), null);
    ctrl.updateAssistantWrapperList(new List<EEC_AssistantListCtrl.AssistantInfoWrap>());
    System.assertNotEquals(ctrl.getCtrlInstance(), null);
  }

  static testMethod void testSave() {
    Account acc = EEC_AssistantUpdateListCtrlTest.loadTestData(Page.EEC_AssistantUpdateList, '', '');

    EEC_AssistantUpdateListCtrl ctrl = new EEC_AssistantUpdateListCtrl();
    ctrl.Save();
  }
}