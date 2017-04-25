@isTest
public class EEC_ViewLicenseTransactionControllerTest {
     static testmethod void testViewGSA() {
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
      
      List<Document__c> listDocument = new List<Document__c>();
      Document__c document = new Document__c();
      document.Provider__c = accnt.Id;
      //document.Out_of_Date__c = date.today() + 100;
      //document.Original_File_Name__c = 'TestFile.jpg';
      document.Notes__c = 'Test Notes';
      document.Document_Type__c = listDocumentType[0].Id;
      document.Content_Type__c = 'jpg';
      document.Approved_for_Future_Usage__c = true;
      listDocument.add(document);
      
      document = new Document__c();
      document.Provider__c = accnt.Id;
      //document.Out_of_Date__c = date.today() + 100;
      //document.Original_File_Name__c = 'TestFile2.jpg';
      document.Notes__c = 'Test Notes';
      document.Document_Type__c = listDocumentType[1].Id;
      document.Content_Type__c = 'jpg';
      document.Approved_for_Future_Usage__c = true;
      listDocument.add(document);
      
      insert listDocument;
      
      Licensing_Transaction__c lic = EEC_TestUtil.mockAssistantLicenseTransaction(accnt,'GSA_New_License');
      //lic.Umbrella__c = accnt.Id;
	  lic.Last_Reached_Step__c = 'Attachments';
	  update lic;
	  
      EEC_TestUtil.mockHouseHold(lic, accnt);
      EEC_TestUtil.mockFCCAssistant(lic, accnt);
      EEC_TestUtil.mockRoom(lic);
      EEC_TestUtil.mockTrainingExperience(lic);
      EEC_TestUtil.mockAWSKeys();
      
      Id addInfoId   = Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('Other Licenses Held').getRecordTypeId();
      Id addRelatedId =  Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('Other License Applications').getRecordTypeId();
      Id addCriminId = Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('Admin/civil/criminal action detail').getRecordTypeId();
      Id addFedId =  Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('State/federal investigation detail').getRecordTypeId();
       
      List<Additional_Information__c> listAdditionalInfo = new List<Additional_Information__c>();
      Additional_Information__c additionalInfo = new Additional_Information__c(recordTypeId = addInfoId,Name_of_Licensee__c = 'Test', Licensing_Transaction__c = lic.Id, Provider__c = accnt.id, Type_of_License__c = 'Test',State_Country_Issuing_the_License__c = 'US',License_Number__c = '123');
      listAdditionalInfo.add(additionalInfo);
      
      additionalInfo = new Additional_Information__c(recordTypeId = addRelatedId,Name_of_Licensee__c = 'Test', Licensing_Transaction__c = lic.Id, Provider__c = accnt.id, Type_of_License__c = 'Test',State_Country_Issuing_the_License__c = 'US',License_Number__c = '123');
      listAdditionalInfo.add(additionalInfo);
      
      additionalInfo = new Additional_Information__c(recordTypeId = addCriminId,Name_of_Licensee__c = 'Test', Licensing_Transaction__c = lic.Id, Provider__c = accnt.id, Type_of_License__c = 'Test',State_Country_Issuing_the_License__c = 'US',License_Number__c = '123');
      listAdditionalInfo.add(additionalInfo);
      
      additionalInfo = new Additional_Information__c(recordTypeId = addFedId,Name_of_Licensee__c = 'Test', Licensing_Transaction__c = lic.Id, Provider__c = accnt.id, Type_of_License__c = 'Test',State_Country_Issuing_the_License__c = 'US',License_Number__c = '123');
      listAdditionalInfo.add(additionalInfo);
      
      insert listAdditionalInfo;

      Test.startTest();
      
      PageReference pg1 = Page.EEC_ViewLicenseTransaction;
      test.setCurrentPage(pg1);      
      ApexPages.currentPage().getParameters().put('ltId', lic.Id);
      ApexPages.currentPage().getParameters().put('member',accnt.Id);
      
      EEC_ViewGSALicenseTransactionController gsaController = new EEC_ViewGSALicenseTransactionController();
      gsaController.getLicenseTrans();
      gsaController.getItems();
      gsaController.getPickItems();
      gsaController.backInstruction();
      gsaController.getCtrlInstance();
      gsaController.getBaseLicenseTransaction();
      gsaController.getBaseLicenseRecordTypeName();
      gsaController.CancelTransaction();
      gsaController.editInstruction();
      test.stopTest();
    }
    
