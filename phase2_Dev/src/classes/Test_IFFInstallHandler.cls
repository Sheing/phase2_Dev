@isTest
public class Test_IFFInstallHandler {
    
    @isTest
    static void testV0() {
        IFFInstallHandler.v0(IFFPackageInformation__c.getOrgDefaults());
        
        IFFPackageInformation__c info = IFFPackageInformation__c.getOrgDefaults();
        
        System.assertEquals(info.ObjectsVersion__c, 0);
    }
     
     
    @isTest
    static void testUpgrade() {
        IFFPackageInformation__c info = IFFPackageInformation__c.getOrgDefaults();
        info.ObjectsVersion__c = 0;
        insert info;
        
        IFFInstallHandler.upgrade(info);
        
        info = IFFPackageInformation__c.getOrgDefaults();
        
        System.assertEquals(info.ObjectsVersion__c, 1);
        System.assertEquals([SELECT ID From Component__c].size(), 20);
        System.assertEquals([SELECT ID From Property__c].size(), 6);
        System.assertEquals([SELECT ID From ComponentProperty__c].size(), 41);
    }
}