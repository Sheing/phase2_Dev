/**
 * EEC_BatchProviderVisitTest
 * 
 */

@isTest
public class EEC_BatchProviderVisitTest {

    static testMethod void testscenario1() {
        String query =  'SELECT Id,Is_Residential__c,Is_R_P__c,Is_GSA__c,Provider_Address_1__c,Provider_Address_2__c,Provider_Zip_Code__c,Config_Record__c,Config_Record__r.Lic_Anniversary_Visit_Estimated_Deadline__c,Config_Record__r.Nb_Days_Prior_to_Lic_Anniv_to_Create_Vis__c,Provider_City__r.Name,Need_a_licensing_visit__c,License_Status__c,Renewal_date__c,OwnerId,Provider_Status__c FROM Account';
        
        Lead_Configuration__c config = EEC_TestUtil.mockLeadConfig('Family Child Care', null);
        
        config.Nb_Days_Prior_to_Lic_Anniv_to_Create_Vis__c = 1;
        config.Lic_Anniversary_Visit_Estimated_Deadline__c = 1;
        
        update config;
        
        Account acc1 = new Account();          
        Date cDate =  System.today();  
        // Scenario 1 : Renewal Application Not Submitted - 30 days prior to  expiration notice
        acc1.Name = 'Test account 1 ';
        acc1.License_Status__c = 'Licensed';
        acc1.Provider_Status__c = 'Current';
        acc1.Provider_Email__c ='test@incapsulate.com';
        acc1.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Family Child Care' AND SobjectType = 'Account'].Id;
        acc1.Provider_Address_1__c = 'Test address';
        acc1.Provider_City__c = EEC_TestUtil.mockCity().Id;
        acc1.Provider_Zip_Code__c = '99999';
        acc1.Language__c = 'English';
        acc1.Preferred_Language__c = 'English';
        acc1.Restraint_Method__c ='OWN';
        acc1.Use_Physical_Restraints__c = true;
        acc1.First_Issue_Date__c = cdate - 307;
        acc1.Renewal_date__c = cdate - 365;
        acc1.Config_Record__c = config.Id;
        insert acc1; 
        
        Regulation__c reg = EEC_testUtil.mockRegulation();
        List<Inspection__c> lstInsp = new List<Inspection__c>();
        Inspection__c insp1 = new Inspection__c(Provider_No__c = acc1.Id, Status__c = 'Scheduled', Date_of_Visit__c = System.Today() - 5, Inspector_del__c = Userinfo.getUserId(), Visit_Created_By_Batch__c  = false);
        Inspection__c insp2 = new Inspection__c(Provider_No__c = acc1.Id, Status__c = 'Scheduled', Date_of_Visit__c = System.Today() - 5, Inspector_del__c = Userinfo.getUserId(), Visit_Created_By_Batch__c  = false);
        
        lstInsp.add(insp1);
        lstInsp.add(insp2);
        
        insert lstInsp;
        
        for(Inspection__c i : lstInsp){
            system.debug(i.Count_Visit_For_Visit_Creation_Batch__c);
        }
        
        Account a1 = [select Id, Need_a_licensing_visit__c from Account where Id =: acc1.Id];
        
        system.debug('acc1: ' + a1.Need_a_licensing_visit__c);
        
        Test.startTest(); 
        EEC_BatchProviderVisit sfbatchSync = new EEC_BatchProviderVisit(query);
        ID batchprocessid = Database.executeBatch(sfbatchSync);
        
        sfbatchSync = new EEC_BatchProviderVisit();
        ID batchprocessid1 = Database.executeBatch(sfbatchSync);
        Test.stopTest();
        
          AsyncApexJob job  = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                                    FROM AsyncApexJob WHERE Id =:batchprocessid];
                //assert for total number of errors
          System.assertEquals(job.NumberOfErrors, 0);  
        
    }
}