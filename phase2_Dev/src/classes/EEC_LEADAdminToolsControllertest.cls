@isTest
public class EEC_LEADAdminToolsControllertest {
 static testMethod void testLEADAdminTools() {
       	Test.startTest();    
        
        EEC_LEADAdminToolsController leadadmin = new EEC_LEADAdminToolsController();       
       	leadadmin.loadFCCDLTools ();
        leadadmin.loadGSADLTools();
        leadadmin.loadResidentialDLTools();
        leadadmin.loadPlacementDLTools();
      
     Test.stopTest(); 
 }
}