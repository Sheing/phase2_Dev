/**
 * EEC_BatchProviderVisitTest
 * 
 */

@isTest
public class EEC_ExportReportTest {

  static testMethod void testGetReportData() {
      List<Report> report = [SELECT ID FROM Report WHERE OwnerId IN 
                     (SELECT ID FROM Folder WHERE Name = 'Visit Item')];
      Id reportId;
      if(report.size() > 0){
          reportId = report.get(0).Id;
      }
      Test.setCurrentPageReference(new PageReference('EEC_ExportReport_CSV')); 
      ApexPages.currentPage().getParameters().put('id', reportId);
      ApexPages.currentPage().getParameters().put('pv0', '');

      EEC_ExportReport eReport = new EEC_ExportReport();
      eReport.getReportData();
  }
    static testMethod void testLEADAdminTools(){
        PageReference pageref = Page.EEC_LicenseCertificatePDF;  
          Test.setCurrentPage(pageref);
         ApexPages.currentPage().getParameters().put('pv0','');
        
           Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Small_Group');
        
          ApexPages.currentPage().getParameters().put('Id',accnt.id);
        EEC_ExportReport er = new EEC_ExportReport ();
            er.getReportData ();
    }
}