@isTest
public class EEC_TestInterventionTriggerHandler {
    
    @isTest
    static void testInterventionSubmittedOutOfOffice() {
        Investigation__c  invest = EEC_TestUtil.loadInvestigationSetup();  
        Intervention__c inter = EEC_TestUtil.mockIntervention(invest); 
        Intervention__c it = [SELECT ID,Investigation__r.Assigned_To__c,RecordType.Name,Status__c
                              FROM Intervention__c WHERE Status__c != 'Submitted'
                              AND RecordType.Name = 'Internal Investigation' AND Investigation__r.Investigation_Status__c != 'Closed' AND
                              Investigation__r.Assigned_To__c != null AND Investigation__r.Assigned_To__r.IsActive = true
                              LIMIT 1];
        
        User leader = [SELECT Id, Out_Of_Office__c,ManagerId FROM User WHERE ID =: it.Investigation__r.Assigned_To__c];
        leader.Out_Of_Office__c = true;
        leader.ManagerId = EEC_TestUtil.mockUser().Id;
        update leader;
        
        it.Status__c = 'Submitted';
        
        update it;
    }
}