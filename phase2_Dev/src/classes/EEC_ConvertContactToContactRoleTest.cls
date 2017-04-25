@isTest
public with sharing class EEC_ConvertContactToContactRoleTest {

    static testMethod void testBatch_ConvertContactToContactRole()	{
        EEC_Batch_ConvertContactToContactRole batchCreateContactRole = new EEC_Batch_ConvertContactToContactRole();   
        
        Test.startTest();
           Database.executeBatch(batchCreateContactRole, 1);
        Test.stopTest();
    }
    
    static testMethod void testConvertContactToContactRole(){
        Account a = new Account();
        a.name ='Test Acccount';
        a.RecordTypeId = [Select Id from RecordType where SobjectType='Account' and Name like 'Small Group'].Id;
        a.License_Type__c = 'Regular';
        a.License_Status__c = 'Not Licensed';
        a.Provider_Status__c ='New application in progress';
        a.Provider_Address_1__c = 'Adres 123';
        a.Provider_Zip_Code__c = '12345';
        a.Provider_City__c = EEC_TestUtil.mockCity('Craigville').Id;
        a.Region__c = EEC_TestUtil.mockRegion().Id;
        insert a;
        
        Contact c = new Contact();
        c.firstname = 'firstname';
        c.LastName = 'lname';
        c.AccountId = a.id;
        insert c;
        
        EEC_Batch_ConvertContactToContactRole batchCreateContactRole = new EEC_Batch_ConvertContactToContactRole();   
        test.startTest();
           Database.executeBatch(batchCreateContactRole, 1);
        test.stopTest();
        
    }
}