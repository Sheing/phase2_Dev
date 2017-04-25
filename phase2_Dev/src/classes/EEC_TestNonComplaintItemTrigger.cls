@isTest
public with sharing class EEC_TestNonComplaintItemTrigger{
    @isTest static void testupdateRequireFeedback() {
        test.startTest();
        
        User u = EEC_TestUtil.mockUser();        
        System.runAs(u) { 
            ID accountid;      
            Integer int1 =0;

            Investigation__c  invest = EEC_TestUtil.loadInvestigationSetup();  
             
            Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
            test.startTest();
            insp.Investigation__c = invest.Id;
            update insp;

            invest.Require_Portal_Feedback__c = true;
            update invest;
            test.stoptest();
        }
    } 
    @isTest static void testRequireFeedback() {
        Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        
        Inspection__c insp = EEC_TestUtil.mockInspection(acc);
        
        Standard_Inspection_Item__c sii = EEC_TestUtil.mockStdInspectionItem();
        
        Inspection_Item__c item1 = EEC_TestUtil.mockInspectionItem(insp, sii, 'Non-Compliant', false, 'Test');
        Inspection_Item__c item2 = EEC_TestUtil.mockInspectionItem(insp, sii, 'Compliant', false, 'Test');
        
        test.startTest();
        Inspection_Item__c ii = [SELECT Id, Inspection_No__r.Provider_No__c,Inspection_No__c,Observations__c,
                                 Technical_Assistance__c, Date_Implemented__c,Correction_Plan__c
                                 FROM Inspection_Item__c 
                                 WHERE Inspection_Result__c = 'Compliant' LIMIT 1];
        
        //Inspection__c i = [SELECT Id FROM Inspection__c WHERE ID =: ii.Inspection_No__c LIMIT 1];
        
        ii.Observations__c = 'technicalAssistance';
        ii.Technical_Assistance__c = 'technicalAssistance';
        ii.Inspection_Result__c = 'Non-Compliant';
        ii.Date_Implemented__c  = Date.Today();
        ii.Correction_Plan__c = 'Testing222';
        update ii;

        test.stopTest();
    }
}