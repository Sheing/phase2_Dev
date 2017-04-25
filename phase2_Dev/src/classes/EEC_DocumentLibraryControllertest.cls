@istest
public class EEC_DocumentLibraryControllertest {
    
    @isTest
    static void testDocumentLibraryController() {
        Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Small Group', null);
        
        Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Small_Group');
        accnt.Config_Record__c = config2.Id;     
        update accnt;
        
        Contact contact = EEC_TestUtil.mockContact(accnt, 'Test', 'LastName', '');
        
        Contact_Role__c contactRole = EEC_TestUtil.mockContactRole('Partner', contact.Id, accnt.Id);
        contactRole = EEC_TestUtil.mockContactRole('Administrative Designee', contact.Id, accnt.Id);
        contactRole = EEC_TestUtil.mockContactRole('Program Director / Administrative Head', contact.Id, accnt.Id);
        contactRole = EEC_TestUtil.mockContactRole('Board Chair', contact.Id, accnt.Id); 
        contactRole = EEC_TestUtil.mockContactRole('Owner', contact.Id, accnt.Id);
        
        User portaluser = EEC_TestUtil.mockPortalUser (contact);
        
        Provider_Meeting__c  providermeeting  = EEC_TestUtil.mockGsaProviderMeeting();
        
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
        docType.Library_Level__c = true;
        listDocumentType.add(docType);
        
        insert listDocumentType;
        
        List<Document__c> listDocument = new List<Document__c>();
        Document__c document = new Document__c();
        document.Provider__c = accnt.Id;
        document.Notes__c = 'Test Notes';
        document.Document_Type__c = listDocumentType[0].Id;
        document.Content_Type__c = 'jpg';
        document.Approved_for_Future_Usage__c = false;
        document.Valid_To__c = DateTime.now();
        document.Valid_From__c = DateTime.now();
        listDocument.add(document);
        
        document = new Document__c();
        document.Provider__c = accnt.Id;
        document.Notes__c = 'Test Notes';
        document.Document_Type__c = listDocumentType[1].Id;
        document.Content_Type__c = 'jpg';
        document.Approved_for_Future_Usage__c = true;
        document.Valid_To__c = DateTime.now();
        document.Valid_From__c = DateTime.now();
        listDocument.add(document);
        insert listDocument;
        
        System.runAs(portaluser){
            test.startTest();
            EEC_DocumentLibraryController mp = new EEC_DocumentLibraryController();  
            mp.doCreateDocs();
            mp.doBack();
            mp.doMarkAsOutOfDate();
            test.stopTest();
            
        }
        
    }
}