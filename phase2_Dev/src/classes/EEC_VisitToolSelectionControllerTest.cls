@isTest 
public class EEC_VisitToolSelectionControllerTest {
    
    static testMethod void TestCopyStandardInspectionItems() {
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        test.startTest();
        insp.Type_of_Visit__c = 'Pre-Licensing';
        update insp;
        insp = [SELECT Id, Provider_No__c,Visit_Tool_Used__c, Provider_No__r.RecordType.Name, 
                Can_be_edited__c, Mater_Visit_for_Res_Cluster_of_Visits__c, Type_of_Visit__c 
                FROM Inspection__c 
                WHERE Id = :insp.Id];  
                
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        
        EEC_VisitToolSelectionController visitToolCtrl = new EEC_VisitToolSelectionController(sc);
        
        visitToolCtrl.populateLists();
       
         
        visitToolCtrl.recommendedTool = [SELECT Id, Name, No_of_Random_Items_Per_Domain_to_Pick__c
                                         FROM Standard_Checklist_Reference__c limit 1];
        for (EEC_VisitToolSelectionController.SCRWrapper scrw : visitToolCtrl.scrWrapperList) {
            scrw.selected = true;
        }
        //visitToolCtrl.copyInspectionItems();  
        
        //visitToolCtrl.selectedTool = 'FCC Enhanced Monitoring Tool';
        visitToolCtrl.selectedTool =  'Swimming pool checklist';
        visitToolCtrl.justificationText = 'test justification';
        //visitToolCtrl.switchTool();
        
        test.stopTest();
        System.debug('***UnitTest*** Switch tool done');
    }
    
    static testMethod void testIsItemAtRisk() {
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        test.startTest();
        EEC_VisitToolSelectionController visitToolCtrl = new EEC_VisitToolSelectionController(sc);
        test.stopTest();
        List<Inspection_Item__c> inspItem = [Select Id, Name, Inspection_No__r.Provider_No__r.Is_R_P__c, Inspection_No__r.Provider_No__r.Is_GSA__c, Inspection_No__r.Provider_No__r.Record_Type_Name__c, Associated_regulation__r.R_P_High_Risk_Reg__c, Associated_regulation__r.GSA_High_Risk_Reg__c, Associated_regulation__r.FCC_High_Risk_Reg__c From Inspection_Item__c Where Inspection_No__c = :insp.Id];
        System.assertEquals(visitToolCtrl.isItemAtRisk(inspItem[0], null), inspItem[0].Associated_regulation__r.FCC_High_Risk_Reg__c);
    }
    
    static testMethod void testIsNCItemAtRisk() {
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        test.startTest();
        Investigation__c invest = EEC_TestUtil.loadInvestigationSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        
        EEC_VisitToolSelectionController visitToolCtrl = new EEC_VisitToolSelectionController(sc);        
        test.stopTest();  
        Non_Compliant__c ncItem = EEC_TestUtil.mockNonCompliant(invest);
        Regulation__c reg = EEC_TestUtil.mockRegulation();  
        Non_Compliant_Item_Regulation__c ncItemReg = EEC_TestUtil.mockNonCompliantItemRegulation(ncItem, reg);
        
        System.assertEquals(visitToolCtrl.isNCItemAtRisk(ncItem, ncItemReg), false); 
        
    }
    
    static testMethod void testPopulateListwithSwitchToolWarningMessage() {
        //Prepare data
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        
        //Get visit tool
        //insp.Type_of_Visit__c = 'Pre-Licensing';
        insp.Visit_Tool_Used__c = [SELECT ID FROM Standard_Checklist_Reference__c limit 1].id;
        update insp; 
        
        PageReference pageRef = new Pagereference('/apex/EEC_VisitToolSwitchSelection');
        Test.setCurrentPage(pageRef);
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        EEC_VisitToolSelectionController visitToolCtrl = new EEC_VisitToolSelectionController(sc);
        
        Test.starttest();
        visitToolCtrl.populatelists();
        Test.stoptest();
    }
    
