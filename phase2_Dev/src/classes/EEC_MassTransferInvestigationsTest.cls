@isTest
public with sharing class EEC_MassTransferInvestigationsTest {
     @isTest static void testGetDirectorContact(){
        Account a = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        Contact c = EEC_TestUtil.mockDirectorContact(a);
        Investigation__c i = EEC_TestUtil.mockInvestigation(a);
        
        executeTest();
     }
     
     @future
     static void executeTest(){
         Contact c = [select Id, Name from Contact limit 1];
         
         User u = EEC_TestUtil.mockDirectorUser();
        
        List<Investigation__c> listInvenstigation = [select Id, Provider_No__c, Assigned_To__c from Investigation__c limit 1];
        
        system.runAs(u){
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(listInvenstigation);
            
            EEC_MassTransferInvestigationsExtension massTransfer = new EEC_MassTransferInvestigationsExtension(sc);
            massTransfer.goBackToinvestigationsTab();
            massTransfer.massTransferinvestigations();            
        }
     }
}