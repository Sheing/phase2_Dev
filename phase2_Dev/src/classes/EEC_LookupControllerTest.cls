@isTest
public class EEC_LookupControllerTest {
  @testSetup static void setup() {

  }

  public static testMethod void testConstructor() {
    EEC_LookupControllerTest.pageSetup();
    // Call the constructor.
    EEC_LookupController ctrl = new EEC_LookupController();
    System.assertEquals(ctrl.sObjectName, 'Account');  
  }

  public static testMethod void testQuery() {
    EEC_LookupControllerTest.pageSetup();
    EEC_LookupController ctrl = new EEC_LookupController();
    ctrl.sObjectName = null;
    System.assertEquals(null, ctrl.query());
  }

  private static void pageSetup() {
    // Setup an instance of the page. 
    PageReference page = new PageReference('Page.EEC_Lookup');
    Test.setCurrentPageReference(page);
    // Set the get params for the page.
    System.currentPageReference().getParameters().put('sobject', 'Account');
    System.currentPageReference().getParameters().put('sortfield', 'Name');
      
    EEC_Lookup_Params__c config = new EEC_Lookup_Params__c();
    config.Name = 'Account';
    config.Where_Conditions__c = 'RecordType.Name = \'FCC Assistant\'';
    config.sObject_Name__c = 'Account';
    config.Query_Fields__c = 'Name,CreatedDate,License_Status__c,Current_License_Number__c,Renewal_date__c,License_Type__c,Provider_City__r.Name';
    config.Order_Conditions__c = 'Created Date DESC';
    config.Like_Conditional_Operator__c = 'OR';
    config.Like_Conditions__c = 'Name,Current_License_Number__c,Provider_City__r.Name';
    insert config;
      
    
  }
}