    static testMethod void testPopulateListwithSwitchTool() {
        //Prepare data
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup(); 
        Test.starttest();
        insp.Status__c = 'Closed';
        insp.Type_of_Visit__c = 'Pre-Licensing';
        update insp;
        
        Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
        
        
        DATE d1 = date.today();
        Date d2 = d1.addMonths(- 11);
        Inspection_Item__c it1 = new Inspection_Item__c();
        Recordtype rt = [select id,name from Recordtype where  (name = 'Standard Visit Item' OR name = 'Legacy System Import Visit / Non Compliance') AND SobjectType = 'Inspection_Item__c' ];
       // it1.RecordTypeId = rt.id;  
        it1.RecordTypeId  = Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('Standard Visit Item').getRecordTypeId();
        it1.Inspection_No__c = insp.id;
        it1.Inspection_Result__c = 'Non-Compliant';     
        it1.Observations__c = 'rtry';
        it1.Standard_Inspection_Item__c = stdIi.id;  
        it1.Assessed_Date__c = d2; 
        it1.Category_additional__c = 'Administration';
        
        Inspection_Item__c it2 = new Inspection_Item__c();
        Recordtype rt1 = [select id,name from Recordtype where  (name = 'Standard Visit Item' OR name = 'Legacy System Import Visit / Non Compliance') AND SobjectType = 'Inspection_Item__c' ];
      //  it2.RecordTypeId = rt.id;   
        it2.RecordTypeId  = Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('Non Standard Visit Item').getRecordTypeId();
        it2.Inspection_No__c = insp.id;  
        it2.Inspection_Result__c = 'Not Applicable';   
        it2.Observations__c = 'rty'; 
        it2.Standard_Inspection_Item__c = stdIi.id;   
        it2.Category_additional__c = 'Adoptive Children Records';
        
        List<Inspection_Item__c> ls1 = new List<Inspection_Item__c> (); 
        ls1.add(it1); 
        ls1.add(it2);
        
        insert ls1;   
       
        
        insp = [SELECT Id, Provider_No__c,Visit_Tool_Used__c, Provider_No__r.RecordType.Name, 
                Can_be_edited__c, Mater_Visit_for_Res_Cluster_of_Visits__c, Type_of_Visit__c  
                FROM Inspection__c 
                WHERE Id = :insp.Id];
        PageReference pageRef = new Pagereference('/apex/EEC_VisitToolSwitchSelection');
        
        pageRef.getParameters().put('mode','1');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        
        EEC_VisitToolSelectionController visitToolCtrl = new EEC_VisitToolSelectionController(sc);
        visitToolCtrl.populatelists();   
        
        
        Test.stoptest();
    }
    
    static testMethod void TestCopyStandardItems() {
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        test.startTest();
        insp.Type_of_Visit__c = 'Pre-Licensing';
        update insp;
        insp = [SELECT Id, Provider_No__c,Visit_Tool_Used__c, Provider_No__r.RecordType.Name, 
                Can_be_edited__c, Mater_Visit_for_Res_Cluster_of_Visits__c, Type_of_Visit__c 
                FROM Inspection__c 
                WHERE Id = :insp.Id];  
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        EEC_VisitToolSelectionController visitToolCtrl = new EEC_VisitToolSelectionController(sc);
        
        visitToolCtrl.populateLists();
        visitToolCtrl.recommendedTool = [SELECT Id, Name, No_of_Random_Items_Per_Domain_to_Pick__c
                                         FROM Standard_Checklist_Reference__c limit 1];
        for (EEC_VisitToolSelectionController.SCRWrapper scrw : visitToolCtrl.scrWrapperList) {
            scrw.selected = true;
            
        }
        Inspection_Item__c prevItem = new Inspection_Item__c();
        prevItem.Inspection_Result__c = 'Not Applicable';
        //visitToolCtrl.copyInspectionItems();  
       // visitToolCtrl.getAdditionalIneleigibilityCriteria();   
        //visitToolCtrl.switchTool(); 
        
       // visitToolCtrl.selectedTool = 'FCC Enhanced Monitoring Tool';    
        visitToolCtrl.selectedTool =  'on';
        visitToolCtrl.justificationText = 'test justification';
        //visitToolCtrl.switchTool();
        visitToolCtrl.getIsRecommendedToolAvailable();
        //visitToolCtrl.isSIISelected();
        test.stopTest();
        System.debug('***UnitTest*** Switch tool done');
    }
    
