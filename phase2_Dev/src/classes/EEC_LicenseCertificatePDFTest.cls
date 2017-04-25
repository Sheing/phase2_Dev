@IsTest
public class EEC_LicenseCertificatePDFTest {
	 static testMethod void testEEC_LicenseCertificatePDFController() {
        // Setup basic defaults.
        Licensing_Transaction__c insp = EEC_TestUtil.loadLicenseSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        // Call constructor.
        EEC_LicenseCertificatePDF tPdf = new EEC_LicenseCertificatePDF(sc);
        tPdf.savePDF(); 
    }
	 static testmethod void licensepdf(){
         		Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Small Group', null);
       		  Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Small_Group');
          	  acc.Config_Record__c = config2.Id;
        	  update acc;
       		 Licensing_Transaction__c ld = EEC_TestUtil.mockLiscence(acc);
         		
         		//insert ld;
         
   			PageReference pageref = Page.EEC_LicenseCertificatePDF;  
         	Test.setCurrentPage(pageref);   
         	ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ld);
         	ApexPages.currentPage().getParameters().put('Id',ld.id);
          
         
         EEC_LicenseCertificatePDF pdf = new EEC_LicenseCertificatePDF(sc);
         
         pdf.savePDF();
         pdf.pdfPageReference();
         	
         
         	
        	     
	}
}