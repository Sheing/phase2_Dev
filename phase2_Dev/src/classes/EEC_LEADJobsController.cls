//Author - Latha Davuluri
public with sharing class EEC_LEADJobsController {
         public void processLegacyUnlicensedProviders() {
            Database.executeBatch(new EEC_Batch_ProcessLegacyUnlicencdProvider(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Processing Legacy Unlicensed Providers...Please wait... !!!'));
         }
         public void processLegacyCases() {
            Database.executeBatch(new EEC_Batch_ProcessLegacyCases(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Processing Legacy Cases...Please wait... !!!'));
         }  
    
         public void processLegacyInvestigations() {
            Database.executeBatch(new EEC_Batch_ProcessLegacyInvestigations(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Processing Legacy Investigations...Please wait... !!!'));
         } 
         
         //Process Legacy Staff
         public void processLegacyStaff() {
            Database.executeBatch(new EEC_Batch_ProcessLegacyStaff(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Processing Legacy Staff...Please wait... !!!'));
         } 
         
         //Process Legacy Intervention
         public void processLegacyIntervention() {
            Database.executeBatch(new EEC_Batch_ProcessLegacyInterventions(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Processing Legacy Interventions...Please wait... !!!'));
         }
         
         //Process Legacy Follow
         public void processLegacyFollow() {
            Database.executeBatch(new EEC_Batch_ProcessLegacyFollow(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Processing Legacy Follow...Please wait... !!!'));
         }	   
    
         
         //Process Intake Legacy Intake Notes on Cases
         public void processLegacyIntakeNotes() {
            Database.executeBatch(new EEC_Batch_ProcessLegacyIntakeNotes(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Processing Legacy Intake Notes on Cases...Please wait... !!!'));
         }  

	 //Process LM 2010 Visit/ FCC Mobile Header Data
        public void processLegacyVisits() {
            Database.executeBatch(new EEC_Batch_ProcessLegacyVisits(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Processing Legacy Visits...Please wait... !!!'));
         }  
         
         //Process FCC Mobile Visit Item Data
        public void processLegacyVisitItems() {
            Database.executeBatch(new EEC_Batch_ProcessLegacyVisitItems(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Processing Legacy Visit Items...Please wait... !!!'));
         } 
         
         
          //Process EECRs Non-Complaince Visits Data
        public void processLegacyNonComplianceVisits() {
            Database.executeBatch(new EEC_Batch_ProcessLegacyNonCompVisits(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Processing EECRs Non-compliance Visits...Please wait... !!!'));
         } 
         
            //Process EECRs Non-Complaince Visit Items Data
        public void processLegacyNonComplianceVisitItems() {
            Database.executeBatch(new EEC_Batch_ProcessLegacyNonCompVisitItems(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Processing EECRs Non-compliance visit items...Please wait... !!!'));
         } 
            //This is to clear all staging data if there are any issues with import and need to start over. Qamar
        public void clearAllStagingRecords() {
            List<EEC_HistoricalVisitSubItemStaging__c> hvList1 = [SELECT ID FROM EEC_HistoricalVisitSubItemStaging__c];
            if(hvList1.size() > 10000){
                List<EEC_HistoricalVisitSubItemStaging__c> hvList1Sub = new List<EEC_HistoricalVisitSubItemStaging__c>();
                for(Integer i = 0; i < 10000; i++){
                    hvList1Sub.add(hvList1[i]);
                }
                try{
                    Delete hvList1Sub;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                    return;
                } catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                }
            } else if (hvList1.size() > 1) {
                try{
                    delete hvList1;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'EEC_HistoricalVisitSubItemStaging__c Records completely deleted.'));
                    return;
                } catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                }
            }
            

            List<EEC_HistoricalVisitItemStaging__c> hvList2 = [SELECT ID FROM EEC_HistoricalVisitItemStaging__c];
            if(hvList2.size() > 10000){
                List<EEC_HistoricalVisitItemStaging__c> hvList2Sub = new List<EEC_HistoricalVisitItemStaging__c>();
                for(Integer i = 0; i < 10000; i++){
                    hvList2Sub.add(hvList2[i]);
                }
                try{
                    delete hvList2Sub;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                    return;
                } catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                }
            } else if(hvList2.size() > 1) {
                try{
                    delete hvList2;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'EEC_HistoricalVisitItemStaging__c Records completely deleted.'));
                    return;
                } catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                }
            }

            List<EEC_HistoricalVisitStaging__c> hvList3 = [SELECT ID FROM EEC_HistoricalVisitStaging__c];
            if(hvList3.size() > 10000){
                List<EEC_HistoricalVisitStaging__c> hvList3Sub = new List<EEC_HistoricalVisitStaging__c>();
                for(Integer i = 0; i < 10000; i++){
                    hvList3Sub.add(hvList3[i]);
                }
                try{
                    Delete hvList3Sub;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                    return;
                } catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                }
            } else if(hvList3.size() > 1) {
                try{
                    delete hvList3;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'EEC_HistoricalVisitStaging__c Records completely deleted.'));
                    return;
                } catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                }
            }

            List<EEC_HistoryOfNonComplianceStaging__c> hvList4 = [SELECT ID FROM EEC_HistoryOfNonComplianceStaging__c];
            if(hvList4.size() > 10000){
                List<EEC_HistoryOfNonComplianceStaging__c> hvList4Sub = new List<EEC_HistoryOfNonComplianceStaging__c>();
                for(Integer i = 0; i < 10000; i++){
                    hvList4Sub.add(hvList4[i]);
                }
                try{
                    Delete hvList4Sub;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                    return;
                } catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                }
            } else if(hvList4.size() > 1) {
                try{
                    delete hvList4;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'EEC_HistoryOfNonComplianceStaging__c Records completely deleted.'));
                    return;
                } catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                }
            }
        } 

        public void deleteAllLegacyVisits() {
            List<Inspection__c> vList = [SELECT ID FROM Inspection__c WHERE RecordType.Name = 'Legacy System Import Visit / Non Compliance'];
            if(vList.size() > 10000){
                List<Inspection__c> vListSub = new List<Inspection__c>();
                for(Integer i = 0; i < 10000; i++){
                    vListSub.add(vList[i]);
                }
                try{
                    Delete vListSub;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                    return;
                } catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                }
            } else if(vList.size() > 1) {
                try{
                    delete vList;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Inspection__c Records completely deleted.'));
                    return;
                } catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                }
            }
        } 

        public void deleteAllLegacyInvestigations() {
            List<Investigation__c> vList = [SELECT ID FROM Investigation__c WHERE isLegacyInvestigation__c = true];
            if(vList.size() > 10000){
                List<Investigation__c> vListSub = new List<Investigation__c>();
                for(Integer i = 0; i < 10000; i++){
                    vListSub.add(vList[i]);
                }
                try{
                    Delete vListSub;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                    return;
                } catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                }
            } else if(vList.size() > 1) {
                try{
                    delete vList;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Investigation__c Records completely deleted.'));
                    return;
                } catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Records not completely deleted, try again'));
                }
            }
        } 
}