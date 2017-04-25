@isTest
public with sharing class EEC_TestVisitTriggerHandler {

    @isTest static void testcheckItemsForPublishedToWeb(){
        Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        
        Inspection__c insp = EEC_TestUtil.mockInspection(acc);
        
        insp = [SELECT Id,Created_on_the_Web__c FROM Inspection__c 
                              WHERE Created_on_the_Web__c = false LIMIT 1];
        
        insp.Created_on_the_Web__c = true;
        
        update insp;
    }

    @isTest static void testSendInvestigationApprovalEmailOutOfOffice(){
        Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        
        Inspection__c insp = EEC_TestUtil.mockInspection(acc);
        
        insp = [SELECT Id,Status__c FROM Inspection__c 
                              WHERE Status__c != 'Pending Approval' LIMIT 1];
        
        User escalater = EEC_TestUtil.mockUser();
        User manager = EEC_TestUtil.mockUser();
        User delegatedApprover = EEC_TestUtil.mockUser();
        manager.DelegatedApproverId = delegatedApprover.Id;
        manager.Out_of_Office__c = true;
        update manager;
        escalater.ManagerId = manager.Id;
        update escalater;
        
        System.runAs(escalater){
        	insp.Created_on_the_Web__c = true;
        }
        
        update insp;
    }

    @isTest static void testVisitySummaryDefualtTriggerToBe() {
        
        LEAD_COnfiguration__c conf = EEC_TestUtil.mockLeadConfig('#Visit_Reason# #Visit_Date#');
        
        Account a = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),null,conf,'FCC'); 
         
        Inspection__c i = EEC_TestUtil.mockInspection(a); 
        
        i.Status__c = 'To be scheduled';
        i.Activity_Summary__c = null;
        i.Date_of_visit__c = null;
        i.Type_of_visit__c = 'Capacity Increase';
        update i;
        
        
        i.Status__c = 'Visit Completed';
        update i;
        
        i = [SELECT Activity_Summary__c, Type_of_Visit__c, Date_of_visit__c  FROM Inspection__C WHERE ID = :i.Id];
        
        System.debug('-----Inspection Type of Visit: ' + i.Type_of_visit__c);
        System.debug('-----Inspection: ' + i);
        
        System.assertNotEquals(null, i.Type_of_visit__c);
    }


    @isTest static void testVisitySummaryDefualtTriggerScheduled() {
     
        LEAD_COnfiguration__c conf = EEC_TestUtil.mockLeadConfig('#Visit_Reason# #Visit_Date#');
    
        Account a = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),null,conf,'FCC'); 
        
        Inspection__c i = EEC_TestUtil.mockInspection(a);
         
        
        i.Status__c = 'Scheduled';
        i.Activity_Summary__c = null;
        i.Date_of_visit__c = System.Today();
        i.Type_of_visit__c = 'Capacity Increase';
        update i;
        
        i.Status__c = 'Visit Completed';
        //i.Created_on_the_Web__c = true;
        update i;
        
        i = [SELECT Activity_Summary__c, Type_of_Visit__c, Date_of_visit__c, Status__c  FROM Inspection__C WHERE ID = :i.Id];
        
        //System.assertEquals('Visit Completed', i.Status__c);
        //System.assert(i.Activity_Summary__c.contains(i.Type_of_visit__c));
        //System.assert(i.Activity_Summary__c.contains(EEC_DateUtil.formatDate('MM/dd/yyyy', i.Date_of_visit__c)));
    }
}