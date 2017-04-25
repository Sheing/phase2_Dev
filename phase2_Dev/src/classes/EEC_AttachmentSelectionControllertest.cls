@istest
public class EEC_AttachmentSelectionControllertest {
    @isTest
    static void testAttachmentSelectionController() {        
        //insert Account
        Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('GSA New License', null);
        RecordType r = [SELECT Id FROM RecordType WHERE DeveloperName='Per_Transaction_Type' AND sObjectType='Lead_Configuration__c'];
        config2.RecordTypeId = r.Id;
        update config2;
        
        Lead_Configuration__c config = EEC_TestUtil.mockLeadConfig('Large Group', null);
        
        Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Large_Group');
        accnt.Config_Record__c = config2.Id;
        update accnt;
        
        //insert Contact
        Contact contact = EEC_TestUtil.mockContact(accnt, 'Test', 'LastName', '');
        //insert Contactrole   
        Contact_Role__c contactRole = EEC_TestUtil.mockContactRole('Partner', contact.Id, accnt.Id);
        contactRole = EEC_TestUtil.mockContactRole('Administrative Designee', contact.Id, accnt.Id);
        contactRole = EEC_TestUtil.mockContactRole('Program Director / Administrative Head', contact.Id, accnt.Id);
        contactRole = EEC_TestUtil.mockContactRole('Board Chair', contact.Id, accnt.Id); 
        contactRole = EEC_TestUtil.mockContactRole('Owner', contact.Id, accnt.Id);
        //creating user
        User portaluser = EEC_TestUtil.mockPortalUser(contact);
        
        Licensing_Transaction__c  lic = EEC_TestUtil.mockAssistantLicenseTransaction(accnt, 'GSA_New_License');

        //insert Document Type
        List<Document_Type__c> listDocumentType = new List<Document_Type__c>();
        Document_Type__c docType = new Document_Type__c();
        docType.Allow_use_of_Umbrella_Level_Document__c = true;
        docType.Name = 'Doc Type 1';
        docType.Description__c ='Test Description';
        docType.Individual_Document__c = false;
        docType.Need_to_be_Updated_at_each_new_Transacti__c = true;
        docType.Optional_for_Transactio_Type__c = 'GSA New License';
        docType.Related_Role__c = '';
        docType.LEAD_Configuration__c = config2.Id;
        docType.Required_For_Transaction_Type__c = 'GSA New License';
        listDocumentType.add(docType);
        
        docType = new Document_Type__c();
        docType.Allow_use_of_Umbrella_Level_Document__c = true;
        docType.Name = 'Doc Type 2';
        docType.Description__c ='Test Description';
        docType.Individual_Document__c = true;
        docType.Need_to_be_Updated_at_each_new_Transacti__c = true;
        docType.Optional_for_Transactio_Type__c = 'GSA New License';
        docType.Related_Role__c = 'Administrative Designee';
        docType.LEAD_Configuration__c = config2.Id;        
        docType.Required_For_Transaction_Type__c = 'GSA New License'; 
        listDocumentType.add(docType);
        
        insert listDocumentType;
         
        //Insert Document
        List<Document__c> listDocument = new List<Document__c>();
        Document__c document = new Document__c();        
        document.Provider__c = accnt.Id;
        //document.Notes__c = 'Test Notes';
        document.Document_Type__c = listDocumentType[0].Id;
        document.Content_Type__c = 'jpg';
        document.Approved_for_Future_Usage__c = False;
        document.Valid_To__c = DateTime.now();
        document.Valid_From__c = null;
        document.Document_Name__c = 'testdocs1';
        
        listDocument.add(document);
        
        document = new Document__c();
        document.Provider__c = accnt.Id;
        document.Notes__c = 'Test Notes';
        document.Document_Type__c = listDocumentType[1].Id;
        document.Content_Type__c = 'jpg';
        document.Approved_for_Future_Usage__c = True;
        document.Valid_To__c = DateTime.now();
        document.Valid_From__c = DateTime.now();
        document.Document_Name__c = 'testdocs2';
        listDocument.add(document);
        
        document = new Document__c();
        document.Provider__c = accnt.Id;
        document.Notes__c = 'Test Notes';
        document.Document_Type__c = listDocumentType[0].Id;
        document.Content_Type__c = 'jpg';
        document.Approved_for_Future_Usage__c = True;
        document.Valid_To__c = DateTime.now();
        document.Valid_From__c =  DateTime.now();
        document.Document_Name__c = 'testdocs3';
        listDocument.add(document);
        
        insert listDocument;
        
        //Insert S3File
        List<S3_File__c> listFiles = new List<S3_File__c>();
        S3_File__c files = new S3_File__c();
        files.Filename__c = 'testFile';
        files.Content_Type__c = 'image/png';
        files.Bucket__c = 'test';
        files.Acl__c = 'authenticated-read';
        files.Prefix__c = listDocument[0].Id;   
        files.Document__c = listDocument[0].Id;
        
        listFiles.add(files);
        
        S3_File__c  dltfiles = new S3_File__c();
        dltfiles.Filename__c = 'testFile2';
        dltfiles.Content_Type__c = 'image/png';
        dltfiles.Bucket__c = 'test';
        dltfiles.Acl__c = 'authenticated-read';
        dltfiles.Prefix__c = listDocument[0].Id;   
        dltfiles.Document__c = listDocument[0].Id;        
        listFiles.add(dltfiles); 
        
        insert listFiles;
        
        EEC_BaseAttachmentsExtensionTest.loadMock();
        EEC_TestUtil.mockAWSKeys();
        
        AWS_Config__c aws_config = new AWS_Config__c(S3_Bucket_Name__c = 'eec-lead'); 
        insert aws_config; 
        
        ApexPages.currentPage().getParameters().put('id', listDocument[0].Id);
        ApexPages.currentPage().getParameters().put('transactionId',lic.Id);
        ApexPages.currentPage().getParameters().put('type','A');
        
        System.runAs(portaluser){
            test.startTest();         
            EEC_AttachmentSelectionController mp = new EEC_AttachmentSelectionController();  
            mp.doCreateDocument();
            
            mp.doBack();
            
            string filebody = '[{"Filename__c":"file1.csv","Prefix__c":"'+listDocument[0].Id+'","Content_Type__c":"application/vnd.ms-excel","Acl__c":"authenticated-read","Bucket__c":"eec-lead-integration"}]';
            ApexPages.currentPage().getParameters().put('attachmentbody', filebody);
            ApexPages.currentPage().getParameters().put('attachmentdeletebody', filebody);
            mp.doSave();
            
            ApexPages.currentPage().getParameters().put('id', listDocument[1].Id);
            mp.doSave();
            
            ApexPages.currentPage().getParameters().put('id', '');
            mp = new EEC_AttachmentSelectionController();  
            mp.doCreateDocument();
            
            String exampleJson = '[{"filename": "testName", "type": "image/png"}]'; 
            
            List<Map<String,String>> result = EEC_AttachmentSelectionController.generateMultiplePolicySignature('eec', 'authenticated-read', exampleJson);
            test.stopTest();
        }
    }
}