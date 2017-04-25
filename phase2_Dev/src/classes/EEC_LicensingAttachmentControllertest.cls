@isTest
public class EEC_LicensingAttachmentControllertest {
    
    static testMethod void testEEC_LicensingAttachmentController() {
       
        Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Small Group', null);
        config2.Transaction_Attachments_New__c = 'largetest';
        config2.Transaction_Attachments_Renewal__c = 'rentest';  
        config2.Transaction_Attachments_Upgrade__c = 'tatest';     
        config2.Name = 'Change of Address';
        update config2;
        
        Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Small_Group');
        accnt.Config_Record__c = config2.Id;     
        update accnt;   
     
      
        
      //	Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_New_License');
       //	 lic.Status__c = 'Submitted';
          //update lic; 
         
        
        Contact contact = EEC_TestUtil.mockContact(accnt, 'Test', 'LastName', '');
        
        Contact_Role__c contactRole = EEC_TestUtil.mockContactRole('Partner', contact.Id, accnt.Id);
        contactRole = EEC_TestUtil.mockContactRole('Administrative Designee', contact.Id, accnt.Id);
        contactRole = EEC_TestUtil.mockContactRole('Program Director / Administrative Head', contact.Id, accnt.Id);
        contactRole = EEC_TestUtil.mockContactRole('Board Chair', contact.Id, accnt.Id); 
        contactRole = EEC_TestUtil.mockContactRole('Owner', contact.Id, accnt.Id);
        
        User portaluser = EEC_TestUtil.mockPortalUser (contact);
        
        
        EEC_BaseAttachmentsExtensionTest.loadMock();
        
        EEC_TestUtil.mockAWSKeys(); 
        
        Regulation__c reg = EEC_TestUtil.mockRegulation();  
        
        
        AWS_Config__c aws_config = new AWS_Config__c(S3_Bucket_Name__c = 'eec'); 
        insert aws_config; 
        
        Provider_Meeting__c  providermeeting  = EEC_TestUtil.mockGsaProviderMeeting();
      
        System.runAs(portaluser){
            test.startTest();
            EEC_LicensingAttachmentController mp = new EEC_LicensingAttachmentController();  
           // mp.doGetDocuments(); 
         //   mp.SaveAndNextAttachment();
          //	mp.UpdateDocument();
          //  mp.delAttachment();
           // mp.CancelTransaction() ;
           // mp.doUpdateComments();
           // mp.doUpdateComments();  
            //Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'R_P_Change_of_Admin_Authority');
         	//lic.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Licensing_Transaction__c' and name='R_P_Change_of_Admin_Authority'].id;
              
          test.stopTest();
            
        }
    }/*
    static Account loadTestData(PageReference lPageRef,String buttonLabel, String index){
        Account accnt = EEC_TestUtil.loadLicenseTransaction();
        PageReference pageRef = lPageRef;
        pageRef.getParameters().put('accountId',accnt.Id);
        pageRef.getParameters().put('buttonLabel',buttonLabel);
        pageRef.getParameters().put('index',index);
        Test.setCurrentPage(pageRef);
        EEC_TestUtil.mockAWSKeys();
        return accnt;
    }
	 static testMethod void testGetAttachmentSpotlightText() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_LicensingAttachmentController controller = new EEC_LicensingAttachmentController();
         
     // Account accnts = [SELECT ID,OwnerId FROM Account WHERE RecordType.DeveloperName = 'FCC' AND Provider_Address_1__c != null LIMIT 1]; 
      
     // Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnts.Id limit 1]; 
        
      
    }
   
*/
     
   
}