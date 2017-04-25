@IsTest
public class EEC_PPMAttachmentCertificatePDFTest {
     Static testMethod void testLicensingCertificatePDFController(){
        Provider_Meeting__c providerMeeting = EEC_TestUtil.mockProviderMeeting();
        ApexPages.StandardController sc = new ApexPages.StandardController(providerMeeting);
        // Call constructor.
        EEC_PPMAttachmentCertificatePDF uExcel = new EEC_PPMAttachmentCertificatePDF(sc);
        uExcel.savePDF();
    }
}