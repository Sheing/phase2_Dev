@isTest
public with sharing class Batch_CleanHistoryofNonComplianceTest {
	
	@isTest static void bulkVisitInsertTest() {
     	
          Account acc1 = new Account();          
          Date cDate =  System.today();  
          // Scenario 1 : Renewal Application Not Submitted - 30 days prior to  expiration notice
          acc1.Name = 'Test account 1 ';
          acc1.License_Status__c = 'Licensed';
          acc1.Provider_Status__c = 'Current';
          acc1.Provider_Email__c ='test@incapsulate.com';
          acc1.RecordTypeId = [select Id from RecordType where Name = 'Family Child Care' and SobjectType = 'Account'].Id;
          acc1.Provider_Address_1__c = 'Test address';
          acc1.Provider_City__c = EEC_TestUtil.mockCity().Id;
          acc1.Provider_Zip_Code__c = '99999';
          acc1.Language__c = 'English';
          acc1.Preferred_Language__c = 'English';
          acc1.Restraint_Method__c = 'OWN';
          acc1.Use_Physical_Restraints__c = true;
          acc1.Renewal_date__c = cdate +30; 
          acc1.Provider_No__c = '603735';
          insert acc1;
        
        Regulation__c reg = new Regulation__c();
        reg.Applicable_To__c = 'Family Child Care';
        reg.Name = '14.14';
        reg.Date_Active__c = system.today();
        reg.Reg_key__c = 'FGS-18';
        insert reg;
     	
        HistoryOfNonCompliance__c nc = new HistoryOfNonCompliance__c();
     	
     	nc.Name = '603735';
     	nc.Interaction__c = '1179 - Monitoring Visit';
     	nc.InteractionDate__c = Date.parse('10/14/2014');
        nc.Citation__c = '14.14';
        nc.Observations__c = 'ssfsjfhdsndsfsdjfnsfsd lfkjsdlkfjdslf sdflkjsdlkfjsdfl fjsldkjflsdkfj klfjslkfjdslkfjslkfjlsdkf';
     	
        try{
     	   insert nc;
        }
        catch(exception ex){
           System.Assert(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')); 
        }
       
     	
     	//HistoryOfNonCompliance__c ncResult = [Select Id,Name From HistoryOfNonCompliance__c Where name ='603735'];
     	
     	//system.assert(ncResult != null);
      
     	Test.startTest();
     	string SOQL = 'Select Id,Name from HistoryOfNonCompliance__c';
        Database.executeBatch(new Batch_CleanHistoryofNonCompliance(SOQL),1);  
        Test.stopTest();
        List<HistoryOfNonCompliance__c> ncResult2 = [Select Id,Name From HistoryOfNonCompliance__c Where name = '603735'];
        
     	system.assert(ncResult2.isEmpty());

     }

}