@isTest
public class EEC_MassTransferVisitsExtensionTest{
    static testMethod void testGetDirectorContact(){
        //Account a = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        //Contact c = EEC_TestUtil.mockDirectorContact(a);
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        Test.startTest();
        executeTest();
        Test.stopTest();
     }
     
     @future
     static void executeTest(){
         User u = EEC_TestUtil.mockDirectorUser();
        
         List<Inspection__c > listInvenstigation = [select Id, Name from Inspection__c];
        
        system.runAs(u){
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(listInvenstigation);
            
            EEC_MassTransferVisitsExtension massTransfer = new EEC_MassTransferVisitsExtension(sc);
            massTransfer.goBackToVisitsTab();
            massTransfer.massTransferVisits();            
        }
     }
}