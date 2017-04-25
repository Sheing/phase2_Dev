@istest
public class EEC_ProcessLegacyVisitDatatest {
 static testMethod void processLegacyVisitsTest() {  
        
        City__c c = new City__c();
         c.name ='Bradford';
         c.State__c ='MA';
         insert c;
         
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
        a.License_Status__c = 'Licensed';
        a.Provider_Status__c = 'Current';
        a.Language__c = 'English';
        a.Preferred_Language__c = 'English';
        a.Provider_Address_1__c = 'street';
        a.Provider_City__c = c.id;
        a.State__c = 'MA';
        a.Provider_Zip_Code__c ='12345';
        a.Provider_No__c = '67890';
        insert a; 
        
        RecordType rt = [select Id from RecordType where Name = 'Legacy System Import Visit / Non Compliance' and sObjectType = 'Inspection__c' limit 1];
        List<Inspection__c> listInspection = new List<Inspection__c>();
        for(integer i=0;i<10;i++){
            Inspection__c legacyVisit = new Inspection__c();
            legacyVisit.Provider_No__c = a.id;
            legacyVisit.Comments__c = 'Test Comment';
            legacyVisit.Date_of_Visit__c = system.today() - 1;
            legacyVisit.Legacy_FCC_LM_Mobile_Visit__c = '67890|EEC-TAB065';
            legacyVisit.Status__c = 'Closed';
            legacyVisit.RecordTypeId = rt.Id;
            listInspection.add(legacyVisit);
        }
        insert listInspection ;
        
        
        
       
        
        EEC_HistoricalVisitStaging__c hv = new EEC_HistoricalVisitStaging__c();
        hv.EEC_VisitId__c = '12345';
        hv.EEC_ProgramId__c = '67890';
        hv.EEC_LeadReasonOfVisit__c = 'Renewal';
        hv.EEC_Comment__c = 'Test Comment';
        hv.EEC_VisitDate__c = system.today();
        hv.EEC_ComplianceCodeDesc__c = 'Compliance';
        hv.EEC_Visit_Processed__c = false;
          
        system.debug('****Result***:'+ hv);        
        
        insert hv;
           Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Small Group', null);
         
         Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Small_Group');
        accnt.Config_Record__c = config2.Id;
        accnt.Provider_No__c = 'test';
        update accnt;
         
        
         Inspection__c it = EEC_TestUtil.loadInspectionSetup(); 
          Test.startTest();
         it.Legacy_FCC_LM_Mobile_Visit__c = 'test1|test2';
         EEC_HistoricalVisitItemStaging__c hs = new EEC_HistoricalVisitItemStaging__c();
         hs.EEC_VisitHeaderId__c  = 'test1';
         hs.EEC_Hostname__c = 'test2';
      
         insert hs;
         
       
            EEC_HistoryOfNonComplianceStaging__c hvn = new EEC_HistoryOfNonComplianceStaging__c();
            hvn.CorrectionPlan__c = 'Test';
            hvn.VisitItem_Processed__c = false;
            //listNonComp.add(hvn);    
            insert hvn;          
       
        
         
         Regulation__c  reg = EEC_TestUtil.mockRegulation(); 
         
         
         EEC_ProcessLegacyVisitData.processLegacyVisits(hv);
         EEC_ProcessLegacyVisitData.processLegacyVisitItems(hs);
         EEC_ProcessLegacyVisitData.processLegacyNonComplianceVisits(hvn);
                      
       
           EEC_Batch_ProcessLegacyVisits bc = new EEC_Batch_ProcessLegacyVisits();
           Database.executeBatch(bc, 1);
        Test.stopTest();
         
        EEC_HistoricalVisitStaging__c result = [Select Id, EEC_VisitId__c,EEC_Visit_Processed__c From EEC_HistoricalVisitStaging__c Where id = :hv.Id];  
        
        system.debug('****Result2***:'+ result);  
          
        system.assert(result.EEC_Visit_Processed__c == true);
     }

}