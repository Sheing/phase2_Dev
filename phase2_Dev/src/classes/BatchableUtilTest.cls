@isTest
private class BatchableUtilTest {
  
  @isTest static void testHasSObjectField() {
    System.assert(!BatchableUtil.hasSObjectField('Name', new Case()));
  }
}