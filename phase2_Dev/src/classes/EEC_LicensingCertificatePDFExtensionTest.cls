@IsTest
public class EEC_LicensingCertificatePDFExtensionTest {
    
    Static testMethod void testLicensingCertificatePDFController(){
        Licensing_Transaction__c insp = EEC_TestUtil.loadLicenseSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        // Call constructor.
        EEC_LicensingCertificatePDFExtension uExcel = new EEC_LicensingCertificatePDFExtension(sc);
    }
  static testMethod void testVisitAttachments(){
      Licensing_Transaction__c inspec = EEC_TestUtil.loadLicenseSetup();
      
      ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(inspec);
        ApexPages.currentPage().getParameters().put('Id',inspec.id);
        
        EEC_LicensingCertificatePDFExtension er = new EEC_LicensingCertificatePDFExtension (sc); 
      er.lt = inspec;
                   er.getProviderConditions();
  }

}