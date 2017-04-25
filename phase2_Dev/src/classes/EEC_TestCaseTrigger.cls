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
private class EEC_TestCaseTrigger {
    
    static testMethod void myUnitTest() {
      Account mockProvider = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
            Investigation__c i = EEC_TestUtil.mockInvestigation(mockProvider);
            Case c = EEC_TestUtil.mockCase(mockProvider, EEC_TestUtil.mockContact(), i);
            c.SendCaseTriageEmail__c = 'Recalled';
            c.TriggerTriageEscalationApproval__C = true;
            update c;
            c.SendCaseTriageEmail__c = 'Approved';
            update c;
            c.SendCaseTriageEmail__c = 'Rejected';   
            update c;
}
    
    static testMethod void testCaseTriggerHandlerEmail() {
        Test.startTest();
        EEC_CaseTriggerHandler.sendIEmail('test@test.com', 'Test', UserInfo.getUserId(), 'TestCaseEmail', 'investId', 'TestSubject', 'AccountName');
        Test.stopTest();
    }
   
    @isTest
    public static void testIncidentSubmissionForOutOfOffice() {
        Test.startTest();
        Account acc = EEC_TestUtil.mockUnlicensedProvider(EEC_TestUtil.mockCity(),null,null);
      
        
        Account accnt = [SELECT ID,OwnerId FROM Account WHERE RecordType.DeveloperName = 'FCC' AND Provider_Address_1__c != null LIMIT 1];
        
        
        Contact con = EEC_TestUtil.mockDirectorContact(accnt);  
        Case c = EEC_TestUtil.mockWebCase(accnt, con);
        Test.stopTest();  
    }
    
    @isTest
    public static void testcheckProviderEditAccess() {
        Account acc = EEC_TestUtil.mockUnlicensedProvider(EEC_TestUtil.mockCity(),null,null);
        Contact con = EEC_TestUtil.mockDirectorContact(acc);  
       
        Case c = EEC_TestUtil.mockWebCase(acc, con);
        EEC_CaseTriggerHandler.FirstRun = null;
        c.Status ='In Triage';
       // c.Out_Of_Office_Initial_Recipient_ID__c = 'test';
        update c; 
        
        c = [SELECT ID, Status,X1st_Escalation_Case_Approver_Completed__c,Investigation__c FROM Case WHERE Status = 'In Triage' AND X1st_Escalation_Case_Approver__c != null AND X2nd_Escalation_Case_Approver__c != null LIMIT 1];
        update c;
        Test.startTest();
        c.Status = 'Escalated';
        c.SendCaseTriageEmail__c = 'Recalled';
        
        EEC_CaseTriggerHandler.FirstRun = null;
        c.X1st_Escalation_Case_Approver_Completed__c = false;      
        update c;
        c.Status = 'In Triage';
        EEC_CaseTriggerHandler.FirstRun = null;
        if(c.Triage_Responsible__c == null)
            c.Triage_Responsible__c = EEC_TestUtil.mockUser().Id;  
        update c;
        c.Status = 'Escalated';
       
        EEC_CaseTriggerHandler.FirstRun = null;
        c.SendCaseTriageEmail__c ='Approved';
        
        c.X1st_Escalation_Case_Approver__c = null;
        c.X1st_Escalation_Case_Approver_Completed__c = true;
        update c;    
        Test.stopTest();  
    }
    