    static testmethod void testViewRP() {
      Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Adoption Agency', null);
	  
	  Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Adoption_Agency');
	  accnt.Config_Record__c = config2.Id;
	  update accnt;
	  
      Contact contact = EEC_TestUtil.mockContact(accnt, 'Test', 'LastName', '');
      Contact_Role__c contactRole = EEC_TestUtil.mockContactRole('Partner', contact.Id, accnt.Id);
      contactRole = EEC_TestUtil.mockContactRole('Administrative Designee', contact.Id, accnt.Id);
      contactRole = EEC_TestUtil.mockContactRole('Program Director / Administrative Head', contact.Id, accnt.Id);
      contactRole = EEC_TestUtil.mockContactRole('Board Chair', contact.Id, accnt.Id);
      contactRole = EEC_TestUtil.mockContactRole('Owner', contact.Id, accnt.Id);
      
      Licensing_Transaction__c lic = EEC_TestUtil.mockAssistantLicenseTransaction(accnt,'Placement_Renewal');
      //lic.Umbrella__c = accnt.Id;
	  lic.Last_Reached_Step__c = 'Attachments';
	  update lic;
	  
      EEC_TestUtil.mockHouseHold(lic, accnt);
      EEC_TestUtil.mockFCCAssistant(lic, accnt);
      EEC_TestUtil.mockRoom(lic);
      EEC_TestUtil.mockTrainingExperience(lic);
      EEC_TestUtil.mockAWSKeys();
      
      Id addInfoId   = Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('Other Licenses Held').getRecordTypeId();
      Id addRelatedId =  Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('Other License Applications').getRecordTypeId();
      Id addCriminId = Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('Admin/civil/criminal action detail').getRecordTypeId();
      Id addFedId =  Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('State/federal investigation detail').getRecordTypeId();
       
      List<Additional_Information__c> listAdditionalInfo = new List<Additional_Information__c>();
      Additional_Information__c additionalInfo = new Additional_Information__c(recordTypeId = addInfoId,Name_of_Licensee__c = 'Test', Licensing_Transaction__c = lic.Id, Provider__c = accnt.id, Type_of_License__c = 'Test',State_Country_Issuing_the_License__c = 'US',License_Number__c = '123');
      listAdditionalInfo.add(additionalInfo);
      
      additionalInfo = new Additional_Information__c(recordTypeId = addRelatedId,Name_of_Licensee__c = 'Test', Licensing_Transaction__c = lic.Id, Provider__c = accnt.id, Type_of_License__c = 'Test',State_Country_Issuing_the_License__c = 'US',License_Number__c = '123');
      listAdditionalInfo.add(additionalInfo);
      
      additionalInfo = new Additional_Information__c(recordTypeId = addCriminId,Name_of_Licensee__c = 'Test', Licensing_Transaction__c = lic.Id, Provider__c = accnt.id, Type_of_License__c = 'Test',State_Country_Issuing_the_License__c = 'US',License_Number__c = '123');
      listAdditionalInfo.add(additionalInfo);
      
      additionalInfo = new Additional_Information__c(recordTypeId = addFedId,Name_of_Licensee__c = 'Test', Licensing_Transaction__c = lic.Id, Provider__c = accnt.id, Type_of_License__c = 'Test',State_Country_Issuing_the_License__c = 'US',License_Number__c = '123');
      listAdditionalInfo.add(additionalInfo);
      
      insert listAdditionalInfo;

      Test.startTest();
      
      PageReference pg1 = Page.EEC_ViewLicenseTransaction;
      test.setCurrentPage(pg1);      
      ApexPages.currentPage().getParameters().put('ltId', lic.Id);
      ApexPages.currentPage().getParameters().put('member',accnt.Id);
      
      EEC_ViewLicenseTransactionController viewController = new EEC_ViewLicenseTransactionController();
      viewController.getLicenseTrans();
      viewController.getItems();
      viewController.getPickItems();
      viewController.backInstruction();
      viewController.getCtrlInstance();
      viewController.getBaseLicenseTransaction();
      viewController.getBaseLicenseRecordTypeName();
      viewController.gettypeOfOwnership();
      viewController.CancelTransaction();
      viewController.editInstruction();
      
      test.stopTest();
    }
    
