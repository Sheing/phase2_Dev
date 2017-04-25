//Author: Latha Davuluri

@isTest
public with sharing class EEC_LEADJobsTest {
    
    static testMethod void testProcessLegacyUnlicndProvBatch()	{
        EEC_Batch_ProcessLegacyUnlicencdProvider bc = new EEC_Batch_ProcessLegacyUnlicencdProvider();
        
        Test.startTest();
           Database.executeBatch(bc, 1);
        Test.stopTest();
    }
    
    static testMethod void testProcessLegacyCasesBatch()	{
        EEC_Batch_ProcessLegacyCases bc = new EEC_Batch_ProcessLegacyCases();
        
        Test.startTest();
           Database.executeBatch(bc, 1);
        Test.stopTest();
    }   
    
    static testMethod void testProcessLegacyIntakeNotesBatch()	{
        EEC_Batch_ProcessLegacyIntakeNotes bc = new EEC_Batch_ProcessLegacyIntakeNotes();
        
        Test.startTest();
           Database.executeBatch(bc, 1);
        Test.stopTest();
    }
    
    static testMethod void testProcessLegacyInvestigationBatch()	{
        EEC_Batch_ProcessLegacyInvestigations bc = new EEC_Batch_ProcessLegacyInvestigations();
        
        Test.startTest();
           Database.executeBatch(bc, 1);
        Test.stopTest();
    }
    
    static testMethod void testProcessLegacyStaffBatch()	{
        EEC_Batch_ProcessLegacyStaff bc = new EEC_Batch_ProcessLegacyStaff();
        
        Test.startTest();
           Database.executeBatch(bc, 1);
        Test.stopTest();
    }
    
    static testMethod void testProcessLegacyFollowBatch()	{
        EEC_Batch_ProcessLegacyFollow bc = new EEC_Batch_ProcessLegacyFollow();
        
        Test.startTest();
           Database.executeBatch(bc, 1);
        Test.stopTest();
    }
    
    static testMethod void testProcessLegacyInterventionsBatch()	{
        EEC_Batch_ProcessLegacyInterventions bc = new EEC_Batch_ProcessLegacyInterventions();
        
        Test.startTest();
           Database.executeBatch(bc, 1);
        Test.stopTest();
    }
    
    static testMethod void processLegacyCasesTest() {  
    	
        City__c c = new City__c();
         c.name ='Bradford';
         c.State__c ='MA';
         insert c;
         
        Account a = new Account();
	 	a.Name = 'Test Account';
	 	a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
	 	a.License_Status__c = 'Licensed';
	 	a.Provider_Status__c = 'Current';
	 	a.Language__c = 'English';
	 	a.Preferred_Language__c = 'English';
	 	a.Provider_Address_1__c = 'street';
	 	a.Provider_City__c = c.id;
	 	a.State__c = 'MA';
	 	a.Provider_Zip_Code__c ='12345';
	 	a.Provider_No__c = '67890';
        a.License_Type__c = 'Regular';
	 	insert a; 
  	 	
        Historical_Cases_Staging__c cs = new Historical_Cases_Staging__c();
        date dt = system.today();
        cs.Program_ID__c = '67890';
    	cs.Date_Closed__c = dt;
		cs.Date_Event_Occurred__c = dt.addDays(-2);
		cs.DCF_File_Submission_Date__c = dt.addDays(-1);
		cs.DCF_File_Submitter__c = '';
		cs.Additional_Description__c = 'Additional Desc';
		cs.Filed_with_DCF__c = 'Yes';
		cs.Nature_of_complaint__c = 'C - Complaint';
		cs.Nature_of_complaint_Description__c = 'Nature of the complaint desc';				
		cs.Intake_Method__c = 'Other';
		cs.Reporter_Relationship_To_Provider__c = 'Neighbor';
	    cs.Reporter_Data_Entry__c = dt.addDays(-3);
		cs.Reporter_ID__c = '';
		cs.Reporter_First_Name__c = 'reporter fname';
		cs.Reporter_Last_Name__c = 'reporter lname';
		cs.Reporter_Street__c = 'test street';
        cs.Reporter_City__c = c.id;
        cs.Reporter_State__c = 'MA';
        cs.Reporter_ZipCode__c = '23456';
		cs.Reporter_Home_Phone__c = '444-5555-9999';
		cs.Reporter_Work_Phone__c = '333-444-7777';
		cs.Allegation_Code__c = 'C.15';
		cs.Allegation_Description__c = 'Allegation desc';
          
        system.debug('****Result***:'+ cs);        
        
        insert cs;
        
        Historical_Intake_Notes_Staging__c ns = new Historical_Intake_Notes_Staging__c();
	 	 ns.Notes_Date__c = string.valueOf(system.today());
		 ns.Notes_CreatedBy__c = 'abcd';
		 ns.Notes__c = 'test notes';
		 ns.Notes_Id__c = '123';
		 ns.Program_Id__c = '67890';
		 ns.intake_Id__c = '1234';
		 insert ns;
        
        EEC_LEADJobsController controller = new EEC_LEADJobsController();        
        controller.processLegacyCases();
        controller.processLegacyIntakeNotes();
        
        Historical_Cases_Staging__c result = [Select Id, Case_Processed__c From Historical_Cases_Staging__c Where id = :cs.Id];  
        
        system.debug('****Result2***:'+ result);  
          
        system.assert(result != null);
     }
     
     
     static testMethod void processLegacyUnlicensedProvidersTest() {  
    	
	        City__c c = new City__c();
	        c.name ='Bradford';
	        c.State__c ='MA';
  
	        insert c;
	 	
	        Historical_Unlicen_Providers_Staging__c ps = new Historical_Unlicen_Providers_Staging__c();
	        ps.Unlicensed_Name__c = 'Test Provider';
			ps.Unlicensed_Address1__c = 'street 123';
			ps.Unlicensed_City__c ='Bradford';
			ps.Unlicensed_ZipCode__c ='12345';
			ps.Unlicensed_Phone__c = '1112223333';
			ps.Unlicensed_ID__c = '123456';
			ps.Unlicensed_Licensor__c ='abcd';
            ps.Unlicensed_Licensor_Name__c = 'Licensor Name';
       
	        insert ps;
	                
	        EEC_LEADJobsController controller = new EEC_LEADJobsController();        
	        controller.processLegacyUnlicensedProviders();
	        
	        Historical_Unlicen_Providers_Staging__c result = [Select Id, Provider_Processed__c From Historical_Unlicen_Providers_Staging__c Where id = :ps.Id];  
	        
	        system.debug('****Result2***:'+ result);  
	          
	        system.assert(result != null);
     }
     
     static testMethod void processLegacyIntakeNotesTest(){
           City__c c = new City__c();
         c.name ='Bradford';
         c.State__c ='MA';
         insert c;
         
        Account a = new Account();
	 	a.Name = 'Test Account';
	 	a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
	 	a.License_Status__c = 'Licensed';
	 	a.Provider_Status__c = 'Current';
	 	a.Language__c = 'English';
	 	a.Preferred_Language__c = 'English';
	 	a.Provider_Address_1__c = 'street';
	 	a.Provider_City__c = c.id;
	 	a.State__c = 'MA';
	 	a.Provider_Zip_Code__c ='12345';
	 	a.Provider_No__c = '67890';
        a.License_Type__c = 'Regular';
	 	insert a; 
         
         Case lc = new Case();
         lc.Duplicate_Rule_1__c = '1234|67890';
         lc.recordTypeId = [Select Id,name From RecordType where sObjectType='Case' and name like 'Legacy Case'].Id;
         lc.origin = 'Other';
         lc.accountId = a.Id;
         lc.Relationship_to_provider__c = 'neighbor';
         lc.Priority = 'Regulatory Compliance Issue';
         insert lc;
     	
         Historical_Intake_Notes_Staging__c ns = new Historical_Intake_Notes_Staging__c();
	 	 ns.Notes_Date__c = string.valueOf(system.today());
		 ns.Notes_CreatedBy__c = 'abcd';
		 ns.Notes__c = 'test notes';
		 ns.Notes_Id__c = '123';
		 ns.Program_Id__c = '67890';
		 ns.intake_Id__c = '1234';
		 insert ns;
        
        EEC_LEADJobsController controller = new EEC_LEADJobsController();        
        controller.processLegacyIntakeNotes();
     }
     
     static testMethod void processLegacyInvestigationsTest(){
     	
     	Intervention_Type__c It = new Intervention_Type__c();
     	It.name = 'Collateral Contacts';
     	insert It;
     	
     	City__c c = new City__c();
         c.name ='Bradford';
         c.State__c ='MA';
         insert c;
         
     	Account a = new Account();
	 	a.Name = 'Test Account';
	 	a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
	 	a.License_Status__c = 'Licensed';
	 	a.Provider_Status__c = 'Current';
	 	a.Language__c = 'English';
	 	a.Preferred_Language__c = 'English';
	 	a.Provider_Address_1__c = 'street';
	 	a.Provider_City__c = c.id;
	 	a.State__c = 'MA';
	 	a.Provider_Zip_Code__c ='12345';
	 	a.Provider_No__c = '67890';
        a.License_Type__c = 'Regular';
	 	insert a; 
	 	
     	Investigation__c Inv = new Investigation__c();
     	Inv.Investigation_Type__c = 'High Risk';
     	Inv.Legacy_IntakeID__c = '332';
     	Inv.Provider_No__c = a.id;
     	insert Inv;
     	
     	Historical_Investigation_Staging__c Hi = new Historical_Investigation_Staging__c();
     	Hi.Intake_Id__c = '332';
     	Hi.Program_Id__c = '67890';  
     	insert Hi;
     	
     	EEC_LEADJobsController controller = new EEC_LEADJobsController();        
	        controller.processLegacyInvestigations();
	        
     	Historical_Investigation_Staging__c result = [Select Id,name From Historical_Investigation_Staging__c Where id = :Hi.Id];  
	        
	        system.debug('****Result***:'+ result);  
	          
	        system.assert(result != null);   
     }
     
     static testMethod void processLegacyStaffTest(){
     	
     	City__c c = new City__c();
         c.name ='Bradford';
         c.State__c ='MA';
         insert c;
         
     	Account a = new Account();
	 	a.Name = 'Test Account';
	 	a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
	 	a.License_Status__c = 'Licensed';
	 	a.Provider_Status__c = 'Current';
	 	a.Language__c = 'English';
	 	a.Preferred_Language__c = 'English';
	 	a.Provider_Address_1__c = 'street';
	 	a.Provider_City__c = c.id;
	 	a.State__c = 'MA';
	 	a.Provider_Zip_Code__c ='12345';
	 	a.Provider_No__c = '67890';
        a.License_Type__c = 'Regular';
	 	insert a; 
	 	
     	Investigation__c Inv = new Investigation__c();
     	Inv.Investigation_Type__c = 'High Risk';
     	Inv.Legacy_IntakeID__c = '332';
     	Inv.Provider_No__c = a.id;
     	insert Inv;
     	
     	Historical_Staff_Staging__c Hs = new Historical_Staff_Staging__c();
     	Hs.Intake_Id__c = '332';
     	Hs.Program_Id__c = '67890';
     	insert Hs;
     	
     	EEC_LEADJobsController controller = new EEC_LEADJobsController();        
	        controller.processLegacyStaff();
     
     }
     
     static testMethod void processLegacyInterventionTest(){
     	
     	City__c c = new City__c();
         c.name ='Bradford';
         c.State__c ='MA';
         insert c;
         
     	Account a = new Account();
	 	a.Name = 'Test Account';
	 	a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
	 	a.License_Status__c = 'Licensed';
	 	a.Provider_Status__c = 'Current';
	 	a.Language__c = 'English';
	 	a.Preferred_Language__c = 'English';
	 	a.Provider_Address_1__c = 'street';
	 	a.Provider_City__c = c.id;
	 	a.State__c = 'MA';
	 	a.Provider_Zip_Code__c ='12345';
	 	a.Provider_No__c = '67890';
        a.License_Type__c = 'Regular';
	 	insert a; 
	 	
     	Investigation__c Inv = new Investigation__c();
     	Inv.Investigation_Type__c = 'High Risk';
     	Inv.Legacy_IntakeID__c = '332';
     	Inv.Provider_No__c = a.id;
     	insert Inv;
        
        Historical_Intervention_Staging__c Is = new Historical_Intervention_Staging__c();
        Is.Intake_Id__c = '332';
        Is.Program_Id__c = '67890';
        insert Is;
        
        EEC_LEADJobsController controller = new EEC_LEADJobsController();        
	        controller.processLegacyIntervention();
        
     }
     
     static testMethod void processLegacyFollowTest(){
     	
     	City__c c = new City__c();
         c.name ='Bradford';
         c.State__c ='MA';
         insert c;
         
     	Account a = new Account();
	 	a.Name = 'Test Account';
	 	a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
	 	a.License_Status__c = 'Licensed';
	 	a.Provider_Status__c = 'Current';
	 	a.Language__c = 'English';
	 	a.Preferred_Language__c = 'English';
	 	a.Provider_Address_1__c = 'street';
	 	a.Provider_City__c = c.id;
	 	a.State__c = 'MA';
	 	a.Provider_Zip_Code__c ='12345';
	 	a.Provider_No__c = '67890';
        a.License_Type__c = 'Regular';
	 	insert a; 
	 	
     	Investigation__c Inv = new Investigation__c();
     	Inv.Investigation_Type__c = 'High Risk';
     	Inv.Legacy_IntakeID__c = '332';
     	Inv.Provider_No__c = a.id;
     	insert Inv;
        
        Historical_Follow_Staging__c Hf = new Historical_Follow_Staging__c();
        Hf.Intake_Id__c = '332';
        Hf.Program_Id__c = '67890';
        insert Hf;
        
        EEC_LEADJobsController controller = new EEC_LEADJobsController();        
	        controller.processLegacyFollow();
        
     }
    static testMethod void testLegacyVisitsBatch()  {         
        EEC_Batch_ProcessLegacyVisits bc = new EEC_Batch_ProcessLegacyVisits();
        
        Test.startTest();
        Database.executeBatch(bc, 1);
        Test.stopTest();
    }
    
    static testMethod void testLegacyVisitItemsBatch()  {
        City__c c = new City__c();
        c.name ='Bradford';
        c.State__c ='MA';
        insert c;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
        a.License_Status__c = 'Licensed';
        a.Provider_Status__c = 'Current';
        a.Language__c = 'English';
        a.Preferred_Language__c = 'English';
        a.Provider_Address_1__c = 'street';
        a.Provider_City__c = c.id;
        a.State__c = 'MA';
        a.Provider_Zip_Code__c ='12345';
        a.Provider_No__c = '67890';
        insert a; 
        
        List<EEC_HistoricalVisitItemStaging__c > listVisitItem = new List<EEC_HistoricalVisitItemStaging__c>();
        for(integer i=0;i<10;i++){
            EEC_HistoricalVisitItemStaging__c hvi = new EEC_HistoricalVisitItemStaging__c();
            hvi.EEC_VisitDetailId__c  = '12345';
            hvi.EEC_VisitHeaderId__c  = '67890';
            hvi.EEC_Comment__c = 'Test Comment';
            hvi.EEC_ComplianceStatusDesc__c  = 'Compliance';
            hvi.EEC_VisitItem_Processed__c = false;
            hvi.EEC_Hostname__c = 'EEC-TAB065';
            hvi.EEC_RegGroupItem__c = '7.11(07)';            
            hvi.EEC_RegGroupItemDesc__c = 'Emergency Preparedness';    
            listVisitItem.add(hvi);
        }
        insert listVisitItem;
        
        EEC_Batch_ProcessLegacyVisitItems bc = new EEC_Batch_ProcessLegacyVisitItems();
        
        Test.startTest();
        Database.executeBatch(bc);
        Test.stopTest();
    }
    
    static testMethod void testLegacyNonCompVisitsBatch()   {
        EEC_Batch_ProcessLegacyNonCompVisits bc = new EEC_Batch_ProcessLegacyNonCompVisits();
        
        
        Test.startTest();
        Database.executeBatch(bc,1);
        Test.stopTest();
    }
    
    static testMethod void testLegacyNonCompVisitItemsBatch()   {
        EEC_Batch_ProcessLegacyNonCompVisitItems bc = new EEC_Batch_ProcessLegacyNonCompVisitItems();
        
        Test.startTest();
        Database.executeBatch(bc, 1);
        Test.stopTest();
    }
    
     
    
    static testMethod void processLegacyVisitsTest() {  
        
        Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Family Child Care', null);
        
        Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'FCC');
        accnt.Config_Record__c = config2.Id;
        accnt.Provider_No__c = 'test'; 
        accnt.AccountRecord_Type_Hidden__c= 'hidden';
        
        update accnt;
        
        EEC_HistoricalVisitStaging__c hv = new EEC_HistoricalVisitStaging__c();
        hv.EEC_VisitId__c = '12345';
        hv.EEC_ProgramId__c = 'test';        
        hv.EEC_LeadReasonOfVisit__c = 'Renewal';
        hv.EEC_Comment__c = 'Test Comment';
        hv.EEC_VisitDate__c = system.today();
        hv.EEC_ComplianceCodeDesc__c = 'Compliance';
        hv.EEC_Visit_Processed__c = false;
        
        system.debug('****Result***:'+ hv);        
        
        insert hv;
        
        Inspection__c  it = EEC_TestUtil.mockInspection(accnt);
        //Inspection__c it = EEC_TestUtil.loadInspectionSetup(); 
        Test.startTest();
        it.Legacy_FCC_LM_Mobile_Visit__c = 'test1|test2'; 
        update it;
        Investigation__c inv = EEC_TestUtil.mockInvestigation(accnt);
        inv.Legacy_FCC_LM_Mobile_Investigation__c ='12|35|4';
        update inv; 
        Non_Compliant__c  ncc  = EEC_TestUtil.mockNonCompliant(inv);  
        ncc.Require_Portal_Feedback__c = false;
        ncc.To_Review_on_Portal__c = false;
        ncc.Correction_Plan_Status__c = 'Legacy Non-compliance';  
        update ncc;     

        EEC_HistoricalVisitItemStaging__c hs = new EEC_HistoricalVisitItemStaging__c();
        hs.EEC_VisitHeaderId__c  = 'test1';
        hs.EEC_Hostname__c = 'test2';
        hs.EEC_RegGroupItem__c = '7.07(07)(h)';
        
        hs.EEC_ComplianceStatusDesc__c ='Compliance';
        
        hs.EEC_ComplianceStatusDesc__c ='Non-compliance';
        hs.EEC_ComplianceStatusDesc__c ='Discussion';
        insert hs;
        
        EEC_HistoryOfNonComplianceStaging__c ncs = new EEC_HistoryOfNonComplianceStaging__c();
        ncs.ProgramId__c ='test';
        ncs.InteractionTypeDesc__c ='|4';
        ncs.InteractionId__c ='3';
        ncs.InteractionDate__c = system.today();  
        ncs.Citation__c = 'hello';
        ncs.Observations__c = 'Test';
        ncs.Visit_Processed__c = false;
        insert ncs;
        
        Regulation__c   reg = EEC_TestUtil.mockRegulation(); 
        reg.Name = 'hello';
        update reg;
        
        Non_Compliant_Item_Regulation__c noncom = EEC_TestUtil.mockNonCompliantItemRegulation(ncc,reg);
        
        Inspection_Item__c inspectitm = EEC_TestUtil.mockInspectionItem(it, reg, 'Compliant', true, 'technicalAssistance');
        update inspectitm; 
        
        //EEC_ProcessLegacyVisitData.processLegacyInvestigationAddionalNonComplianceItems(ncs);
        EEC_ProcessLegacyVisitData.processLegacyInvestigations(ncs);            
        
        Test.stopTest();
    }
    
     
    
    static testMethod void processLegacyVisitTest() {
        Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Family Child Care', null);
        
        Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'FCC');
        accnt.Config_Record__c = config2.Id;
        accnt.Provider_No__c = 'test';        
        
        update accnt;
        
        EEC_HistoricalVisitStaging__c hv = new EEC_HistoricalVisitStaging__c();
        hv.EEC_VisitId__c = '12345';
        hv.EEC_ProgramId__c = 'test';        
        hv.EEC_LeadReasonOfVisit__c = 'Renewal';
        hv.EEC_Comment__c = 'Test Comment';
        hv.EEC_VisitDate__c = system.today();
        hv.EEC_ComplianceCodeDesc__c = 'Compliance';
        hv.EEC_Visit_Processed__c = false;
        
        system.debug('****Result***:'+ hv);        
        
        insert hv;
        
        Inspection__c  it = EEC_TestUtil.mockInspection(accnt);
       
        Test.startTest();
       
        Investigation__c inv = EEC_TestUtil.mockInvestigation(accnt);
        Non_Compliant__c  ncc  = EEC_TestUtil.mockNonCompliant(inv);  
        ncc.Require_Portal_Feedback__c = false;
        ncc.To_Review_on_Portal__c = false;
        ncc.Correction_Plan_Status__c = 'Legacy Non-compliance';  
        update ncc;     
		
        Regulation__c   reg = EEC_TestUtil.mockRegulation();    
        reg.Applicable_To__c ='Family Child Care';
        reg.Name = '7.07(07)(g)';
        update reg;
        
        Inspection_Item__c inspectitm = EEC_TestUtil.mockInspectionItem(it, reg, 'Compliant', true, 'technicalAssistance');
        update inspectitm; 
        
        EEC_HistoricalVisitItemStaging__c hs = new EEC_HistoricalVisitItemStaging__c();
        hs.EEC_VisitHeaderId__c  = 'test1';
        hs.EEC_Hostname__c = 'test2';
        hs.EEC_RegGroupItem__c = '7.07(07)(h)';
        hs.EEC_RegGroupItem__c = '7.07(07)(g);7.07(07)(h)';
        hs.EEC_ComplianceStatusDesc__c ='Compliance';
        hs.EEC_ComplianceStatusDesc__c ='Non-compliance';
        hs.EEC_ComplianceStatusDesc__c ='Discussion';
        hs.EEC_VisitHeaderId__c ='sam';
        hs.EEC_Hostname__c ='sf';
        hs.EEC_VisitDetailId__c = 'visit';
        hs.EEC_Comment__c ='demo';
        inspectitm.Inspection_Result__c = hs.EEC_ComplianceStatusDesc__c;
        insert hs;
        
        EEC_HistoricalVisitSubItemStaging__c visitsubitem = new EEC_HistoricalVisitSubItemStaging__c();
        visitsubitem.EEC_Hostname__c ='sf';
        visitsubitem.EEC_VisitDetailId__c ='visit';
        visitsubitem.EEC_VisitHeaderId__c ='sam';
        visitsubitem.EEC_DisplayText__c = 'temp';
        visitsubitem.EEC_SubItemVal__c ='saleforce';
        visitsubitem.EEC_Visit_SubItem_Processed__c = false;
        insert visitsubitem;
        
        EEC_HistoryOfNonComplianceStaging__c ncs = new EEC_HistoryOfNonComplianceStaging__c();
        ncs.ProgramId__c ='test';
        ncs.InteractionTypeDesc__c ='desc';
        ncs.InteractionId__c ='inter';
        ncs.InteractionDate__c = system.today();  
        ncs.Citation__c = 'hello'; 
        ncs.Observations__c = 'Test';        
        insert ncs; 
           
        Non_Compliant_Item_Regulation__c noncom = EEC_TestUtil.mockNonCompliantItemRegulation(ncc,reg);
        
        
        EEC_ProcessLegacyVisitData.processLegacyVisits(hv);
        //EEC_ProcessLegacyVisitData.processLegacyVisitItems(hs);
       
        /*EEC_Batch_ProcessLegacyVisits bc = new EEC_Batch_ProcessLegacyVisits();
        Database.executeBatch(bc, 1);*/
        
        Test.stopTest();
    }
    
    static testMethod void processvisititem(){
         
        
        Lead_Configuration__c config = EEC_TestUtil.mockLeadConfig('Family Child Care', null);
        
        Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'FCC');
        acc.Config_Record__c = config.Id;
        acc.Provider_No__c = 'test';        
        
        update acc;
        
         Inspection__c  it = EEC_TestUtil.mockInspection(acc);
        
         test.startTest();
        
        Regulation__c re = new Regulation__c();
        re.Name = 'hello';
        re.Applicable_To__c ='Family Child Care; Large Group;';
        re.Date_Active__c = system.today() - 100;
        insert re;
        
        
        
        
        EEC_HistoricalVisitItemStaging__c hvs = new EEC_HistoricalVisitItemStaging__c();
        hvs.EEC_VisitHeaderId__c  = 'test1|';
        hvs.EEC_Hostname__c = 'test2|';
        hvs.EEC_VisitDetailId__c ='test3';
        hvs.EEC_RegGroupItem__c = '7.07(07)(h);7.07(07)(h)';        
        hvs.EEC_ComplianceStatusDesc__c ='Compliance';        
        hvs.EEC_ComplianceStatusDesc__c ='Non-compliance';
        hvs.EEC_ComplianceStatusDesc__c ='Discussion';
        insert hvs;
        
        EEC_HistoricalVisitSubItemStaging__c hvsb = new EEC_HistoricalVisitSubItemStaging__c();
        hvsb.EEC_VisitHeaderId__c  = 'test1|';
        hvsb.EEC_Hostname__c = 'test2|';
        hvsb.EEC_VisitDetailId__c ='test3';
        hvsb.EEC_Visit_SubItem_Processed__c = false;
        insert hvsb;
        
        EEC_ProcessLegacyVisitData.processLegacyVisitItems(hvs);
        test.stopTest();
    }
    
    static testMethod void processAdditionalnonCompliance(){
        
        Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Family Child Care', null);
        
        Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'FCC');
        accnt.Config_Record__c = config2.Id;
        accnt.Provider_No__c = 'test';   
        update accnt;
		
		Investigation__c inv = EEC_TestUtil.mockInvestigation(accnt);
        Non_Compliant__c  ncc  = EEC_TestUtil.mockNonCompliant(inv);  
        ncc.Require_Portal_Feedback__c = false;
        ncc.To_Review_on_Portal__c = false; 
        ncc.Correction_Plan_Status__c = 'Legacy Non-compliance';  
        update ncc;          
        
        test.startTest();
        Regulation__c reg = new Regulation__c();
        reg.Name = 'hello';
        reg.Applicable_To__c ='Family Child Care; Large Group;';
        reg.Date_Active__c = system.today() - 100;
        insert reg;
        
        
        EEC_HistoryOfNonComplianceStaging__c nc = new EEC_HistoryOfNonComplianceStaging__c();
        nc.ProgramId__c ='test';
        nc.InteractionTypeDesc__c ='desc'; 
        nc.InteractionId__c ='inter';
        nc.InteractionDate__c = system.today();  
        nc.Citation__c = 'hello'; 
        nc.Observations__c = 'Test';        
        insert nc; 
        
        EEC_ProcessLegacyVisitData.processLegacyInvestigationAddionalNonComplianceItems(nc);
        test.stopTest();
    }
    
    static testMethod void processLegacyVisitsTestError() {  
        
        City__c c = new City__c();
        c.name ='Bradford';
        c.State__c ='MA';
        insert c;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
        a.License_Status__c = 'Licensed';
        a.Provider_Status__c = 'Current';
        a.Language__c = 'English';
        a.Preferred_Language__c = 'English';
        a.Provider_Address_1__c = 'street';
        a.Provider_City__c = c.id;
        a.State__c = 'MA';
        a.Provider_Zip_Code__c ='12345';
        a.Provider_No__c = '67899';
        insert a; 
        
        EEC_HistoricalVisitStaging__c hv = new EEC_HistoricalVisitStaging__c();
        hv.EEC_VisitId__c = '12345';
        hv.EEC_ProgramId__c = '67890';
        hv.EEC_LeadReasonOfVisit__c = 'Renewal';
        hv.EEC_Comment__c = 'Test Comment';
        hv.EEC_VisitDate__c = system.today();
        hv.EEC_ComplianceCodeDesc__c = 'Compliance';
        hv.EEC_Visit_Processed__c = false;
        
        system.debug('****Result***:'+ hv);        
        
        insert hv;
        
        Test.startTest();
        EEC_Batch_ProcessLegacyVisits bc = new EEC_Batch_ProcessLegacyVisits();
        Database.executeBatch(bc, 1);
        Test.stopTest();
        
        EEC_HistoricalVisitStaging__c result = [Select Id, EEC_ErrorText__c, EEC_VisitId__c,EEC_Visit_Processed__c From EEC_HistoricalVisitStaging__c Where id = :hv.Id];  
        
        system.debug('****Result2***:'+ result);  
        
        system.assert(result.EEC_Visit_Processed__c == false);
        system.assert(result.EEC_ErrorText__c.contains('Provider Not Found in LEAD'));  
    }  
    
    static testMethod void leadJobsControllerTest() {  
        
        City__c c = new City__c();
        c.name ='Bradford';
        c.State__c ='MA';
        insert c;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
        a.License_Status__c = 'Licensed';
        a.Provider_Status__c = 'Current';
        a.Language__c = 'English';
        a.Preferred_Language__c = 'English';
        a.Provider_Address_1__c = 'street';
        a.Provider_City__c = c.id;
        a.State__c = 'MA';
        a.Provider_Zip_Code__c ='12345';
        a.Provider_No__c = '67890';
        insert a; 
        
        EEC_HistoryOfNonComplianceStaging__c hsf = new EEC_HistoryOfNonComplianceStaging__c();
        hsf.Citation__c = 'Notnull';
        insert hsf;
        
        EEC_HistoricalVisitStaging__c hv = new EEC_HistoricalVisitStaging__c();
        hv.EEC_VisitId__c = '12345';
        hv.EEC_ProgramId__c = a.id;
        hv.EEC_LeadReasonOfVisit__c = 'Renewal';
        hv.EEC_Comment__c = 'Test Comment';
        hv.EEC_VisitDate__c = system.today();
        hv.EEC_ComplianceCodeDesc__c = 'Compliance';
        hv.EEC_Visit_Processed__c = false;
        
        system.debug('****Result***:'+ hv);        
        
        insert hv;
        hv.EEC_Visit_Processed__c = true;
        update hv;
        test.startTest();        
        EEC_LEADJobsController controller = new EEC_LEADJobsController();
        
        controller.processLegacyVisits();
        controller.processLegacyVisitItems();
        controller.processLegacyNonComplianceVisits();
        controller.processLegacyNonComplianceVisitItems();
        controller.deleteAllLegacyVisits();
        controller.deleteAllLegacyInvestigations();
        test.stopTest();
        EEC_HistoricalVisitStaging__c result = [Select Id, EEC_VisitId__c,EEC_Visit_Processed__c From EEC_HistoricalVisitStaging__c Where id = :hv.Id];  
        
        system.debug('****Result2***:'+ result);  
        
        system.assert(result != null);
    }
    
    static testMethod void processBatchLegacyCompVisitItems(){
        City__c c = new City__c();
        c.name ='Bradford';
        c.State__c ='MA';
        insert c;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
        a.License_Status__c = 'Licensed';
        a.Provider_Status__c = 'Current';
        a.Language__c = 'English';
        a.Preferred_Language__c = 'English';
        a.Provider_Address_1__c = 'street';
        a.Provider_City__c = c.id;
        a.State__c = 'MA';
        a.Provider_Zip_Code__c ='12345';
        a.Provider_No__c = '67890';
        insert a; 
        
        List<EEC_HistoryOfNonComplianceStaging__c> listNonComp = new List<EEC_HistoryOfNonComplianceStaging__c>();
        for(integer i = 0; i<10;i++){            
            EEC_HistoryOfNonComplianceStaging__c hv = new EEC_HistoryOfNonComplianceStaging__c();
            hv.CorrectionPlan__c = 'Test';
            hv.VisitItem_Processed__c = false;
            hv.Visit_Processed__c = true;
            hv.ProgramId__c ='67890';
            hv.InteractionTypeDesc__c ='demo';
            hv.InteractionId__c ='test';
            listNonComp.add(hv);              
        }
        insert listNonComp;
        
        test.startTest();
        EEC_Batch_ProcessLegacyNonCompVisitItems bc = new EEC_Batch_ProcessLegacyNonCompVisitItems();
        Database.executeBatch(bc);
        
        test.stopTest();
    }
    ///////
    static testMethod void processLegacyInvestigations(){
        City__c c = new City__c();
        c.name ='Bradford';
        c.State__c ='MA';
        insert c;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
        a.License_Status__c = 'Licensed';
        a.Provider_Status__c = 'Current';
        a.Language__c = 'English';
        a.Preferred_Language__c = 'English';
        a.Provider_Address_1__c = 'street';
        a.Provider_City__c = c.id;
        a.State__c = 'MA';
        a.Provider_Zip_Code__c ='12345';
        a.Provider_No__c = '67890';
        insert a; 
        
        List<EEC_HistoryOfNonComplianceStaging__c> listNonComp = new List<EEC_HistoryOfNonComplianceStaging__c>();
        for(integer i = 0; i<10;i++){            
            EEC_HistoryOfNonComplianceStaging__c hv = new EEC_HistoryOfNonComplianceStaging__c();
            hv.CorrectionPlan__c = 'Test';
            hv.VisitItem_Processed__c = false;
            hv.Visit_Processed__c = true;
            listNonComp.add(hv);              
        }
        insert listNonComp;
        
        test.startTest();
        EEC_Batch_ProcessLegacyNonCompVisitItems bc = new EEC_Batch_ProcessLegacyNonCompVisitItems();
        Database.executeBatch(bc);
        
        test.stopTest();
    }
    ///////
    
    static testMethod void processBatchLegacyCompVisit(){
        City__c c = new City__c();
        c.name ='Bradford';
        c.State__c ='MA';
        insert c;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
        a.License_Status__c = 'Licensed';
        a.Provider_Status__c = 'Current';
        a.Language__c = 'English';
        a.Preferred_Language__c = 'English';
        a.Provider_Address_1__c = 'street';
        a.Provider_City__c = c.id;
        a.State__c = 'MA';
        a.Provider_Zip_Code__c ='12345';
        a.Provider_No__c = '67890';
        insert a; 
        
        List<EEC_HistoryOfNonComplianceStaging__c> listNonComp = new List<EEC_HistoryOfNonComplianceStaging__c>();
        for(integer i = 0; i<10;i++){            
            EEC_HistoryOfNonComplianceStaging__c hv = new EEC_HistoryOfNonComplianceStaging__c();
            hv.CorrectionPlan__c = 'Test';
            hv.VisitItem_Processed__c = false;
            hv.ProgramId__c ='67890';
            listNonComp.add(hv);              
        }
        insert listNonComp;
        
        
        test.startTest();        
        EEC_Batch_ProcessLegacyNonCompVisits bc1 = new EEC_Batch_ProcessLegacyNonCompVisits();
        Database.executeBatch(bc1);
        test.stopTest();
    }
    
    
    
    
    static testMethod void processLegacyVisitItemsTest() {  
        
        City__c c = new City__c();
        c.name ='Bradford';
        c.State__c ='MA';
        insert c;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
        a.License_Status__c = 'Licensed';
        a.Provider_Status__c = 'Current';
        a.Language__c = 'English';
        a.Preferred_Language__c = 'English';
        a.Provider_Address_1__c = 'street';
        a.Provider_City__c = c.id;
        a.State__c = 'MA';
        a.Provider_Zip_Code__c ='12345';
        a.Provider_No__c = '67890';
        insert a; 
        
        RecordType rt = [select Id from RecordType where Name = 'Legacy System Import Visit / Non Compliance' and sObjectType = 'Inspection__c' limit 1];
        List<Inspection__c> listInspection = new List<Inspection__c>();
        for(integer i=0;i<10;i++){
            Inspection__c legacyVisit = new Inspection__c();
            legacyVisit.Provider_No__c = a.id;
            legacyVisit.Comments__c = 'Test Comment';
            legacyVisit.Date_of_Visit__c = system.today() - 1;
            legacyVisit.Legacy_FCC_LM_Mobile_Visit__c = '67890|EEC-TAB065';
            legacyVisit.Status__c = 'Closed';
            legacyVisit.RecordTypeId = rt.Id;
            listInspection.add(legacyVisit);
        }
        insert listInspection ;
        
        List<EEC_HistoricalVisitItemStaging__c > listVisitItem = new List<EEC_HistoricalVisitItemStaging__c>();
        for(integer i=0;i<10;i++){
            EEC_HistoricalVisitItemStaging__c hvi = new EEC_HistoricalVisitItemStaging__c();
            hvi.EEC_VisitDetailId__c  = '12345';
            hvi.EEC_VisitHeaderId__c  = '67890';
            hvi.EEC_Comment__c = 'Test Comment';
            hvi.EEC_ComplianceStatusDesc__c  = 'Compliance';
            hvi.EEC_VisitItem_Processed__c = false;
            hvi.EEC_Hostname__c = 'EEC-TAB065';
            hvi.EEC_RegGroupItem__c = '7.11(07)';
            hvi.EEC_RegGroupItemDesc__c = 'Emergency Preparedness';            
            listVisitItem.add(hvi);
        }
        insert listVisitItem;
        
        List<EEC_HistoricalVisitSubItemStaging__c > listVisitSubItem = new List<EEC_HistoricalVisitSubItemStaging__c>();
        
        for(integer i=0;i<10;i++){
            EEC_HistoricalVisitSubItemStaging__c subItem = new EEC_HistoricalVisitSubItemStaging__c ();
            subItem.EEC_DisplayText__c  = 'Test display';
           
            subItem.EEC_SubItemVal__c = '5';
            subItem.EEC_Visit_SubItem_Processed__c = false;
            subItem.EEC_VisitSubItemId__c = '1';
            subItem.EEC_VisitDetailId__c  = '12345';
            subItem.EEC_VisitHeaderId__c  = '67890';
            subItem.EEC_Hostname__c = 'EEC-TAB065';
            listVisitSubItem.add(subItem);
        }
        insert listVisitSubItem;
        
        List<EEC_HistoricalVisitStaging__c> listVisit = new List<EEC_HistoricalVisitStaging__c>();
        for(integer i = 0; i<10;i++){            
            EEC_HistoricalVisitStaging__c hv = new EEC_HistoricalVisitStaging__c();
            hv.EEC_VisitId__c = '12345';
            hv.EEC_ProgramId__c = a.id;
            hv.EEC_LeadReasonOfVisit__c = 'Renewal';
            hv.EEC_Comment__c = 'Test Comment';
            hv.EEC_VisitDate__c = system.today();
            hv.EEC_ComplianceCodeDesc__c = 'Compliance';
            hv.EEC_Visit_Processed__c = false;            
            listVisit.add(hv);              
        }
        insert listVisit;
        
        
        List<EEC_HistoryOfNonComplianceStaging__c> listNonComp = new List<EEC_HistoryOfNonComplianceStaging__c>();
        for(integer i = 0; i<10;i++){            
            EEC_HistoryOfNonComplianceStaging__c hv = new EEC_HistoryOfNonComplianceStaging__c();
            hv.CorrectionPlan__c = 'Test';
            hv.VisitItem_Processed__c = false;
            hv.Visit_Processed__c = true;
            listNonComp.add(hv);              
        }
        insert listNonComp;
        
        Regulation__c reg = new Regulation__c();
        reg.Name = '7.11(07)';
        reg.Applicable_To__c ='Family Child Care; Large Group;';
        reg.Date_Active__c = system.today() - 100;
        insert reg;
        
        Investigation__c investigation = EEC_TestUtil.mockInvestigation(a);
        Test.startTest();
        investigation.isLegacyInvestigation__c = true;
        update investigation; 
        
        EEC_LEADJobsController controller = new EEC_LEADJobsController();
        controller.clearAllStagingRecords();
        controller.clearAllStagingRecords();
        controller.clearAllStagingRecords();
        controller.clearAllStagingRecords();
        controller.deleteAllLegacyInvestigations();   
        controller.deleteAllLegacyVisits();
        controller.processLegacyVisitItems();
        //controller.processLegacyVisits();
        Test.stopTest();
    }


}