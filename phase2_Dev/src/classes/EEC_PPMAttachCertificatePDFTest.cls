@IsTest
public class EEC_PPMAttachCertificatePDFTest {
	 static testMethod void testEEC_PPMAttachCertificatePDFController() {
        // Setup basic defaults.
        Lead mLead = EEC_TestUtil.mockLead();
        ApexPages.StandardController sc = new ApexPages.StandardController(mLead);
        // Call constructor.
        EEC_PPMAttachCertificatePDF tPdf = new EEC_PPMAttachCertificatePDF(sc);
        tPdf.savePDF(); 
    }
}