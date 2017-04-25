@isTest
public with sharing class StandardVisitItemTriggerTest {
	
	@isTest static void bulkInsertStandardVisitItemsTest() {
	 	
	 	Standard_Inspection_Item__c stdVisitItm = new Standard_Inspection_Item__c();
	 	stdVisitItm.Name = 'Test Name';
	 	stdVisitItm.Description__c = 'Test Desc';
	 	stdVisitItm.Guidance__c = 'This is a test Guidance';
	 	stdVisitItm.Category__c ='Inspections';
	 	stdVisitItm.StdVisitItemRandom__c = false;
	 	stdVisitItm.StdVisitItemRandomDomainName__c = '';
	 	stdVisitItm.StdVisitItemReg__c = '7.27;7.27(a)';
	 	stdVisitItm.StdVisitItemTool__c = 'FCC Progress Tool';
	 	
	 	insert stdVisitItm;
	 	
	 	stdVisitItm.StdVisitItemRandom__c = true;
	 	stdVisitItm.StdVisitItemRandomDomainName__c = 'Administration';
	 	
	 	update stdVisitItm;
        
       
	 }

}