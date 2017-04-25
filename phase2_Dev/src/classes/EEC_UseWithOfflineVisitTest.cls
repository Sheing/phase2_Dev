@isTest
public class EEC_UseWithOfflineVisitTest {

    @isTest
    static void testActionMethod(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
    	EEC_UseWithOfflineVisitAppController visitOfflineToolCtrl = new EEC_UseWithOfflineVisitAppController(sc);
        
        visitOfflineToolCtrl.updateOfflineVisitLock();
    }
}