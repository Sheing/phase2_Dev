@isTest 
public class EEC_LoadDLToolsTest {
   
    static testMethod void eecloaddltools(){
        test.startTest();
    	List<VisitItemsStaging__c> visit = new List <VisitItemsStaging__c>();
         VisitItemsStaging__c visit1 = new VisitItemsStaging__c();
         visit1.Name = 'test';
         visit1.Description__c = 'testd';
         visit1.VisitItemToolAssignment__c = 'Residential gertg';
         visit1.VisitItemRegulation__c = 'regulation';
         Junction_InspReg__c vItmReg = new Junction_InspReg__c();
         vItmReg.Standard_Inspection_Item__c = visit1.Id; 
        
         visit.add(visit1); 
       		
         
         EEC_LoadDLTools.loadFCCDLTools(visit1);   
        test.stopTest();
  		    
}
    
}