    @isTest
    public static void testAssignCaseOwnerByStatus() {
        Account acc = EEC_TestUtil.mockUnlicensedProvider(EEC_TestUtil.mockCity(),null,null);
        Contact con = EEC_TestUtil.mockDirectorContact(acc);  
        Case c = EEC_TestUtil.mockWebCase(acc, con);
        c.Status ='In Triage';
        EEC_CaseTriggerHandler.FirstRun = null;
        update c;
        
        
        c = [SELECT ID, Status,AccountId,X1st_Escalation_Case_Approver_Completed__c FROM Case WHERE Status = 'In Triage' AND X1st_Escalation_Case_Approver__c != null LIMIT 1];
        Account a = [SELECT ID, Name FROM Account WHERE Id =: c.AccountId];
       
        update a;
        update c;    
        Investigation__c i = EEC_TestUtil.mockInvestigation(a);
        User us = EEC_TestUtil.mockUser();
        us.Out_of_Office__c = false ;
        us.DB_Region__c = 'NA';
        
        Test.startTest();

        c.Investigation__c = i.Id;  
        c.Status = 'Investigation in Progress';
        EEC_CaseTriggerHandler.FirstRun = null;
        c.Out_Of_Office_Initial_Recipient_ID__c = null; 
        c.X1st_Escalation_Case_Approver_Completed__c = false;      
        update c;
        c.Status = 'In Triage';
        EEC_CaseTriggerHandler.FirstRun = null;        
        c.X1st_Escalation_Case_Approver_Completed__c = false;   
        update c;
        c.Status ='No Non-Compliance Closure Pending';     
        c.Triage_Responsible__c = us.Id;
        EEC_CaseTriggerHandler.FirstRun = null;  
        update us;
        update c;
        Test.stopTest();  
    }
    
    @isTest
    public static void testNewCaseOwner() {
        Account acc = EEC_TestUtil.mockUnlicensedProvider(EEC_TestUtil.mockCity(),null,null);
        Contact con = EEC_TestUtil.mockDirectorContact(acc);  
        User us =  EEC_TestUtil.mockUser();
        Case c = EEC_TestUtil.mockWebCase(acc, con);
        Investigation__c invest = EEC_TestUtil.mockInvestigation(acc);
        c = [SELECT ID, Status,X1st_Escalation_Case_Approver_Completed__c,Investigation__c FROM Case WHERE Status = 'New' LIMIT 1];
       Account accnt = [SELECT ID,OwnerId FROM Account WHERE RecordType.DeveloperName = 'FCC' AND Provider_Address_1__c != null LIMIT 1];
        update accnt;
        c.Out_Of_Office_Initial_Recipient_ID__c = 'test';
        update c;
        Test.startTest();
     
        c.Unlicensed_Provider_Region__c = null;
        c.SendCaseTriageEmail__c = null;  
        EEC_CaseTriggerHandler.FirstRun = null;
        update c;
        c.Status = 'In Triage';
        c.SendCaseTriageEmail__c = 'Approved'; 
        EEC_CaseTriggerHandler.FirstRun = null;
        c.TriageEscalationApproverEmailList__c = 'test@test.com,abc@test.com';  
        update c;  
        //c.Status = 'No Non-Compliance Closure Pending';
        //update c;  
        Test.stopTest();  
    }
    
    @isTest
    public static void testInTriageEmail() {
        Account acc = EEC_TestUtil.mockUnlicensedProvider(EEC_TestUtil.mockCity(),null,null);
        Region__c reg = EEC_TestUtil.mockRegion();
        Account accnt = [SELECT ID,OwnerId FROM Account WHERE RecordType.DeveloperName = 'FCC' AND Provider_Address_1__c != null LIMIT 1];
        update acc;
          
        Investigation__c invest = EEC_TestUtil.mockInvestigation(acc); 
        Contact con = EEC_TestUtil.mockDirectorContact(acc);  
        Case c = EEC_TestUtil.mockWebCase(acc, con);
        c = [SELECT ID, Status,X1st_Escalation_Case_Approver_Completed__c,Case_Type__c FROM Case WHERE  Status = 'New' and Origin = 'Web'   LIMIT 1];
        update c;
        
        User u = EEC_TestUtil.mockUser(); 
        User manager = EEC_TestUtil.mockUser();  
        u.Out_Of_Office__c = true;
        u.ManagerId = manager.Id;  
        update u;    
           
        Test.startTest();
       // c.RecordTypeId  = Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        c.Status = 'In Triage';  
        c.Unlicensed_Provider_Region__c = null;
        c.SendCaseTriageEmail__c = null;  
        c.Triage_Responsible__c = u.Id;        
        EEC_CaseTriggerHandler.FirstRun = null;
        update c;     
        c.SendCaseTriageEmail__c = 'Recalled';
        // c.RecordTypeId  = Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('SLGSA Injury').getRecordTypeId();
        c.TriageEscalationApproverEmailList__c = 'test@test.com';    
        EEC_CaseTriggerHandler.FirstRun = null;
        update c;
        Test.stopTest();  
    }
    
   
    
