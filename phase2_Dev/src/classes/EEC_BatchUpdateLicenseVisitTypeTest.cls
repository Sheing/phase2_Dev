@isTest
public class EEC_BatchUpdateLicenseVisitTypeTest {
    static testMethod void testscenario1() {
        Inspection__c inspection = EEC_TestUtil.loadInspectionSetup();
        
        Database.BatchableContext BC;
        List<Inspection__c> listInspection = new List<Inspection__c>();
        listInspection.add(inspection);
        
        Test.startTest(); 
        EEC_BatchUpdateLicensingVisitRecordType sfbatchSync = new EEC_BatchUpdateLicensingVisitRecordType();
        ID batchprocessid = Database.executeBatch(sfbatchSync);
        sfbatchSync.execute(BC, listInspection);
        Test.stopTest();
    }
}