@istest
public class EEC_NavigationControllerTest {
	 @isTest
    static void testNavigation() {
        test.startTest();
        EEC_NavigationController EEC_NavigationController = new EEC_NavigationController();
        EEC_NavigationController.setcurrentPage('Review & Submission');        
        EEC_NavigationController.setrecordTypeName('FCC_New_License');
        EEC_NavigationController.setproviderRecordTypeName('Family Child Care');
        
        EEC_NavigationController.getcurrentPage();
        EEC_NavigationController.getproviderRecordTypeName();
        EEC_NavigationController.getrecordTypeName();
        
        EEC_NavigationController = new EEC_NavigationController();
        EEC_NavigationController.setcurrentPage('Review & Submission');
        EEC_NavigationController.setcurrentPage('GSA_New_License');
        EEC_NavigationController.setcurrentPage('Large Group');
        
        EEC_NavigationController.getcurrentPage();
        EEC_NavigationController.getproviderRecordTypeName();
        EEC_NavigationController.getrecordTypeName();
        
        EEC_NavigationController = new EEC_NavigationController();
        EEC_NavigationController.setcurrentPage('Review & Submission');
        EEC_NavigationController.setcurrentPage('Residential_New_License');
        EEC_NavigationController.setcurrentPage('Temporary Shelter');
        
        EEC_NavigationController.getcurrentPage();
        EEC_NavigationController.getproviderRecordTypeName();
        EEC_NavigationController.getrecordTypeName();
        
        test.stopTest();
    }
}