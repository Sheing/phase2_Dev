@IsTest
public class EEC_UploadExcelControllerTest {
 
    Static testMethod void testEEC_UploadExcelController(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        // Call constructor.
        EEC_UploadExcelController uExcel = new EEC_UploadExcelController(sc);
        uExcel.uploadExcel();
    }
     static testmethod void excelcntrl(){
         Inspection__c inspec = EEC_TestUtil.loadInspectionSetup();
         test.startTest();
        	  
        	  
        	  ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(inspec);
         	  ApexPages.currentPage().getParameters().put('Id',inspec.id);
         
         EEC_DocumentAttachmentsExtension atach = new EEC_DocumentAttachmentsExtension(sc);
         atach.getCtrlInstance();
         test.stopTest();
         
     }
    static testmethod void testSplitCsvEOL(){
        String csv = '"Visit Item Name","Visit Item No","Visit No","Domain (list)","Description (list)","Result","Observations","Technical Assistance","Correction Plan","Date Implemented","Non-Assessed Item","Provider: Name"\n"Electric outlets covered, no frayed electrical cords","VI-019919","Visit# 000625","Physical Facility - Indoors","","","","","","","0","My FCC Provider"';
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        EEC_UploadExcelController uExcel = new EEC_UploadExcelController(sc);
        uExcel.csvFileBody = Blob.valueof(csv);
        uExcel.uploadExcel();
   }
   static testmethod void testSplitCsv(){
        String csv = '"Visit Item Name","Visit Item No","Visit No","Domain (list)","Description (list)","Result","Observations","Technical Assistance","Correction Plan","Date Implemented","Non-Assessed Item","Provider: Name"\n';
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        List<Inspection_Item__c> iiList = [Select Name From Inspection_Item__c where Inspection_No__c = :insp.id] ;
        csv = csv + '"' + iiList[0].Name + '","' + iiList[0].Name + '",,,C,"everything is fine","Installed tubes",,,,,\n';
        csv = csv + '"' + iiList[1].Name + '","' + iiList[1].Name + '",,,NC,"everything is fine","Installed tubes",,,,,\n';
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        EEC_UploadExcelController uExcel = new EEC_UploadExcelController(sc);
        uExcel.csvFileBody = Blob.valueof(csv);
        uExcel.uploadExcel();
   }
}