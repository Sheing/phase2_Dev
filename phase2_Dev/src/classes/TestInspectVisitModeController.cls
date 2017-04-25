/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestInspectVisitModeController {

    @isTest  static void testVisitModeController() {
        // Setup test defaults.
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        test.startTest();
        Inspection_Item__c inspItem = EEC_TestUtil.mockInspectionItem(insp, EEC_TestUtil.mockStdInspectionItem(), '', true, '');
        
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        pageRef.getParameters().put('correctionPlan','EEC Accepted');
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        List<InspectVisitModeController.InspectionListWrapper> iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();
        
        // Test the sort direction default when no expression is present.
        ivm.sortExpression = null;
        System.assertEquals(ivm.getSortDirection(), 'ASC');
       
        ivm.selectedCategoryFilter = 'NS';
        ivm.selectedResultFilter = 'NoneSelected';
        ivm.setSortDirection('ASC');
        ivm.sortExpression = 'name';
        // Call a 2nd time to hit alternate flow.
        ivm.sortExpression = 'name';
        ivm.getSortDirection();
        ivm.getCatFilterOptions();
        ivm.getFilterOptions();
        ivm.getInspectionItemData();
        ivm.lockVisitMode();
        ivm.Save();
        ivm.SaveAndCloseVisitMode();
        ivm.NewVisitItemTabletView();
        ivm.SaveItems(); 
        ivm.MarkSelectionCompliant();
        Test.stopTest();
        
        //System.assertNotEquals(null, ivm.SaveAndAddNewVisitItem());
        //System.assertEquals(null, ivm.MarkCompliant());
        
        
    }

    static testMethod void testStandardVistiModeSelectOption(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        insp = [SELECT Id,Start_Time__c,End_Time__c, Status__c, Provider_No__c,Provider_No__r.RecordType.Name, Name,Can_be_edited__c from Inspection__c where Id = :insp.Id];
        Inspection_Item__c inspItem = EEC_TestUtil.mockInspectionItem(insp, EEC_TestUtil.mockStdInspectionItem(), '', true, '');
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        List<InspectVisitModeController.InspectionListWrapper> iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();
        
        Test.startTest();
        System.assertNotEquals(ivm.getStdBestPractices(), null);
        pageRef.getParameters().put('reason','sbpDomain');
        pageRef.getParameters().put('mode','1');
        System.assertEquals(ivm.retrieveBestPracticeListForDomain(), null);
        ivm.SaveReason();
    }
    @isTest  static void testAddVisitModeController() {
        // Setup test defaults.
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        test.startTest();
        Inspection_Item__c inspItem = EEC_TestUtil.mockInspectionItem(insp, EEC_TestUtil.mockStdInspectionItem(), '', true, '');
        
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        pageRef.getParameters().put('correctionPlan','EEC Accepted');
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        List<InspectVisitModeController.InspectionListWrapper> iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();
        
        // Test the sort direction default when no expression is present.
        ivm.sortExpression = null;
        System.assertEquals(ivm.getSortDirection(), 'ASC');
       
        ivm.selectedCategoryFilter = 'NS';
        ivm.selectedResultFilter = 'NoneSelected';
        ivm.setSortDirection('ASC');
        ivm.sortExpression = 'name';
        // Call a 2nd time to hit alternate flow.
        
        ivm.getInspectionItemData();
        ivm.visitModeLocked = true;
        ivm.lockVisitMode();
        ivm.visitModeLocked = false;
        ivm.CancelAndCloseVisitMode();
        ivm.SaveItems();
        ivm.autoSave();
        ivm.MarkCompliantTabletView();
        Test.stopTest();
        
        
    }
    static testMethod void testDeleteVisitMode(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        insp = [select Id,Start_Time__c,End_Time__c, Status__c, Provider_No__c,Provider_No__r.RecordType.Name, Name,Can_be_edited__c from Inspection__c where Id = :insp.Id];
        Inspection_Item__c inspItem = EEC_TestUtil.mockInspectionItem(insp, EEC_TestUtil.mockStdInspectionItem(), '', true, '');
        Inspection_Item__c inspItemDeleted = EEC_TestUtil.mockInspectionItem(insp, EEC_TestUtil.mockStdInspectionItem(), '', true, '');
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        List<InspectVisitModeController.InspectionListWrapper> iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();

        Test.startTest();
        // Add a simple list to the controller.
	ivm.lockVisitMode();
        iiWrapperList.add(new InspectVisitModeController.InspectionListWrapper(0, new Inspection_Item__c(), null));
        ivm.iiWrapperList = iiWrapperList;
        // Test the marking of a compliant. 
        ivm.MarkCompliant();
        // Assert that the wrapper list has at least one element.
        System.assert(ivm.iiWrapperList.size() > 0 ? true : false);
        for(InspectVisitModeController.InspectionListWrapper iiw : ivm.iiWrapperList) {
            System.assertEquals('Compliant', iiw.result);
            break;
        }
        
        // Create a new wrapper list for the controller.
        iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();
        // Create and add a new InspectionListWrapper.
        InspectVisitModeController.InspectionListWrapper ilw = new InspectVisitModeController.InspectionListWrapper(0, inspItem, null);
        iiWrapperList.add(ilw);
        // Create and add a new InspectionListWrapper that is expected to be deleted.
        InspectVisitModeController.InspectionListWrapper ilwDeleted = new InspectVisitModeController.InspectionListWrapper(0, inspItemDeleted, null);
        ilwDeleted.isDeleted = true;
        iiWrapperList.add(ilwDeleted);
        // Set the wrapper list in the controller.
        ivm.iiWrapperList = iiWrapperList;
        // Attempt to update and save the items.
        ivm.Save();
        ivm.filterCriteria = 'all'; 
        ivm.markBulkAssessForDomain();
        ivm.retrieveBestPracticeListForDomain();
        ivm.getStdBestPractices();
       
       // ivm.markBulkAssessForDomain(); 
        
        // Set a null deleteIndex for false path.
        ApexPages.currentPage().getParameters().put('deleteIndex','');
        System.assertEquals(null, ivm.DeleteInspectionItem());
        
        // Setup the positive path for DeleteInspectionItem().
        Test.stopTest();
    }


    static testMethod void testDeleteVisitMode1(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();  
         
        Test.startTest();  
        insp = [select Id, Provider_No__c,Provider_No__r.RecordType.Name, Name,Can_be_edited__c,Status__c,Start_Time__c from Inspection__c where Id = :insp.Id];
       
        Inspection_Item__c inspItem =[Select id ,name,RecordTypeId,RecordType.Name ,Date_Implemented__c,Observations__c,Non_Assessed_Item__c,Key_Indicator__c,Technical_Assistance__c,Correction_Plan__c,Inspection_Result__c,Discussed__c,Assessed_Date__c,Additional_Inspection_Item_Name__c,Description_of_inspection_list__c,Associated_regulation__c,Category_list__c,Associated_regulation__r.Regulation_Number__c from Inspection_Item__c limit 1];
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        ivm.selectedResultFilter = 'NoneSelected'; 
        ivm.selectedCategoryFilter ='NS';
         List<InspectVisitModeController.InspectionListWrapper> iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();

        // Add a simple list to the controller. 
        
        iiWrapperList.add(new InspectVisitModeController.InspectionListWrapper(0, new Inspection_Item__c(), null));
        ivm.iiWrapperList = iiWrapperList;
        // Test the marking of a compliant.
       ivm.MarkCompliant(); 
        ivm.lockVisitMode(); 
        // Assert that the wrapper list has at least one element.
       System.assert(ivm.iiWrapperList.size() > 0 ? true : false);
        for(InspectVisitModeController.InspectionListWrapper iiw : ivm.iiWrapperList) {
            System.assertEquals('Compliant', iiw.result);
            break;
        }  
        
        // Create a new wrapper list for the controller.
        iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();
        // Create and add a new InspectionListWrapper.
        InspectVisitModeController.InspectionListWrapper ilw = new InspectVisitModeController.InspectionListWrapper(0, inspItem, null);
        iiWrapperList.add(ilw);
        // Create and add a new InspectionListWrapper that is expected to be deleted.
        //InspectVisitModeController.InspectionListWrapper ilwDeleted = new InspectVisitModeController.InspectionListWrapper(0, inspItemDeleted, null);
        //ilwDeleted.isDeleted = true;
       // iiWrapperList.add(ilwDeleted); 
        // Set the wrapper list in the controller.
        ivm.iiWrapperList = iiWrapperList;
        // Attempt to update and save the items.
        
        
        ivm.SaveAndAddNewVisitItem();
        ivm.SaveAndAddNewBP();
        ivm.MarkBulkAssess();
        ivm.StartTimer();
        ivm.endTimer();
        ivm.showDesc();
        ivm.uploadAttachment();
        ivm.SaveBP();
        ivm.DeleteBP();
        Test.stopTest();
    }

    static testMethod void testVistiModeController(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        insp = [SELECT Id,Start_Time__c,End_Time__c, Status__c, Provider_No__c,Provider_No__r.RecordType.Name, Name,Can_be_edited__c from Inspection__c where Id = :insp.Id];
        Inspection_Item__c inspItem = EEC_TestUtil.mockInspectionItem(insp, EEC_TestUtil.mockStdInspectionItem(), '', true, '');
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        List<InspectVisitModeController.InspectionListWrapper> iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();
        
        Test.startTest();
        ivm.SaveAndAddNewBP();
        pageRef.getParameters().put('inspId',insp.Id);
        ivm.StartTimer();
        ivm.EndTimer();
        ivm.MarkCompliantTabletView();
    }
    static testMethod void testVistiModeControllerWithHelperClasses(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        insp = [SELECT Id,Start_Time__c,End_Time__c, Status__c, Provider_No__c,Provider_No__r.RecordType.Name, Name,Can_be_edited__c from Inspection__c where Id = :insp.Id];
        Inspection_Item__c inspItem = EEC_TestUtil.mockInspectionItem(insp, EEC_TestUtil.mockStdInspectionItem(), '', true, '');
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        List<InspectVisitModeController.InspectionListWrapper> iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();
        
        Test.startTest();
        ivm.SaveAndAddNewBP();
        pageRef.getParameters().put('ids',inspItem.Id);
        ivm.MarkSelectionCompliant();
        System.assertEquals(ivm.uploadAttachment(),null);
        Standard_Best_Practices__c stBP = new Standard_Best_Practices__c(
            Name  = 'test',
            Best_Practice_Guidance__c = 'test',
        	Domain__c = 'Administration');
        insert stBp;
        List<Standard_Best_Practices__c> lstbp = new List<Standard_Best_Practices__c>();
        lstbp.add(stBp);
        pageRef.getParameters().put('bpID',stBp.Id);
        pageRef.getParameters().put('optObservation',inspItem.Id);
        ivm.SaveBP();
        ivm.DeleteBP();
        ivm.processStdBestPractices(lstbp);
    }

    
    static testMethod void testVisitBestPractices(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();  
        Standard_Best_Practices__c stdbest = EEC_TestUtil.mockStdBestPractice();
        Visit_Best_Practices__c visitpratice = EEC_TestUtil.mockVisitBestPractice(insp,stdbest);
        Inspection_Item__c inspItem =[Select id ,name,RecordTypeId,RecordType.Name ,Date_Implemented__c,Observations__c,Non_Assessed_Item__c,Key_Indicator__c,Technical_Assistance__c,Correction_Plan__c,Inspection_Result__c,Discussed__c,Assessed_Date__c,Additional_Inspection_Item_Name__c,Description_of_inspection_list__c,Associated_regulation__c,Category_list__c,Associated_regulation__r.Regulation_Number__c from Inspection_Item__c limit 1];
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        pageRef.getParameters().put('bpID',visitpratice.Id);
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        ivm.DeleteBP();
        
        
        
    }
    
    
    static testMethod void testMarkSelectionCompliant(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();  
        test.startTest();
        Standard_Best_Practices__c stdbest = EEC_TestUtil.mockStdBestPractice();
        Visit_Best_Practices__c visitpratice = EEC_TestUtil.mockVisitBestPractice(insp,stdbest);
        Inspection_Item__c inspItem =[Select id ,name,RecordTypeId,RecordType.Name ,Date_Implemented__c,Observations__c,Non_Assessed_Item__c,Key_Indicator__c,Technical_Assistance__c,Correction_Plan__c,Inspection_Result__c,Discussed__c,Assessed_Date__c,Additional_Inspection_Item_Name__c,Description_of_inspection_list__c,Associated_regulation__c,Category_list__c,Associated_regulation__r.Regulation_Number__c from Inspection_Item__c limit 1];
        
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        pageRef.getParameters().put('ids',inspItem.id);
        
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        ivm.MarkSelectionCompliant();
        test.stopTest();
        
        
    }
    
    static testMethod void testDeleteNoneAssessed(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();  
         
        Test.startTest();  
        insp = [select Id, Provider_No__c,Provider_No__r.RecordType.Name, Name,Can_be_edited__c,Status__c,Start_Time__c from Inspection__c where Id = :insp.Id];
       
        Inspection_Item__c inspItem =[Select id ,name,RecordTypeId,RecordType.Name ,Date_Implemented__c,Observations__c,Non_Assessed_Item__c,Key_Indicator__c,Technical_Assistance__c,Correction_Plan__c,Inspection_Result__c,Discussed__c,Assessed_Date__c,Additional_Inspection_Item_Name__c,Description_of_inspection_list__c,Associated_regulation__c,Category_list__c,Associated_regulation__r.Regulation_Number__c from Inspection_Item__c limit 1];
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        ivm.selectedResultFilter = 'NonAssessed'; 
        ivm.selectedCategoryFilter ='NS';
         List<InspectVisitModeController.InspectionListWrapper> iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();

        // Add a simple list to the controller. 
        
        iiWrapperList.add(new InspectVisitModeController.InspectionListWrapper(0, new Inspection_Item__c(), null));
        ivm.iiWrapperList = iiWrapperList;
        // Test the marking of a compliant.
       ivm.MarkCompliant(); 
        ivm.lockVisitMode(); 
        // Assert that the wrapper list has at least one element.
       System.assert(ivm.iiWrapperList.size() > 0 ? true : false);
        for(InspectVisitModeController.InspectionListWrapper iiw : ivm.iiWrapperList) {
            System.assertEquals('Compliant', iiw.result);
            break;
        }  
        
        // Create a new wrapper list for the controller.
        iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();
        // Create and add a new InspectionListWrapper.
        InspectVisitModeController.InspectionListWrapper ilw = new InspectVisitModeController.InspectionListWrapper(0, inspItem, null);
        iiWrapperList.add(ilw);
        // Create and add a new InspectionListWrapper that is expected to be deleted.
        //InspectVisitModeController.InspectionListWrapper ilwDeleted = new InspectVisitModeController.InspectionListWrapper(0, inspItemDeleted, null);
        //ilwDeleted.isDeleted = true;
       // iiWrapperList.add(ilwDeleted); 
        // Set the wrapper list in the controller.
        ivm.iiWrapperList = iiWrapperList;
        // Attempt to update and save the items.
        
        
        ivm.SaveAndAddNewVisitItem();
        ivm.SaveAndAddNewBP();
        ivm.MarkBulkAssess();
        ivm.StartTimer();
        ivm.endTimer();
        ivm.showDesc();
        ivm.uploadAttachment();
        ivm.SaveBP();
        ivm.DeleteBP();
        Test.stopTest();
    }
    
     static testMethod void testKeyIndicators(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();  
         
        Test.startTest();  
        insp = [select Id, Provider_No__c,Provider_No__r.RecordType.Name, Name,Can_be_edited__c,Status__c,Start_Time__c from Inspection__c where Id = :insp.Id];
       
        Inspection_Item__c inspItem =[Select id ,name,RecordTypeId,RecordType.Name ,Date_Implemented__c,Observations__c,Non_Assessed_Item__c,Key_Indicator__c,Technical_Assistance__c,Correction_Plan__c,Inspection_Result__c,Discussed__c,Assessed_Date__c,Additional_Inspection_Item_Name__c,Description_of_inspection_list__c,Associated_regulation__c,Category_list__c,Associated_regulation__r.Regulation_Number__c from Inspection_Item__c limit 1];
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        ivm.selectedResultFilter = 'KeyIndicators'; 
        ivm.selectedCategoryFilter ='NS';
         List<InspectVisitModeController.InspectionListWrapper> iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();

        // Add a simple list to the controller. 
        
        iiWrapperList.add(new InspectVisitModeController.InspectionListWrapper(0, new Inspection_Item__c(), null));
        ivm.iiWrapperList = iiWrapperList;
        // Test the marking of a compliant.
       ivm.MarkCompliant(); 
        ivm.lockVisitMode(); 
        // Assert that the wrapper list has at least one element.
       System.assert(ivm.iiWrapperList.size() > 0 ? true : false);
        for(InspectVisitModeController.InspectionListWrapper iiw : ivm.iiWrapperList) {
            System.assertEquals('Compliant', iiw.result);
            break;
        }  
        
        // Create a new wrapper list for the controller.
        iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();
        // Create and add a new InspectionListWrapper.
        InspectVisitModeController.InspectionListWrapper ilw = new InspectVisitModeController.InspectionListWrapper(0, inspItem, null);
        iiWrapperList.add(ilw);
        // Create and add a new InspectionListWrapper that is expected to be deleted.
        //InspectVisitModeController.InspectionListWrapper ilwDeleted = new InspectVisitModeController.InspectionListWrapper(0, inspItemDeleted, null);
        //ilwDeleted.isDeleted = true;
       // iiWrapperList.add(ilwDeleted); 
        // Set the wrapper list in the controller.
        ivm.iiWrapperList = iiWrapperList;
        // Attempt to update and save the items.
        
        
        ivm.SaveAndAddNewVisitItem();
        ivm.SaveAndAddNewBP();
        ivm.MarkBulkAssess();
        ivm.StartTimer();
        ivm.endTimer();
        ivm.showDesc();
        ivm.uploadAttachment();
        ivm.SaveBP();
        ivm.DeleteBP();
        Test.stopTest();
    }
    
     static testMethod void testCompliant(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();  
         
        Test.startTest();  
        insp = [select Id, Provider_No__c,Provider_No__r.RecordType.Name, Name,Can_be_edited__c,Status__c,Start_Time__c from Inspection__c where Id = :insp.Id];
       
        Inspection_Item__c inspItem =[Select id ,name,RecordTypeId,RecordType.Name ,Date_Implemented__c,Observations__c,Non_Assessed_Item__c,Key_Indicator__c,Technical_Assistance__c,Correction_Plan__c,Inspection_Result__c,Discussed__c,Assessed_Date__c,Additional_Inspection_Item_Name__c,Description_of_inspection_list__c,Associated_regulation__c,Category_list__c,Associated_regulation__r.Regulation_Number__c from Inspection_Item__c limit 1];
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        ivm.selectedResultFilter = 'Non-Compliant'; 
        ivm.selectedCategoryFilter ='NS';
         List<InspectVisitModeController.InspectionListWrapper> iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();

        // Add a simple list to the controller. 
        
        iiWrapperList.add(new InspectVisitModeController.InspectionListWrapper(0, new Inspection_Item__c(), null));
        ivm.iiWrapperList = iiWrapperList;
        // Test the marking of a compliant.
       ivm.MarkCompliant();  
        ivm.lockVisitMode(); 
        // Assert that the wrapper list has at least one element.
       System.assert(ivm.iiWrapperList.size() > 0 ? true : false);
        for(InspectVisitModeController.InspectionListWrapper iiw : ivm.iiWrapperList) {
            System.assertEquals('Compliant', iiw.result);
            break;
        }  
        
        // Create a new wrapper list for the controller.
        iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();
        // Create and add a new InspectionListWrapper.
        InspectVisitModeController.InspectionListWrapper ilw = new InspectVisitModeController.InspectionListWrapper(0, inspItem, null);
        iiWrapperList.add(ilw);
        // Create and add a new InspectionListWrapper that is expected to be deleted.
        //InspectVisitModeController.InspectionListWrapper ilwDeleted = new InspectVisitModeController.InspectionListWrapper(0, inspItemDeleted, null);
        //ilwDeleted.isDeleted = true;
       // iiWrapperList.add(ilwDeleted); 
        // Set the wrapper list in the controller.
        ivm.iiWrapperList = iiWrapperList;
        // Attempt to update and save the items.
        
        
        ivm.SaveAndAddNewVisitItem();
        ivm.SaveAndAddNewBP();
        ivm.MarkBulkAssess();
        ivm.StartTimer();
        ivm.endTimer();
        ivm.showDesc();
        ivm.uploadAttachment();
        ivm.SaveBP();
        ivm.DeleteBP();
        Test.stopTest();
    }
    
    static testMethod void testNotAssessed(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();  
         
        Test.startTest();  
        insp = [select Id, Provider_No__c,Provider_No__r.RecordType.Name, Name,Can_be_edited__c,Status__c,Start_Time__c from Inspection__c where Id = :insp.Id];
       
        Inspection_Item__c inspItem =[Select id ,name,RecordTypeId,RecordType.Name ,Date_Implemented__c,Observations__c,Non_Assessed_Item__c,Key_Indicator__c,Technical_Assistance__c,Correction_Plan__c,Inspection_Result__c,Discussed__c,Assessed_Date__c,Additional_Inspection_Item_Name__c,Description_of_inspection_list__c,Associated_regulation__c,Category_list__c,Associated_regulation__r.Regulation_Number__c from Inspection_Item__c limit 1];
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        ivm.selectedResultFilter = 'NotAssessed'; 
        ivm.selectedCategoryFilter ='NS';
         List<InspectVisitModeController.InspectionListWrapper> iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();

        // Add a simple list to the controller. 
        
        iiWrapperList.add(new InspectVisitModeController.InspectionListWrapper(0, new Inspection_Item__c(), null));
        ivm.iiWrapperList = iiWrapperList;
        // Test the marking of a compliant.
       ivm.MarkCompliant();  
        ivm.lockVisitMode(); 
        // Assert that the wrapper list has at least one element.
       System.assert(ivm.iiWrapperList.size() > 0 ? true : false);
        for(InspectVisitModeController.InspectionListWrapper iiw : ivm.iiWrapperList) {
            System.assertEquals('Compliant', iiw.result);
            break;
        }  
        
        // Create a new wrapper list for the controller.
        iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();
        // Create and add a new InspectionListWrapper.
        InspectVisitModeController.InspectionListWrapper ilw = new InspectVisitModeController.InspectionListWrapper(0, inspItem, null);
        iiWrapperList.add(ilw);
        // Create and add a new InspectionListWrapper that is expected to be deleted.
        //InspectVisitModeController.InspectionListWrapper ilwDeleted = new InspectVisitModeController.InspectionListWrapper(0, inspItemDeleted, null);
        //ilwDeleted.isDeleted = true;
       // iiWrapperList.add(ilwDeleted); 
        // Set the wrapper list in the controller.
        ivm.iiWrapperList = iiWrapperList;
        // Attempt to update and save the items.
        
        
        ivm.SaveAndAddNewVisitItem();
        ivm.SaveAndAddNewBP();
        ivm.MarkBulkAssess();
        ivm.StartTimer();
        ivm.endTimer();
        ivm.showDesc();
        ivm.uploadAttachment();
        ivm.SaveBP();
        ivm.DeleteBP();
        Test.stopTest();
    }
    static testMethod void testNonCompliant(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();  
         
        Test.startTest();  
        insp = [select Id, Provider_No__c,Provider_No__r.RecordType.Name, Name,Can_be_edited__c,Status__c,Start_Time__c from Inspection__c where Id = :insp.Id];
       
        Inspection_Item__c inspItem =[Select id ,name,RecordTypeId,RecordType.Name ,Date_Implemented__c,Observations__c,Non_Assessed_Item__c,Key_Indicator__c,Technical_Assistance__c,Correction_Plan__c,Inspection_Result__c,Discussed__c,Assessed_Date__c,Additional_Inspection_Item_Name__c,Description_of_inspection_list__c,Associated_regulation__c,Category_list__c,Associated_regulation__r.Regulation_Number__c from Inspection_Item__c limit 1];
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        ivm.selectedResultFilter = 'Compliant';   
        ivm.selectedCategoryFilter ='NS';
         List<InspectVisitModeController.InspectionListWrapper> iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();

        // Add a simple list to the controller. 
        
        iiWrapperList.add(new InspectVisitModeController.InspectionListWrapper(0, new Inspection_Item__c(), null));
        ivm.iiWrapperList = iiWrapperList;
        // Test the marking of a compliant.
       ivm.MarkCompliant();  
        ivm.lockVisitMode(); 
        // Assert that the wrapper list has at least one element.
       System.assert(ivm.iiWrapperList.size() > 0 ? true : false);
        for(InspectVisitModeController.InspectionListWrapper iiw : ivm.iiWrapperList) {
            System.assertEquals('Compliant', iiw.result);
            break;
        }  
        
        // Create a new wrapper list for the controller.
        iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();
        // Create and add a new InspectionListWrapper.
        InspectVisitModeController.InspectionListWrapper ilw = new InspectVisitModeController.InspectionListWrapper(0, inspItem, null);
        iiWrapperList.add(ilw);
        // Create and add a new InspectionListWrapper that is expected to be deleted.
        //InspectVisitModeController.InspectionListWrapper ilwDeleted = new InspectVisitModeController.InspectionListWrapper(0, inspItemDeleted, null);
        //ilwDeleted.isDeleted = true;
       // iiWrapperList.add(ilwDeleted); 
        // Set the wrapper list in the controller.
        ivm.iiWrapperList = iiWrapperList;
        // Attempt to update and save the items.
        
        
        ivm.SaveAndAddNewVisitItem();
        ivm.SaveAndAddNewBP();
        ivm.MarkBulkAssess();
        ivm.StartTimer();
        ivm.endTimer();
        ivm.showDesc(); 
        ivm.uploadAttachment();
        ivm.SaveBP();
        ivm.DeleteBP(); 
        Test.stopTest();
    }
    
    
    static testMethod void testNotApplicable(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();  
         
        Test.startTest();  
        insp = [select Id, Provider_No__c,Provider_No__r.RecordType.Name, Name,Can_be_edited__c,Status__c,Start_Time__c from Inspection__c where Id = :insp.Id];
       
        Inspection_Item__c inspItem =[Select id ,name,RecordTypeId,RecordType.Name ,Date_Implemented__c,Observations__c,Non_Assessed_Item__c,Key_Indicator__c,Technical_Assistance__c,Correction_Plan__c,Inspection_Result__c,Discussed__c,Assessed_Date__c,Additional_Inspection_Item_Name__c,Description_of_inspection_list__c,Associated_regulation__c,Category_list__c,Associated_regulation__r.Regulation_Number__c from Inspection_Item__c limit 1];
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        ivm.selectedResultFilter = 'NotApplicable';   
        ivm.selectedCategoryFilter ='NS';
         List<InspectVisitModeController.InspectionListWrapper> iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();

        // Add a simple list to the controller. 
        
        iiWrapperList.add(new InspectVisitModeController.InspectionListWrapper(0, new Inspection_Item__c(), null));
        ivm.iiWrapperList = iiWrapperList;
        // Test the marking of a compliant.
       ivm.MarkCompliant();  
        ivm.lockVisitMode(); 
        // Assert that the wrapper list has at least one element.
       System.assert(ivm.iiWrapperList.size() > 0 ? true : false);
        for(InspectVisitModeController.InspectionListWrapper iiw : ivm.iiWrapperList) {
            System.assertEquals('Compliant', iiw.result);
            break;
        }  
        
        // Create a new wrapper list for the controller.
        iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();
        // Create and add a new InspectionListWrapper.
        InspectVisitModeController.InspectionListWrapper ilw = new InspectVisitModeController.InspectionListWrapper(0, inspItem, null);
        iiWrapperList.add(ilw);
        // Create and add a new InspectionListWrapper that is expected to be deleted.
        //InspectVisitModeController.InspectionListWrapper ilwDeleted = new InspectVisitModeController.InspectionListWrapper(0, inspItemDeleted, null);
        //ilwDeleted.isDeleted = true;
       // iiWrapperList.add(ilwDeleted); 
        // Set the wrapper list in the controller.
        ivm.iiWrapperList = iiWrapperList;
        // Attempt to update and save the items.
        
        
        ivm.SaveAndAddNewVisitItem();
        ivm.SaveAndAddNewBP();
        ivm.MarkBulkAssess();
        ivm.StartTimer();
        ivm.endTimer();
        ivm.showDesc();
        ivm.uploadAttachment();
        ivm.SaveBP();
        ivm.DeleteBP();
        Test.stopTest();
    }
    
    static testMethod void testsaveReason(){
         Inspection__c insp = EEC_TestUtil.loadInspectionSetup();  
        test.startTest();
        Inspection_Item__c inspItem =[Select id ,name,RecordTypeId,RecordType.Name ,Date_Implemented__c,Observations__c,Non_Assessed_Item__c,Key_Indicator__c,Technical_Assistance__c,Correction_Plan__c,Inspection_Result__c,Discussed__c,Assessed_Date__c,Additional_Inspection_Item_Name__c,Description_of_inspection_list__c,Associated_regulation__c,Category_list__c,Associated_regulation__r.Regulation_Number__c from Inspection_Item__c limit 1];
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        ivm.SaveReason();
        test.stopTest();
    }

    static testMethod void testprocessStdBestPractices(){   
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();  
       
        Standard_Best_Practices__c stdinsp = EEC_TestUtil.mockStdBestPractice();          
         test.startTest();  
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc); 
        List<Standard_Best_Practices__c> stdBestPractList; 
        stdBestPractList = [Select id ,Best_Practice_Guidance__c From Standard_Best_Practices__c Limit 1];
        ivm.processStdBestPractices(stdBestPractList);
        List<SelectOption> bestPRac = ivm.processStdBestPractices(stdBestPractList);
        test.stopTest();
    }    

    static testMethod void testVisitMode() {
		List<InspectVisitModeController.InspectionListWrapper> iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();

		Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        insp = [select Id,Start_Time__c,End_Time__c, Status__c, Provider_No__c,Provider_No__r.RecordType.Name, Name,Can_be_edited__c from Inspection__c where Id = :insp.Id];
		ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        
		List<Inspection_Item__c> iiList = [SELECT Id from Inspection_Item__c where Inspection_no__c = :insp.Id];
        ApexPages.currentPage().getParameters().put('deleteIndex','0');
        ApexPages.currentPage().getParameters().put('deleteId',iiList.get(0).Id);
        //ivm.iiWrapperList = iiWrapperList;
        ivm.DeleteInspectionItem();

    }
}