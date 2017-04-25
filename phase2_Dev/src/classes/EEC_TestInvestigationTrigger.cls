@isTest
public with sharing class EEC_TestInvestigationTrigger {

    @isTest static void testUpdateClosedInvestigationsBefore() {
        test.startTest();
        
        User u = EEC_TestUtil.mockUser();
        
        System.runAs(u) {
            Investigation__c i = EEC_TestUtil.mockInvestigation(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()));
            i.Investigation_Status__c = 'Approved - Report to send';
            i.Assigned_To__c = u.id;
            i.Approval_Task_Creation__c = 'NonEscalated Approved';
            EEC_InvestigationTriggerHandler.FirstRun = true;
           // update i;
            i.Investigation_Status__c = 'Report Sent to Provider';    
            update i;    
            //i.Investigation_Status__c = 'Closed'; 
            //i.Cover_Letter_Issue_Date__c = System.Today();
            //Intervention__c inv = EEC_TestUtil.mockIntervention(i);
            //inv.Status__c = 'Cancelled';
            //inv.Cancel_Reason__c = 'Testing';
            
            //update inv;
            //update i;
            
            //i = [SELECT Closed_date__c FROM Investigation__c WHERE ID = :i.Id];
             
            //System.assertEquals(System.today(), i.Closed_Date__c); 
        }
        
        test.stopTest();
    }
    
    @isTest static void testUpdateClosedInvestigationsAfter() {   
        User u = EEC_TestUtil.mockUser();
        
        System.runAs(u) {
            Investigation__c i = EEC_TestUtil.mockInvestigation(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
            i.Investigation_Status__c = 'Approved - Report to send';
            i.Assigned_To__c = u.id;
            i.Approval_Task_Creation__c = 'NonEscalated Rejected';
            update i;
            i.Investigation_Status__c = 'Ready to Publish/Send to Provider';
            i.Report_Narrative_Issue_Date__c = Date.today();
            i.Sent_Date__c = Date.today();
            i.Cover_Letter_Issue_Date__c = Date.today();
			i.Created_on_the_Web__c = true;   
            test.startTest();
            update i; 
            i.Investigation_Status__c = 'Closed';
            update i;
        }
    }

    static testMethod void testCheckVisitForPublishedToWeb(){
        User u = EEC_TestUtil.mockUser();
        System.runAs(u){
            Account a = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC');
            Investigation__c i = EEC_TestUtil.mockInvestigation(a);
            i.Created_on_the_Web__c = false;
            update i;
            
            i.Created_on_the_Web__c = true;
            update i;

        }
    }
    @isTest static void testInvestigationAssignedEmailOutOfOffice() {  
        Investigation__c  invest = EEC_TestUtil.loadInvestigationSetup();  
        Intervention__c inter = EEC_TestUtil.mockIntervention(invest); 
        Investigation__c inv = [SELECT Id,Assigned_To__c FROM Investigation__c WHERE Investigation_Status__c != 'Closed' 
                                AND Number_of_Interventions__c > 0 LIMIT 1];

        User leader = [SELECT Id,Out_Of_Office__c,Name,ManagerId,For_Portal_Email__c FROM User WHERE IsActive = True AND UserType = 'Standard' AND 
                       Region__c != null AND ManagerId != null LIMIT 1];
        leader.Out_Of_Office__c = true;
        leader.Email = 'test@test.com';
        update leader;
        
        inv.Assigned_To__c = leader.Id;
        update inv;
        
    }
    
    @isTest static void testInvestigationApprovalEmailOutOfOffice() {
        Investigation__c  invest = EEC_TestUtil.loadInvestigationSetup();  
        Intervention__c inter = EEC_TestUtil.mockIntervention(invest); 
        Investigation__c inv = [SELECT Id,Assigned_To__c,Out_Of_Office_Initial_Recipient__c,Out_Of_Office_Email_Template_To_Send_del__c
                                FROM Investigation__c WHERE Investigation_Status__c != 'Closed' 
                                AND Number_of_Interventions__c > 0 LIMIT 1];
        User leader = [SELECT Id,Out_Of_Office__c,Name,ManagerId,For_Portal_Email__c FROM User WHERE IsActive = True AND UserType = 'Standard' AND 
                       Region__c != null AND ManagerId != null LIMIT 1];
        leader.Email = 'test@test.com';
        leader.Out_Of_Office__c = true;
        update leader;
        
        inv.Assigned_To__c = leader.Id;
        inv.Out_Of_Office_Initial_Recipient__c = leader.Id;
        inv.Out_Of_Office_Email_Template_To_Send_del__c = 'X25_Investigation_Approval_Investigation_sent_for_review_and_approval';
        update inv;
        
    }
    
    @isTest static void testCaseOwnerByInvestigationLeader() {
        Investigation__c  invest = EEC_TestUtil.loadInvestigationSetup();  
        Intervention__c inter = EEC_TestUtil.mockIntervention(invest); 
        Investigation__c inv = [SELECT Id,Assigned_To__c,Investigation_Status__c
                                FROM Investigation__c WHERE Investigation_Status__c = 'New' AND 
                                Number_of_Interventions__c > 0 LIMIT 1];
        
        User leader = [SELECT Id,Out_Of_Office__c,Name,ManagerId,For_Portal_Email__c FROM User WHERE IsActive = True AND UserType = 'Standard' AND 
                       Region__c != null AND ManagerId != null LIMIT 1];
        
        leader.Out_Of_Office__c = true;
        leader.Email = 'test@test.com';
        update leader;
        
        inv.Assigned_To__c = leader.Id;
        inv.Investigation_Status__c = 'Assigned - In Progress';
        update inv;
        
    }
    @isTest static void testReportDatesForApproved() {
        Investigation__c  invest = EEC_TestUtil.loadInvestigationSetup();  
        Intervention__c inter = EEC_TestUtil.mockIntervention(invest); 
        invest.Investigation_Status__c = 'Assigned - In Progress';
        update invest;
        Investigation__c inv = [SELECT Id,Assigned_To__c,Investigation_Status__c
                                FROM Investigation__c WHERE Investigation_Status__c = 'Assigned - In Progress' AND 
                                Number_of_Interventions__c > 0 LIMIT 1];
                        
        inv.Investigation_Status__c = 'Approved - Report to send';
        update inv;
        
    }
    
    @isTest static void testClosedInvestigationsAfter() {
        Investigation__c  invest = EEC_TestUtil.loadInvestigationSetup();  
        Intervention__c inter = EEC_TestUtil.mockIntervention(invest); 
		inter.Status__c = 'Done';
        inter.Date_Completed__c = system.today();
        update inter;
        test.startTest();
        Investigation__c inv = [SELECT Id,Assigned_To__c,Investigation_Status__c,Cover_Letter_Issue_Date__c
                                FROM Investigation__c WHERE Investigation_Status__c != 'Closed' AND
                                All_Interventions_Done__c = True LIMIT 1];
        
        inv.Investigation_Status__c = 'Ready to Publish/Send to Provider';
        inv.Cover_Letter_Issue_Date__c = System.today();
        update inv;
        
        inv.Investigation_Status__c = 'Closed';
        update inv;
        test.stopTest();
    }

}