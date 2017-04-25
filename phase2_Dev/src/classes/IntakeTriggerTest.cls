@isTest
private class IntakeTriggerTest {

  @isTest static void testPreProcessing() {
    FormVersion__c testFormVersion = BatchTestUtil.loadData();
    
    Intake__c testIntake = new Intake__c(FormVersion__c = testFormVersion.Id);
    insert testIntake;

    List<Response__c> responses = [Select Id From Response__c];
    System.assertNotEquals(null, responses);
    System.assertEquals(2, responses.size());
  }
  
  @isTest static void testPostProcessing() {
    FormVersion__c testFormVersion = BatchTestUtil.loadData();
    
    Intake__c testIntake = new Intake__c(FormVersion__c = testFormVersion.Id);
    insert testIntake;

    Test.startTest();
    testIntake.Status__c = 'Submitted'; 
    update testIntake;
    Test.stopTest();
  }
}