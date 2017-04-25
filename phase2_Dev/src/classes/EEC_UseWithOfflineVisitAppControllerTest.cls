@istest
public class EEC_UseWithOfflineVisitAppControllerTest {
    
    static testmethod void Visitpdf(){
        	Inspection__c inspec = EEC_TestUtil.loadInspectionSetup();
         test.startTest();
        	  
        	  
        	  ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(inspec);
         	  ApexPages.currentPage().getParameters().put('Id',inspec.id);
         
      		  EEC_UseWithOfflineVisitAppController  offline = new EEC_UseWithOfflineVisitAppController(sc);
        	  offline.updateOfflineVisitLock();      	
         
        	
        
        	EEC_UploadExcelController upload = new EEC_UploadExcelController(sc);
        	upload.csvAsString='';
        	upload.csvFileBody=blob.valueOf('test00');
        	upload.uploadExcel();
        	
        
        
  		test.stopTest(); 
   
    }

}