    static testMethod void testPopulateListwithActiveMode() {
        //Prepare data
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup(); 
        Test.starttest();
        insp.Status__c = 'Closed';
        insp.Type_of_Visit__c = 'Pre-Licensing';
        update insp;
        
        
        Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
        
        Regulation__c  reg= EEC_TestUtil.mockRegulation();
      
        Junction_InspReg__c jreg= EEC_TestUtil.mockRegStdInsp(reg,stdIi );
       // jreg.Regulation__c  = reg.id;
        reg.Name = 'test';
       //Regulation_Number__c
        reg.R_P_High_Risk_Reg__c = true;
        reg.GSA_High_Risk_Reg__c = true;
        reg.FCC_High_Risk_Reg__c = true;
        //jreg.Standard_Inspection_Item__c  = sii.id;
        update jreg;
        
        DATE d1 = date.today();
        Date d2 = d1.addMonths(- 11);
        Inspection_Item__c it1 = new Inspection_Item__c();
        Recordtype rt = [select id,name from Recordtype where  (name = 'Standard Visit Item' OR name = 'Legacy System Import Visit / Non Compliance') AND SobjectType = 'Inspection_Item__c' ];
       // it1.RecordTypeId = rt.id;  
        it1.RecordTypeId  = Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('Standard Visit Item').getRecordTypeId();
        it1.Inspection_No__c = insp.id;
        it1.Inspection_Result__c = 'Non-Compliant';     
        it1.Observations__c = 'rtry';
        it1.Standard_Inspection_Item__c = stdIi.id;  
        it1.Assessed_Date__c = d2; 
        it1.Associated_regulation__c = reg.Id;
        
        Inspection_Item__c it2 = new Inspection_Item__c();
        Recordtype rt1 = [select id,name from Recordtype where  (name = 'Standard Visit Item' OR name = 'Legacy System Import Visit / Non Compliance') AND SobjectType = 'Inspection_Item__c' ];
      //  it2.RecordTypeId = rt.id;   
        it2.RecordTypeId  = Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('Non Standard Visit Item').getRecordTypeId();
        it2.Inspection_No__c = insp.id;  
        it2.Inspection_Result__c = 'Not Applicable';   
        it2.Observations__c = 'rty'; 
        it2.Standard_Inspection_Item__c = stdIi.id;   
        it1.Associated_regulation__c = reg.Id;
        
        List<Inspection_Item__c> ls1 = new List<Inspection_Item__c> (); 
        ls1.add(it1); 
        ls1.add(it2);
        
        insert ls1;   
        
        Standard_Checklist_Reference__c scr1 = new Standard_Checklist_Reference__c(name='Swimming pool checklist',Active__c=true,Applicable_To__c='Family Child Care',No_of_Random_Items_Per_Domain_to_Pick__c=0);
        insert scr1;
        
        Standard_Checklist_Reference__c scr = new Standard_Checklist_Reference__c(name='Swimming pool checklist',Active__c = true, Applicable_To__c = 'Family Child Care', Available_for__c = 'Pre-Licensing',No_of_Random_Items_Per_Domain_to_Pick__c=0,Recommended_for__c ='Pre-Licensing',Longer_visit_if_Non_Compliant__c=scr1.id);
        insert scr;
       
        
        insp = [SELECT Id, Provider_No__c,Visit_Tool_Used__c, Provider_No__r.RecordType.Name,Provider_No__r.Additional_Ineligibility_Criteria__c, 
                Can_be_edited__c, Mater_Visit_for_Res_Cluster_of_Visits__c, Type_of_Visit__c  
                FROM Inspection__c 
                WHERE Id = :insp.Id];
        PageReference pageRef = new Pagereference('/apex/EEC_VisitToolSwitchSelection');
        
        pageRef.getParameters().put('mode','0');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        
        EEC_VisitToolSelectionController visitToolCtrl = new EEC_VisitToolSelectionController(sc);
        visitToolCtrl.populatelists();   
        visitToolCtrl.getAdditionalIneleigibilityCriteria();
        
        
        Test.stoptest();
    }
    