    @isTest
    public static void testEscalatedEmailToManagerOutofOffice() {
        Account acc = EEC_TestUtil.mockUnlicensedProvider(EEC_TestUtil.mockCity(),null,null);
        Contact con = EEC_TestUtil.mockDirectorContact(acc);  
        Case c = EEC_TestUtil.mockWebCase(acc, con);
        c = [SELECT ID, Status,X1st_Escalation_Case_Approver_Completed__c FROM Case WHERE Status = 'New' LIMIT 1];
        User u = EEC_TestUtil.mockUser();
        User manager = EEC_TestUtil.mockUser();  
        u.Out_Of_Office__c = true;
        u.ManagerId = manager.Id;  
        update u;  
        Test.startTest();
        c.Out_Of_Office_Initial_Recipient_ID__c = u.Id; 
        c.Out_Of_Office_Email_Template_To_Send__c = 'X19_Case_Escalated_Case_sent_for_review_and_approval';  
        c.Unlicensed_Provider_Region__c = null;
        EEC_CaseTriggerHandler.FirstRun = null;
        update c;
        Test.stopTest();  
    }
    
    @isTest
    public static void testInjuryCaseClosureOutofOffice() {
        Account acc = EEC_TestUtil.mockUnlicensedProvider(EEC_TestUtil.mockCity(),null,null);
        Contact con = EEC_TestUtil.mockDirectorContact(acc);  
        Case c = EEC_TestUtil.mockWebCase(acc, con);
        c = [SELECT ID, Status,X1st_Escalation_Case_Approver_Completed__c FROM Case WHERE Status = 'New' LIMIT 1];
        Test.startTest();
        User u = EEC_TestUtil.mockUser();
        User manager = EEC_TestUtil.mockUser();  
        u.Out_Of_Office__c = true;
        u.ManagerId = manager.Id;  
        update u;    
        c.Triage_Responsible__c = u.Id; 
        c.Status = 'No Non-Compliance Closure Pending';
        c.X1st_Escalation_Case_Approver_Completed__c = false;      
        update c;
        c.Status = 'In Triage';
        c.X1st_Escalation_Case_Approver_Completed__c = false;   
        Test.stopTest();  
    }
    
    
    static testMethod void testEventTrigger() {
        RecordType r = [select Id from RecordType where DeveloperName='FCC' and sobjecttype='Account'];
        Account pAccount = new Account(
            name='TestProvider1',
            RecordTypeId=r.Id,
            Provider_Email__c='test@test.com',
            Provider_Address_1__c='123 Test St.',
            Provider_City__c=EEC_TestUtil.mockCity().Id,
            Provider_Zip_Code__c='B3H0A2');
        insert pAccount;
        // Use a visit obj.
        
       // Inspection_Item__c item1 = EEC_TestUtil.mockInspectionItem(EEC_TestUtil.mockInspection(pAccount), EEC_TestUtil.mockStdInspectionItem(), 'Test', true, 'Test');
        Inspection__c item = EEC_TestUtil.mockInspection(pAccount);
        System.debug('*****Item Id: ' + item.Id);
        
        Event event = new Event(
            DurationInMinutes = 14400,
            ActivityDateTime = DateTime.now(),
            WhatId = item.Id,
            EndDateTime = DateTime.now().addDays(10)
        );
        insert event;
        event.Description = 'Testing!';
        update event;
    }
    static testMethod void testUpdateEventTrigger() {
        Inspection__c[] item = [SELECT ID, Name,Announced__c FROM Inspection__c LIMIT 1];
        if (item.size() > 0)
            item[0].Announced__c = true;
        update item;
    }
    
