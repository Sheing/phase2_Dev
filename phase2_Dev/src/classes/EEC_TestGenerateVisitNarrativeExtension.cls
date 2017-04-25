@isTest
public with sharing class EEC_TestGenerateVisitNarrativeExtension {

    @isTest static void testGetCompliantWithObservations(){
        Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()));
        Standard_Inspection_Item__c sii1 = EEC_TestUtil.mockStdInspectionItem();
        
        Regulation__c reg1 = EEC_TestUtil.mockRegulation();
        Regulation__c reg2 = EEC_TestUtil.mockRegulation();
        EEC_TestUtil.mockRegStdInsp(reg1, sii1);
        EEC_TestUtil.mockRegStdInsp(reg2, sii1);
        
         Inspection_Item__c ii1 = EEC_TestUtil.mockInspectionItem(i, sii1 , 'Compliant', false, null);
        Inspection_Item__c ii2 = EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation() , 'Non-Compliant', false, null);
        
        Inspection_Item__c ii = [SELECT Id, Inspection_No__r.Provider_No__c,Inspection_No__c FROM Inspection_Item__c 
                                WHERE Inspection_Result__c = 'Compliant' LIMIT 1];
        
        i = [SELECT Id,Mater_Visit_for_Res_Cluster_of_Visits__c,Provider_No__r.Umbrella_Members__c
                           FROM Inspection__c WHERE ID =: ii.Inspection_No__c LIMIT 1];
        
        //Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
        //EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null, 'My observation'); 
        //EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Compliant', false, null, null); 
        //EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Not Applicable', false, null, 'test'); 
        //EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Compliant', false, null, 'test 2'); 
        test.startTest();
        EEC_GenerateVisitNarrativePDFExtension ext = new EEC_GenerateVisitNarrativePDFExtension(new ApexPages.StandardController(i));
        
        List<EEC_GeneratePDFBase.VisitChecklistItemWrapper> l = ext.getCompliantWithObservations();
        test.stopTest();
        //System.assertEquals(2, l.size());
    }

    @isTest static void testGetProgramDirectorContactValid(){ 
        Account pa = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()); 
         
        Inspection__c i = EEC_TestUtil.mockInspection(pa);
        
        i = [SELECT Provider_No__r.Umbrella_Members__c FROM Inspection__c WHERE Id = :i.Id];
        
        Contact c = EEC_TestUtil.mockDirectorContact(pa);
        //AccountContactRole acr = EEC_TestUtil.mockAccountContactRole('Director', c, pa);
        test.startTest();
        EEC_GenerateVisitNarrativePDFExtension ext = new EEC_GenerateVisitNarrativePDFExtension(new ApexPages.StandardController(i));
        Contact result = ext.getDirectorContact();
        test.stopTest();
        System.assertEquals(c.FirstName, result.FirstName);
        System.assertEquals(c.Id, result.Id);
    }

    @isTest static void testGetProgramDirectorContactInvalid(){ 
        Account pa = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());  
         
        Inspection__c i = EEC_TestUtil.mockInspection(pa);
        
        i = [SELECT Provider_No__r.Umbrella_Members__c,Mater_Visit_for_Res_Cluster_of_Visits__c FROM Inspection__c WHERE Id = :i.Id];
        
        test.startTest();
        EEC_GenerateVisitNarrativePDFExtension ext = new EEC_GenerateVisitNarrativePDFExtension(new ApexPages.StandardController(i));
        Contact result = ext.getDirectorContact();
        
        List<Inspection__c> insp = ext.getChildVisits();
        test.stopTest();
        System.assertEquals(null, result ); 
    }


    @isTest static void testGetExecutiveDirectorContactValid(){ 
       
        Account a1 = new Account();
          RecordType r = [SELECT Id, Name FROM RecordType WHERE DeveloperName='Umbrella' and sobjecttype='Account'];
        a1.Name = 'Test Umbrella';
        a1.RecordTypeId = r.Id;
        a1.Provider_Address_1__c = 'Test';
        a1.Provider_City__c = EEC_TestUtil.mockCity().Id;
        a1.Provider_Zip_Code__c = '43433';
        insert a1;
        
         Account ca = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), a1);
        ca.Umbrella_Members__c = a1.Id;
        update ca;
        Inspection__c i = EEC_TestUtil.mockInspection(ca);
        
        i = [SELECT Provider_No__r.Umbrella_Members__c FROM Inspection__c WHERE Id = :i.Id];
        
        System.debug('-----Inspection__c: ' + i);
        
        Contact c = EEC_TestUtil.mockDirectorContact(ca);
        AccountContactRole acr = EEC_TestUtil.mockAccountContactRole('Director', c, ca);
        EEC_GenerateVisitNarrativePDFExtension ext = new EEC_GenerateVisitNarrativePDFExtension(new ApexPages.StandardController(i));
      //  ext.getExecutiveDirectorContact();
        System.debug('Ext: ' + ext);   
        Contact result = ext.getExecutiveDirectorContact();   
       
        
        //System.assertEquals(c.FirstName, result.FirstName);
        //System.assertEquals(c.Id, result.Id);
    }

    @isTest static void testGetExecutiveDirectorContactInvalid(){ 
        Account pa = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()); 
         
        Inspection__c i = EEC_TestUtil.mockInspection(pa);
        
        i = [SELECT Provider_No__r.Umbrella_Members__c FROM Inspection__c WHERE Id = :i.Id];
        
        Contact c = EEC_TestUtil.mockDirectorContact(pa);
        //AccountContactRole acr = EEC_TestUtil.mockAccountContactRole('Director', c, pa);
        EEC_GenerateVisitNarrativePDFExtension ext = new EEC_GenerateVisitNarrativePDFExtension(new ApexPages.StandardController(i));
        Contact result = ext.getExecutiveDirectorContact();
        
        System.assertEquals(null, result);
    }
   
}