/**
 * EEC_CorrectiveActionReviewControllerTest 
 * 
 * This class contains all the unit test behaviour for the EEC_CorrectiveActionReviewController class.
 * @author Darkis
 */

@isTest
private class EEC_CorrectiveActionReviewControllerTest {
    
    static ApexPages.StandardController setupTest() {
        // Setup basic defaults.
        ApexPages.StandardController sc = new ApexPages.StandardController(EEC_TestUtil.loadInspectionSetup());
        return sc;
    }

/*    static testMethod void testGetInspectionItemData() {
        ApexPages.StandardController sc = EEC_CorrectiveActionReviewControllerTest.setupTest();
        // Call constructor
        new EEC_CorrectiveActionReviewController(sc);
        // Check apex messages for failed message.
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
		System.assertNotEquals(0, pageMessages.size());
		// Check that the error message you are expecting is in pageMessages
		Boolean messageFound = false;
		// Loop through the page messages to assert the one we are looking for is found.
		for(ApexPages.Message message : pageMessages) {
    		if(message.getSummary() == 'This functionality is not available for a Closed or Cancelled Visit, Visit must first be re-opened by a Supervisor or Director.' 
               && message.getSeverity() == ApexPages.Severity.ERROR) {
        		messageFound = true;        
    		}
		}	
        // Assert the message.
		//System.assert(messageFound);
    }*/
    
    static testMethod void testGetInspectionItemData(){
        ApexPages.StandardController sc = EEC_CorrectiveActionReviewControllerTest.setupTest();
        EEC_CorrectiveActionReviewController ctrl = new EEC_CorrectiveActionReviewController(sc);
        PageReference p = ctrl.getInspectionItemData();
    }

    static testMethod void testSortExpression() {
        ApexPages.StandardController sc = EEC_CorrectiveActionReviewControllerTest.setupTest();
        EEC_CorrectiveActionReviewController ctrl = new EEC_CorrectiveActionReviewController(sc);
        // Test setting and getting sortExpression.
        ctrl.sortExpression = 'ASC';
        System.assertEquals('ASC', ctrl.getSortDirection());
        // Check alternate flow for identical values.
        ctrl.sortExpression = 'ASC';
        System.assertEquals('DESC', ctrl.getSortDirection());
    }
    
    static testMethod void testSortDirection() {
        ApexPages.StandardController sc = EEC_CorrectiveActionReviewControllerTest.setupTest();
        EEC_CorrectiveActionReviewController ctrl = new EEC_CorrectiveActionReviewController(sc);
        // Test the sort direction default when no expression is present.
        ctrl.sortExpression = null;
        System.assertEquals(ctrl.getSortDirection(), 'ASC');
        // Set direction to DESC but expression is still null forcing ASC.
        ctrl.setSortDirection('DESC');
        System.assertEquals('ASC', ctrl.getSortDirection());
        // Set the sort expression to allow direction to proceed without being defaulted to ASC.
        ctrl.sortExpression = 'DESC';
        ctrl.setSortDirection('DESC');
        System.assertEquals('DESC', ctrl.getSortDirection());
    }
    

    static testMethod void testSave() {
        ApexPages.StandardController sc = EEC_CorrectiveActionReviewControllerTest.setupTest();
        EEC_CorrectiveActionReviewController ctrl = new EEC_CorrectiveActionReviewController(sc);
        // Call the save method.
        ctrl.Save();
    }
    
    static testMethod void testSaveAndCloseVisitMode() {
        ApexPages.StandardController sc = EEC_CorrectiveActionReviewControllerTest.setupTest();
        EEC_CorrectiveActionReviewController ctrl = new EEC_CorrectiveActionReviewController(sc);
        // Call the save and close visit method.
        ctrl.SaveAndCloseVisitMode();
    }
    
