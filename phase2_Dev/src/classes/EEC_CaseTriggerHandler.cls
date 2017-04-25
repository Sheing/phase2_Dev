public without sharing class EEC_CaseTriggerHandler {
    List<Case> newCaseList;
    Map<Id, Case> oldCaseMap;
    Map<Id,city__c> cityMap;
    Map<Id,Account> accountMap;
    Map<Id,Contact> contactMap;
    Map<Id,String> cityRegionMap;
    Map<Id,Investigation__c> investigationMap;
    List<ProcessInstance> processList;
    Map<Id, User> userList;
    Map<Id, UserRole> userRoleList;
    Map<String, EmailTemplate> emailTemplateMap;
    public static boolean FirstRun {get; set;}
    public static boolean TestRun = false;
    List<OrgWideEmailAddress> orgList;
    
    //EmailTemplate template20 = [SELECT Body, Subject FROM EmailTemplate WHERE DeveloperName = 'X20_Case_Escalated_Approved_info_to_initial_requestor'];
    //EmailTemplate template21 = [SELECT Body, Subject FROM EmailTemplate WHERE DeveloperName = 'X21_Case_Escalated_Rejected_info_to_initial_requestor'];
    //EmailTemplate template22 = [SELECT Body, Subject FROM EmailTemplate WHERE DeveloperName = 'X22_Case_Escalated_Request_Recalled'];
    //EmailTemplate template13 = [SELECT Body, Subject FROM EmailTemplate WHERE DeveloperName = 'Test_13_Email_Template'];
    
    EmailTemplate template20,template21,template22,template18,template19,template14,template124,template49;

    /*public EEC_CaseTriggerHandler(List<Case> newList){
        this.newCaseList = newList;
        if(FirstRun == null){
            FirstRun = true;
        }
    }*/
    
    public EEC_CaseTriggerHandler(List<Case> newList, Map<Id, Case> oldList){
        this.newCaseList = newList;
        this.oldCaseMap = oldList;
        if(FirstRun == null){
            FirstRun = true;
        }
        
        if(UserInfo.getUserType() == 'Standard' && FirstRun == true){
            setup();
        }
    }
    public void checkProviderEditAccess(){
       Map<Id,UserRole> licensorRoles = new Map<Id,UserRole>([SELECT Id,name FROM UserRole WHERE Name Like '%Licensor' OR Name Like '%Supervisor' OR Name = 'Admin' OR Name = 'Investigator']);
       for(Case c : newCaseList){
           Case oldC = oldCaseMap.get(c.Id);
           if(oldC.Status == 'In Triage' && c.Triage_Responsible__c != UserInfo.getUserId() && licensorRoles.keySet().contains(System.UserInfo.getUserRoleId()) && c.Provider_Closed_Reminder__c == oldC.Provider_Closed_Reminder__c && c.Licensor_s_Manager_Email__c == oldc.Licensor_s_Manager_Email__c){
                c.addError('Changes are not allowed while In Triage. Please contact your administrator.');
           }
       }
    }
    public void closeTasksOnStatusChange(){
        List<Task> updateTask = new List<Task>();
        for(Case c : newCaseList){
            Case oldC = oldCaseMap.get(c.Id);
            if(oldC.Status == 'In Triage' && c.Status != 'In Triage'){
                List<Task> lstTasks = [SELECT Id,Status FROM Task WHERE WhatId =: c.Id AND Status != 'Completed'];
                if(lstTasks.size() > 0){
                    for(Task tsk : lstTasks){
                        tsk.Status = 'Completed';
                        updateTask.add(tsk);
                    }
                }
            }
        }
        if(updateTask.size() > 0){
            update updateTask;
        }
    }
    public void assignCaseOwnerByStatus(){
    	List<RecordType> transRecordTypeList = [select id from RecordType where name = 'Foster Home 51A or Incident' and SobjectType = 'Case'];
    	
        List<Case> lstCases = new List<Case>();
        for(Case c : newCaseList){
            Case oldC = oldCaseMap.get(c.Id);
            if(c.Status == 'Escalated'){
                if(c.X1st_Escalation_Case_Approver__c != null && !c.X1st_Escalation_Case_Approver_Completed__c)
                    c.OwnerId = c.X1st_Escalation_Case_Approver__c;
                if(c.X2nd_Escalation_Case_Approver__c != null && c.X1st_Escalation_Case_Approver_Completed__c)
                    c.OwnerId = c.X2nd_Escalation_Case_Approver__c;
            }
            else if(c.Status == 'Investigation in Progress'){
                if(c.Investigation__c != null){
                    Investigation__c i = investigationMap.get(c.Investigation__c);
                    if(i.Assigned_To__c != null)
                        c.OwnerId = i.Assigned_To__c;
                }
                System.debug('Case Owner Test-->' + c.OwnerId);
            }
            else if(c.Status == 'No Non-Compliance Closure Pending' || c.Status == 'In Triage'){
                if(c.Triage_Responsible__c != null)
                    c.OwnerId = c.Triage_Responsible__c;
                System.debug('Case Owner Test-->' + c.OwnerId);
            }
            else if(c.Status == 'Closed'){
                Account acc = accountMap.get(c.AccountId);
                c.OwnerId = acc.OwnerId;
            }
            else if(c.Status == 'Incident Reported' && oldC.Status == 'Not Submitted' && c.Origin == 'Web' && c.RecordTypeId == transRecordTypeList[0].Id){
            	Account acc = accountMap.get(c.AccountId);
            	c.Out_Of_Office_Email_Template_To_Send__c = 'X133_New_Foster_Home_51A_or_Incident_Submitted';
            	c.Out_Of_Office_Initial_Recipient_ID__c = acc.OwnerId;
            }
            else if(c.Status == 'Conclusions Submitted' && c.Origin == 'Web' && c.RecordTypeId == transRecordTypeList[0].Id){
            	Account acc = accountMap.get(c.AccountId);
            	c.Out_Of_Office_Email_Template_To_Send__c = 'X130_Investigation_conclusion_submitted_for_a_Foster_Home_51A_or_Incident_from';
            	c.Out_Of_Office_Initial_Recipient_ID__c = acc.OwnerId;
            }
        }
    }
    public void assignCaseOwner(){
        Map<Id, Region__c> lstRegions = new Map<Id, Region__c>([
            SELECT Id, SGLSA_New_Case_Default_Assignee__c, 
            FCC_New_Case_Default_Assignee__c,Deputy_Commissioner__c,
            R_P_New_Case_Default_Assignee__c 
            FROM Region__c
        ]);  
        Account acc;
        for(Case c : newCaseList){
            if(c.Status != 'Escalated' && c.Status != 'In Triage' && c.Status != 'Investigation in Progress' && c.Status != 'No Non-Compliance Closure Pending' && c.AccountId != null){
                if(accountMap == null)
                    accountBulAfter();
                acc = accountMap.get(c.AccountId);
                if(acc == null){
                    accountBulAfter();
                    acc = accountMap.get(c.AccountId);
                }
                Region__c lRegion = lstRegions.get(acc.Region__c);
                system.debug('***lRegion***'+lRegion);
                system.debug('****userList****'+userList);
                system.debug('****Account***'+acc.OwnerId);
                User licensor = userList.get(acc.OwnerId);
                system.debug('***licensor****'+licensor);
                if(lRegion != null && UserInfo.getUserId() != lRegion.Deputy_Commissioner__c){
                    if(c.AccountId != null && c.Unlicensed_Provider_Region__c == null){
                    	system.debug('****'+acc.Licensor_Full_Name__c);
                    	system.debug('****'+licensor);
                        if(acc.Licensor_Full_Name__c == 'LEAD System_Batch_User' || !licensor.IsActive){
                            if(acc.RecordType.Name == 'Large Group' || acc.RecordType.Name == 'Small Group'){
                                c.OwnerId = lRegion.SGLSA_New_Case_Default_Assignee__c;
                            }
                            else if(acc.RecordType.DeveloperName  == 'FCC' || acc.RecordType.Name  == 'FCC Assistant'){
                                c.OwnerId = lRegion.FCC_New_Case_Default_Assignee__c;
                            }
                            else if(acc.Is_R_P__c){
                                c.OwnerId = lRegion.R_P_New_Case_Default_Assignee__c;
                            }
                        }
                        else{
                            c.OwnerId = acc.OwnerId;
                        }
                    }
                    else if(c.Unlicensed_Provider_Region__c != null){
                        lRegion = lstRegions.get(c.Unlicensed_Provider_Region__c);
                        c.OwnerId = lRegion.FCC_New_Case_Default_Assignee__c;
                    }
                }
            }
        }
    }
        
    private void setup(){ 
        
        Set<Id> actors = new Set<Id>{};
        Set<Id> roleIds = new Set<Id>{};
        orgList = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'EEC LEAD Alert'];
        processList = new List<ProcessInstance>([
            SELECT Status, Id, TargetObject.Name, TargetObjectID, TargetObject.Type, 
            (SELECT OriginalActorId, ActorId FROM WorkItems ORDER BY CreatedDate DESC LIMIT 1)  
            FROM ProcessInstance
            WHERE TargetObjectId IN :newCaseList AND Status = 'Pending'
            ORDER BY CreatedDate DESC
        ]);
        
        for(Case c : newCaseList){
            if(c.OwnerId != null){
                actors.add(c.OwnerId);
            }
        }
        
        for(ProcessInstance pi : processList){
            if(pi.WorkItems.size() > 0){
                actors.add(pi.WorkItems[0].OriginalActorId);
                actors.add(pi.WorkItems[0].ActorId);
            }
        }
        
        userList = new Map<Id, User>([
            SELECT ManagerId, For_Portal_Email__c,IsActive,UserRoleId, Email, Name, DelegatedApproverId,Out_of_Office__c
            FROM User
           // WHERE Id IN :actors
            WHERE UserType = 'Standard'
        ]);
        
        System.debug('ACTORS---->'+actors);
        
        for(User u : userList.values()){
            roleIds.add(u.UserRoleId);
        }
        
        userRoleList = new Map<Id, UserRole>([
            SELECT Name
            FROM UserRole
            WHERE ID IN :roleIds
        ]); 
    }
    
    private class TestException extends Exception {}
    
    public void sendCaseEscalatedEmailToManagerOutofOffice(){
        for(Case c : newCaseList){
            Case oldC = oldCaseMap.get(c.Id);

            if(c.Out_Of_Office_Initial_Recipient_ID__c != null && oldC.Out_Of_Office_Initial_Recipient_ID__c == null && userList != null){
                User approver = userList.get(c.Out_Of_Office_Initial_Recipient_ID__c);
                //if(approver.Out_of_office__c){
                    EEC_EmailUtil email = new EEC_EmailUtil(); 
                    String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + c.Id;
                    template19 = emailTemplateMap.get(c.Out_Of_Office_Email_Template_To_Send__c);
                    
                    email.plainTextBody = template19.Body
                        .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c)
                        .replace('{!Case.OwnerFullName}', userList.get(c.OwnerId).Name)
                        .replace('{!Case.Reason_for_Detailed_Investigation__c}', (c.Reason_for_Detailed_Investigation__c == null ? '' : c.Reason_for_Detailed_Investigation__c))
                        .replace('{!Case.Id}', c.Id)
                        .replace('{!Case.Link}', fullRecordURL)
                    	.replace('{!Case.Account}', c.Provider_Name_For_Email_Merge__c);
                    	
                    email.subject = template19.Subject
                        .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c);
                    
                    email.toAddresses = new List<String>();
                    
                    if(approver.Out_of_office__c){
	                    if(userList.get(approver.ManagerId) != null){
	                        User manager = userList.get(approver.ManagerId);
	                        if(!manager.Out_of_office__c)
	                            email.toAddresses.add(manager.Email); 
	                        else if(manager.ManagerId != null){
	                            User managersManager = userList.get(manager.ManagerId);
	                            email.toAddresses.add(managersManager.Email); 
	                        }
	                    }
                    }
                    //else{
                	email.toAddresses.add(approver.Email);
                    //}
                    
                    email.whatId = c.Id;
                    email.saveAsActivity = false; 
                    if(orgList.size() > 0)
                        email.orgWideEmailId = orgList.get(0).Id;
                    
                    email.sendEmail();
                //}
                c.Out_Of_Office_Email_Template_To_Send__c = '';
                c.Out_Of_Office_Initial_Recipient_ID__c = '';
            }
        }
    }
    public void sendNonComplianceInjuryCaseClosureOutofOffice(){
        for(Case c : newCaseList){
            Case oldC = oldCaseMap.get(c.Id);
            if(c.Triage_Responsible__c != null && userList != null){
                System.debug('----------> TriageResponsible: ' + c.Triage_Responsible__c);
                System.debug('-------> UserList: ' + userList);
                User triageResponsible = userList.get(c.Triage_Responsible__c);
                if(c.Status == 'No Non-Compliance Closure Pending' && oldC.Status != 'No Non-Compliance Closure Pending' 
                   && triageResponsible.Out_of_Office__c){
                     
                    EEC_EmailUtil email = new EEC_EmailUtil(); 
                    String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + c.Id;
                    template14 = emailTemplateMap.get('X14_New_SLGSA_case_with_no_noncompliance_to_review_and_close');               
                    email.plainTextBody = template14.Body
                        .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c)
                        .replace('{!Case.Id}', c.Id)
                        .replace('{!Case.Link}', fullRecordURL);
                    
                    email.subject = template14.Subject
                        .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c);
                    
                    email.toAddresses = new List<String>();
                    
                    if(String.isNotBlank(triageResponsible.DelegatedApproverId)){
                        email.toAddresses.add(userList.get(triageResponsible.DelegatedApproverId).For_Portal_Email__c); 
                    }
                    else if(userList.get(triageResponsible.ManagerId) != null){
                        User manager = userList.get(triageResponsible.ManagerId);
                        if(!manager.Out_of_office__c){
                            email.toAddresses.add(manager.For_Portal_Email__c); 
                            System.debug('------> manager email: ' + manager.For_Portal_Email__c);
                        }
                        else if(manager.ManagerId != null){
                            User managersManager = userList.get(manager.ManagerId);
                            email.toAddresses.add(managersManager.For_Portal_Email__c); 
                            System.debug('------> managerManager email: ' + managersManager.For_Portal_Email__c);
                        }
                    }
                    
                    email.whatId = c.Id;
                    email.saveAsActivity = false; 
                    if(orgList.size() > 0)
                        email.orgWideEmailId = orgList.get(0).Id;
                    
                    email.sendEmail();
                }
            }
        }
    }
    
    private void sendTriageResultEmail(Case c, Case oldCase){ 
        if((oldCase == null || oldCase.SendCaseTriageEmail__c == null) && c.SendCaseTriageEmail__c != null){  
            EEC_EmailUtil email = new EEC_EmailUtil(); 
            String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + c.Id;
            if(emailTemplateMap == null)
                bulkBefore();
            if(c.SendCaseTriageEmail__c == 'Approved'){  
                
                // c.SendCaseTriageEmail__c = 'Approved and Email Triggered';
                template20 = emailTemplateMap.get('X20_Case_Escalated_Approved_info_to_initial_requestor');
                email.htmlBody = template20.Body
                    .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c)
                    .replace('{!Case.OwnerFullName}', userList.get(c.OwnerId).Name)
                    .replace('{!Case.Link}', fullRecordURL)
                    .replace('{!Case.Id}', c.Id);
                    
                email.subject = template20.Subject
                    .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c);
                    
            }
            else if (c.SendCaseTriageEmail__c == 'Recalled') {
            	template22 = emailTemplateMap.get('X22_Case_Escalated_Request_Recalled');
                email.htmlBody = template22.Body
                    .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c)
                    .replace('{!Case.OwnerFullName}', userList.get(c.OwnerId).Name)
                    .replace('{!Case.Id}', c.Id)
                    .replace('{!Case.Link}', fullRecordURL);
                    
                email.subject = template22.Subject
                    .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c);
            }
            else {
            	template21 = emailTemplateMap.get('X21_Case_Escalated_Rejected_info_to_initial_requestor');
                email.htmlBody = template21.Body
                    .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c)
                    .replace('{!Case.OwnerFullName}', userList.get(c.OwnerId).Name)
                    .replace('{!Case.Id}', c.Id)
                    .replace('{!Case.Link}', fullRecordURL);
                    
                email.subject = template21.Subject
                    .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c);
            }
            
            email.toAddresses = new List<String>();
            
            System.debug('Email Addresses--->' + c.TriageEscalationApproverEmailList__c);
            System.debug('New Address--->' + c.Provider_Address_For_Email_Merge__c);
            
            /*if(c.TriageEscalationApproverEmailList__c != null){
                if(c.TriageEscalationApproverEmailList__c.contains(',')) {
                    email.toAddresses.addAll(c.TriageEscalationApproverEmailList__c.split(',')); 
                } else {
                    email.toAddresses.add(c.TriageEscalationApproverEmailList__c); 
                }
            }*/
            User triageRes = userList.get(c.Triage_Responsible__c);
            email.toAddresses.add(triageRes.Email);
            
            /*if(userList.get(c.OwnerId).Email != null) 
                email.toAddresses.add(userList.get(c.OwnerId).Email);
            if(c.X1st_Escalation_Approver_Email_Address__c != null)
                email.toAddresses.add(c.X1st_Escalation_Approver_Email_Address__c);*/
            
            System.debug(email.toAddresses);
            
            email.orgWideEmailId = orgList.get(0).Id;
            email.whatId = c.Id;
            email.saveAsActivity = false; 
            email.sendEmail();
            
            // Now we also want to send out a special email just to the task Case owner 
            // and delegated approver, but we will use a different email template
            /*email.htmlBody = template18.Body
                .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c)
                .replace('{!Case.Id}', c.Id);
                    
            email.subject = template18.Subject
                .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c);

            System.debug('Second Email Sent------>');
            email.sendEmail();*/            
        }
    }
    
    public void sendInTriageEmail(){
        for(Case c : newCaseList) { 
            Case oldC = oldCaseMap.get(c.Id);
            if(c.Status == 'In Triage' && oldC.Status != 'In Triage' && oldC.Status != 'Escalated'){
            	EEC_EmailUtil email = new EEC_EmailUtil(); 
                email.whatId = c.Id;
                email.saveAsActivity = false; 
                
                email.toAddresses = new List<String>();
                if(c.Triage_Responsible__c != null) {
                    User triageResponsible = userList.get(c.Triage_Responsible__c);
                    email.toAddresses.add(triageResponsible.For_Portal_Email__c);  
                    //Delegated Approvers
                    if(triageResponsible.DelegatedApproverId != null){
                        email.toAddresses.add(userList.get(triageResponsible.DelegatedApproverId).For_Portal_Email__c);
                    }
                    if(triageResponsible.Out_of_Office__c && triageResponsible.ManagerId != null){
                        email.toAddresses.add(userList.get(triageResponsible.ManagerId).For_Portal_Email__c);
                    }
                }
                System.debug('email.toAddresses-->' + email.toAddresses);
                String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + c.Id;
                if(orgList.size() > 0)
                	email.orgWideEmailId = orgList.get(0).Id;
                template18 = emailTemplateMap.get('X18_Case_Escalated_New_Case_sent_to_Triage_for_Original_Assignee');
                email.plainTextBody = template18.Body
            	.replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c)
                .replace('{!Case.Link}', fullRecordURL)
                .replace('{!Case.Name}', c.CaseNumber);
                
                email.subject = template18.Subject
                .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c);
                
                email.sendEmail();
            }
        }
    }
    
    public void sendPortalInjuryIncidentSubmissionForOutOfOffice(){
        Account acc;
        for(Case c : newCaseList) { 
            Case oldC = oldCaseMap.get(c.Id);
            System.debug('Case--->' + c);
            if(c.Origin == 'Web' && c.Status == 'New' && oldC.Status != 'New' 
               && (c.Case_Type__c == 'SLGSA Injury' || c.Case_Type__c == 'Incident') 
               && c.Id != null){
                EEC_EmailUtil email = new EEC_EmailUtil(); 
                email.whatId = c.Id;
                email.saveAsActivity = false;
                if(accountMap != null)
                    acc = accountMap.get(c.AccountId);
                email.toAddresses = new List<String>();
                System.debug('UserMap-->' + userList);    
                if(acc.OwnerId != null && userList != null) {
                    System.debug('Owner Id-->' + acc.OwnerId); 
                    System.debug('Owner Id-->' + acc.Owner_ID_for_Portal__c); 
                    User licensor = userList.get(acc.Owner_ID_for_Portal__c );
                    System.debug('Licensor--->' + licensor);
                    if(licensor != null && licensor.Out_of_Office__c && licensor.ManagerId != null){
                        User manager = userList.get(licensor.ManagerId);
                        System.debug('Manager--->' + Manager);
                        email.toAddresses.add(manager.For_Portal_Email__c);
                        if(manager.Out_of_Office__c && manager.ManagerId != null){
                            User managersManager = userList.get(manager.ManagerId);
                            email.toAddresses.add(managersManager.For_Portal_Email__c);
                        }
                    }
                    System.debug('Licensor--->' + email.toAddresses);
                }
                
                String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + c.Id;
                if(orgList == null){
                    orgList = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'EEC LEAD Alert'];
                }
                if(orgList.size() > 0)
                    email.orgWideEmailId = orgList.get(0).Id;
                if(c.Case_Type__c == 'SLGSA Injury'){
                    template124 = emailTemplateMap.get('X124_New_Injury_From_Portal_To_Review');               
                    email.plainTextBody = template124.Body
                    .replace('{!Case.Link}', fullRecordURL)
                    .replace('{!Case.Account}', acc.Name);
                    email.subject = template124.Subject;
                }
                else if(c.Case_Type__c == 'Incident'){
                    template49 = emailTemplateMap.get('X49_New_Incident_From_Portal_to_Review');      
                    email.plainTextBody = template49.Body
                    .replace('{!Case.Link}', fullRecordURL)
                    .replace('{!Case.Account}', acc.Name);
                   email.subject = template49.Subject;
                }
                   
                if(email.toAddresses.size() > 0)
                    email.sendEmail();
            }
        }
    }
    
    public void sendApprovalTriageResultEmail(){
        if(Test.isRunningTest()){
            bulkBefore();
        }
        List<Investigation__c> updatedInvestigations = new List<Investigation__c>();
        for(Case c : newCaseList) {               
            Case oldCase = oldCaseMap.get(c.Id);
            sendTriageResultEmail(c, oldCase);
            System.debug('Case Detail----->' + c);
            if(accountMap == null)
                bulkBefore();
            if(c.X1st_Escalation_Case_Approver_Completed__c && (c.Status == 'In Triage' || c.Status == 'Escalated' || c.Status == 'Investigation in Progress')){
                Account acc = accountMap.get(c.AccountId);
                if(acc.Is_R_P__c && c.Investigation__c != null && investigationMap.containsKey(c.Investigation__c)){
                    Investigation__c i = investigationMap.get(c.Investigation__c);
                    i.Escalated_Investigation__c = true; 
                    updatedInvestigations.add(i); 
                }
            }
            if(c.X1st_Escalation_Case_Approver_Completed__c && c.X2nd_Escalation_Case_Approver_Completed__c && (c.Status == 'In Triage' || c.Status == 'Escalated')){
                Account acc = accountMap.get(c.AccountId);
                if(!acc.Is_R_P__c && c.Investigation__c != null && investigationMap.containsKey(c.Investigation__c)){
                    Investigation__c i = investigationMap.get(c.Investigation__c);
                    i.Escalated_Investigation__c = true;
                    updatedInvestigations.add(i); 
                }
                EEC_CaseTriggerHandler.FirstRun = true;
            }
            if(c.SendCaseTriageEmail__c == 'Approved' && c.Status == 'In Triage'){ 
                if(c.Investigation__c != null && investigationMap.containsKey(c.Investigation__c)){
                   Investigation__c i = investigationMap.get(c.Investigation__c);
                   i.Escalated_Investigation__c = true;
                   //i.Approval_Task_Creation__c = 'Escalated Approved'; 
                   updatedInvestigations.add(i); 
                }
            }
            if(c.SendCaseTriageEmail__c != null && c.Status == 'Escalated'){ 
                c.TriageEscalationApproverEmailList__c = null;
                c.SendCaseTriageEmail__c = null;
            }
        }
        update updatedInvestigations;
    }
    
    public void updateApprovalManager(){ 
        for(Case c : newCaseList){  
        
            Case oldCase = oldCaseMap.get(c.Id);
            
            if(c.TriggerTriageEscalationApproval__c && processList != null){
                c.Approver_Manager__c = null;
                c.TriggerTriageEscalationApproval__C = false;
                
                for(ProcessInstance pi : processList) {
                
                    if(pi.TargetObjectId == c.Id && pi.WorkItems.size() > 0){
                    
                        User oActor = userList.get(pi.WorkItems[0].OriginalActorId);
                        UserRole oActorRole = userRoleList.get(oActor.UserRoleId);
                        
                        if(c.TriageEscalationApproverEmailList__c == null){
                            c.TriageEscalationApproverEmailList__c = '';
                        }
                        
                        if(c.TriageEscalationApproverEmailList__c != null && c.TriageEscalationApproverEmailList__c != ''){
                            c.TriageEscalationApproverEmailList__c += ',';
                        }
                        c.TriageEscalationApproverEmailList__c += oActor.Email;
                        
                        if(oActor.ManagerId != NULL && (oActorRole == NULL || oActorRole.Name != 'Executive and Directors')){
                            c.Approver_Manager__c = oActor.ManagerId;
                        } 
                        
                        break;
                    }
                }
            }
            
        } 
    }
    
   
     public void bulkBefore(){
        
        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> cityIdSet = new Set<Id>();
        Set<Id> investIdSet = new Set<Id>();
        cityRegionMap = new Map<Id,String>();
        Set<Id> contactIdSet = new Set<Id>();
        
        Set<String> emailTemplateName = new Set<String>();
        emailTemplateName.add('X20_Case_Escalated_Approved_info_to_initial_requestor');
        emailTemplateName.add('X21_Case_Escalated_Rejected_info_to_initial_requestor');
        emailTemplateName.add('X22_Case_Escalated_Request_Recalled');
        emailTemplateName.add('X18_Case_Escalated_New_Case_sent_to_Triage_for_Original_Assignee');
        emailTemplateName.add('X14_New_SLGSA_case_with_no_noncompliance_to_review_and_close');
        emailTemplateName.add('X124_New_Injury_From_Portal_To_Review');
        emailTemplateName.add('X49_New_Incident_From_Portal_to_Review');
        emailTemplateName.add('X19_New_Incident_From_Portal_to_Review');
        emailTemplateName.add('X19_Case_Escalated_Case_sent_for_review_and_approval');
        emailTemplateName.add('X130_Investigation_conclusion_submitted_for_a_Foster_Home_51A_or_Incident_from');
        emailTemplateName.add('X131_Investigation_conclusion_missing_for_a_Foster_Home_51A_or_Incident_from_po');
        emailTemplateName.add('X132_Reminder_Sent_to_Provider_for_Missing_Investigation_Conclusion_for_Foster');
        emailTemplateName.add('X133_New_Foster_Home_51A_or_Incident_Submitted');
        
        List<EmailTemplate> emailTempateList = new List<EmailTemplate>([SELECT Body, Subject,DeveloperName FROM EmailTemplate WHERE DeveloperName IN: emailTemplateName]);
        emailTemplateMap = new Map<String, EmailTemplate>();
        for(EmailTemplate temp : emailTempateList){
            emailTemplateMap.put(temp.DeveloperName, temp);
        }
        
        if(orgList == null)
            orgList = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'EEC LEAD Alert'];
        for(Case cse : newCaseList){
            if(String.isNotBlank(cse.AccountId)){// && String.isBlank(cse.Unlicensed_Provider_Name__c)){
                accountIdSet.add(cse.AccountId);
            }
            if(string.isNotBlank(cse.ContactId)){
            	contactIdSet.add(cse.ContactId);
            }
          //  else if(String.isBlank(cse.Unlicensed_Provider_Region__c) && !String.isBlank(cse.Unlicensed_Provider_City__c) && !String.isBlank(cse.Unlicensed_Provider_Name__c)){
            if(String.isBlank(cse.Unlicensed_Provider_Region__c) && !String.isBlank(cse.Unlicensed_Provider_City__c) && !String.isBlank(cse.Unlicensed_Provider_Name__c)){
                cityIdSet.add(cse.Unlicensed_Provider_City__c);
            }
            
            if(String.isNotBlank(cse.Investigation__c)){
                investIdSet.add(cse.Investigation__c);
            }
        }
        Map<Id,String> tempCRMap = new Map<Id,String>();
        String tRegion = '';
        if(cityIdSet != null && cityIdSet.size() > 0){
            for(City_Assignment__c ca : [SELECT id, city__r.name, Applicable_to__c, Region__c 
                                         FROM City_Assignment__c 
                                         WHERE city__c in :cityIdSet]){
                if(cityRegionMap.containsKey(ca.city__c)){
                    if(ca.Applicable_to__c.contains('Family Child Care')){
                        cityRegionMap.put(ca.city__c,ca.Region__c);
                    }
                }
                else{
                    cityRegionMap.put(ca.city__c,ca.Region__c);
                }
            }
        }
        if(userList == null){
            userList = new Map<Id, User>([
                SELECT ID,For_Portal_Email__c ,Email, ManagerId, UserRoleId, Name, DelegatedApproverId,Out_of_Office__c,IsActive
                FROM User
                WHERE UserType = 'Standard'
            ]);
        }
        
        if(accountIdSet != null && accountIdSet.size() > 0){
            accountMap = new Map<Id,Account>([select Id,name,RecordType.name,RecordType.DeveloperName,Licensor_Full_Name__c,Is_R_P__c,Region__c,OwnerId,Owner_ID_for_Portal__c from Account where Id in :accountIdSet]);
        }
        
        if(contactIdSet != null && contactIdSet.size() > 0){
            contactMap = new Map<Id,Contact>([select Id,name,AccountId,Account.Name from Contact where Id in :contactIdSet]);
        }
        
        if(investIdSet != null && investIdSet.size() > 0){
            investigationMap = new Map<Id,Investigation__c>([SELECT Id,name,Investigation_Status__c,Assigned_To__c,Assigned_To__r.Email,
                                                             Related_to_51A__c,DCF_51A_Screen_Result__c,  
                                                            (SELECT Id,createdDate FROM Cases__r order by createddate) 
                                                             FROM Investigation__c WHERE Id in :investIdSet]);
        }
    }
    
    public void accountBulAfter(){
        Set<Id> accountIdSet = new Set<Id>();
        for(Case cse : newCaseList){
            if(String.isNotBlank(cse.AccountId)){// && String.isBlank(cse.Unlicensed_Provider_Name__c)){
                accountIdSet.add(cse.AccountId);
            }
        }
        if(accountIdSet != null && accountIdSet.size() > 0){
            accountMap = new Map<Id,Account>([select Id,name,RecordType.name,RecordType.DeveloperName,Licensor_Full_Name__c,Is_R_P__c,Region__c,OwnerId,Owner_ID_for_Portal__c from Account where Id in :accountIdSet]);
        }
    }
    /*public void bulkAfter(){
        
        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> investIdSet = new Set<Id>();
         
        for(Case cse : newCaseList){
            if(String.isNotBlank(cse.AccountId)){
                accountIdSet.add(cse.AccountId);
            }
          
            if(String.isNotBlank(cse.Investigation__c)){
                investIdSet.add(cse.Investigation__c);
            }
        }
        Map<Id,String> tempCRMap = new Map<Id,String>();
        
        if(accountIdSet != null && accountIdSet.size() > 0){
            accountMap = new Map<Id,Account>([select Id,name,RecordType.name,Region__c from Account where Id in :accountIdSet]);
        }
        
        if(investIdSet != null && investIdSet.size() > 0){
            investigationMap = new Map<Id,Investigation__c>([select Id,name,Investigation_Status__c,Assigned_To__c,Assigned_To__r.Email,
                                                            (select Id,createdDate from Cases__r order by createddate) 
                                                             from Investigation__c where Id in :investIdSet]);
        } 
        
    }*/
    
   public void updateCaseRegion(){
        Account accnt;
        Region__c region;
        Set<Id> regionIdSet = new Set<Id>();
        Map<Id,Region__c> regionMap;
        
        Map<string,Account> unlicensedProviderMap = new Map<string,Account>();
        for(Account a : [Select Id,Name,Region__c From Account where name like 'Unlicensed Provider -%']){
        	unlicensedProviderMap.put(a.Region__c,a);
        	regionIdSet.add(a.Region__c);
        }
        
        for(Case cse : newCaseList){
        	
          	if(String.isBlank(cse.AccountId) && String.isBlank(cse.Unlicensed_Provider_Region__c) && !String.isBlank(cse.Unlicensed_Provider_City__c) && cityRegionMap.containsKey(cse.Unlicensed_Provider_City__c) && (cse.Status == 'New' || cse.Status == 'Not Submitted')){
                cse.Unlicensed_Provider_Region__c = cityRegionMap.get(cse.Unlicensed_Provider_City__c);
                system.debug('*** cse.Unlicensed_Provider_Region__c ***'+cse.Unlicensed_Provider_Region__c);
            }
            if(String.isNotBlank(cse.Unlicensed_Provider_Region__c)){
                regionIdSet.add(cse.Unlicensed_Provider_Region__c);
            }
            if(accountMap != null && String.isNotBlank(cse.AccountId) ){
                accnt = accountMap.get(cse.AccountId);
                regionIdSet.add(accnt.Region__c);
            }
            
        }
        
        if(regionIdSet != null && regionIdSet.size() > 0){
            regionMap = new Map<Id,Region__c>([select Id,FCC_New_Case_Default_Assignee__c,R_P_New_Case_Default_Assignee__c, SGLSA_New_Case_Default_Assignee__c from Region__c where Id in :regionIdSet]);
        }       
        
        Investigation__c invest;
        EEC_EmailUtil eu;
        List<String> toAddresses;
        
        Id templateId = [select id, name from EmailTemplate where developername = 'X13_Notification_that_a_new_case_has_been_attached_to_investigation'].id;
        //Id templateId = [select id, name from EmailTemplate where developername = 'Test_13_Email_Template'].id;
        //OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'doNotReply@blahblah.com'];
        for(Case cse : newCaseList){
            if(cse.Status == 'New' || cse.Status == 'Not Submitted'){
                if(String.isBlank(cse.AccountId)){
                    system.debug('*** Account is BLANK ***');       
                    if(String.isNotBlank(cse.Unlicensed_Provider_Region__c)){
                        region = regionMap.get(cse.Unlicensed_Provider_Region__c);
                        cse.Triage_Responsible__c = region.FCC_New_Case_Default_Assignee__c;
                        if(String.isNotBlank(cse.ContactId)){
                            Contact con = contactMap.get(cse.ContactId);
                            if(con != null){
                                if(con.AccountId == null){
                                     Account acc = unlicensedProviderMap.get(cse.Unlicensed_Provider_Region__c);
                                     if (acc != null){
                                            cse.AccountId = unlicensedProviderMap.get(cse.Unlicensed_Provider_Region__c).Id;                   
                                            system.debug('*** cse.AccountId ***'+ cse.AccountId);  
                                     } 
                                }
                                else{
                                    cse.AccountId = con.AccountId;
                                }
                            }
                        }
                        else{
                            Account acc = unlicensedProviderMap.get(cse.Unlicensed_Provider_Region__c);
                            if (acc != null){
                                cse.AccountId = acc.Id;  
                            }
                    	}
                    }
                }
                else{
                    //Assign unlicensed Provider (Bucket Provider) on Case
                     if(!String.isBlank(cse.Unlicensed_Provider_Name__c) && !String.isBlank(cse.Unlicensed_Provider_City__c) && cityRegionMap.containsKey(cse.Unlicensed_Provider_City__c)){  	
                            system.debug('******LD'+ cse.AccountId);
                            cse.Unlicensed_Provider_Region__c = cityRegionMap.get(cse.Unlicensed_Provider_City__c);
                            system.debug('******LD REgion ****'+ cse.Unlicensed_Provider_Region__c);
                            
                            region = regionMap.get(cse.Unlicensed_Provider_Region__c);
                            cse.Triage_Responsible__c = region.FCC_New_Case_Default_Assignee__c;
                            Account acc = unlicensedProviderMap.get(cse.Unlicensed_Provider_Region__c);
                            if (acc != null){
                            cse.AccountId = unlicensedProviderMap.get(cse.Unlicensed_Provider_Region__c).Id;
                       
                             system.debug('******LD Unlicensed Provider ****'+ acc);
                            }
                        }
                     else {
                        accnt = accountMap.get(cse.AccountId);
                        system.debug('****Account ***'+accnt);
                        if(String.isNotBlank(accnt.Region__c)){
                            region = regionMap.get(accnt.Region__c);
                            if(accnt.RecordType.name == 'Family Child Care'){
                                cse.Triage_Responsible__c = region.FCC_New_Case_Default_Assignee__c;
                            }
                            else if(accnt.RecordType.name == 'Large Group' || accnt.RecordType.name == 'Small Group' || accnt.RecordType.name == 'Umbrella'){
                                cse.Triage_Responsible__c = region.SGLSA_New_Case_Default_Assignee__c;
                            }
                            else if(accnt.Is_R_P__c){
                                system.debug('****Account Owner***'+accnt.OwnerId);
                                User[] owner = [SELECT Id,ManagerId FROM User WHERE Id =: accnt.OwnerId LIMIT 1];
                                if(accnt.Licensor_Full_Name__c == 'LEAD System_Batch_User' || (owner != null && owner[0].ManagerId == null)){
                                    cse.Triage_Responsible__c = region.R_P_New_Case_Default_Assignee__c;
                                }
                                else if(owner.size() > 0 && owner != null){
                                    cse.Triage_Responsible__c = owner[0].ManagerId;
                                }
                            }
                        }
                     }
                } // end if
            }
        }       
    }
    
    public void updateCaseStatus(){
    	Investigation__c invest;
        Integer counter = 0;
    	for(Case cse : newCaseList){
    		if(String.isNotBlank(cse.Investigation__c) && cse.Status != 'Escalated'){
                invest = investigationMap.get(cse.Investigation__c);
                if(invest.Cases__r != null && invest.Cases__r.size() > 0 && invest.Assigned_To__c != null){
                    if(String.isNotBlank(invest.Investigation_Status__c) && invest.Investigation_Status__c != 'Closed' ){
                        cse.Status = 'Investigation in Progress';
                    }
                    else if(cse.Status != 'Closed'){
                        cse.Status = 'Closed';
                        cse.Closing_Reasons__c = 'Investigation completed';
                    }
                    //Removing this as client no longer wants to associate cases using parent id.
                    //This was causing circular dependency error. Qamar
                    /*if(String.isBlank(cse.ParentId)){
                        Case[] pCase = [SELECT Id FROM Case WHERE ParentId = null AND Investigation__c =: invest.Id AND Id !=: cse.Id LIMIT 1];
                        if(pCase.size() > 0){
                            if(pCase[0].Id != cse.Id){
                                cse.ParentId = pCase[0].Id;
                            }
                        }
                    }*/
                }
            }
    	}
    }
    
    public void sendCaseEmail(){
        Investigation__c invest;
        EEC_EmailUtil eu;
        List<String> toAddresses;
        Id oldInvest;
        for(Case cse : newCaseList){
        	if(String.isNotBlank(cse.Investigation__c)){
                invest = investigationMap.get(cse.Investigation__c);
                oldInvest = (oldCaseMap == null || String.isBlank(oldCaseMap.get(cse.Id).Investigation__c)) ? null :oldCaseMap.get(cse.Id).Investigation__c;
                if(cse.Investigation__c != oldInvest && invest.Cases__r != null && invest.Cases__r.size() > 0){
                    toAddresses = new List<String>();
                    
                    if(String.isNotBlank(invest.Assigned_To__c)){ 
                        String accntName = '';
                        if(String.isNotBlank(cse.AccountId)){
                            accntName = accountMap.get(cse.AccountId).Name;
                        }
                        else{
                            accntName = cse.Unlicensed_Provider_Name__c;
                        }
                        sendIEmail(invest.Assigned_To__r.Email,invest.name,invest.Assigned_To__c,cse.CaseNumber,cse.Investigation__c,cse.Subject,accntName);
                    }
                }
            }
       }
    }
    
    @future
    public static void sendIEmail(String assignedEmail,String investName,Id assignedTo, String caseName,String investId, String caseSubject, String accntName){
        EEC_EmailUtil eu = new EEC_EmailUtil();
        List<String> toAddresses = new List<String>();
        List<OrgWideEmailAddress> orgList = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'EEC LEAD Alert'];
        String emailBOdy = '';
        URL hostURL = URL.getCurrentRequestUrl(); 
        String domain = 'https://' + hostURL.getHost() +'/'+investId;
        
        // If assigned to investigator, then also send email to Associate Commissioner of Investigations role
        User[] assUser = [SELECT Id FROM User WHERE User.UserRole.Name ='Investigator' AND Id =: assignedTo LIMIT 1];
        if(assUser.size() > 0){
            User[] sendUser = [SELECT Id, email FROM User WHERE User.UserRole.Name ='Associate Commissioner of Investigations' LIMIT 1];
            if(sendUser.size() > 0){
            	toAddresses.add(sendUser.get(0).email);   
            } 
        }
        
        toAddresses.add(assignedEmail);
        if(orgList != null){
        	eu.orgWideEmailId = orgList.get(0).Id;
        }
        eu.targetObjectId = assignedTo;
        //eu.whatId = caseId;
        eu.toAddresses = toAddresses;
        caseSubject = String.isBlank(caseSubject)?'':caseSubject;
        eu.Subject = 'Subject Notification that a new case has been attached to investigation';
        //eu.templateId = templateId;
        emailBody = 'Hello\n\nA new case ('+caseName+' - ' + caseSubject + ') has been attached to investigation ' + investName+' associated to provider : '+accntName + ' you are in charge of.\n\n';
        emailBody = emailBody + 'Please review your investigation ('+domain+' ) in Salesforce to get more information on this case.\n\nLEAD System';
        eu.plainTextBody = emailBody;
        eu.sendEmail();
    }
    
    
}