    @isTest
    public static void testassignCaseOwner() {
        Account acc = EEC_TestUtil.mockUnlicensedProvider(EEC_TestUtil.mockCity(),null,null);
        
        Contact con = EEC_TestUtil.mockDirectorContact(acc);
        
        Case c = EEC_TestUtil.mockWebCase(acc, con);
        
        Region__c regionrecord = [Select id,Deputy_Commissioner__c FROM Region__c limit 1];
        regionrecord.Deputy_Commissioner__c = EEC_TestUtil.mockUser().id;
        update regionrecord;
        Investigation__c invest = EEC_TestUtil.mockInvestigation(acc);
        c = [SELECT ID, Status,X1st_Escalation_Case_Approver_Completed__c,Investigation__c FROM Case WHERE Status = 'New' LIMIT 1];
       Account accnt = [SELECT ID,OwnerId FROM Account WHERE RecordType.DeveloperName = 'FCC' AND Provider_Address_1__c != null LIMIT 1];
        User LEADSystem_Batch_User = EEC_TestUtil.mockUser();
        LEADSystem_Batch_User.firstName = 'LEAD';
        LEADSystem_Batch_User.LastName = 'System_Batch_User';
        update LEADSystem_Batch_User;
        accnt.OwnerID = LEADSystem_Batch_User.id;
        update accnt;
        c.Out_Of_Office_Initial_Recipient_ID__c = 'test';
        update c;
        Test.startTest();
     
        c.Unlicensed_Provider_Region__c = null;
        c.SendCaseTriageEmail__c = null;  
        EEC_CaseTriggerHandler.FirstRun = null;
        update c;
        c.Status = 'In Triage';
        c.SendCaseTriageEmail__c = 'Approved'; 
        EEC_CaseTriggerHandler.FirstRun = null;
        c.TriageEscalationApproverEmailList__c = 'test@test.com,abc@test.com';  
        update c;  
        //c.Status = 'No Non-Compliance Closure Pending';
        //update c;  
        Test.stopTest();  
    }
    
    @isTest
    public static void testassignCaseOwnerwithOutLeadSystemBatchUser() {
        Account acc = EEC_TestUtil.mockUnlicensedProvider(EEC_TestUtil.mockCity(),null,null);
        
        Contact con = EEC_TestUtil.mockDirectorContact(acc);
        
        Case c = EEC_TestUtil.mockWebCase(acc, con);
        
        Region__c regionrecord = [Select id,Deputy_Commissioner__c FROM Region__c limit 1];
        regionrecord.Deputy_Commissioner__c = EEC_TestUtil.mockUser().id;
        update regionrecord;
        Investigation__c invest = EEC_TestUtil.mockInvestigation(acc);
        c = [SELECT ID, Status,X1st_Escalation_Case_Approver_Completed__c,Investigation__c FROM Case WHERE Status = 'New' LIMIT 1];
       c.Out_Of_Office_Initial_Recipient_ID__c = 'test';
        update c;
        Test.startTest();
       c.Unlicensed_Provider_Region__c = null;
        c.SendCaseTriageEmail__c = null;  
        EEC_CaseTriggerHandler.FirstRun = null;
        update c;
        c.Status = 'In Triage';
        c.SendCaseTriageEmail__c = 'Approved'; 
        EEC_CaseTriggerHandler.FirstRun = null;
        c.TriageEscalationApproverEmailList__c = 'test@test.com,abc@test.com';  
        update c;  
        //c.Status = 'No Non-Compliance Closure Pending';
        //update c;  
        Test.stopTest();  
    }
    
