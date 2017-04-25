@isTest
private class ProcessingStepBatchableTest {

  @isTest static void testProcessingStepBatchable() {
    FormVersion__c testFormVersion = BatchTestUtil.loadData();
    
    Intake__c testIntake = new Intake__c(FormVersion__c = testFormVersion.Id);
    insert testIntake;

    Set<Id> mIntakeList = new Set<Id>();
    mIntakeList.add(testIntake.Id);
    String queryStr = 'Select Id, Name, Status__c, FormVersion__c, FormVersion__r.Name, FormVersion__r.Status__c, FormVersion__r.Form__c, FormVersion__r.Form__r.Name From Intake__c';

    ProcessingStepBatchable batch = new ProcessingStepBatchable(0, mIntakeList);
    batch.currentCronJobName = BatchableUtil.generateBatchableName('Intake', 0, UserInfo.getUserId());

    Test.startTest();
    testIntake.Status__c = 'Submitted'; 
    update testIntake;

    Database.executebatch(batch, 200);
    Test.stopTest();

    Integer i = [Select Count() From Case];
    System.assertEquals(i, 1);
  }
}