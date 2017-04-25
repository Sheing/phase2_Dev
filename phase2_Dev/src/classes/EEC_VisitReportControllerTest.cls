/**
 * EEC_VisitReportControllerTest
 * 
 */

@isTest
public class EEC_VisitReportControllerTest {
    static testMethod void testInitializeVisitReportController() {
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        test.startTest();
        PageReference pg = Page.EEC_PortalProviderPage;
        test.setCurrentPage(pg);        
        ApexPages.currentPage().getParameters().put('visitID',insp.Id);
        EEC_VisitReportController vr = new EEC_VisitReportController();
        ApexPages.currentPage().getParameters().put('member',insp.Provider_No__c);
        vr = new EEC_VisitReportController();
        vr.returnProvider();
        test.stopTest();
    }
}