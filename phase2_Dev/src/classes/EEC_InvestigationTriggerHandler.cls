public with sharing class EEC_InvestigationTriggerHandler {

    private Map<Id, Investigation__c> newMap;
    private Map<Id, Investigation__c> oldMap;
    private Map<Id,User> userMap;
    private Map<Id,Account> providerMap;
    private List<Case> cases;
    private List<Inspection__c> inspections;
    private List<Task> tasks;
    private Boolean gotRelatedObjects = false;
    private Set<Id> leaderSet;
    private Set<Id> providerSet;
    public static boolean FirstRun = true;
    Map<String, EmailTemplate> emailTemplateMap;
    List<OrgWideEmailAddress> orgList;
    private Map<String, Lead_Configuration__c> leadConfigMap;
    Map<Id, User> userList;
    
    EmailTemplate template24,template25,template34,template125; 

    public EEC_InvestigationTriggerHandler(Map<Id, Investigation__c> newMap, Map<Id, Investigation__c> oldMap){
        this.newMap = newMap;
        this.oldMap = oldMap; 
    }
    public void sendEscalationNotificationToInvestigator(){
        for(Investigation__c inv : newMap.values()){
            Investigation__c old = oldMap.get(inv.Id);
            if(inv.X1st_Escalation_Approver_Completed__c  && !old.X1st_Escalation_Approver_Completed__c 
               && inv.X1st_Escalation_Approver_Completed__c){
                EEC_EmailUtil email = new EEC_EmailUtil();
                EEC_EmailUtil invEmail = new EEC_EmailUtil();   
                if(!this.gotRelatedObjects){
                    getRelatedObjects();
                }
                   
                User invLeader = userList.get(inv.Assigned_To__c);
                Account prov = [SELECT Id,Name,Region__c, Region__r.Deputy_Commissioner__c,
                                Is_R_P__c,Is_GSA__c,OwnerId,Region__r.Regional_Director__r.Email,RecordType.Name 
                                FROM Account WHERE Id =: inv.Provider_No__c];
                
                 
                String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + inv.Id;
                email.subject = 'Investigation sent for review and approval';
                invEmail.subject = 'Investigation sent for review and approval: First Level Approval Complete';   
                template125 = emailTemplateMap.get('X125_Investigation_approved_by_Associate_Commissioner_of_Investigations');
                email.plainTextBody = template125.Body
                    .replace('{!Investigation__c.Name}', inv.Name)
                    .replace('{!Investigation__c.Assigned_To__c}', invLeader.Name)
                    .replace('{!Investigation__c.Provider_No__c}', prov.Name)
                    .replace('{!Investigation__c.Link}', fullRecordURL);
               
                invEmail.plainTextBody = template125.Body
                    .replace('{!Investigation__c.Name}', inv.Name)
                    .replace('{!Investigation__c.Assigned_To__c}', invLeader.Name)
                    .replace('{!Investigation__c.Provider_No__c}', prov.Name)
                    .replace('{!Investigation__c.Link}', fullRecordURL);   
                
                email.toAddresses = new List<String>();
                invEmail.toAddresses = new List<String>();   
                
                invEmail.toAddresses.add(invLeader.Email);
                if(invLeader.Out_of_Office__c){
                    User manager = userList.get(invLeader.ManagerId);
                    if(!manager.Out_of_office__c)
                        email.toAddresses.add(manager.Email);
                }
                if(prov.Is_GSA__c)
                    email.toAddresses.add(prov.Region__r.Regional_Director__r.Email);
                else if(prov.Is_R_P__c){
                    User licensor = userList.get(prov.OwnerId);
                    if(licensor.ManagerId != null)
                        email.toAddresses.add(userList.get(licensor.ManagerId).Email);
                }
                email.whatId = inv.Id;
                email.saveAsActivity = false; 
                invEmail.whatId = inv.Id;
                invEmail.saveAsActivity = false;
                   
                if(orgList.size() > 0){
                    System.debug('email.orgWideEmailId-->' + email.orgWideEmailId);
                    email.orgWideEmailId = orgList.get(0).Id;
                    invEmail.orgWideEmailId = orgList.get(0).Id;
                }
                if(email.toAddresses.size() > 0)    
                    email.sendEmail();
                if(invEmail.toAddresses.size() > 0)    
                    invEmail.sendEmail();   
            }
        }
    }

    public void sendInvestigationAssignedEmailOutOfOffice(){
        for(Investigation__c inv : newMap.values()){
            Investigation__c old = oldMap.get(inv.Id);

            if ( (old.Assigned_To__c == null && inv.Assigned_To__c != null) || 
                    (old.Assigned_To__c != null && inv.Assigned_To__c != null && old.Assigned_To__c != inv.Assigned_To__c)){
                if(!this.gotRelatedObjects){
                    getRelatedObjects();
                }
                User invLeader = userList.get(inv.Assigned_To__c);
                if(invLeader.out_of_Office__c){
                    EEC_EmailUtil email = new EEC_EmailUtil();
                    Account prov = [SELECT Id,Name,Region__c, Region__r.Deputy_Commissioner__c,
                                   Region__r.Regional_Director__c,RecordType.Name 
                                   FROM Account WHERE Id =: inv.Provider_No__c];
                    String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + inv.Id;
                    User leaderAssignedBy = userList.get(inv.LastModifiedById);
                    if(old.Assigned_To__c != null){
                        template24 = emailTemplateMap.get('X24_Investigation_ReAssigned_Notification_docx');
                        email.subject = template24.Subject;
                    }
                    else{
                        template24 = emailTemplateMap.get('X23a_Investigation_Assigned_Leader_Notification');
                        email.subject = template24.Subject.replace('{!Investigation__c.Provider_No__c}', prov.Name);
                        email.plainTextBody = template24.Body.replace('{!Investigation__c.Due_Date__c}', String.valueOf(inv.Due_Date__c));
                    }
                    email.plainTextBody = template24.Body
                        .replace('{!Investigation__c.Name}', inv.Name)
                        .replace('{!Investigation__c.LastModifiedBy}', leaderAssignedBy.Name)
                        .replace('{!Investigation__c.Provider_No__c}', prov.Name)
                        .replace('{!Investigation__c.Link}', fullRecordURL);
                    email.toAddresses = new List<String>();

                    if(invLeader.ManagerId != null){
                        User manager = userList.get(invLeader.ManagerId);
                        if(!manager.Out_of_office__c){
                            email.toAddresses.add(manager.Email); 
                        }
                        else if(manager.ManagerId != null){
                            User managersManager = userList.get(manager.ManagerId);
                            email.toAddresses.add(managersManager.Email); 
                        }
                    }
                    email.whatId = inv.Id;
                    email.saveAsActivity = false; 
    
                    if(orgList.size() > 0)
                        email.orgWideEmailId = orgList.get(0).Id;
                    
                    email.sendEmail();
                }
            }
        }
    }

    public void sendInvestigationApprovalEmailOutOfOffice(){
        for(Investigation__c inv : newMap.values()){
            Investigation__c old = oldMap.get(inv.Id);
            
            if(inv.Out_Of_Office_Initial_Recipient__c != null 
               && old.Out_Of_Office_Initial_Recipient__c == null){
                if(!this.gotRelatedObjects){
                    getRelatedObjects();
                }
                User approver = userList.get(inv.Out_Of_Office_Initial_Recipient__c);
                if(approver.Out_of_Office__c){
                    //template25 = [SELECT Body, Subject FROM EmailTemplate WHERE DeveloperName =: inv.Out_Of_Office_Email_Template_To_Send_del__c];   
                    template25 = emailTemplateMap.get(inv.Out_Of_Office_Email_Template_To_Send_del__c);
                    EEC_EmailUtil email = new EEC_EmailUtil();
                    Account prov = [SELECT Id,Name,Region__c, Region__r.Deputy_Commissioner__c,
                                   Region__r.Regional_Director__c,RecordType.Name 
                                   FROM Account WHERE Id =: inv.Provider_No__c];
                    User invLeader = userList.get(inv.Assigned_To__c);
                        
                    String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + inv.Id;
                    email.subject = template25.Subject;
                    email.plainTextBody = template25.Body
                        .replace('{!Investigation__c.Name}', inv.Name)
                        .replace('{!Investigation__c.Assigned_To__c}', invLeader.Name)
                        .replace('{!Investigation__c.Provider_No__c}', prov.Name)
                        .replace('{!Investigation__c.Link}', fullRecordURL);
                    
                    email.toAddresses = new List<String>();
                    
                    if(approver.ManagerId != null){
                        User manager = userList.get(approver.ManagerId);
                        if(!manager.Out_of_office__c)
                            email.toAddresses.add(manager.For_Portal_Email__c); 
                        else if(manager.ManagerId != null){
                            User managersManager = userList.get(manager.ManagerId);
                            email.toAddresses.add(managersManager.For_Portal_Email__c); 
                        }
                    }
                                        
                    email.whatId = inv.Id;
                    email.saveAsActivity = false; 
    
                    if(orgList.size() > 0)
                        email.orgWideEmailId = orgList.get(0).Id;
                    
                    email.sendEmail();
                }
                inv.Out_Of_Office_Email_Template_To_Send_del__c = '';
                inv.Out_Of_Office_Initial_Recipient__c = '';
            }
        }
    }
        
    private Boolean isInvestigator(Id userId) {
        //Do a check to see if this is an investigator and if so do not add task - per LEAD-4112
        Boolean ret = false;
        
        User[] user = [SELECT Id FROM User WHERE User.UserRole.Name ='Investigator' AND Id =: userId LIMIT 1];
        if(user.size() > 0){
            ret = true;
        }
        
        return ret;
    }
    
    public void assignNumberOfDaysToRecieveRespose(){
        Account provider;
        for(Investigation__c inv : newMap.values()){
            provider = providerMap.get(inv.Provider_no__c);
            if(inv.Number_of_Days_to_Receive_Response__c == null){
                if(!this.gotRelatedObjects){
                    getRelatedObjects();
                }
                Lead_Configuration__c lc = leadConfigMap.get(provider.RecordType.Name);
                inv.Number_of_Days_to_Receive_Response__c = lc.Number_of_days_to_receive_response_inv__c;
            }
        }
    }
    
    public void checkBeforeAssigningInvLeader(){
        Account provider;
        Boolean valid = true;
        for(Investigation__c inv : newMap.values()){
            Investigation__c old = oldMap.get(inv.Id);
            if(inv.Assigned_To_Id__c != old.Assigned_To_Id__c){
                provider = providerMap.get(inv.Provider_no__c);
                if(!this.gotRelatedObjects){ 
                    getRelatedObjects();
                }
                List<Case> cases = casesForInvestigation(inv); 
                for(Case c : cases){
                    if(c.Status == 'Escalated' && ((!c.X2nd_Escalation_Case_Approver_Completed__c && c.X2nd_Escalation_Case_Approver__c != null) || 
                       (!c.X1st_Escalation_Case_Approver_Completed__c && c.X2nd_Escalation_Case_Approver__c == null)))
                        valid = false;
                }
            }
            if(!valid)
                inv.addError('The associated case needs to be approved before assigning an investigation leader.');
        }
    }
   
    public void updateClosedInvestigationsBefore(){
        
        leaderSet = new Set<Id>();
        providerSet = new Set<Id>();
        for(Investigation__c inv : newMap.values()){
            
            Investigation__c old = oldMap.get(inv.Id);
            System.debug('New Investigation Status --- >' + inv.Investigation_Status__c);
            System.debug(old);
            
            providerSet.add(inv.Provider_no__c);
            if(String.isNotBlank(inv.Assigned_to__c)){
                leaderSet.add(inv.Assigned_to__c);
            }    
            if((old == NULL || old.Investigation_Status__c != 'Closed') && inv.Investigation_Status__c == 'Closed'){
                inv.Closed_date__c = System.Today();
                inv.Created_on_the_Web__c = true;
                inv.Require_Portal_Feedback__c = true;
            }
            
        }
    }
    
    private void getRelatedObjects(){ 
        
        this.cases = [
            SELECT ID, Investigation__c, X2nd_Escalation_Case_Approver_Completed__c, 
            Status,X2nd_Escalation_Case_Approver__c,X1st_Escalation_Case_Approver_Completed__c
            FROM Case 
            WHERE Investigation__c IN :newMap.keySet()
        ];
        
        this.inspections = [
            SELECT ID, Investigation__c, Status__c, Closed_Cancellation_Date__c, Cancellation__c
            From Inspection__c 
            WHERE Investigation__c IN :newMap.keySet()
            AND Status__c IN ('Visit Completed', 'Report to be sent to Provider')
        ];
        
        this.tasks = [
            SELECT ID, WhatId
            FROM Task 
            WHERE WhatId IN :newMap.keySet() 
            AND IsRecurrence = false AND Status != 'Completed'
        ];
        
        this.userList = new Map<Id, User>([
            SELECT ManagerId, UserRoleId, Email, Name, DelegatedApproverId,Out_of_Office__c,For_Portal_Email__c
            FROM User
            WHERE UserType = 'Standard'
        ]);
        
        this.leadConfigMap = new Map<String, Lead_Configuration__c>();
        for(Lead_Configuration__c lc : [SELECT Id, Name,Number_of_days_to_receive_response_inv__c FROM Lead_Configuration__c]){
            if(lc.Number_of_days_to_receive_response_inv__c != null && !leadConfigMap.keySet().Contains(lc.Name)){
                leadConfigMap.put(lc.Name, lc);
            }
        }
        
        orgList = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'EEC LEAD Alert'];
        
        Set<String> emailTemplateName = new Set<String>();
        emailTemplateName.add('X24_Investigation_ReAssigned_Notification_docx');
        emailTemplateName.add('X25_Investigation_Approval_Investigation_sent_for_review_and_approval');
        emailTemplateName.add('X34_Alert_to_licensor_that_corrective_actions_have_been_submitted');
        emailTemplateName.add('X23a_Investigation_Assigned_Leader_Notification');
        emailTemplateName.add('X125_Investigation_approved_by_Associate_Commissioner_of_Investigations');

        
        List<EmailTemplate> emailTempateList = new List<EmailTemplate>([SELECT Body, Subject,DeveloperName FROM EmailTemplate WHERE DeveloperName IN: emailTemplateName]);
        emailTemplateMap = new Map<String, EmailTemplate>();
        for(EmailTemplate temp : emailTempateList){
            emailTemplateMap.put(temp.DeveloperName, temp);
        }
        
        /*template24 = [SELECT Body, Subject FROM EmailTemplate WHERE DeveloperName = 'X24_Investigation_ReAssigned_Notification_docx'];
        template25 = [SELECT Body, Subject FROM EmailTemplate WHERE DeveloperName = 'X25_Investigation_Approval_Investigation_sent_for_review_and_approval'];
        template34 = [SELECT Body, Subject FROM EmailTemplate WHERE DeveloperName = 'X34_Alert_to_licensor_that_corrective_actions_have_been_submitted'];
        template125 = [SELECT Body, Subject FROM EmailTemplate WHERE DeveloperName = 'X125_Investigation_approved_by_Associate_Commissioner_of_Investigations'];*/

        this.gotRelatedObjects = true;
    }
    public void updateCaseOwnerByInvestigationLeader(){
        for(Investigation__c inv : newMap.values()){
            Investigation__c old = oldMap.get(inv.Id);
            if((old.Investigation_Status__c == 'New' 
                || inv.Investigation_Status__c == 'Assigned - In Progress') 
                && old.Assigned_To__c != inv.Assigned_To__c && inv.Assigned_To__c != null){
                if(!this.gotRelatedObjects){
                    getRelatedObjects();
                }
                List<Case> cases = casesForInvestigation(inv); 
                for(Case c : cases){
                    c.Status = 'Investigation in Progress';
                    c.OwnerId = inv.Assigned_To__c;
                }
                if(cases.size() != 0){
                    update cases;
                }
            }
        }
    }
    
    public void updateReportDatesForApproved(){
        for(Investigation__c inv : newMap.values()){
            Investigation__c old = oldMap.get(inv.Id);
            if(old.Investigation_Status__c != 'Approved - Report to send' &&
               inv.Investigation_Status__c == 'Approved - Report to send') {
                Attachment[] att = [SELECT Id, CreatedDate FROM Attachment WHERE Name Like '%NonCompliance-%' AND ParentId =: inv.Id ORDER BY CreatedDate DESC];   
                Attachment[] attNarr = [SELECT Id, CreatedDate FROM Attachment WHERE Name Like '%Narrative-%' AND ParentId =: inv.Id ORDER BY CreatedDate DESC];      
                if(att.size() > 0)
                    inv.Statement_of_non_compliance_Issue_Date__c = att[0].CreatedDate.date();
                if(attNarr.size() > 0)   
                    inv.Report_Narrative_Issue_Date__c = attNarr[0].CreatedDate.date();
            }
        }
    }
    
    public void updateClosedInvestigationsAfter() {
        for(Investigation__c inv : newMap.values()){
            Investigation__c old = oldMap.get(inv.Id);
            if((old == NULL || old.Investigation_Status__c != 'Closed') && inv.Investigation_Status__c == 'Closed'){
                if(!this.gotRelatedObjects){
                    getRelatedObjects();
                }
                List<Case> cases = casesForInvestigation(inv); 
                for(Case c : cases){ 
                    c.Status = 'Closed';
                    c.Closing_reasons__c = 'Investigation Closed';
                } 
                if(cases.size() != 0){
                    update cases;
                }
                List<Inspection__c> inspections = inspectionsForInvestigation(inv);
                
                for(Inspection__c insp : inspectionsForInvestigation(inv)){
                    insp.Status__c = 'Closed';
                    insp.Closed_Cancellation_Date__c = System.Today();
                    insp.Cancellation__c = 'Investigation Closed';
                }
                if(inspections.size() != 0){
                    update inspections;
                }
                
               /* List<Task> tasks = tasksForInvestigation(inv);
                
                for(Task t : tasks){
                    t.Status = 'Completed'; 
                }
                
                if(tasks.size() != 0){
                    update tasks;
                }*/
                
            }
        }
    }
    
    public void updateLeaderHeirarchy(){
        
        List<Task> approvalTaskList = new List<Task>();
        Account provider;
        providerMap = new Map<Id,Account>([select Id,Name,Region__c, Region__r.Deputy_Commissioner__c,Region__r.Regional_Director__c,RecordType.Name from Account where Id in :providerSet]);
        if(leaderSet != null && leaderSet.size()>0){
            this.userMap  = new Map<Id,User>([select Id, ManagerId from User where Id in :leaderSet and ManagerId != null]);
        }
        
        for(Investigation__c inv : newMap.values()){
            provider = providerMap.get(inv.Provider_no__c);
            if(String.isNotBlank(provider.Region__c) && String.isNotBlank(provider.Region__r.Deputy_Commissioner__c)){
             /* REPLACED BY WORKFLOW   inv.Leader_Deputy_Commisioner__c = provider.Region__r.Deputy_Commissioner__c;  */
            }
            if(userMap != null && String.isNotBlank(inv.Assigned_To__c) && userMap.containsKey(inv.Assigned_To__c)){
              inv.Leader_Manager__c = userMap.get(inv.Assigned_To__c).ManagerId;
            }
            if(provider.RecordType.Name == 'Family Child Care' || provider.RecordType.Name == 'Small Group' || provider.RecordType.Name == 'Large Group'){
              /* REPLACED BY WORKFLOW     inv.Leader_Director_Supervisor__c = provider.Region__r.Regional_Director__c;*/
            }
            else{
              /* REPLACED BY WORKFLOW     inv.Leader_Director_Supervisor__c = inv.Leader_Manager__c;*/
            }
                        
            String newATC = inv.Approval_Task_Creation__c;
            String oldATC;
            Task approvalTask;
            if(String.isNotBlank(newATC)){
                if(oldMap != null){
                    Investigation__c old = oldMap.get(inv.Id);
                    oldATC = (old != null && String.isNotBlank(old.Approval_Task_Creation__c))?old.Approval_Task_Creation__c:'';
                    if(newATC != oldATC){
                        if(newATC == 'NonEscalated Approved' || newATC == 'Escalated Approved'){
                            //if (!isInvestigator(inv.Assigned_To__c)) {
                                approvalTask = new Task();
                                approvalTask.Subject = 'Review, send investigation report to Provider and close investigation - For ' + provider.Name;
                                approvalTask.Status = 'Not Started';
                                approvalTask.Priority = 'High';
                                approvalTask.WhatId = inv.Id;
                                if(newATC == 'NonEscalated Approved') 
                                    approvalTask.OwnerId = String.isNotBlank(inv.Assigned_To__c) ? inv.Assigned_To__c : UserInfo.getUserId();
                                else {
                                    if(!provider.Is_R_P__c)
                                        approvalTask.OwnerId = String.isNotBlank(inv.Leader_Director_Supervisor__c) ? inv.Leader_Director_Supervisor__c : UserInfo.getUserId();
                                    else
                                        approvalTask.OwnerId = String.isNotBlank(inv.Licensor_Manager__c) ? inv.Licensor_Manager__c : UserInfo.getUserId();
                                }
                                    approvalTask.ActivityDate = Date.today().addDays(3);
                                    approvalTaskList.add(approvalTask);
                                
                            //} 
                        }
                        else if(newATC == 'NonEscalated Rejected' || newATC == 'Escalated Rejected'){
                            approvalTask = new Task();
                            approvalTask.Subject = 'Re-work required on investigation following review and rejection';
                            approvalTask.Status = 'Not Started';
                            approvalTask.Priority = 'High';
                            approvalTask.WhatId = inv.Id;
                            approvalTask.OwnerId = String.isNotBlank(inv.Assigned_To__c)?inv.Assigned_To__c:UserInfo.getUserId();
                            approvalTask.ActivityDate = Date.today().addDays(3);
                            approvalTaskList.add(approvalTask);
                        }
                        
                    }
                }
            }
        }
        if(approvalTaskList != null && approvalTaskList.size()>0){
            insert approvalTaskList;
        }
        
    }
    
    
    
    public List<Case> casesForInvestigation(Investigation__c i){ 
        List<Case> l = new List<Case>();
        
        for(Case c : cases){
            if(c.Investigation__c == i.Id){
                l.add(c);
            }
        }
        
        return l;
    }
    
    public List<Task> tasksForInvestigation(Investigation__c i){ 
        List<Task> l = new List<Task>();
        
        for(Task t : tasks){
            if(t.WhatId == i.Id){
                l.add(t);
            }
        }
        
        return l;
    }
    
    public List<Inspection__c> inspectionsForInvestigation(Investigation__c i){ 
        List<Inspection__c> l = new List<Inspection__c>();
        
        for(Inspection__c insp : inspections){
            if(insp.Investigation__c == i.Id){
                l.add(insp);
            }
        }
        
        return l;
    }
    
    /**
     * checkVisitsForPublishedToWeb
     * 
     * This function will verify all visits and non compliants for published to web. 
     * @author Darkis
     */
    public void checkVisitsForPublishedToWeb() {
      for(Investigation__c inv : newMap.values()){
        Investigation__c old = oldMap.get(inv.Id); System.debug('-----> Investigation: ' + inv.Id);
        // If the old record was not published to web and the new one is then continue.  
        if (!old.Created_on_the_Web__c && inv.Created_on_the_Web__c) {
          // Get all the related visits who are not closed or cancelled.
          List<Id> visitIds = new List<Id>();
          List<Inspection__c> visits = [SELECT Id, Name, Status__c, Created_on_the_Web__c 
                                        FROM Inspection__c 
                                        WHERE Investigation__c = :inv.Id 
                                        AND Status__c NOT IN('Cancelled', 'Closed')];  
            System.debug('-----> Visits: ' + visits);
          // If there are any visits meeting the criteria.
          if (visits != null && visits.size() > 0) {
            // Loop through the results.
            for (Inspection__c visit : visits) {
              visitIds.add(visit.Id);
              visit.Created_on_the_Web__c = true;
            }    
            // Update the visits. The visits will be modified by the Visits trigger to set Visit Items to Review on Portal = true and the Visit to "Report Sent to Provider, Awaiting Feedback".
            update visits;
          }
          //Get all non-compliant items.
          List<Non_Compliant__c> nonCompliantItems = [Select Id, Name, Feedback_Requested__c,Correction_Plan_Status__c, To_Review_on_Portal__c From Non_Compliant__c Where Investigation__c = :inv.Id AND Feedback_Requested__c = true]; System.debug('-----> NonCompliants: ' + nonCompliantItems);
          // If there are non compliant items with feedback requested. 
          List<Non_Compliant__c> updateNonComp = new List<Non_Compliant__c>();
          if (nonCompliantItems != null && nonCompliantItems.size() > 0) {
            // Loop through non compliant items and update To_Review_on_Portal__c to True.
            for (Non_Compliant__c ncItem : nonCompliantItems) {
                Non_Compliant__c ncItem2 = ncItem;
                ncItem2.To_Review_on_Portal__c = true;
                ncItem2.Correction_Plan_Status__c ='Provider To Submit';
                updateNonComp.add(ncItem2);
            } 
            update updateNonComp;
          }
          // Get a count of the Visit Items that have Feedback_Requested__c = true.
          Integer visitItemsCount = [Select Count() From Inspection_Item__c Where Feedback_Requested__c = true AND Inspection_No__c IN :visitIds]; System.debug('-----> visitItemsCount: ' + visitItemsCount);
          // If there are any NonCompliant Items OR Visit Items with Feedback_Requested__c = true then update the Investigation.   
          if ((nonCompliantItems != null && nonCompliantItems.size() > 0) || (visitItemsCount != null && visitItemsCount > 0)) {
            // Update Investigation fields.
            Investigation__c newInvest = [Select Id, Name, Require_Portal_Feedback__c,lock_investigation__c From Investigation__c Where Id = :inv.Id];
            newInvest.Require_Portal_Feedback__c = true;
            update newInvest;      
          }
        }
      }
    }
}