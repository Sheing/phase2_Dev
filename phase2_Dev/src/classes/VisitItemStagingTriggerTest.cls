@isTest
public with sharing class VisitItemStagingTriggerTest {
	
	 @isTest static void bulkInsertStandardVisitItemsTest() {
	 	
	    Standard_Checklist_Reference__c visitTool = new Standard_Checklist_Reference__c ();
        visitTool.Name = 'FCC Progress Tool';
        visitTool.Applicable_To__c = 'Family Child Care';
        visitTool.Recommended_for__c = 'Progress';
        visitTool.Available_for__c = 'Progress';
        insert visitTool;
         
        system.debug('***VisitTool'+visitTool); 
         
        Regulation__c reg = new Regulation__c();
        reg.Applicable_To__c = 'Family Child Care';
        reg.Name = '14.14';
        reg.Date_Active__c = system.today();
        reg.Reg_key__c = 'FGS-18';
        insert reg;
         
        Standard_Inspection_Item__c stdVItm = new Standard_Inspection_Item__c();
         
	 	stdVItm.Name = 'Test Name';
	 	stdVItm.Description__c = 'Test Description';
	 	stdVItm.Guidance__c = 'This is a test Guidance';
	 	stdVItm.Category__c ='Inspections';
	 	stdVItm.StdVisitItemReg__c = '14.14';
	 	stdVItm.StdVisitItemTool__c = 'FCC Progress Tool';
	 	
	   insert stdVItm;
         
       
       Standard_Inspection_Item__c stdVItm2 = stdVItm.clone();
       stdVItm2.Category__c ='Inspections2';  
       insert stdVItm2;
         
       Junction_ChklInsp__c visitToolAssgn = new Junction_ChklInsp__c();
       visitToolAssgn.Standard_Checklist_Reference__c = visitTool.Id;
       visitToolAssgn.Standard_Inspection_Item__c = stdVItm.Id;  
       
       insert visitToolAssgn;  
         
       visitItemsStaging__c vts = new visitItemsStaging__c();
	   vts.Name = 'Test Name';
	   vts.Description__c ='Test Description';
	   vts.Guidance__c ='This is a test guidance';
	   vts.IsRandomItem__c = true;
	   vts.RandomItemDomain__c ='Administration';
	   vts.ProviderType__c = 'Family Child Care';
	   vts.VisitItemDomain__c = 'Inspections';
	   vts.VisitItemRegulation__c ='14.14';
	   vts.VisitItemToolAssignment__c = 'FCC Progress Tool';
       vts.Override__c = false; 
        	
       insert vts;
         
       visitItemsStaging__c vts2 = vts.clone(); 
       vts2.VisitItemDomain__c = 'TestDomain2';
       insert vts2;  
       
       VisitItemsStaging__c vtsResult = [Select Id,Name,VisitItemRegulation__c,IsRandomItem__c From VisitItemsStaging__c Where id = :vts.Id];
         
       Standard_Inspection_Item__c stdVisitItm = [Select Id,Name,StdVisitItemReg__c,StdVisitItemRandom__c From Standard_Inspection_Item__c Where Name='Test Name' and Category__c ='TestDomain2'];
       
       Junction_InspReg__c vItmRegResult = [Select Standard_Inspection_Item__c, Regulation__c From Junction_InspReg__c Where Standard_Inspection_Item__c = :stdVItm2.Id];
	 
       system.debug('****visitTool.Id'+visitTool.Id);  
       Junction_ChklInsp__c visitToolResult = [Select Standard_Inspection_Item__c, Standard_Checklist_Reference__c  From  Junction_ChklInsp__c Where Standard_Inspection_Item__c = :stdVItm.Id and Standard_Checklist_Reference__c = :visitTool.Id];
           
       system.assert(vItmRegResult != null);  
       system.assert(stdVisitItm != null);
       //system.debug(visitToolResult != null);  
            
        //system.debug('***stdVisitItm.StdVisitItemRandom__c:'+stdVisitItm.StdVisitItemRandom__c);
        //system.debug('***vtsResult.IsRandomItem__c:'+vtsResult.IsRandomItem__c);
        system.assertEquals(stdVisitItm.StdVisitItemRandom__c, vtsResult.IsRandomItem__c); 
        
        VisitItemsStaging__c VIResult = [Select Id,Name From VisitItemsStaging__c Where name ='Test Name' and VisitItemDomain__c ='TestDomain2'];
     	
     	system.assert(VIResult != null);
     		
        Test.startTest();
     	  string SOQL = 'Select Id from VisitItemsStaging__c';
    	  Database.executeBatch(new Batch_CleanVisitItemStaging(SOQL),200); 
        Test.stopTest();
        List<VisitItemsStaging__c> VIResult2 = [Select Id,Name From VisitItemsStaging__c Where name = 'Test Name'];
        
     	system.assert(VIResult2.isEmpty());

     
         
	 	
	 }
	 

}