    @isTest
    public static void testassignCaseOwnerwithUnlicensedProviderRegion() {
        Account acc = EEC_TestUtil.mockUnlicensedProvider(EEC_TestUtil.mockCity(),null,null);
        
        Contact con = EEC_TestUtil.mockDirectorContact(acc);
        
        Case c = EEC_TestUtil.mockWebCase(acc, con);
        
        Region__c regionrecord = [Select id,Deputy_Commissioner__c FROM Region__c limit 1];
        regionrecord.Deputy_Commissioner__c = EEC_TestUtil.mockUser().id;
        update regionrecord;
        Investigation__c invest = EEC_TestUtil.mockInvestigation(acc);
        c = [SELECT ID, Status,X1st_Escalation_Case_Approver_Completed__c,Investigation__c FROM Case WHERE Status = 'New' LIMIT 1];
       c.Out_Of_Office_Initial_Recipient_ID__c = 'test';
        c.Unlicensed_Provider_Region__c = regionrecord.id;
        update c;
        Test.startTest();
       c.SendCaseTriageEmail__c = null;  
        EEC_CaseTriggerHandler.FirstRun = null;
        update c;
        c.Status = 'In Triage';
        c.SendCaseTriageEmail__c = 'Approved'; 
        EEC_CaseTriggerHandler.FirstRun = null;
        c.TriageEscalationApproverEmailList__c = 'test@test.com,abc@test.com';  
        update c;  
        //c.Status = 'No Non-Compliance Closure Pending';
        //update c;  
        Test.stopTest();  
    }
    @isTest
    public static void testsendNonComplianceInjuryCaseClosureOutofOffice() {
        Account acc = EEC_TestUtil.mockUnlicensedProvider(EEC_TestUtil.mockCity(),null,null);
        
        Contact con = EEC_TestUtil.mockDirectorContact(acc);
        
        Case c = EEC_TestUtil.mockWebCase(acc, con);
        
        Region__c regionrecord = [Select id,Deputy_Commissioner__c FROM Region__c limit 1];
        regionrecord.Deputy_Commissioner__c = EEC_TestUtil.mockUser().id;
        update regionrecord;
        User u = EEC_TestUtil.mockUser();
        u.Out_of_Office__c = true;
        u.ManagerId = Userinfo.getUserID();
        update u;
        
        User exeManager = EEC_TestUtil.mockUser();
        
        User currentUser = new User(id= UserInfo.getUserId(), ManagerID = exeManager.id);
        update currentUser;
        
        Investigation__c invest = EEC_TestUtil.mockInvestigation(acc);
        c = [SELECT ID, Status,X1st_Escalation_Case_Approver_Completed__c,Investigation__c FROM Case WHERE Status = 'New' LIMIT 1];
       c.Out_Of_Office_Initial_Recipient_ID__c = 'test';
        c.Unlicensed_Provider_Region__c = regionrecord.id;
        c.Triage_Responsible__c = u.id;
        update c;
        Test.startTest();
       c.SendCaseTriageEmail__c = null;
        c.Status = 'No Non-Compliance Closure Pending';
        EEC_CaseTriggerHandler.FirstRun = null;
        update c;
        c.Status = 'In Triage';
        c.SendCaseTriageEmail__c = 'Approved'; 
        EEC_CaseTriggerHandler.FirstRun = null;
        c.TriageEscalationApproverEmailList__c = 'test@test.com,abc@test.com';  
        update c;  
        //c.Status = 'No Non-Compliance Closure Pending';
        //update c;  
        Test.stopTest();  
    }
    
    @isTest
    public static void testsendcloseTasksOnStatusChange() {
        Account acc = EEC_TestUtil.mockUnlicensedProvider(EEC_TestUtil.mockCity(),null,null);
        Contact con = EEC_TestUtil.mockDirectorContact(acc);
        Case c = EEC_TestUtil.mockWebCase(acc, con);
        Investigation__c invest = EEC_TestUtil.mockInvestigation(acc);
        Task taskrecord  = EEC_TestUtil.mockTask(c);
        c = [SELECT ID, Status,X1st_Escalation_Case_Approver_Completed__c,Investigation__c FROM Case WHERE Status = 'New' LIMIT 1];
       c.Out_Of_Office_Initial_Recipient_ID__c = 'test';
        c.SendCaseTriageEmail__c = null;
        c.Status = 'In Triage';
        update c;
        Test.startTest();
       
        c.status = 'New';
        EEC_CaseTriggerHandler.FirstRun = null;
        update c ;
         
        Test.stopTest();  
    }
}