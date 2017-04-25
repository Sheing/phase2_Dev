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
private class EEC_TestTransactionWizardController { 

    static testMethod void TestIntroductionPage() {
        loadTestData(Page.EEC_TransactionIntroduction,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        List<String> buttonList = controller.getButtonList();
        System.assert(buttonList.size()>0);
        PageReference nextPageIntr = controller.callTransaction();
        System.assert(nextPageIntr.getUrl().contains('eec_transactioninstructions'));       
        
    }
    
    static testMethod void TestInstructionPage() {
        
        loadTestData(Page.EEC_TransactionIntroduction,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        PageReference nextPageIntr = controller.cancelInstruction();
        nextPageIntr = controller.previousInstruction();
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_transactionintroduction'));
        Test.startTest();
          nextPageIntr = controller.submitInstruction();
        Test.stopTest();
        Licensing_Transaction__c lt = [select Id,Status__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Status__c,'Submitted');
        PageReference nextPageIntr1 = controller.nextInstruction();
        lt = [select Id,Status__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Status__c,'To Submit');
        controller.getItems();
        controller.getHeatingElements();
     
    }
    
     static testMethod void TestTransactionProviderPage() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_TransactionProvider,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        //PageReference nextPageIntr = controller.nextInstruction();
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_New_License');
        controller.licenseTransation = lic;
        PageReference nextPageIntr = controller.saveAndNextTransactionProvider();
        List<Household_Member__c> hmList = [select Id from Household_Member__c where Licensing_Transactions__c = :controller.licenseTransation.Id];
        System.assertEquals(hmList.size(),1);
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_householdmembers'));
        nextPageIntr = controller.saveAndPreviousTransactionProvider();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        //System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_transactionintroduction'));
        System.assertEquals(lt.Last_Reached_Step__c,'Household Members');
        nextPageIntr = controller.saveAndReturnTransactionProvider();
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_portalproviderpage'));
        nextPageIntr = controller.CancelTransaction();
        lt = [select Id,status__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.status__c,'Cancelled (by Applicant)');
        Test.stopTest();
     }
     
     
    static testMethod void TestHouseHoldPageNL() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_HouseholdMembers,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_New_License');
        controller.licenseTransation = lic;
        controller.ihmList = EEC_TestUtil.mockHouseHold(lic, accnt);
        controller.addRow();
        
        controller.delRow();
        PageReference nextPageIntr = controller.SaveAndNextHH();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_licensestatuscapacityinfo'));
        System.assertEquals(lt.Last_Reached_Step__c,'License Status and Capacity');
        nextPageIntr = controller.SaveAndPreviousHH();
        lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Household Members');
        nextPageIntr = controller.SaveAndReturnHH();
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_portalproviderpage'));
        Test.stopTest();
    } 
    
