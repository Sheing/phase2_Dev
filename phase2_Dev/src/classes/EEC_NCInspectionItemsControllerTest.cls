/**
 * EEC_NCInspectionItemsControllerTest
 * 
 */

@isTest
public class EEC_NCInspectionItemsControllerTest {
	    
    static testMethod void testEEC_NCInspection() {
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        
        EEC_NCInspectionItemsController ctrl = new EEC_NCInspectionItemsController(sc);
    }
    
    static testMethod void testgetNCInspItemList(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        
        EEC_NCInspectionItemsController ctrl = new EEC_NCInspectionItemsController(sc);
        
        List<Inspection_Item__c> inspItems = ctrl.getNCInspItemList();
    }

    static testMethod void testgetNonCompliantItemList(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        
        EEC_NCInspectionItemsController ctrl = new EEC_NCInspectionItemsController(sc);
        
        List<Non_Compliant__c> ncItems = ctrl.getNonCompliantItemList();
    }

    static testMethod void testgetAllNonCompliantCombinedList(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        
        EEC_NCInspectionItemsController ctrl = new EEC_NCInspectionItemsController(sc);
        
        List<EEC_NCInspectionItemsController.NCInspectionItemsWrapper> ncCombinedItems = ctrl.getAllNonCompliantItemsCombined();
    }

    static testMethod void testNCInspectionItemsWrapper(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        
        test.startTest();
         Inspection_Item__c inspItem = [SELECT Id,Name,Inspection_No__r.Name, Inspection_No__r.Provider_No__c,Correction_Plan_Status__c,
         Inspection_No__r.Date_of_Visit__c,Key_Indicator__c,
                                       Inspection_No__c,RecordType.Name,Inspection_Item_Name__c,Additional_Inspection_Item_Name__c,Associated_regulation__c,
                                       Associated_regulation__r.name, Associated_regulation__r.Regulation_Number__c, Category_list__c,Description_of_inspection__c,Inspection_Result__c,Discussed__c,
                                       technical_assistance__c,observations__c,correction_plan__c,Corrective_Actions_Submitter__c,
                                       Corrective_Action_EEC_Feedback__c,Standard_Inspection_Item__c,Date_Implemented__c
                                       FROM Inspection_Item__c 
                                       WHERE Inspection_Result__c = 'Non-Compliant' AND Standard_Inspection_Item__c != null LIMIT 1];
                                       
        EEC_NCInspectionItemsController ctrl = new EEC_NCInspectionItemsController(sc);
        EEC_NCInspectionItemsController.NCInspectionItemsWrapper testCtrl = new EEC_NCInspectionItemsController.NCInspectionItemsWrapper(inspItem , null);
        System.assertNotEquals(testCtrl, null);
        test.stopTest();
    }
    
    static testMethod  void testupdaterequiredfeedback(){
        List<Non_Compliant__c> nonitems = new List<Non_Compliant__c>();
        Map<Id,Non_Compliant__c> oldMap = new Map<Id,Non_Compliant__c>();        
        Investigation__c inv = EEC_TestUtil.loadInvestigationSetup();  
        inv.isLegacyInvestigation__c = false; 
        inv.Created_on_the_Web__c = true;
		update inv; 
		        
        Non_Compliant__c ncc = EEC_TestUtil.mockNonCompliant(inv);  
        ncc.Correction_Plan__c = null;
        ncc.Date_Implemented__c = null;
        
        update ncc;
        
        Account acc = [SELECT id FROM ACCOUNT LIMIT 1];
        Inspection__c insp = EEC_TestUtil.mockInspection(acc);
        insp.Investigation__c = inv.id;
        update insp;
        test.startTest();
        
        ncc.Correction_Plan__c = EEC_TestUtil.generateRandomString(20);
        ncc.Date_Implemented__c = System.Today();
        update ncc;
        
        delete ncc; 
        test.stopTest();
        
        /*
        nonitems.add(updatedncc);
        
        EEC_NonComplaintItemTriggerHandler noncom = new EEC_NonComplaintItemTriggerHandler(nonitems,oldMap);
       	test.startTest();
        	noncom.updateRequireFeedback(); 
        	EEC_NonComplaintItemTriggerHandler.verifyDeleteForLegacyData(nonitems, oldMap);
        	test.stopTest();*/
        
    }
}