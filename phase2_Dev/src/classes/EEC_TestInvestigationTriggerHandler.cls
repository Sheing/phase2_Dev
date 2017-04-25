@isTest
public class EEC_TestInvestigationTriggerHandler {
    static testMethod void investigationtrigger(){
        City__c  c = EEC_TestUtil.mockCity();
        Account a = EEC_TestUtil.mockProvider(c);
        Contact con  = EEC_TestUtil.mockContact();
        User u = EEC_TestUtil.mockUser();
        Investigation__c inve = new Investigation__c(Provider_No__c = a.Id, Assigned_To__c=u.Id);
        inve.X1st_Escalation_Approver_Completed__c = false;
        insert inve;
        
        Task task = EEC_TestUtil.mockTask(inve);
        Case cas = EEC_TestUtil.mockCase(a, con, inve);
        //Inspection__c insp = EEC_TestUtil.mockInspection(a);
        
        test.startTest(); 
        
        inve.Approval_Task_Creation__c = 'NonEscalated Approved';
        inve.Assigned_To__c = null;  
        inve.X1st_Escalation_Approver_Completed__c = true;
        inve.Assigned_To__c=u.Id;
        EEC_InvestigationTriggerHandler.FirstRun = true;
        update inve;  
        
        system.debug('inv.X1st_Escalation_Approver_Completed__c: ' + inve.X1st_Escalation_Approver_Completed__c);
        
        test.stopTest();        
    }
    
    static testMethod void investemailoutofoffice(){
        City__c  c = EEC_TestUtil.mockCity();
        Account a = EEC_TestUtil.mockProvider(c);
        
        User tempUser = new User(id = UserInfo.getUserId() , Out_of_Office__c = true,ManagerID = (EEC_TestUtil.mockUser()).id);
        update tempUser;
        
        Investigation__c inv = new Investigation__c(Provider_No__c = a.Id, Assigned_To__c=Userinfo.getUserId());
        inv.X1st_Escalation_Approver_Completed__c = false;
        insert inv;
        
        test.startTest();
        
        inv.Created_on_the_Web__c = false;
        inv.Out_Of_Office_Initial_Recipient__c = UserInfo.getUserId();
        inv.Out_Of_Office_Email_Template_To_Send_del__c = 'X25_Investigation_Approval_Investigation_sent_for_review_and_approval';
        inv.X1st_Escalation_Approver_Completed__c = true;
        
        update inv;
        
        system.debug('inv.X1st_Escalation_Approver_Completed__c: ' + inv.X1st_Escalation_Approver_Completed__c);
        test.stopTest();        
    }
}