    @isTest static void testSaveInspectionItems() {
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        
        Test.startTest();
        Inspection_Item__c inspItem = [SELECT Id,Name,Inspection_No__r.Name, Inspection_No__r.Provider_No__c,Correction_Plan_Status__c,
                                       Inspection_No__c,RecordType.Name,Inspection_Item_Name__c,Additional_Inspection_Item_Name__c,Associated_regulation__c,
                                       Associated_regulation__r.name, Associated_regulation__r.Regulation_Number__c, Category_list__c,Description_of_inspection__c,Inspection_Result__c,Discussed__c,
                                       technical_assistance__c,observations__c,correction_plan__c,Corrective_Actions_Submitter__c,
                                       Corrective_Action_EEC_Feedback__c,Standard_Inspection_Item__c,Date_Implemented__c
                                       FROM Inspection_Item__c 
                                       WHERE Inspection_Result__c = 'Non-Compliant' AND Standard_Inspection_Item__c != null LIMIT 1];
        Inspection_Item__c inspItemDeleted = [SELECT Id,Name,Inspection_No__r.Name, Inspection_No__r.Provider_No__c,
                                       Correction_Plan_Status__c,
                                       Inspection_No__c,RecordType.Name,Inspection_Item_Name__c,Additional_Inspection_Item_Name__c,Associated_regulation__c,
                                       Associated_regulation__r.name, Associated_regulation__r.Regulation_Number__c, Category_list__c,Description_of_inspection__c,Inspection_Result__c,Discussed__c,
                                       technical_assistance__c,observations__c,correction_plan__c,Corrective_Actions_Submitter__c,
                                       Corrective_Action_EEC_Feedback__c,Standard_Inspection_Item__c,Date_Implemented__c
                                       FROM Inspection_Item__c
                                       WHERE Inspection_Result__c = 'Compliant' AND Standard_Inspection_Item__c != null
                                       AND Inspection_No__r.Provider_No__c =: inspItem.Inspection_No__r.Provider_No__c 
                                       LIMIT 1];
        
        insp = [SELECT Id,RecordType.Name,Mater_Visit_for_Res_Cluster_of_Visits__c,Provider_No__c,Can_be_Edited__c,Name
                           FROM Inspection__c WHERE ID =: inspItem.Inspection_No__c LIMIT 1];
        
        List<EEC_CorrectiveActionReviewController.InspectionListWrapper> iiWrapperList = new List<EEC_CorrectiveActionReviewController.InspectionListWrapper>();
        Set<Id> siSet = new Set<Id>();
        siSet.add(inspItem.Standard_Inspection_Item__c);
        siSet.add(inspItemDeleted.Standard_Inspection_Item__c);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        EEC_CorrectiveActionReviewController ctrl = new EEC_CorrectiveActionReviewController(sc);
        Map<Id, Map<String,String>> iRegMap = new Map<Id, Map<String,String>>();
        for(Junction_InspReg__c jir : [select Id,Regulation__c,Regulation__r.name, Regulation__r.Regulation_Number__c, Regulation__r.article__c,Standard_Inspection_Item__c from Junction_InspReg__c where Standard_Inspection_Item__c in :siSet]){
            Map<String,String> jiMap = new Map<String,String>();
            jiMap.put(jir.Regulation__r.Regulation_Number__c+',', jir.Regulation__c);
            iRegMap.put(jir.Standard_Inspection_Item__c,jiMap);    
        }
            
        
        // Create a new wrapper list for the controller.
        iiWrapperList = new List<EEC_CorrectiveActionReviewController.InspectionListWrapper>();
        // Create and add a new InspectionListWrapper.
        EEC_CorrectiveActionReviewController.InspectionListWrapper ilw = new EEC_CorrectiveActionReviewController.InspectionListWrapper(0, inspItem, iRegMap);
        iiWrapperList.add(ilw);
        // Create and add a new InspectionListWrapper that is expected to be deleted.
        EEC_CorrectiveActionReviewController.InspectionListWrapper ilwDeleted = new EEC_CorrectiveActionReviewController.InspectionListWrapper(0, inspItemDeleted, iRegMap);
        ilwDeleted.isDeleted = true;
        iiWrapperList.add(ilwDeleted);
        // Set the wrapper list in the controller.
        ctrl.iiWrapperList = iiWrapperList;
        // Attempt to update and save the items.
        ctrl.Save();
        Test.stopTest();
    }
    
    static testMethod void testInspectionListWrapper() {
        new EEC_CorrectiveActionReviewController.InspectionListWrapper(0, new Inspection_Item__c(), null);
    }
}