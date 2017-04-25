@isTest
public class EEC_PortalNonCompliancePageTest {
    
    public static testMethod void testEEC_PortalNonCompliancePageController() {
        PageReference pr = Page.EEC_PortalNonCompliancePage;
        Test.setCurrentPage(pr);
        ID accountid;  
        
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup(); 
        
        test.startTest();
        RecordType rType = [select Id from RecordType where SobjectType = 'Inspection_Item__c' and DeveloperName = 'Additional_Inspection_Item'];
        List<Inspection_Item__c> iItemList = [select Id,Inspection_No__r.Provider_No__c from Inspection_Item__c where Inspection_no__c = :insp.Id and RecordTypeId = :rType.Id];
        Inspection_Item__c iItem = iItemList.get(0);     
        accountid=insp.Provider_No__c;
        ApexPages.currentPage().getParameters().put('member',accountid);    
        EEC_PortalNonCompliancePageController ncomp = new EEC_PortalNonCompliancePageController();    
        ncomp = new EEC_PortalNonCompliancePageController();    
        Investigation__c inv = EEC_TestUtil.loadInvestigationSetup(); 
        Regulation__c reg =  EEC_TestUtil.mockRegulation();
        Non_Compliant__c nc = EEC_TestUtil.mockNonCompliant(inv);
        Non_Compliant_Item_Regulation__c ncr = EEC_TestUtil.mockNonCompliantItemRegulation(nc,reg);
        accountid=inv.Provider_No__c;
        ApexPages.currentPage().getParameters().put('member',accountid);    
        ApexPages.currentPage().getParameters().put('view','all');      
        EEC_PortalNonCompliancePageController ncomp2 = new EEC_PortalNonCompliancePageController();    
        ncomp2 = new EEC_PortalNonCompliancePageController();
        ncomp2.valcount = 10;
        test.stopTest();
    }           
    
    static testMethod void testSaveInspectionItems() {
        EEC_PortalNonCompliancePageController ncomp = new EEC_PortalNonCompliancePageController();
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        test.startTest();
        RecordType rType = [select Id from RecordType where SobjectType = 'Inspection_Item__c' and DeveloperName = 'Additional_Inspection_Item'];
        List<Inspection_Item__c> iItemList = [select Id,Inspection_No__r.Provider_No__c,Associated_regulation__c,Associated_regulation__r.Regulation_Number__c,
                                              Inspection_No__r.Name,Inspection_No__r.Investigation__r.Name,Inspection_No__r.Investigation__c,Date_Implemented__c,
                                              Inspection_No__r.Date_Of_Visit__c,Inspection_No__r.Investigation__r.Closed_Date__c,observations__c,correction_plan__c,
                                              Corrective_Action_EEC_Feedback__c,Description_of_inspection__c,Inspection_No__r.Status__c,Inspection_No__r.Visit_Tool_Used__r.Name,
                                              Inspection_No__r.RecordType.Name,Inspection_No__r.Investigation__r.Investigation_Status__c,
                                              RecordTypeId, RecordType.Name from Inspection_Item__c where Inspection_no__c = :insp.Id and RecordTypeId = :rType.Id];
        
        Inspection_Item__c inspItem = iItemList[0];       
        Investigation__c inv = EEC_TestUtil.loadInvestigationSetup(); 
        Regulation__c reg =  EEC_TestUtil.mockRegulation();
        Non_Compliant__c nc = EEC_TestUtil.mockNonCompliant(inv);
        Non_Compliant_Item_Regulation__c ncr = EEC_TestUtil.mockNonCompliantItemRegulation(nc,reg);
        
        
        List<EEC_PortalNonCompliancePageController.InspectionListWrapper> iiWrapperList = new List<EEC_PortalNonCompliancePageController.InspectionListWrapper>();
        List<EEC_PortalNonCompliancePageController.ComplainceListWrapper> ncWrapperList = new List<EEC_PortalNonCompliancePageController.ComplainceListWrapper>();       
        
        // Create a new wrapper list for the controller.
        iiWrapperList = new List<EEC_PortalNonCompliancePageController.InspectionListWrapper>();
        ncWrapperList = new List<EEC_PortalNonCompliancePageController.ComplainceListWrapper>();
        
        // Create and add a new InspectionListWrapper.
        EEC_PortalNonCompliancePageController.InspectionListWrapper ilw = new EEC_PortalNonCompliancePageController.InspectionListWrapper(0, inspItem, null);
        iiWrapperList.add(ilw);
        EEC_PortalNonCompliancePageController.ComplainceListWrapper clw = new EEC_PortalNonCompliancePageController.ComplainceListWrapper(0, nc, null);
        ncWrapperList.add(clw);
        
        ncomp.iiWrapperList =iiWrapperList;
        ncomp.ncWrapperList =ncWrapperList;
        ncomp.getitems();
        ncomp.Cancel();
        ncomp.Save();   
        test.stopTest();
        
    }
    @isTest static void testGeneratePDF() {
        Account prov = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC');
        Investigation__c inv = EEC_TestUtil.loadInvestigationSetup(); 
        Regulation__c reg =  EEC_TestUtil.mockRegulation();
        Non_Compliant__c nc = EEC_TestUtil.mockNonCompliant(inv);
        Non_Compliant_Item_Regulation__c ncr = EEC_TestUtil.mockNonCompliantItemRegulation(nc,reg);
        
        nc = [SELECT Id, Investigation__r.Provider_No__c FROM Non_Compliant__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('member', nc.Investigation__r.Provider_No__c);
        ApexPages.currentPage().getParameters().put('mode','accountid');   
        EEC_PortalNonCompliancePageController ncomp = new EEC_PortalNonCompliancePageController();
        ncomp.generatePDF();
        ncomp.returnProvider();
    }
    @isTest static void testGetNonComplaintItems() {
        Account prov = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC');
        Investigation__c inv = EEC_TestUtil.loadInvestigationSetup(); 
        Regulation__c reg =  EEC_TestUtil.mockRegulation();
        Non_Compliant__c nc = EEC_TestUtil.mockNonCompliant(inv);
        Non_Compliant_Item_Regulation__c ncr = EEC_TestUtil.mockNonCompliantItemRegulation(nc,reg);
        
        nc = [SELECT Id, Investigation__r.Provider_No__c FROM Non_Compliant__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('member', nc.Investigation__r.Provider_No__c);    
        EEC_PortalNonCompliancePageController ncomp = new EEC_PortalNonCompliancePageController();
        ncomp.generatePDF();
        ncomp.returnProvider();
    } 
    @isTest static void testSaveForLater() {
        Account prov = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC');
        Investigation__c inv = EEC_TestUtil.loadInvestigationSetup(); 
        Regulation__c reg =  EEC_TestUtil.mockRegulation();
        Non_Compliant__c nc = EEC_TestUtil.mockNonCompliant(inv);
        Non_Compliant_Item_Regulation__c ncr = EEC_TestUtil.mockNonCompliantItemRegulation(nc,reg);
        
        nc = [SELECT Id, Investigation__r.Provider_No__c FROM Non_Compliant__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('member', nc.Investigation__r.Provider_No__c);    
        EEC_PortalNonCompliancePageController ncomp = new EEC_PortalNonCompliancePageController();
        ncomp.generatePDF();
        ncomp.ReturnToProvider();  
    }   
    
    static testMethod void testInspectionListWrapper() {
        new EEC_PortalNonCompliancePageController.InspectionListWrapper(0, new Inspection_Item__c(), null);
    } 
}