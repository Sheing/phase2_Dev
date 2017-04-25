@isTest
public class UserManagementCtrlTest {
  public static testmethod void testSave() {
    Test.startTest();
    User u1 = EEC_TestUtil.mockUser();
    List<UM_PageReferenceParamsWrapper> paramsList = new List<UM_PageReferenceParamsWrapper> ();
    paramsList.add(new UM_PageReferenceParamsWrapper('Page', 'EEC_ContactPage'));

    System.runAs(u1) {
      UserManagementCtrl umCtrl = new UserManagementCtrl();
      umCtrl.pageRefParams = paramsList;

      System.assertEquals('/apex/EEC_ContactPage', (umCtrl.save()).getUrl());
    }

    Contact c1 = EEC_TestUtil.mockContact();
    
    System.runAs(u1) {
      UserManagementCtrl umCtrl = new UserManagementCtrl();
      umCtrl.contact = c1;
      paramsList.add(new UM_PageReferenceParamsWrapper('Id', c1.Id));

      PageReference returnedReference = umCtrl.save();
      System.assertEquals(null, returnedReference);
    }
  }
}