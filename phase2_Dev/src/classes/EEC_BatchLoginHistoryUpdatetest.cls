@isTest
public class EEC_BatchLoginHistoryUpdatetest {
 static testMethod void testForwardToCustombatch() {
    Test.startTest();
	ID batchprocessid = Database.executeBatch(new EEC_BatchLoginHistoryUpdate ());
	Test.stopTest();
}
}