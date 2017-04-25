@isTest
public class EEC_TestInvestigationCorrectionScheduler {
    
    static testMethod void test() {
        String CRON_EXP = '0 0 0 1 1 ? 2025'; 
        Test.startTest(); 
        // Schedule the test job.
        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new EEC_InvestigationCorrectionScheduler());
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression); 
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        // Verify the next time the job will run
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
         
        
      //  List<Investigation__c> Investigation = new List <Investigation__c>();
        
      Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Small Group', null);
        Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Small_Group');
        accnt.Config_Record__c = config2.Id;
        update accnt;
        
         Investigation__c inv = EEC_TestUtil.mockInvestigation(accnt);   
        // Investigation__c in = new Investigation__c(); 
        // Investigation.add(in);
       // insert inv;  
        Non_Compliant__c  inve = EEC_TestUtil.mockNonCompliant(inv); 
 		//List <Investigation__c> investList;
        
        
        String text= 'select id, Provider_No__r.OwnerId, (select Id from Non_Compliant_Item__r) from Investigation__c';
        EEC_InvestigationCorrectionAction loadtool = new EEC_InvestigationCorrectionAction(text);
        ID batchprocessid = Database.executeBatch(loadtool); 
       
      
        
        Test.stopTest();
    }
}