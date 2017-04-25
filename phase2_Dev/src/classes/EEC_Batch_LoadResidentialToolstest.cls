@isTest
public class EEC_Batch_LoadResidentialToolstest {
    static testMethod void testLoadResidentialTool() {
        
        List<VisitItemsStaging__c> visit = new List <VisitItemsStaging__c>();
        VisitItemsStaging__c visit1 = new VisitItemsStaging__c();
        visit1.Name = 'test';
        visit1.Description__c = 'testd';
        visit1.VisitItemToolAssignment__c = 'Residential gertg';
        visit.add(visit1);
        
        VisitItemsStaging__c visit2 = new VisitItemsStaging__c();
        visit2.Name = 'test';
        visit2.Description__c = 'testd';
        visit2.VisitItemToolAssignment__c = 'Foster Care agency';
        visit.add(visit2);
        
        
        VisitItemsStaging__c visit3 = new VisitItemsStaging__c();
        visit3.Name = 'test';
        visit3.Description__c = 'testd';
        visit3.VisitItemToolAssignment__c = 'Adoption care';
        visit.add(visit3);
        
        VisitItemsStaging__c visit4 = new VisitItemsStaging__c();
        visit4.Name = 'test';
        visit4.Description__c = 'testd';
        visit4.VisitItemToolAssignment__c = 'Large Group as';
        visit.add(visit4);
        
        VisitItemsStaging__c visit5 = new VisitItemsStaging__c();
        visit5.Name = 'test';
        visit5.Description__c = 'testd';
        visit5.VisitItemToolAssignment__c = 'LSmall Group sg';
        visit.add(visit5);
        
         VisitItemsStaging__c visit6 = new VisitItemsStaging__c();
        visit6.Name = 'test';
        visit6.Description__c = 'testd';
        visit6.VisitItemToolAssignment__c = 'FCC fc';
        visit6.Processed__c = false;
        visit.add(visit6);
        
        insert visit;
        
        Test.startTest();
        EEC_Batch_LoadResidentialTools loadtool = new EEC_Batch_LoadResidentialTools();
        
        //  ID batchprocessid = Database.executeBatch(new EEC_Batch_LoadResidentialTools ());
        ID batchprocessid = Database.executeBatch(loadtool);
        
        EEC_Batch_LoadPlacementTools loadtoof = new EEC_Batch_LoadPlacementTools();
        ID batchprocessida = Database.executeBatch(loadtoof);
        
        EEC_Batch_LoadGSADLTools loadgsa = new EEC_Batch_LoadGSADLTools();
        ID batchprocessidgsa = Database.executeBatch(loadgsa); 
        
        EEC_Batch_LoadFCCDLTools loadfcc = new EEC_Batch_LoadFCCDLTools();
        
        ID batchprocessidfcc = Database.executeBatch(loadfcc); 
        
        Test.stopTest(); 
    }
}