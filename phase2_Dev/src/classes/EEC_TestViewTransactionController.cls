/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class EEC_TestViewTransactionController {

    static testMethod void TestViewTransaction() {
        Test.startTest();
        Account accnt = EEC_TestUtil.loadLicenseTransaction();
        Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id];
        
        S3_File__c s3File = new S3_File__c();
        s3File.Filename__c = 'Test.txt';
        s3File.Bucket__c = 'Test';
        s3File.Acl__c = 'Test';
        s3File.Content_Type__c = 'txt';
        s3File.Description__c = 'Test';
        insert s3File;
        
        FileMap__c fileMap = new FileMap__c();
        fileMap.Object_Id__c = lic.Id;
        fileMap.Object_Name__c  = 'Licensing_Transaction__c';
        fileMap.S3_File__c = s3File.Id;
        insert fileMap;
        
        EEC_ViewTransactionController controller = new EEC_ViewTransactionController();

        PageReference pageRef = Page.EEC_ViewTransaction;
        pageRef.getParameters().put('ltID',lic.Id);
        pageRef.getParameters().put('member',accnt.Id);
        Test.setCurrentPage(pageRef);
    	EEC_TestUtil.mockHouseHold(lic, accnt);
        EEC_TestUtil.mockFCCAssistant(lic, accnt);
        EEC_TestUtil.mockRoom(lic);
        EEC_TestUtil.mockTrainingExperience(lic, accnt);
        
        controller = new EEC_ViewTransactionController();
        controller.LicenseRecordTypeName = 'FCC_Renewal';
     	controller.getHeatingElements();
     	controller.getItems();
     	controller.CancelTransaction();
     	controller.rowNum = 0;
        controller.selectedHestStr = 'Test 1';
        controller.getBaseLicenseRecordTypeName();
        controller.getBaseLicenseTransaction();
        controller.getCtrlInstance();
     	
     	Licensing_Transaction__c lt = [select Id,Status__c from Licensing_Transaction__c where Id = :lic.Id];
        //System.assertEquals(lt.Status__c,'Cancelled (by Applicant)');
        
        PageReference nextPageIntr = controller.backInstruction();
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_portalproviderpage'));
        
        controller.licenseTransation.Last_Reached_Step__c = 'Household Members';
        nextPageIntr = controller.editInstruction();
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_householdmembers'));
        Test.stopTest();
    }
}