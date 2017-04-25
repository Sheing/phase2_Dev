@isTest
public class EEC_BatchLoginHostorySchedulerTest {
    
	public static String CRON_EXP = '0 0 0 1 1 ? 2025';
    
    static testMethod void test() {
         User inspection = EEC_TestUtil.mockUser();
        
         Database.BatchableContext BC;
        List<User> listInspection = new List<User>();
        listInspection.add(inspection);
        
      Test.startTest(); 
            // Schedule the test job.
          String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new EEC_BatchPortalUserLoginHistoryScheduler());
          // Get the information from the CronTrigger API object
          CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
      // Verify the expressions are the same
          System.assertEquals(CRON_EXP, ct.CronExpression); 
          // Verify the job has not run
          System.assertEquals(0, ct.TimesTriggered);
          // Verify the next time the job will run
          System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        
         EEC_BatchPortalUserLoginHistoryUpdate sfbatchSync = new EEC_BatchPortalUserLoginHistoryUpdate();
        ID batchprocessid = Database.executeBatch(sfbatchSync);   
        
        sfbatchSync.execute(BC, listInspection);
       
        sfbatchSync.finish(BC);   
        Test.stopTest();
    }
            
}