@isTest
public class EEC_ReportGeneration_OneExtensionTest {   
    public static testmethod void testProcessNaraitiveDefault() {
        
          Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Small Group', null);
        
        Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Small_Group');
        accnt.Config_Record__c = config2.Id;
        update accnt;
        
          Contact contact = EEC_TestUtil.mockDirectorContact(accnt);
        
         Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();	
        
        /*Account provider = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC');
        
        Inspection__c i = EEC_TestUtil.mockInspection(provider);

        i.Number_of_days_to_receive_response__c= 5;
        update i;
        
        //Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null, 'My observation'); 
        System.debug('Test Provider Id' + i.Provider_No__c);*/
        
        Inspection__c i = EEC_TestUtil.loadInspectionSetup();
       // i.Corrective_Action_Deadline__c = TODAY();
        
        Test.startTest();
        
        EEC_ReportGeneration_OneExtension ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));
        //ext.processNaraitiveDefault();
        //System.assertEquals('This functionality is only available if the visit is in status "Visit Completed" or "Report to be sent to Provider"', ext.toastMsg);
        
        i.Number_of_days_to_receive_response__c= 5;
        i.Status__c = 'Visit Completed';
        i.Inspector_del__c = UserInfo.getUserId();  
        update i;
        
        ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));
        ext.processNaraitiveDefault();
        
        Test.stopTest();
    } 
    public static testmethod void testProcessNaraitiveDefaultWithUmbrella() {
       
        /*Account provider = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC');
        Account umbrella = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC');
        
        Contact director = EEC_TestUtil.mockContact(provider, 'firstName', 'lastName', 'Director');
        //Contact mainContact = EEC_TestUtil.mockContact(provider, 'firstName', 'lastName', 'Main Contact / Licensee');  
        
        umbrella.Umbrella_Members__c = provider.Id;
        update provider;  
        
        Inspection__c i = EEC_TestUtil.mockInspection(umbrella);
        
        i.Number_of_days_to_receive_response__c = 5;
        update i;
        
        //Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null, 'My observation'); 
        System.debug('Test Provider Id' + i.Provider_No__c);*/
        
        Inspection__c i = EEC_TestUtil.loadInspectionSetup();
        
        Test.startTest();
        
        EEC_ReportGeneration_OneExtension ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));
        ext.processNaraitiveDefault();
        //System.assertEquals('This functionality is only available if the visit is in status "Visit Completed" or "Report to be sent to Provider"', ext.toastMsg);
        
        i.Number_of_days_to_receive_response__c= 5;
        i.Status__c = 'Visit Completed';
        i.Inspector_del__c = UserInfo.getUserId();  
        update i;
        
        ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));
        //ext.processNaraitiveDefault();
        
        Test.stopTest();
    }   
    
    public static testmethod void testGenerateAllReports() {
        
        
        Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null, 'My observation'); 
        
        Test.setCurrentPageReference(new PageReference('EEC_ReportGeneration_One')); 
        System.currentPageReference().getParameters().put('reportType', 'nc');
        
        Test.startTest();
        
        EEC_ReportGeneration_OneExtension ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));
        ext.generateAllReports();
        System.assertEquals('Report Narrative can only be generated if the Visit is Completed, and not Closed', ext.toastMsg);
        
        i.Status__c = 'Visit Completed';
        update i;
        
        ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));
        ext.generateAllReports();
        System.assertEquals('This functionality is not available for a Closed or Cancelled Visit, Visit must first be re-opened by a Supervisor or Director', ext.toastMsg);
        
        Test.stopTest();  
    } 
    public static testmethod void testGenerateChecklistReports() {
        
        Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null, 'My observation'); 
        
        i.Status__c = 'Visit Completed';
        update i;
        Test.startTest();
        
        EEC_ReportGeneration_OneExtension ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));  
        
        Test.setCurrentPageReference(new PageReference('EEC_ReportGeneration_One')); 
        System.currentPageReference().getParameters().put('reportType', 'checklist');
        ext.generateAllReports();
        System.assertEquals('Visit Summary generated. See Notes and Attachments to view the report.', ext.toastMsg);
        
        
        Test.stopTest();    
    }
    
    public static testmethod void testGenerateNarrativeReports() {
        
        Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null, 'My observation'); 
        
        i.Status__c = 'Visit Completed';
        update i;
        Test.startTest();
        
        EEC_ReportGeneration_OneExtension ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));  
        
        Test.setCurrentPageReference(new PageReference('EEC_ReportGeneration_One')); 
        System.currentPageReference().getParameters().put('reportType', 'narrative');
        ext.generateAllReports();
        System.assertEquals('Visit Narrative generated. See Notes and Attachments to view the report.', ext.toastMsg);
        
        
        Test.stopTest(); 
    }
    
    public static testmethod void testGenerateCoverLetterReports() {
        
        Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null, 'My observation'); 
        
        i.Status__c = 'Visit Completed';
        update i;
 
        Test.startTest();
               
        EEC_ReportGeneration_OneExtension ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));  
        
        Test.setCurrentPageReference(new PageReference('EEC_ReportGeneration_One')); 
        System.currentPageReference().getParameters().put('reportType', 'coverletter');
        ext.generateAllReports();
        System.assertEquals('Cover Letter generated. See Notes and Attachments to view the report.', ext.toastMsg);
        
        
        Test.stopTest();  
        
    }  
    
    public static testmethod void testPublishReportOnPortal() {
    
     
    
        Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
         update i;
        
        EEC_ReportGeneration_OneExtension ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));
        
        Test.startTest();
         Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Small Group', null);
      
      Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Small_Group');
        accnt.Config_Record__c = config2.Id;
       accnt.Electronic_Communication__c = true;
        update accnt;
      
        update i;
        ext.publishReportOnPortal();
        
        i.Checklist_Summary_issue_date__c = null;
        i.Visit_Narrative_Issue_Date__c = null; 
         update i;
        ext.publishReportOnPortal();
        
        i.Cover_Letter_Issue_Date__c = null;
        update i;
        ext.publishReportOnPortal();
        
         i.Created_on_the_Web__c = true;
         update i;
        ext.publishReportOnPortal();
        
        
        Test.stopTest();
        System.assertEquals('This provider does not use electronic communication', ext.toastMsg);
    } 
}