    static testMethod void validateNonCompliantRegulationstest() {
        //Prepare data
         Investigation__c invest = EEC_TestUtil.loadInvestigationSetup();
         
        Non_Compliant__c NC= EEC_TestUtil.mockNonCompliant(invest);
        
        list<Non_Compliant__c> NC1 = new list<Non_Compliant__c> ();
        NC1.add(NC);
        //insert NC1;
        
        Regulation__c  reg= EEC_TestUtil.mockRegulation();
         
        Non_Compliant_Item_Regulation__c ncir = EEC_TestUtil.mockNonCompliantItemRegulation(NC,reg); 
        reg.Name = 'test';
        reg.R_P_High_Risk_Reg__c = true;
        reg.GSA_High_Risk_Reg__c = true;
        reg.FCC_High_Risk_Reg__c = true;
        update ncir;
          
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup(); 
        Test.starttest();
        insp.Status__c = 'Closed';
        insp.Type_of_Visit__c = 'Pre-Licensing';
        update insp;
        
        Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
              
        Junction_InspReg__c jreg= EEC_TestUtil.mockRegStdInsp(reg,stdIi );
        reg.Name = 'test';
        reg.R_P_High_Risk_Reg__c = true;
        reg.GSA_High_Risk_Reg__c = true;
        reg.FCC_High_Risk_Reg__c = true;
        update jreg;
        
        DATE d1 = date.today();
        Date d2 = d1.addMonths(- 11);
        Inspection_Item__c it1 = new Inspection_Item__c();

        it1.RecordTypeId  = Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('Standard Visit Item').getRecordTypeId();
        it1.Inspection_No__c = insp.id;
        it1.Inspection_Result__c = 'Non-Compliant';     
        it1.Observations__c = 'rtry';
        it1.Standard_Inspection_Item__c = stdIi.id;  
        it1.Assessed_Date__c = d2; 
        it1.Associated_regulation__c = reg.Id;
        
        Inspection_Item__c it2 = new Inspection_Item__c();
        it2.RecordTypeId  = Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('Non Standard Visit Item').getRecordTypeId();
        it2.Inspection_No__c = insp.id;  
        it2.Inspection_Result__c = 'Not Applicable';   
        it2.Observations__c = 'rty'; 
        it2.Standard_Inspection_Item__c = stdIi.id;   
        it1.Associated_regulation__c = reg.Id;
        
        List<Inspection_Item__c> ls1 = new List<Inspection_Item__c> (); 
        ls1.add(it1); 
        ls1.add(it2);
        
        insert ls1;   
        
        Standard_Checklist_Reference__c scr1 = new Standard_Checklist_Reference__c(name='Swimming pool checklist',Active__c=true,Applicable_To__c='Family Child Care',No_of_Random_Items_Per_Domain_to_Pick__c=0);
        insert scr1;
        
        Standard_Checklist_Reference__c scr = new Standard_Checklist_Reference__c(name='Swimming pool checklist',Active__c = true, Applicable_To__c = 'Family Child Care', Available_for__c = 'Pre-Licensing',No_of_Random_Items_Per_Domain_to_Pick__c=0,Recommended_for__c ='Pre-Licensing',Longer_visit_if_Non_Compliant__c=scr1.id);
        insert scr;
       
        
        insp = [SELECT Id, Provider_No__c,Visit_Tool_Used__c, Provider_No__r.RecordType.Name,Provider_No__r.Additional_Ineligibility_Criteria__c, 
                Can_be_edited__c, Mater_Visit_for_Res_Cluster_of_Visits__c, Type_of_Visit__c  
                FROM Inspection__c 
                WHERE Id = :insp.Id];
        PageReference pageRef = new Pagereference('/apex/EEC_VisitToolSwitchSelection');
        
        pageRef.getParameters().put('mode','0');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        
        EEC_VisitToolSelectionController visitToolCtrl = new EEC_VisitToolSelectionController(sc);
        visitToolCtrl.populatelists();   
        visitToolCtrl.getAdditionalIneleigibilityCriteria();
        visitToolCtrl.validateNonCompliantRegulations(NC1);
       
        
        Test.stoptest();
    }
    static testMethod void switchTooltest() {
    
        DATE d1 = date.today();
        Date d2 = d1.addMonths(- 11);
        
        Account pAccount = new Account(
          name='TestProvider1',
          RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family Child Care').getRecordTypeId(),
          Provider_Email__c='test@test.com',
          Provider_Address_1__c='123 Test St',
          Provider_City__c= EEC_TestUtil.mockCity().Id,
          Provider_Zip_Code__c='B3H0A2');
        insert pAccount;
        
        Inspection__c insp = new Inspection__c(Provider_No__c=pAccount.Id,RecordTypeId=Schema.SObjectType.Inspection__c.getRecordTypeInfosByName().get('Investigation Visits').getRecordTypeId(),Status__c='Scheduled', Date_of_Visit__c=date.today(), Mater_Visit_for_Res_Cluster_of_Visits__c=null);
        insp.Type_of_Visit__c = 'Pre-Licensing';
        insert insp;
        
        List<Standard_Checklist_Reference__c> liststdChecklist = new List<Standard_Checklist_Reference__c>();
        
        Standard_Checklist_Reference__c scr = new Standard_Checklist_Reference__c(name='Swimming pool checklist',Active__c=true,Applicable_To__c='Large Group',No_of_Random_Items_Per_Domain_to_Pick__c=0);
        liststdChecklist.add(scr);
        scr = new Standard_Checklist_Reference__c(name='Swimming pool checklist',Active__c=true,Applicable_To__c='Family Child Care',No_of_Random_Items_Per_Domain_to_Pick__c=0);
        liststdChecklist.add(scr);
        scr = new Standard_Checklist_Reference__c(name = 'Swimming pool checklist', Active__c = true, Applicable_To__c = 'Family Child Care', Available_for__c = 'Pre-Licensing', No_of_Random_Items_Per_Domain_to_Pick__c = 0);
        liststdChecklist.add(scr);
        scr = new Standard_Checklist_Reference__c(name='Swimming pool checklist',Active__c = true, Applicable_To__c = 'Family Child Care', Available_for__c = 'Pre-Licensing',No_of_Random_Items_Per_Domain_to_Pick__c=6,Recommended_for__c ='Pre-Licensing');
        liststdChecklist.add(scr);
        scr = new Standard_Checklist_Reference__c(name='Swimming pool checklist',Active__c = true, Applicable_To__c = 'Family Child Care', Available_for__c = 'Pre-Licensing',No_of_Random_Items_Per_Domain_to_Pick__c=6,Recommended_for__c ='Pre-Licensing');
        liststdChecklist.add(scr);
        
        insert liststdChecklist;
        
        List<Standard_Inspection_Item__c> siiList = new List<Standard_Inspection_Item__c>();
        Standard_Inspection_Item__c sii = new Standard_Inspection_Item__c(name='Swimming pool security rules',Description__c='Check gates',Applicable_to__c='Family Child Care');
        siiList.add(sii);
        Standard_Inspection_Item__c sii2 = new Standard_Inspection_Item__c(name='Swimming pool written consent',Description__c='    Check written consent for children.',Applicable_to__c='Family Child Care');
        siiList.add(sii2);
        insert siiList;
        
        Regulation__c reg = new Regulation__c(name='Test Reg',Date_Active__c=Date.today(),Reg_key__c='123456',Article__c='TEST Article',Applicable_To__c='Family Child Care');
        reg.Name = 'test';
        reg.R_P_High_Risk_Reg__c = true;
        reg.GSA_High_Risk_Reg__c = true;
        reg.FCC_High_Risk_Reg__c = true;
        insert reg;
        
        List<Inspection_Item__c> iiList = new List<Inspection_Item__c>();
        
        Inspection_Item__c iItem = new Inspection_Item__c (Inspection_no__c = insp.Id,Category_additional__c = 'Legacy',Associated_regulation__c=reg.Id,RecordTypeId=Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('Non Standard Visit Item').getRecordTypeId(),Inspection_Result__c='Non-Compliant',Date_Implemented__c  = Date.Today(),Correction_Plan__c='Testing 1',observations__c='test',To_Review_on_Portal__c = true);
        Inspection_Item__c iItem1 = new Inspection_Item__c (Inspection_no__c = insp.Id,Category_additional__c = 'Legacy',Standard_Inspection_Item__c=siiList[1].Id,RecordTypeId=Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('Standard Visit Item').getRecordTypeId(),Inspection_Result__c='Non-Compliant',observations__c='test',Date_Implemented__c  = Date.Today(),Correction_Plan__c='Testing 2',To_Review_on_Portal__c = true);
        Inspection_Item__c iItem2 = new Inspection_Item__c (Inspection_no__c = insp.Id,Category_additional__c = 'Legacy',Standard_Inspection_Item__c=siiList[1].Id,RecordTypeId=Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('Standard Visit Item').getRecordTypeId(),Inspection_Result__c='Non-Compliant',observations__c='test',To_Review_on_Portal__c = true);
        Inspection_Item__c iItem3 = new Inspection_Item__c(Inspection_no__c = insp.Id,Category_additional__c = 'Legacy',Standard_Inspection_Item__c = siiList[1].Id, RecordTypeId = Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('Standard Visit Item').getRecordTypeId(), Inspection_Result__c = 'Non-Compliant', observations__c = 'test', To_Review_on_Portal__c = true);
        Inspection_Item__c iItem4 = new Inspection_Item__c(Inspection_no__c = insp.Id,Category_additional__c = 'Test',Standard_Inspection_Item__c = siiList[1].Id, RecordTypeId = Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('Standard Visit Item').getRecordTypeId(), Inspection_Result__c = 'Compliant', observations__c = 'test', To_Review_on_Portal__c = true);
        
        Inspection_Item__c it1 = new Inspection_Item__c();
        it1.RecordTypeId  = Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('Standard Visit Item').getRecordTypeId();
        it1.Inspection_No__c = insp.id;
        it1.Inspection_Result__c = 'Non-Compliant';     
        it1.Observations__c = 'rtry';
        it1.Standard_Inspection_Item__c = siiList[0].id;  
        it1.Category_additional__c = 'Legacy';
        it1.Assessed_Date__c = d2; 
        it1.Associated_regulation__c = reg.Id;
        it1.Visit_Mode_Ranking__c=999;
        
        Inspection_Item__c it2 = new Inspection_Item__c();
        it2.RecordTypeId  = Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('Non Standard Visit Item').getRecordTypeId();
        it2.Inspection_No__c = insp.id;  
        it2.Inspection_Result__c = 'Not Applicable';   
        it2.Category_additional__c = 'Legacy';
        it2.Observations__c = 'rty'; 
        it2.Standard_Inspection_Item__c = siiList[0].id;   
        it2.Associated_regulation__c = reg.Id;
        
        Inspection_Item__c it3 = new Inspection_Item__c();
        it3.RecordTypeId  = Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('Non Standard Visit Item').getRecordTypeId();
        it3.Inspection_No__c = insp.id;  
        it3.Inspection_Result__c = 'Non-Compliant';   
        it3.Category_additional__c = 'Legacy';
        it3.Observations__c = 'rty'; 
        it3.Standard_Inspection_Item__c = siiList[0].id;   
        it3.Associated_regulation__c = reg.Id;

        iiList.add(iItem);
        iiList.add(iItem1);
        iiList.add(iItem2);
        iiList.add(iItem3);
        iiList.add(iItem4);
        iiList.add(it1 );
        iiList.add(it2);
        iiList.add(it3);
        insert iiList;
        
        List<Junction_ChklInsp__c> jcList = new List<Junction_ChklInsp__c>();
        Junction_ChklInsp__c jc = new Junction_ChklInsp__c(Standard_Inspection_Item__c=siiList[0].Id,Standard_Checklist_Reference__c=liststdChecklist[2].Id);
        Junction_ChklInsp__c jc1 = new Junction_ChklInsp__c(Standard_Inspection_Item__c=siiList[1].Id,Standard_Checklist_Reference__c=liststdChecklist[3].Id);
        Junction_ChklInsp__c jc2 = new Junction_ChklInsp__c(Standard_Inspection_Item__c=siiList[1].Id,Standard_Checklist_Reference__c=liststdChecklist[4].Id);
        Junction_ChklInsp__c checklist = new Junction_ChklInsp__c(Visit_Mode_Ranking__c = 5, Standard_Inspection_Item__c = siiList[0].Id, Standard_Checklist_Reference__c = liststdChecklist[3].Id);
        jcList.add(jc);
        jcList.add(jc1);
        jcList.add(jc2);
        jcList.add(checklist);
        checklist = new Junction_ChklInsp__c(Visit_Mode_Ranking__c = 5, Standard_Inspection_Item__c = siiList[0].Id, Standard_Checklist_Reference__c = liststdChecklist[4].Id);
        jcList.add(checklist);
        
        insert jcList;
          
        insp = [SELECT Id, Provider_No__c,Visit_Tool_Used__c, Provider_No__r.RecordType.Name,
                Can_be_edited__c, Mater_Visit_for_Res_Cluster_of_Visits__c, Type_of_Visit__c 
                FROM Inspection__c 
                WHERE Id = :insp.Id];  
        
        Junction_InspReg__c jreg= EEC_TestUtil.mockRegStdInsp(reg,siiList[0]);
        
        test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        
        EEC_VisitToolSelectionController visitToolCtrl = new EEC_VisitToolSelectionController(sc);
        
        visitToolCtrl.populateLists();
        
        system.debug('visitToolCtrl.scrWrapperList: ' + visitToolCtrl.scrWrapperList.size());
        
        system.debug('visitToolCtrl.scrWrapperList: ' + visitToolCtrl.scrWrapperList);
        
        for (EEC_VisitToolSelectionController.SCRWrapper scrw : visitToolCtrl.scrWrapperList) {
            system.debug('scrw :' + scrw );
            scrw.selected = true;
        }

        visitToolCtrl.selectedTool =  'Swimming pool checklist';
        visitToolCtrl.justificationText = 'test justification'; 
        visitToolCtrl.copyInspectionItems();   
        visitToolCtrl.switchTool();        
        test.stopTest();
        System.debug('***UnitTest*** Switch tool done');
    }
}