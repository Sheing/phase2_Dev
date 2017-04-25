@isTest
public with sharing class EEC_TestInvGenerateCoverLetterExtension {
    
    @isTest 
    static void testGetDirectorContact() { 
        Account a = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
      // Contact c = EEC_TestUtil.mockDirectorContact(a);
        //AccountContactRole acr = EEC_TestUtil.mockAccountContactRole('Director', c, a);
        Investigation__c i = EEC_TestUtil.mockInvestigation(a);
        
        EEC_GenerateInvCoverLetterExtension ext = new EEC_GenerateInvCoverLetterExtension  (new ApexPages.StandardController(i));
         
        Contact co = ext.getDirectorContact();
                 
       // System.assertEquals(c.FirstName, co.FirstName);
      //  System.assertEquals(c.LastName, co.LastName); 
      //  System.assertEquals(c.Salutation, co.Salutation); 
        
        ext.getOldestCaseDate();
        ext.getCaseNumbers();
        ext.getProviderName();
        ext.getInvestigationNumber();
        ext.getOustandingComplianceIssues();
        ext.getInspecitonItems();
        
    }
    @isTest 
    static void InvestigationVisitChecklistItemWrappertest() { 
      /*
            Inspection__c insp = EEC_TestUtil.loadInspectionSetup(); 
         Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
       Inspection_Item__c it1 = new Inspection_Item__c();
          DATE d1 = date.today();
        Date d2 = d1.addMonths(- 11);
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
        it2.RecordTypeId = rt.id;   
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
        
       */
    }
}