    static testMethod void TestHouseHoldPageCA(){
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_HouseholdMembers,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'Change_of_Address';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'Change_of_Address');
        controller.licenseTransation = lic;
        PageReference nextPageIntr = controller.SaveAndNextHH();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_indoorspacepage'));
        System.assertEquals(lt.Last_Reached_Step__c,'Indoor / Outdoor space information');
        lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_Change_of_Household');
        controller.licenseTransation = lic;
        nextPageIntr = controller.SaveAndNextHH();
        Test.stopTest();
    }
    static testMethod void TestTAPageRenewal() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_TechnicalAssistance,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_Renewal';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_Renewal');
        controller.licenseTransation = lic;
        PageReference nextPageIntr = controller.SaveAndNextTA();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Attachments');
        nextPageIntr = controller.SaveAndPreviousTA();
        lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Daily Routine Activities / Technical Assistance');
        nextPageIntr = controller.SaveAndReturnTA();
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_portalproviderpage'));
        Test.stopTest();
    } 
    
    static testMethod void TestTAPageCA(){
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_TechnicalAssistance,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'Change_of_Address';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'Change_of_Address');
        controller.licenseTransation = lic;
        PageReference nextPageIntr = controller.SaveAndNextTA();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_reviewsummarysubmission'));
        System.assertEquals(lt.Last_Reached_Step__c,'Review Summary and Submission');
    }
    
    static testMethod void TestLSPageNL() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_LicenseStatusCapacityInfo,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_New_License');
        controller.licenseTransation = lic;
        //controller.faList = EEC_TestUtil.mockFCCAssistant(lic, accnt);
        controller.addRowLS();
        controller.delRowLS();
        PageReference nextPageIntr = controller.SaveAndNextLS();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_involvementexperience'));
        System.assertEquals(lt.Last_Reached_Step__c,'EEC Involvement Experience & Professional Exp.');
        nextPageIntr = controller.SaveAndPreviousLS();
        lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'License Status and Capacity');
        nextPageIntr = controller.SaveAndReturnLS();
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_portalproviderpage'));
        Test.stopTest();
    } 
    
    static testMethod void TestLSPageRenewal(){
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_LicenseStatusCapacityInfo,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_Renewal';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_Renewal');
        controller.licenseTransation = lic;
        PageReference nextPageIntr = controller.SaveAndNextLS();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_backgroundinformation'));
        System.assertEquals(lt.Last_Reached_Step__c,'Background Information');
    }
    
    static testMethod void TestEHPage() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_InvolvementExperience,'Apply for a New License','0');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_New_License');
        controller.licenseTransation = lic;
        controller.addRowEH();
        controller.delRowEH();
        PageReference nextPageIntr = controller.SaveAndNextEH();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Background Information');
        nextPageIntr = controller.SaveAndPreviousEH();
        lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'EEC Involvement Experience & Professional Exp.');
        nextPageIntr = controller.SaveAndReturnEH();
        Test.stopTest();
    }
    
    static testMethod void TestBIPage() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_BackgroundInformation,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_Renewal';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_Renewal');
        controller.licenseTransation = lic;
        PageReference nextPageIntr = controller.SaveAndNextBI();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Training Information');
        nextPageIntr = controller.SaveAndPreviousBI();
        lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Background Information');
        nextPageIntr = controller.SaveAndReturnBI();
        Test.stopTest();
    }
    
    static testMethod void TestRoomPage() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_IndoorSpacePage,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_New_License');
        controller.licenseTransation = lic;
        controller.roomList = EEC_TestUtil.mockRoom(lic);
        controller.selectedHestElems = new List<String>(); 
        controller.selectedHestElems.add('Background');
        controller.showCBDesc();
        controller.addRowRoom();
        controller.delRowRoom();
        PageReference nextPageIntr = controller.SaveAndNextRoom();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_technicalassistance'));
        System.assertEquals(lt.Last_Reached_Step__c,'Daily Routine Activities / Technical Assistance');
        nextPageIntr = controller.SaveAndPreviousRoom();
        lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Indoor / Outdoor space information');
        nextPageIntr = controller.SaveAndReturnRoom();
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_portalproviderpage'));
        Test.stopTest();
    } 
    
    static testMethod void TestTEPage() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_TechnicalAssistance,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_Renewal');
        controller.licenseTransation = lic;
        controller.teList = EEC_TestUtil.mockTrainingExperience(lic);
        controller.addRowTE();
        controller.delRowTE();
        PageReference nextPageIntr = controller.SaveAndNextTE();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_indoorspacepage'));
        System.assertEquals(lt.Last_Reached_Step__c,'Indoor / Outdoor space information');
        nextPageIntr = controller.SaveAndPreviousTE();
        lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Training Information');
        nextPageIntr = controller.SaveAndReturnTE();
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_portalproviderpage'));
        Test.stopTest();
    }
    
    
    
    
    /*static testMethod void TestReviewSummaryPage() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_New_License');
        controller.licenseTransation = lic;
        controller.submitRS();
        Licensing_Transaction__c lt = [select Id,Status__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Status__c,'Submitted');
        controller.SaveAndReturnRS();
        lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Review Summary and Submission');
        controller.previousRS();
    }-----*/
    
    
    
    
    static testMethod void TestLicenseTrans() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_New_License');
        controller.getLicenseTrans(lic.Id);
    }
    
    static testMethod void testHMWrapper(){
      Test.startTest();
        Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_Renewal';
        Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
        Household_Member__c hm = [select Id from Household_Member__c where Licensing_Transactions__c = :lic.Id limit 1];
        controller.licenseTransation = lic;
        controller.MembersJson = '[{"Id":"'+hm.Id+'","First_Name":"Harry","Last_Name":"Potter","Date_of_Birth":"2015-06-28T00:00:00.000Z","Relationship_to_Provider":"baby","Occupation":"wizard","Number_of_Hours_Home_During_Child_Care":5,"Current_School_Grade":null,"Email_Address":null}]';
        controller.MembersToDeleteJson = '[{"Id":"'+hm.Id+'","First_Name":"Harry","Last_Name":"Potter","Date_of_Birth":"2015-06-28T00:00:00.000Z","Relationship_to_Provider":"baby","Occupation":"wizard","Number_of_Hours_Home_During_Child_Care":5,"Current_School_Grade":null,"Email_Address":null}]';
        controller.UpdateMembersList();
    }
    
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
    
    static Account loadNewTestData(PageReference lPageRef,String buttonLabel, String index){
        Account accnt = EEC_TestUtil.loadNewLicenseTransaction();
        PageReference pageRef = lPageRef;
        pageRef.getParameters().put('accountId',accnt.Id);
        pageRef.getParameters().put('buttonLabel',buttonLabel);
        pageRef.getParameters().put('index',index);
        Test.setCurrentPage(pageRef);
        EEC_TestUtil.mockAWSKeys();
        return accnt;
    }
    
    static testMethod void testGetWaterIsPrivate() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
      // False path.
      lic.Drinking_Water_Source__c = 'Town Water Supply';
      update lic;  
      System.assert(!controller.getWaterIsPrivate());
      // Success path.
      controller.selectedWaterStr = 'private water supply';
      System.assert(!controller.getWaterIsPrivate());
    }
    
    static testMethod void testGetHeatingConditionals() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
        
      // Test the barricade section.
      controller.selectedHestStr = '';
      System.assert(!controller.getHeatingIsBarricaded());
      // Success path.
      controller.selectedHestElems = new List<String>{'Baseboards'};
      System.assert(!controller.getHeatingIsBarricaded());
        
      // Test the heating evidence section.  
      controller.selectedHestStr = null;
      System.assert(!controller.getHeatingEvidenceRequired());
      controller.selectedHestStr = 'Coal / Pellet / Wood Burning Stove';
      System.assert(controller.getHeatingEvidenceRequired());
    }
    
    static testMethod void testGetRoomTableVisibility() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
      
      controller.roomList = new List<Room__c>();
      System.assert(!controller.getRoomTableVisibility());
      controller.addRowRoom();
      System.assert(controller.getRoomTableVisibility());
    }
    
    static testMethod void testGenerateMultiplePolicySignature() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
        
      // Test method.
      String exampleJson = '[{"filename": "testName", "type": "image/png"}]'; 
        
      List<Map<String,String>> result = EEC_TransactionWizardController.generateMultiplePolicySignature('eec', 'authenticated-read', exampleJson);
      System.assertNotEquals(0, result.size());
      System.assertNotEquals(null, result.get(0).get('policy'));  
      System.assertNotEquals(null, result.get(0).get('signature'));
    }
    
    static testMethod void testDeleteAttachment() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
        
      // Test Method
      S3_File__c file = new S3_File__c(
        Filename__c = 'testFile',
        Content_Type__c = 'image/png',
        Bucket__c = 'test',
        Acl__c = 'authenticated-read',
        Prefix__c = lic.Id
      ); 
      insert file;  
        
      FileMap__c fileMap = new FileMap__c(
        Object_Id__c = lic.Id,
        Object_Name__c = 'Licensing_Transaction__c',
        S3_File__c = file.Id
      );
      insert fileMap;
      
      controller.licenseTransation = lic;
      controller.fileToDelete = 'testFile';
      controller.refreshAttachmentsList();
      controller.deleteAttachment();  
    }
    
    static testMethod void testGetExistingItems() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
      
      // Test Method.
      System.assert(!controller.getRenderExistingWaterAttachment()); 
      System.assert(!controller.getRenderExistingHeatingAttachment());
      System.assert(!controller.getRenderExistingMedicationAttachment());
      System.assert(!controller.getRenderExistingTransportationAttachment());
      System.assert(!controller.getRenderExistingSidsAttachment());
      System.assert(!controller.getRenderExistingUsdaAttachment());
      System.assert(!controller.getRenderExistingUpgradeAttachment());
      System.assert(!controller.getRenderExistingOrientationAttachment());
      System.assert(!controller.getRenderExistingCprAttachment());
      System.assert(!controller.getRenderExistingFirstAidAttachment());
    }
    
    static testMethod void testSaveAttachmentsFromJson() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
        
      String attachmentsJson = '[{"Filename__c": "TestFile", "Prefix__c": "12345", "Content_Type__c": "image/png", "Acl__c": "authenticated-read", "Bucket__c": "test"}]';
      controller.indoorAttachmentsJson = attachmentsJson;
      controller.saveAttachmentsFromJson();
      controller.saveAllAttachmentsFromJson();
      controller.saveTrainingAttachmentsFromJson();
    }
    
    static testMethod void testGetAttachmentSpotlightText() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1]; 
        
      controller.getAttachmentSpotlightText();
      controller.licenseRecordTypeName = 'FCC_New_License';
      controller.getAttachmentSpotlightText();
      controller.licenseRecordTypeName = 'FCC_License_Upgrade';  
      controller.getAttachmentSpotlightText();
    }
    
    static testMethod void testGetCityOptions() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1]; 
        
      System.assertEquals(2, (controller.getCityOptions()).size());        
    }
    
    static testMethod void testSaveFileDescription() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];   
      // Test Method
      S3_File__c file = new S3_File__c(
        Filename__c = 'testFile',
        Content_Type__c = 'image/png',
        Bucket__c = 'test',
        Acl__c = 'authenticated-read',
        Prefix__c = lic.Id,
        Description__c = 'Description!'
      ); 
      insert file;    
      System.assertEquals('Description!', file.Description__c);
       
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      controller.fileToEditId = file.Id;
      controller.fileToEditDescription = 'A new description';
      controller.saveFileDescription();
        
      file = [Select Description__c From S3_File__c Where Id = :file.Id];
      System.assertEquals('A new description', file.Description__c);        
    }

    static testmethod void testEditInstruction() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_TransactionProvider,'Apply for a New License','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_New_License');
      controller.licenseTransation = lic;
      controller.saveAndNextTransactionProvider();
      
      System.assertEquals(controller.licenseTransation.Last_Reached_Step__c, 'Indoor / Outdoor space information');
      System.assertEquals(controller.editInstruction().getUrl(), ('/apex/eec_indoorspacepage?ltId='+lic.Id));
    }

    static testMethod void testGetIdAssistantReviewMode() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_TransactionProvider,'Apply for a New License','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();

      System.assertEquals(false, controller.getIsAssistantReviewMode());
      PageReference newPage = new PageReference('/apex/eec_transactionprovider');
      newPage.getParameters().put('mode', '4');
      Test.setCurrentPage(newPage);
      System.assertEquals(true, controller.getIsAssistantReviewMode());
      newPage.getParameters().put('mode', '0');
      System.assertEquals(false, controller.getIsAssistantReviewMode());
    }

    static testMethod void testGetIsAssistantUpgradeOrientationProvided() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_TransactionProvider,'Apply for a New License','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();

      // False Path
      Licensing_Transaction__c lic = EEC_TestUtil.mockAssistantLicenseTransaction(accnt,'FCC_Assistant_New_License');
      controller.licenseTransation = lic;
      System.assertEquals(false, controller.getIsAssistantUpgradeOrientationProvided());

      // True Path
      Licensing_Transaction__c lic2 = EEC_TestUtil.mockAssistantLicenseTransaction(accnt,'FCC_Assistant_Renewal');
      lic2.Took_FCC_Orientation__c = 'No';
      update lic2;

      controller = new EEC_TransactionWizardController();
      controller.licenseTransation = lic;
      System.assertEquals(true, controller.getIsAssistantUpgradeOrientationProvided());
    }

    static testmethod void testDailyRandASave() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_Transaction_DailyRandA,'Apply for a New License','1');
      Licensing_Transaction__c lic = EEC_TestUtil.mockAssistantLicenseTransaction(accnt,'FCC_Assistant_New_License');
      ApexPages.currentPage().getParameters().put('saveType', '1');
      ApexPages.currentPage().getParameters().put('ltId', lic.Id);

      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.DailyRandASave();
      System.assertEquals('Background Information', controller.licenseTransation.Last_Reached_Step__c);

      ApexPages.currentPage().getParameters().put('saveType', '3');
      controller.DailyRandASave();
      System.assertEquals('Daily Routine & Activities', controller.licenseTransation.Last_Reached_Step__c);

      // This flow needs to have the page reference tested as well due to multiple conditions.
      ApexPages.currentPage().getParameters().put('saveType', '2');
      controller.DailyRandASave();
      System.assertEquals('Daily Routine & Activities', controller.licenseTransation.Last_Reached_Step__c);

      Licensing_Transaction__c lic2 = EEC_TestUtil.mockAssistantLicenseTransaction(accnt,'FCC_Assistant_Renewal');
      ApexPages.currentPage().getParameters().put('ltId', lic2.Id);
      controller = new EEC_TransactionWizardController();
      controller.DailyRandASave();
    }
    
    static testmethod void testNewOwnershipAdmin1() {
      Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Small Group', null);
    
    Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Small_Group');
    accnt.Config_Record__c = config2.Id;
    update accnt;
    
    system.debug('accnt'+ accnt);
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
      lic.Umbrella__c = accnt.Id;
    system.debug('lic'+ lic);
      
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
      
      PageReference pg = Page.EEC_OwnershipAdministratorInfo;
      test.setCurrentPage(pg);      
      ApexPages.currentPage().getParameters().put('ltId', lic.Id);
      ApexPages.currentPage().getParameters().put('member',accnt.Id);

      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      
      Test.startTest();
      controller.gettypeOfOwnership();
      controller.getContactList();
      
      controller.selectedBoardContact = 'New Individual';
      controller.selectedContact = 'New Individual';
      
    controller.addadmincontactrole();
    controller.addcontactrole();
    controller.newAdminHead();
    controller.newBoardHead();
      
      controller.pullContactRole();
      controller.LicenseRecordTypeLabel='GSA_New_License';
      
      controller.SaveAndNextOwnership();
      controller.SaveAndReturnOwnership();
      controller.SaveAndPreviousOwnership();
      controller.SaveAndNextDesign();
      controller.saveAndNextPlacement();
      controller.saveAndPreviousPlacement();
      controller.saveAndReturnPlacement();
      controller.saveAndReturnDesignation();
      
      test.stopTest();
    }
    static testmethod void testNewOwnershipAdmin2() {
      Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Small Group', null);
    
    Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Small_Group');
    accnt.Config_Record__c = config2.Id;
    update accnt;
    
    system.debug('accnt'+ accnt);
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
      lic.Minimum_Age_Limit_Requested_Years__c=5;
      lic.Minimum_Age_Limit_Requested_Months__c=2;
      lic.Maximum_Age_Limit_Requested_Years__c=2;
      lic.Maximum_Age_Limit_Requested_Months__c=2;
      lic.Ownership_Type__c = 'Partnership';
      update lic;
    system.debug('lic'+ lic);
      
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
      
      PageReference pg = Page.EEC_OwnershipAdministratorInfo;
      test.setCurrentPage(pg);      
      ApexPages.currentPage().getParameters().put('ltId', lic.Id);
      ApexPages.currentPage().getParameters().put('member',accnt.Id);
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      
      Test.startTest();
      controller.LicenseRecordTypeLabel='GSA_New_License';
      controller.LicenseRecordTypeName='Residential_New_License';
      controller.SaveAndPreviousCapacity();
      //controller.SaveAndNextCapacity();
      controller.saveAndReturnCapacity();
      controller.SaveAndNextOperation();
      controller.SaveAndPreviousOperation();
      controller.saveAndReturnOperation();
      controller.SaveAndPreviousResidentialDetail();
      controller.saveAndReturnResidentialDetail();
      controller.SaveAndNextIndoorGSA();
      controller.SaveAndPreviousIndoorGSA();
      controller.saveAndReturnIndoorGSA();
      controller.otherReferral();   
      controller.SaveAndNextResidentialDetail();
      controller.LicenseRecordTypeName = 'GSA_Move';
      controller.SaveAndNextCapacity();
      controller.internationalCountries();
      controller.bldgCode();
      controller.otherCountries();
      controller.dcfSpecialNeeds();
      controller.LicenseRecordTypeName='Residential_Move';
      controller.saveAndReturnDesignation();
      controller.AddLicenseHeld();
      controller.DeleteLicenseHeld();
      controller.checkHeld();
      controller.AddCriminalAct();
      controller.DeleteCriminalHeld();
      controller.checkCriminal();
      controller.AddFederalInv();
      controller.DeleteFederalInv();
      controller.checkFederal();
      controller.AddRelatedLicense();
      controller.DeleteRelatedLicense();
      controller.checkRelated();
      ApexPages.currentPage().getParameters().put('saveType','1');
      controller.LicensingStatusCapacityInfoSave();
      controller.AssistantInfoSave();
      ApexPages.currentPage().getParameters().put('saveType','2');
      controller.LicensingStatusCapacityInfoSave();
      controller.AssistantInfoSave();
      ApexPages.currentPage().getParameters().put('saveType','3');
      controller.LicensingStatusCapacityInfoSave();
      controller.AssistantInfoSave();
      controller.LicenseRecordTypeName='Residential_License_Renewal';
      controller.saveAndPreviousTransactionProvider();
      controller.saveAndReturnTransactionProvider();
      controller.setLicensedAgency();
      controller.showWaterUpload();
      controller.SaveAndPreviousRoom();
      controller.LicenseRecordTypeName='FCC_Change_Room_Floor_Level';
      controller.SaveAndPreviousRoom();
      ApexPages.currentPage().getParameters().put('buttonLabel', 'Residential_License_Renewal');
      controller.callIntakeForms();
      Test.stopTest();
 
    }   
    static testmethod void testcallTransaction() {      
    Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Small Group', null);
    
    Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Group_Care');
    accnt.Config_Record__c = config2.Id;
    update accnt;
    System.debug(accnt.Is_Residential__c);
    Account a=[Select id,RecordType.Name,Is_Residential__c from account where id=:accnt.id];
    System.debug(a.RecordType.Name);
    System.debug(a.Is_Residential__c);
    system.debug('accnt'+ accnt);
      Contact contact = EEC_TestUtil.mockContact(a, 'Test', 'LastName', '');
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
      lic.Minimum_Age_Limit_Requested_Years__c=5;
      lic.Minimum_Age_Limit_Requested_Months__c=2;
      lic.Maximum_Age_Limit_Requested_Years__c=2;
      lic.Maximum_Age_Limit_Requested_Months__c=2;
      lic.Ownership_Type__c = 'Partnership';
      update lic;
    system.debug('lic'+ lic);
      
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
      
      PageReference pg = Page.EEC_OwnershipAdministratorInfo;
      test.setCurrentPage(pg);      
      ApexPages.currentPage().getParameters().put('ltId', lic.Id);
      ApexPages.currentPage().getParameters().put('member',accnt.Id);
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      
      Test.startTest();
      controller.licenseTransation=lic;
      ApexPages.currentPage().getParameters().put('buttonLabel','New Application (Provisional)');
      controller.callTransaction();
      controller.providerRecordType='Small Group';
      controller.callTransaction();
      controller.providerRecordType = 'Foster Care Agency';
      controller.callTransaction();
      
      ApexPages.currentPage().getParameters().put('buttonLabel','New Application (Regular)');
      controller.providerRecordType = 'Group Care';
      controller.callTransaction();
      controller.providerRecordType='Small Group';
      controller.callTransaction();
      controller.providerRecordType = 'Foster Care Agency';
      controller.callTransaction();   
      
      ApexPages.currentPage().getParameters().put('buttonLabel','Apply for Renewal (without move)');
      controller.providerRecordType = 'Group Care';
      controller.callTransaction();
      controller.providerRecordType='Small Group';
      controller.callTransaction();
      controller.providerRecordType = 'Foster Care Agency';
      controller.callTransaction();   
      
      ApexPages.currentPage().getParameters().put('buttonLabel','Apply for a Move or License Renewal with Move');
      controller.providerRecordType = 'Group Care';
      controller.callTransaction();
      controller.providerRecordType='Small Group';
      controller.callTransaction();
      controller.providerRecordType = 'Foster Care Agency';
      controller.callTransaction();   
      
      Test.stopTest();
    }
    static testmethod void testAttachment1() {      
    Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Small Group', null);
    
    Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Small_Group');
    accnt.Config_Record__c = config2.Id;
    update accnt;
    
    system.debug('accnt'+ accnt);
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
      lic.NewUmbrella_State__c = 'MA';
      
    system.debug('lic'+ lic);
      
      EEC_TestUtil.mockHouseHold(lic, accnt);
      EEC_TestUtil.mockFCCAssistant(lic, accnt);
      EEC_TestUtil.mockRoom(lic);
      EEC_TestUtil.mockTrainingExperience(lic);
      EEC_TestUtil.mockAWSKeys();
      
      Regulation__c regulation = new Regulation__c(name = EEC_TestUtil.generateRandomString(5), Date_Active__c = Date.today(), Reg_key__c = EEC_TestUtil.generateRandomString(5), Article__c = EEC_TestUtil.generateRandomString(5), applicable_To__c = 'Small Group');
      upsert regulation;
    
      List<Variance_on_Regulation__c> listVariance = new List<Variance_on_Regulation__c>();
      
      Variance_on_Regulation__c variance = new Variance_on_Regulation__c();
      variance.Associated_Regulation__c = regulation.Id;
      variance.Provider__c = accnt.Id;
      variance.Source_Transaction__c = lic.Id;
      variance.Licensor_Recommendation__c = 'Granted';
      variance.Decision__c = 'Granted';
      variance.Brief_explanation_for_license__c = 'Test';
      variance.Decision_Date__c = date.today();
      variance.Decision_Rationale__c = 'Test';
      variance.Provider_Understanding_of_Regulation__c = 'Test';
      variance.Recommendation_Rationale__c = 'Test';
      listVariance.add(variance);
      
      variance = new Variance_on_Regulation__c();
      variance.Associated_Regulation__c = regulation.Id;
      variance.Provider__c = accnt.Id;
      variance.Source_Transaction__c = lic.Id;
      variance.Licensor_Recommendation__c = 'Granted';
      variance.Decision__c = 'Granted';
      variance.Brief_explanation_for_license__c = 'Test';
      variance.Decision_Date__c = date.today();
      variance.Decision_Rationale__c = 'Test';
      variance.Provider_Understanding_of_Regulation__c = 'Test';
      variance.Recommendation_Rationale__c = 'Test';
      listVariance.add(variance);
    
    insert listVariance;
    
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
      
      test.startTest();
      PageReference pg = Page.EEC_LicensingTransactionAttachment;
      test.setCurrentPage(pg);      
      ApexPages.currentPage().getParameters().put('ltId', lic.Id);
      ApexPages.currentPage().getParameters().put('member',accnt.Id);
      
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
     
      string filebody = '[{"Filename__c":"file1.csv","Prefix__c":"'+lic.Id+'","Content_Type__c":"application/vnd.ms-excel","Acl__c":"authenticated-read","Bucket__c":"eec-lead-integration"}]';
      
      ApexPages.currentPage().getParameters().put('attachmentbody', filebody);
      ApexPages.currentPage().getParameters().put('clickedId', lic.Id);
      ApexPages.currentPage().getParameters().put('clickedType', 'Required');
      ApexPages.currentPage().getParameters().put('documentTypeId', listDocumentType[0].Id);
       
      controller.getLicenseTrans(lic.Id);
      
      controller.umbrellaName = 'test';
      controller.cityName = 'test';
      controller.doGetCity();
      controller.query();
      
      controller.newCityName = 'Test2';
      
      controller.addUmbrella();
      
      controller.doOpenAttachment();
      controller.uploadAttachment();
      
      ApexPages.currentPage().getParameters().put('clickedType', 'Additional');
      ApexPages.currentPage().getParameters().put('documentTypeId', '');
      controller.uploadAttachment();
      
      ApexPages.currentPage().getParameters().put('clickedType', 'Optional');
      ApexPages.currentPage().getParameters().put('documentTypeId', listDocumentType[0].Id);
      controller.uploadAttachment();
      
      ApexPages.currentPage().getParameters().put('clickedType', 'Additional');
      ApexPages.currentPage().getParameters().put('documentTypeId', '');
      controller.uploadAttachment();
      
      ApexPages.currentPage().getParameters().put('clickedType', 'Individual');
      ApexPages.currentPage().getParameters().put('documentTypeId', listDocumentType[1].Id);
      controller.uploadAttachment();
      
      ApexPages.currentPage().getParameters().put('clickedType', 'Variance');
      ApexPages.currentPage().getParameters().put('clickedId', listVariance[0].Id);
      controller.uploadAttachment();
      
      ApexPages.currentPage().getParameters().put('clickedType', 'Variance');
      ApexPages.currentPage().getParameters().put('clickedId', listVariance[1].Id);
      controller.uploadAttachment();
      
      ApexPages.currentPage().getParameters().put('documentId', listDocument[0].Id);
      ApexPages.currentPage().getParameters().put('documentName', 'Test Document');
      ApexPages.currentPage().getParameters().put('clickedId', lic.Id);
      ApexPages.currentPage().getParameters().put('clickedType', 'Additional');
      ApexPages.currentPage().getParameters().put('documentTypeId', listDocumentType[0].Id);
      
      controller.doSelectDocument();
      
      List<Transaction_Document__c> listTranDocs = [select Id, Comments__c from Transaction_Document__c limit 1];
      
      ApexPages.currentPage().getParameters().put('trandocId', listTranDocs[0].Id);
      ApexPages.currentPage().getParameters().put('trandocComments', 'Test Comments');
      
      
      
      controller.doUpdateComments(); 
      System.debug('1');
      controller.clearAttachLib();
      
      test.stopTest();
      /*System.debug('2');
      controller.setDocNameId('Test', listDocument[0].Id);
      System.debug('3');
      //controller.addDocument();
      controller.showLSDesc();
      System.debug('4');
      controller.showAddAssistanceDesc();
      System.debug('5');
      controller.SaveAndNextAttachment();
      System.debug('6');
      controller.SaveAndPreviousAttachment();
      System.debug('7');
      controller.SaveAndReturnAttachment();
      System.debug('8');
      controller.previousRS();
      System.debug('9');
      controller.submitRS();
      System.debug('10');
      
      
      
      EEC_TransactionWizardController.createAndInsertAttachment(lic.Id);
      controller.SaveAndReturnRS();
      controller.getIsTransactionEditiable();
      controller.getSupply();
      controller.getGrps();
      List<SelectOption> listOption = controller.weekDays;
      String[] setString = controller.selectedDay;
      boolean b = controller.isSelectedDay;
      controller.opsFullDay();
      listOption = controller.weekHalfDays;
      setString = controller.selectedHalfDay;
      listOption = controller.weekHalfAfterDays;
      setString = controller.selectedHalfAfterDay;
      listOption = controller.weekExtendDays;
      controller.getHeatingElements();
      controller.getRenderExistingOrientationModuleAttachment();
      controller.getRenderExistingIntroEECModuleAttachment();
      EEC_PaginatedSelectList page1 = controller.allCityList;
      page1 = controller.maCityList;
      controller.getMACityOptions();
      controller.getCityOptions();
      controller.getBackgroundInformationQuestions();
      controller.getRequestedLicenseOptions();
      controller.getCtrlInstance();
      controller.getBaseLicenseTransaction();
      controller.getBaseLicenseRecordTypeName();
      controller.doSelectUmbrella();
      controller.initGSA_RSubmissionPage();
      ApexPages.currentPage().getParameters().put('index', listTranDocs[0].Id);
      controller.delAttachment();
      controller.getMinMaxYears();
      controller.getMinMaxMonths();
      controller.getMinMaxAge();
      controller.saveandpreviousGSASummary();
      controller.saveandreturnTOProviderGSASummary();
      ----------------*/
    }
    static testmethod void testAttachment2() {      
    Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Small Group', null);
    
    Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Small_Group');
    accnt.Config_Record__c = config2.Id;
    update accnt;
    
    system.debug('accnt'+ accnt);
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
      lic.NewUmbrella_State__c = 'MA';
      
    system.debug('lic'+ lic);
      
      EEC_TestUtil.mockHouseHold(lic, accnt);
      EEC_TestUtil.mockFCCAssistant(lic, accnt);
      EEC_TestUtil.mockRoom(lic);
      EEC_TestUtil.mockTrainingExperience(lic);
      EEC_TestUtil.mockAWSKeys();
      
      Regulation__c regulation = new Regulation__c(name = EEC_TestUtil.generateRandomString(5), Date_Active__c = Date.today(), Reg_key__c = EEC_TestUtil.generateRandomString(5), Article__c = EEC_TestUtil.generateRandomString(5), applicable_To__c = 'Small Group');
      upsert regulation;
    
      List<Variance_on_Regulation__c> listVariance = new List<Variance_on_Regulation__c>();
      
      Variance_on_Regulation__c variance = new Variance_on_Regulation__c();
      variance.Associated_Regulation__c = regulation.Id;
      variance.Provider__c = accnt.Id;
      variance.Source_Transaction__c = lic.Id;
      variance.Licensor_Recommendation__c = 'Granted';
      variance.Decision__c = 'Granted';
      variance.Brief_explanation_for_license__c = 'Test';
      variance.Decision_Date__c = date.today();
      variance.Decision_Rationale__c = 'Test';
      variance.Provider_Understanding_of_Regulation__c = 'Test';
      variance.Recommendation_Rationale__c = 'Test';
      listVariance.add(variance);
      
      variance = new Variance_on_Regulation__c();
      variance.Associated_Regulation__c = regulation.Id;
      variance.Provider__c = accnt.Id;
      variance.Source_Transaction__c = lic.Id;
      variance.Licensor_Recommendation__c = 'Granted';
      variance.Decision__c = 'Granted';
      variance.Brief_explanation_for_license__c = 'Test';
      variance.Decision_Date__c = date.today();
      variance.Decision_Rationale__c = 'Test';
      variance.Provider_Understanding_of_Regulation__c = 'Test';
      variance.Recommendation_Rationale__c = 'Test';
      listVariance.add(variance);
    
    insert listVariance;
    
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
      
      test.startTest();
      PageReference pg = Page.EEC_LicensingTransactionAttachment;
      test.setCurrentPage(pg);      
      ApexPages.currentPage().getParameters().put('ltId', lic.Id);
      ApexPages.currentPage().getParameters().put('member',accnt.Id);
      
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
     
      string filebody = '[{"Filename__c":"file1.csv","Prefix__c":"'+lic.Id+'","Content_Type__c":"application/vnd.ms-excel","Acl__c":"authenticated-read","Bucket__c":"eec-lead-integration"}]';
      
      ApexPages.currentPage().getParameters().put('attachmentbody', filebody);
      ApexPages.currentPage().getParameters().put('clickedId', lic.Id);
      ApexPages.currentPage().getParameters().put('clickedType', 'Required');
      ApexPages.currentPage().getParameters().put('documentTypeId', listDocumentType[0].Id);
       controller.getLicenseTrans(lic.Id);
      
      controller.umbrellaName = 'test';
      controller.cityName = 'test';
      controller.doGetCity();
      controller.query();
      
      controller.newCityName = 'Test2';
      
      controller.addUmbrella();
      
      List<Transaction_Document__c> listTranDocs1 = [select Id, Comments__c from Transaction_Document__c limit 1];
      System.debug('list>>'+listTranDocs1);
      controller.doGetAttachmentList();
      controller.doOpenAttachment();
      controller.uploadAttachment();
      controller.doSelectDocument();
      
      List<Transaction_Document__c> listTranDocs = [select Id, Comments__c from Transaction_Document__c limit 1];
       
       ApexPages.currentPage().getParameters().put('trandocId', listTranDocs[0].Id);
      ApexPages.currentPage().getParameters().put('trandocComments', 'Test Comments');
      
      
      
      controller.doUpdateComments(); 
      controller.clearAttachLib();
      controller.setDocNameId('Test', listDocument[0].Id);
      //controller.addDocument();
      controller.showLSDesc();
      controller.showAddAssistanceDesc();
      controller.LicenseRecordTypeLabel='Residential_Move';
      controller.SaveAndNextAttachment();
      controller.LicenseRecordTypeLabel='GSA_Change_of_Admin_Authority';
      controller.SaveAndNextAttachment();
      controller.LicenseRecordTypeName = 'R_P_Change_of_Admin_Authority';
      controller.gettypeOfOwnership();
      controller.LicenseRecordTypeName='Residential_Change_of_Admin_Authority';
      controller.pullContactRole();
      controller.SaveAndPreviousAttachment();
      controller.SaveAndReturnAttachment();
      controller.previousRS();
      controller.submitRS();
      
      
      
      EEC_TransactionWizardController.createAndInsertAttachment(lic.Id);
      controller.SaveAndReturnRS();
      controller.getIsTransactionEditiable();
      controller.getSupply();
      controller.getGrps();
      List<SelectOption> listOption = controller.weekDays;
      String[] setString = controller.selectedDay;
      boolean b = controller.isSelectedDay;
      controller.opsFullDay();
      listOption = controller.weekHalfDays;
      setString = controller.selectedHalfDay;
      listOption = controller.weekHalfAfterDays;
      setString = controller.selectedHalfAfterDay;
      listOption = controller.weekExtendDays;
      controller.getHeatingElements();
      controller.getRenderExistingOrientationModuleAttachment();
      controller.getRenderExistingIntroEECModuleAttachment();
      EEC_PaginatedSelectList page1 = controller.allCityList;
      page1 = controller.maCityList;
      controller.getMACityOptions();
      controller.getCityOptions();
      controller.getBackgroundInformationQuestions();
      controller.getRequestedLicenseOptions();
      controller.getCtrlInstance();
      controller.getBaseLicenseTransaction();
      controller.getBaseLicenseRecordTypeName();
      controller.doSelectUmbrella();
      controller.initGSA_RSubmissionPage();
      ApexPages.currentPage().getParameters().put('index', listTranDocs[0].Id);
      controller.delAttachment();
      controller.getMinMaxYears();
      controller.getMinMaxMonths();
      controller.getMinMaxAge();
      controller.saveandpreviousGSASummary();
      controller.saveandreturnTOProviderGSASummary();
      controller.copyall();
      controller.copyBusinessSec();
      controller.copyDevelopSec();
      controller.copyOtherSec();
      test.stopTest();
      
    }
    
}