    static testmethod void testViewVariance() {
      Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Adoption Agency', null);
	  
	  Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Adoption_Agency');
	  accnt.Config_Record__c = config2.Id;
	  update accnt;
	  
      Licensing_Transaction__c lic = EEC_TestUtil.mockAssistantLicenseTransaction(accnt,'Variance_On_Regulation_Request');
      //lic.Umbrella__c = accnt.Id;
	  lic.Last_Reached_Step__c = 'Attachments';
	  update lic;
	  
      Test.startTest();
      
      PageReference pg1 = Page.EEC_ViewLicenseTransaction;
      test.setCurrentPage(pg1);      
      ApexPages.currentPage().getParameters().put('ltId', lic.Id);
      ApexPages.currentPage().getParameters().put('member',accnt.Id);
      
      EEC_ViewVarianceTransactionController viewController = new EEC_ViewVarianceTransactionController();
      viewController.getLicenseTrans();
      viewController.getItems();
      viewController.getPickItems();
      viewController.backInstruction();
      viewController.getCtrlInstance();
      viewController.getBaseLicenseTransaction();
      viewController.getBaseLicenseRecordTypeName();
      viewController.CancelTransaction();
      viewController.editInstruction();
      
      test.stopTest();
    }
    
    static testmethod void testViewFCC() {
      Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Family Child Care', null);
	  
	  Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'FCC');
	  accnt.Config_Record__c = config2.Id;
	  update accnt;
	  
      Licensing_Transaction__c lic = EEC_TestUtil.mockAssistantLicenseTransaction(accnt,'FCC_New_License');
      //lic.Umbrella__c = accnt.Id;
	  lic.Last_Reached_Step__c = 'Attachments';
	  update lic;
	  
      EEC_TestUtil.mockHouseHold(lic, accnt);
      EEC_TestUtil.mockFCCAssistant(lic, accnt);
      EEC_TestUtil.mockRoom(lic);
      EEC_TestUtil.mockTrainingExperience(lic);
      EEC_TestUtil.mockAWSKeys();
      
      Id addInfoId   = Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('Other Licenses Held').getRecordTypeId();
      Id addRelatedId =  Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('Other License Applications').getRecordTypeId();
      Id addCriminId = Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('Admin/civil/criminal action detail').getRecordTypeId();
      Id addFedId =  Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('State/federal investigation detail').getRecordTypeId();
       
      List<Additional_Information__c> listAdditionalInfo = new List<Additional_Information__c>();
      Additional_Information__c additionalInfo = new Additional_Information__c(recordTypeId = addInfoId,Name_of_Licensee__c = 'Test', Licensing_Transaction__c = lic.Id, Provider__c = accnt.id, Type_of_License__c = 'Test',State_Country_Issuing_the_License__c = 'US',License_Number__c = '123');
      listAdditionalInfo.add(additionalInfo);
      
      additionalInfo = new Additional_Information__c(recordTypeId = addRelatedId,Name_of_Licensee__c = 'Test', Licensing_Transaction__c = lic.Id, Provider__c = accnt.id, Type_of_License__c = 'Test',State_Country_Issuing_the_License__c = 'US',License_Number__c = '123');
      listAdditionalInfo.add(additionalInfo);
      
      additionalInfo = new Additional_Information__c(recordTypeId = addCriminId,Name_of_Licensee__c = 'Test', Licensing_Transaction__c = lic.Id, Provider__c = accnt.id, Type_of_License__c = 'Test',State_Country_Issuing_the_License__c = 'US',License_Number__c = '123');
      listAdditionalInfo.add(additionalInfo);
      
      additionalInfo = new Additional_Information__c(recordTypeId = addFedId,Name_of_Licensee__c = 'Test', Licensing_Transaction__c = lic.Id, Provider__c = accnt.id, Type_of_License__c = 'Test',State_Country_Issuing_the_License__c = 'US',License_Number__c = '123');
      listAdditionalInfo.add(additionalInfo);
      
      insert listAdditionalInfo;

      Test.startTest();
      
      PageReference pg1 = Page.EEC_ViewLicenseTransaction;
      test.setCurrentPage(pg1);      
      ApexPages.currentPage().getParameters().put('ltId', lic.Id);
      ApexPages.currentPage().getParameters().put('member',accnt.Id);
      
      EEC_ViewTransactionController viewController = new EEC_ViewTransactionController();
      viewController.getLicenseTrans();
      viewController.getItems();
      viewController.getHeatingElements();
      viewController.backInstruction();
      viewController.getCtrlInstance();
      viewController.getBaseLicenseTransaction();
      viewController.getBaseLicenseRecordTypeName();
      viewController.refreshAttachmentsList();
      viewController.CancelTransaction();
      viewController.editInstruction();
      
      test.stopTest();
    }
}