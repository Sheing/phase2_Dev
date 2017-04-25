public with sharing class EEC_VisitTriggerHandler {
    
    List<Inspection__c> newInspectionList;
    Map<Id,Inspection__c> oldInspectionMap;
    Map<Id,User> userMap;
    Set<Id> cancelledVisits;
    Map<Id,Account> providerMap;
    Map<Id,ProcessInstance> inspectionApprovals;
    Map<Id,Investigation__c> investigationMap;
    Map<Id, Inspection_Item__c> inspectionItemMap;
    Set<Id> inspectionIds;
    public static boolean flag =false;

    public EEC_VisitTriggerHandler(List<Inspection__c> newList){
        this.newInspectionList = newList;
        setup();
    }
    
    public void sendInvestigationApprovalEmailOutOfOffice(){
        User escalationUser = userMap.get(UserInfo.getUserId());
        Account prov;
        if(escalationUser != null){
            for(Inspection__c insp : newInspectionList){
                Inspection__c old = oldInspectionMap.get(insp.Id);
                User escalationManager = userMap.get(escalationUser.ManagerId);
                if(providerMap != null)
                    prov = providerMap.get(insp.Provider_No__c);
                else
                    prov = [SELECT Id,Name,Region__c, Region__r.Deputy_Commissioner__c,
                            Region__r.Regional_Director__r.Email,RecordType.Name 
                            FROM Account WHERE Id =: insp.Provider_No__c];
                if(insp.Status__c == 'Pending Approval' && old.Status__c != 'Pending Approval' && escalationManager.Out_of_Office__c){
                    List<OrgWideEmailAddress> orgList = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'EEC LEAD Alert'];
                    EEC_EmailUtil email = new EEC_EmailUtil(); 
                    String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + insp.Id;
                    
                    EmailTemplate template9 = [SELECT Body, Subject FROM EmailTemplate WHERE DeveloperName = 'X9_New_Licensing_Visit_to_Review_and_Approve'];
                    
                    email.plainTextBody = template9.Body
                        .replace('{!Inspection__c.Provider_No__c}', prov.Name)
                        .replace('{!Inspection__c.Id}', insp.Id)
                        .replace('{!Inspection__c.Link}', fullRecordURL);
                    email.Subject = 'New Licensing Visit to Review and Approve';
                    email.toAddresses = new List<String>();
                    
                    if(escalationManager.DelegatedApproverId != null){
                        email.toAddresses.add(userMap.get(escalationManager.DelegatedApproverId).Email); 
                    }
                    else if(escalationManager.ManagerId != null && escalationManager.Out_of_office__c){
                        User managersManager = userMap.get(escalationManager.ManagerId);
                        email.toAddresses.add(managersManager.Email); 
                    }
                                        
                    email.whatId = insp.Id;
                    email.saveAsActivity = false;
                    if(orgList.size() > 0)
                        email.orgWideEmailId = orgList.get(0).Id;
                    
                    email.sendEmail();
                }
            }
        }
    }
    
    public EEC_VisitTriggerHandler(List<Inspection__c> newList, Map<Id,Inspection__c> oldMap){
        this.newInspectionList = newList;
        this.oldInspectionMap = oldMap;
        setup();
    }
    
    public void setup(){
        userMap = new map<Id,User>();
        inspectionIds = new Set<Id>();
        Set<Id> providerSet = new Set<Id>();  
        
        for(Inspection__c insp : newInspectionList){ 
            inspectionIds.add(insp.Id);
            if(insp.Provider_No__c != null){
                providerSet.add(insp.Provider_No__c);
            } 
        }

        inspectionItemMap = new Map<Id, Inspection_Item__c>([SELECT Id, Name, Feedback_Requested__c,Inspection_No__c, Corrective_Action_EEC_Feedback__c 
                                                             FROM Inspection_Item__c 
                                                             WHERE Feedback_Requested__c = TRUE 
                                                             AND Inspection_No__c IN : inspectionIds]);

        providerMap = new Map<Id, Account>([SELECT Id,OwnerId,Name, Config_Record__r.Visit_Narrative_Summary_Default__c 
                                            FROM Account 
                                            WHERE Id in :providerSet]);
        
        userMap = new Map<Id, User>([
            SELECT ManagerId, UserRoleId, Email, Name, DelegatedApproverId, Out_of_Office__c
            FROM User
            WHERE UserType = 'Standard'
        ]); 
        
    }
    
    public void bulkBefore(){
        
        userMap = new map<Id,User>(); 
        Set<Id> investigationSet = new Set<Id>();
        
        for(Inspection__c insp : newInspectionList){
             
            if(insp.Investigation__c != null){
                investigationSet.add(insp.Investigation__c);
            }
        }
         
        investigationMap = new Map<Id, Investigation__c>([select Id,Assigned_To__c from Investigation__c where Id in :investigationSet]);
    }

    public void updateVisitCoordinatesBefore(){
      //Get list of inspections where address field is populated
      Set<String> addressLinesSet = new Set<String>();
      Set<String> zipCodesSet = new Set<String>();
      Boolean addressUpdated = false;
      
      for(Inspection__c insp : newInspectionList){
        if(Trigger.isUpdate){
          Inspection__c oldInsp = oldInspectionMap.get(insp.id);
          System.debug('------->OldInspection: ' + oldInsp);
          if(insp.Address_1__c != oldInsp.Address_1__c || insp.Zip_Code__c != oldInsp.Zip_Code__c){
            addressUpdated = true;
          }
        }
        
        if(String.isNotBlank(insp.Address_1__c) && String.isNotBlank(insp.Zip_Code__c)){
          addressLinesSet.add(insp.Address_1__c);
          zipCodesSet.add(insp.Zip_Code__c);
        }
      }
      //Check if visit coordinates need to be updated/populated
      if( (Trigger.isInsert && addressLinesSet.size() < 1) || (Trigger.isUpdate && addressUpdated == false)){
        System.debug('------> No updates required');
        return;
      }
      //Get the coordinates from exisiting visits
      AggregateResult[] inspWithCoordinates = [SELECT Address_1__c, Zip_Code__c, visitLatitude__c, visitLongitude__c 
                              FROM Inspection__c
                              WHERE Address_1__c IN :addressLinesSet AND Zip_Code__c IN :zipCodesSet
                                AND visitLatitude__c != null AND visitLatitude__c != ''
                              GROUP BY Address_1__c, Zip_Code__c, visitLatitude__c, visitLongitude__c];
      Map<String, String> visitCoordinatesMap = new Map<String, String>();
      if(inspWithCoordinates != null && inspWithCoordinates.size() > 0){
        for(AggregateResult ar : inspWithCoordinates){
          visitCoordinatesMap.put(ar.get('Address_1__c') + ' ' + ar.get('Zip_Code__c'), ar.get('visitLatitude__c') + '|' + ar.get('visitLongitude__c'));
        }
      }
      //Map<Id, Inspection__c> inspCoordinatesNotFound = new Map<Id, Inspection__c>(newInspectionList);
      for(Inspection__c insp : newInspectionList){
        if(String.isNotBlank(insp.Address_1__c) && String.isNotBlank(insp.Zip_Code__c)){
          String keyToGetCoordinates = insp.Address_1__c + ' ' + insp.Zip_Code__c;
          String visitCoordinates = visitCoordinatesMap.get(keyToGetCoordinates);
          if(String.isNotBlank(visitCoordinates)){
            insp.visitLatitude__c = visitCoordinates.substring(0, visitCoordinates.indexOf('|'));
            insp.visitLongitude__c = visitCoordinates.substring(visitCoordinates.indexOf('|')+1, visitCoordinates.length());
            //Inspection__c inspFound = inspCoordinatesNotFound.remove(insp.ID);
          } else{
            if(Trigger.isUpdate){
              Inspection__c oldInsp = oldInspectionMap.get(insp.id);
              System.debug('------->OldInspection: ' + oldInsp);
              if(insp.Address_1__c != oldInsp.Address_1__c || insp.Zip_Code__c != oldInsp.Zip_Code__c){
                insp.visitLongitude__c = null;
                insp.visitLatitude__c = null;
              }
            }
          }
        }
      }
    }
    
    public void bulkAfter(){
        
        cancelledVisits = new Set<Id>();
        Inspection__c oldInsp;
        for(Inspection__c insp : newInspectionList){
            oldInsp = oldInspectionMap.get(insp.Id);
            if(insp.Status__c != null && (insp.Status__c == 'Cancelled' || insp.Status__c == 'Closed') && insp.Status__c != oldInsp.Status__c){
                cancelledVisits.add(insp.Id);
            }
        }
        
    }
    
    public void updateVisit(){ 
        
        Id assignedTo;
        for(Inspection__c insp : newInspectionList){
            if(insp.Original_Visit__c == null && String.isNotBlank(insp.Inspector_del__c)){
                /*if(EEC_RecordTypeUtil.findById(insp.recordTypeId).DeveloperName == 'Licensing_Visits'){
                    if(providerMap != null && providerMap.containsKey(insp.Provider_No__c) != null){
                        insp.Inspector_del__c = providerMap.get(insp.Provider_No__c).ownerid;
                    }
                }
                else */if(EEC_RecordTypeUtil.findById(insp.recordTypeId).DeveloperName == 'Investigation_Visits' && insp.Investigation__c != null){
                    if(investigationMap != null && investigationMap.containsKey(insp.Investigation__c) != null){
                        assignedTo = investigationMap.get(insp.Investigation__c).Assigned_To__c;
                        insp.Inspector_del__c = assignedTo;
                    }
                }
            }
            if(insp.Inspector_del__c == null){
                insp.Inspector_del__c = Userinfo.getUserId();
            }
        }
    }
    
    public void createVisitTasks(){
        List<Task> taskList = new List<Task>();
        Task vTask;
        for(Inspection__c insp : newInspectionList){
            System.debug('Inspection*******' + insp);
            vTask = new Task();
            vTask.Status = 'Not Started';
            vTask.Priority = 'Normal';
            vTask.WhatId = insp.Id;
            vTask.OwnerId = String.isNotBlank(insp.Inspector_del__c)?insp.Inspector_del__c:UserInfo.getUserId();
            String city = insp.City__c;
            String address = insp.Address_1__c;
            if((city==null || address==null)&&(insp.Provider_Address_City__c !=null)){
                city = insp.Provider_Address_City__c.split(',')[1];
                address = insp.Provider_Address_City__c.split(',')[0]; 
            }
            vTask.Subject = 'Schedule visit - ' + insp.Provider_Name__c + ' - ' + address + ' - ' + city ;//+ '-' + insp.Date_of_Visit__c + '-' + insp.Provider_No__r.Name
            system.debug('Address value: '+insp);
            system.debug('Subject Value: '+vTask.Subject);
            if(insp.Announced__c){
                //vTask.Subject = 'Schedule visit - Announced';
                vTask.Subject = 'Schedule visit - Announced';
                vTask.ActivityDate = (insp.Estimated_Deadline__c != null) ? insp.Estimated_Deadline__c.addDays(-10):null;
            }
            else{
                //vTask.Subject = 'Schedule visit - UnAnnounced';
                vTask.ActivityDate = (insp.Date_of_Visit__c != null) ? insp.Date_of_Visit__c.addDays(-10):null;
            }
            taskList.add(vTask);
        }
        if(taskList.size() > 0){
            insert taskList;
        }
    }

    public void updateTaskSubjectForAnnouncementType(){
      List<Task> taskList = new List<Task>();
      Set<Id> visitIdSet = new Set<Id>();
      for(Inspection__c insp : newInspectionList){
        Inspection__c old = oldInspectionMap.get(insp.Id);
        if(insp.Status__c == 'To be Scheduled' && insp.Announcement_Type__c <> old.Announcement_Type__c){
          visitIdSet.add(insp.Id);
        }
      }
      if(visitIdSet <> null && visitIdSet.size() > 0){
        taskList = [SELECT Status, Subject, WhatId 
                    FROM Task 
                    WHERE WhatId IN: visitIdSet
                      AND Status = 'Not Started'];
        Map<Id, Inspection__c> newInspectionMap = new Map<Id, Inspection__c>(newInspectionList);
        if(taskList <> null && taskList.size() > 0){
          for(Task vTask : taskList){
            Inspection__c i = newInspectionMap.get(vTask.WhatId);
            String city = i.City__c;
            String address = i.Address_1__c;
            if((city==null || address==null)&&(i.Provider_Address_City__c !=null)){
                city = i.Provider_Address_City__c.split(',')[1];
                address = i.Provider_Address_City__c.split(',')[0]; 
            }
            vTask.Subject = 'Schedule visit - ' + i.Announcement_Type__c + ' - ' + i.Provider_Name__c + ' - ' + address + ' - ' + city ;
          }
          update taskList;
        }
        
      }
      
    }
    
    public void updateClosedActivitySummary(){
        for(Inspection__c i : newInspectionList){
            Inspection__c oldRecord = oldInspectionMap.get(i.Id);
            
            Lead_Configuration__c conf = providerMap.get(i.Provider_No__c).Config_Record__r;
           
            if((i.Status__c == 'Visit Completed' && (i.Activity_Summary__c == NULL || i.Activity_Summary__c.trim() == '')) &&
                (oldRecord.Status__c == 'Scheduled' || oldRecord.Status__c == 'To be scheduled') &&
                (conf != NULL && conf.Visit_Narrative_Summary_Default__c != NULL)){
                
                String defaultActivitySummary = conf.Visit_Narrative_Summary_Default__c;
                                           
                // Set visit reason and visit date only if they are set.
                defaultActivitySummary = defaultActivitySummary .replace('#Visit_Reason#', 
                    i.Type_of_Visit__c == NULL ? 'unknown' : i.Type_of_Visit__c);
                    
                defaultActivitySummary = defaultActivitySummary .replace('#Visit_Date#', 
                    i.Date_of_Visit__c == NULL ? 'unknown' : EEC_DateUtil.formatDate('MM/dd/yyyy',i.Date_of_Visit__c));
                
                i.Activity_Summary__c = defaultActivitySummary;
            }
        }
    }
    
    public void closeCancelledTasks(){
        
        List<Task> closeTaskList = new List<Task>();
        List<Task> deleteTaskList = new List<Task>();
        
        for(Task tsk : [select Id,status,activitydate from Task where WhatId = :cancelledVisits and isClosed != true]){
            if(tsk.activitydate != null && tsk.activitydate > Date.Today()){
                deleteTaskList.add(tsk);
            }
            else{
                tsk.status = 'Completed';
                closeTaskList.add(tsk);
            }
        }
        
        if(closeTaskList != null && closeTaskList.size() > 0){
            update closeTaskList;
        }
        if(deleteTaskList != null && deleteTaskList.size() > 0){
            delete deleteTaskList;
        }
    }
    
    /**
     * checkItemsForPublishedToWeb
     * 
     * This function will check the newly updated Visits to ensure that if their published to web is enabled
     *   that their Visit Items will be set accordingly.
     * @author Darkis 
     */
    public void updateVisitStatusBefore(){
      for (Inspection__c i : newInspectionList){
        Inspection__c oldRecord = oldInspectionMap.get(i.Id);
        if (i.Created_on_the_Web__c && !oldRecord.Created_on_the_Web__c) {
          if(i.RecordType.Developername == 'Licensing_Visits'){
            i.Status__c = 'Report Sent to Provider, Awaiting feedback';
          } 
        }
      }
    }
    public void checkItemsForPublishedToWeb() {
      //List<Inspection__c> nInsp = [SELECT Id, Created_on_the_Web__c, RecordType.Developername FROM Inspection__c WHERE Id IN: inspIds];  
      List<Inspection_Item__c> feedbackRequestedItemList = new List<Inspection_Item__c>();
      for(Inspection__c i : newInspectionList){
        //Inspection__c modifiedVisit = [Select Id, Status__c, RecordType.Developername From Inspection__c Where Id = :i.Id];
        Inspection__c oldRecord = oldInspectionMap.get(i.Id);
        // If the new record has been switched to true and the old record was false.  
        if (i.Created_on_the_Web__c && !oldRecord.Created_on_the_Web__c) {
          // Search for at least one item from this visit that has Feedback_Requested__c = true. 
          for(Inspection_Item__c insp_Item : inspectionItemMap.values()){
                if(insp_Item.Inspection_No__c == i.Id )
                    feedbackRequestedItemList.add(insp_Item);
          }
          // If the item is not null then we know there is one set to true.   
          if (feedbackRequestedItemList != null && feedbackRequestedItemList.size() > 0) {
            // Loop through all the items and change their 'To_Review_on_Portal__c' status to true.
            for (Inspection_Item__c item : feedbackRequestedItemList) {
              item.To_Review_on_Portal__c = true;
            }  
          }  
        }
      }
      if(feedbackRequestedItemList.size() > 0){
          update feedbackRequestedItemList;
      }
    }
    
    /**
     * checkForNewMasterVisit
     * 
     * This function will check for new master visits and close all tasks related to the changed visit. 
     * @author Darkis
     */
    public void checkForNewMasterVisit() {
      // Get the visit id list fro the new inspection list.
      Set<Id> visitIdSet = (new Map<Id, Inspection__c>(newInspectionList)).keySet();
      // Fetch all the modified visit items.
      Map<Id, Inspection__c> modifiedVisits = new Map<Id, Inspection__c>([Select Id From Inspection__c Where Id IN :visitIdSet]);
      // Create a new instacne of child visit ids. 
      Set<Id> newChildVisits = new Set<Id>();
      // Verify all the modified visits and check if the new version has a NEW master visit.  
      for (Inspection__c i : newInspectionList) {
        Inspection__c modifiedVisit = modifiedVisits.get(i.Id);           
        Inspection__c oldRecord = oldInspectionMap.get(i.Id);
        // If a master visit has been added then add the id to the child visit id list.  
        if (i.Mater_Visit_for_Res_Cluster_of_Visits__c != null && oldRecord.Mater_Visit_for_Res_Cluster_of_Visits__c == null) {
          newChildVisits.add(i.Id);
        }
      }  
      
      if (newChildVisits != null && newChildVisits.size() > 0) {
        // Collect all the tasks for the new child visits for closure.   
        List<Task> allTasksToClose = [select Id,status,activitydate from Task where WhatId = :newChildVisits and isClosed != true];  
        for(Task tsk : allTasksToClose) {
          tsk.status = 'Completed';       
        }
        // Update the tasks.
        update allTasksToClose;
      }
    }
    
    public void checkMasterVisitForChanges() {
      // Get the visit id list fro the new inspection list.
      Set<Id> visitIdSet = (new Map<Id, Inspection__c>(newInspectionList)).keySet();
      // Fetch all the modified visit items.
      Map<Id, Inspection__c> modifiedVisits = new Map<Id, Inspection__c>([
        Select 
          Id, 
          Status__c, 
          Estimated_Deadline__c, 
          Closed_Cancellation_Date__c,  
          Cancellation__c,
          Announced__c,
          Date_of_Visit__c,
          Time_of_visit__c,
          Activity_Summary__c,
          Corrective_Action_Required__c,
          Tech_Assist_Recommendations_Comments__c,
          Comments__c,
          Cover_Letter_Narrative__c,
          Updates_Changes__c,
          Announcement_Type__c
        From Inspection__c Where Id IN :visitIdSet
      ]);    
      // Get all the children visits for the master records. 
      List<Inspection__c> childVisits = [SELECT Id, Status__c, 
                                         Mater_Visit_for_Res_Cluster_of_Visits__c 
                                         FROM Inspection__c 
                                         WHERE Mater_Visit_for_Res_Cluster_of_Visits__c 
                                         IN : visitIdSet];
      Map<Id, List<Inspection__c>> childVisitsMapToMaster = new Map<Id, List<Inspection__c>>();
      if (childVisits != null && childVisits.size() > 0) {
        // Loop through the children and add them to a list in a mapping for their master.  
        for (Inspection__c child : childVisits) {
          // If the master already has a record then get the list and add the child to it. 
          if (childVisitsMapToMaster.containsKey(child.Mater_Visit_for_Res_Cluster_of_Visits__c)) {
            childVisitsMapToMaster.get(child.Mater_Visit_for_Res_Cluster_of_Visits__c).add(child);       
          } else {
            // If there is no record of this master then create one and add it's firse child.
            childVisitsMapToMaster.put(child.Mater_Visit_for_Res_Cluster_of_Visits__c, new List<Inspection__c>{child});    
          }
        }  
      }
      // Verify all the modified visits and check if the new version has a NEW master visit.  
      for (Inspection__c i : newInspectionList) {  
        Inspection__c masterVisit = modifiedVisits.get(i.Id);           
        Inspection__c oldMasterVisit = oldInspectionMap.get(i.Id);
        if (i.Mater_Visit_for_Res_Cluster_of_Visits__c == null) {
          // When Status of Master visit is changed, update the Status of all child visits associated
          if (masterVisit.Status__c != oldMasterVisit.Status__c) {
            updateChildVisitsData(masterVisit, childVisitsMapToMaster, 'Status__c');
          }
          //Keep visit status in sync
          if(childVisitsMapToMaster != null && childVisitsMapToMaster.size() > 0){
            for(Inspection__c childVisit : childVisitsMapToMaster.get(i.Id)){
              if(childVisit.Status__c != masterVisit.Status__c){
                updateChildVisitsData(masterVisit, childVisitsMapToMaster, 'Status__c');
              }
            }
          }
          
          // When Estimated Deadline is changed, update the Estimated Deadline of all child visits associated
          if (masterVisit.Estimated_Deadline__c != oldMasterVisit.Estimated_Deadline__c) {
            updateChildVisitsData(masterVisit, childVisitsMapToMaster, 'Estimated_Deadline__c');
          }
          // When Closed / Cancellation Date is changed, update the Closed / Cancellation Date of all child visits associated
          if (masterVisit.Closed_Cancellation_Date__c != oldMasterVisit.Closed_Cancellation_Date__c) {
            updateChildVisitsData(masterVisit, childVisitsMapToMaster, 'Closed_Cancellation_Date__c');
          }
          // When Cancellation Reason is changed, update the Cancellation Reason of all child visits associated
          if (masterVisit.Cancellation__c != oldMasterVisit.Cancellation__c) {
            updateChildVisitsData(masterVisit, childVisitsMapToMaster, 'Cancellation__c');
          } 
          /*
          // When Announced flag is changed, update the Announced flag of all child visits associated
          if (masterVisit.Announced__c != oldMasterVisit.Announced__c) {
            updateChildVisitsData(masterVisit, childVisitsMapToMaster, 'Announced__c');
          }*/
          // When Announced flag is changed, update the Announced flag of all child visits associated
          if (masterVisit.Announcement_Type__c != oldMasterVisit.Announcement_Type__c) {
            updateChildVisitsData(masterVisit, childVisitsMapToMaster, 'Announcement_Type__c');
          }
          // When Date of Visit is changed, update the Date of Visit of all child visits associated
          if (masterVisit.Date_of_Visit__c != oldMasterVisit.Date_of_Visit__c) {
            updateChildVisitsData(masterVisit, childVisitsMapToMaster, 'Date_of_Visit__c');
          }
          // When Time of Visit is changed, update the Time of Visit of all child visits associated
          if (masterVisit.Time_of_visit__c != oldMasterVisit.Time_of_visit__c) {
            updateChildVisitsData(masterVisit, childVisitsMapToMaster, 'Time_of_visit__c');
          }
          // When Activity Summary is changed, update the Activity Summary of all child visits associated
          if (masterVisit.Activity_Summary__c != oldMasterVisit.Activity_Summary__c) {
            updateChildVisitsData(masterVisit, childVisitsMapToMaster, 'Activity_Summary__c');
          }
          // When Corrective Action Required is changed, update the Corrective Action Required of all child visits associated
          if (masterVisit.Corrective_Action_Required__c != oldMasterVisit.Corrective_Action_Required__c) {
            updateChildVisitsData(masterVisit, childVisitsMapToMaster, 'Corrective_Action_Required__c');
          }
          // When Technical Assistance is changed, update the Technical Assistance of all child visits associated
          if (masterVisit.Tech_Assist_Recommendations_Comments__c != oldMasterVisit.Tech_Assist_Recommendations_Comments__c) {
            updateChildVisitsData(masterVisit, childVisitsMapToMaster, 'Tech_Assist_Recommendations_Comments__c');
          }
          // When Comments is changed, update the Comments of all child visits associated
          if (masterVisit.Comments__c != oldMasterVisit.Comments__c) {
            updateChildVisitsData(masterVisit, childVisitsMapToMaster, 'Comments__c');
          }
          // When Cover Letter Narrative is changed, update the Cover Letter Narrative of all child visits associated     
          if (masterVisit.Cover_Letter_Narrative__c != oldMasterVisit.Cover_Letter_Narrative__c) {
            updateChildVisitsData(masterVisit, childVisitsMapToMaster, 'Cover_Letter_Narrative__c');
          }
          // When Updates_Changes__c is changed, update the Updates_Changes__c of all child visits associated     
          if (masterVisit.Updates_Changes__c != oldMasterVisit.Updates_Changes__c) {
            updateChildVisitsData(masterVisit, childVisitsMapToMaster, 'Updates_Changes__c');
          }  
        }       
      }
      
      List<Inspection__c> fullChildrenList = new List<Inspection__c>();  
      for (Id key : childVisitsMapToMaster.keySet()) {
        fullChildrenList.addAll(childVisitsMapToMaster.get(key));        
      }

      flag = true;
      update fullChildrenList;
    }
    
    /**
     * updateChildVisitsData
     * 
     * This function will take in the master visit, its children and the fieldname that the children need to learn.
     * @author Darkis
     */
    private void updateChildVisitsData(Inspection__c masterVisit, Map<Id, List<Inspection__c>> childVisitsMapToMaster, String fieldname) {
      List<Inspection__c> childVisitsToMold = new List<Inspection__c>();
      childVisitsToMold = childVisitsMapToMaster.get(masterVisit.Id);
      // Loop through the children and mold their status to the masters. 
      if (childVisitsToMold != null && childVisitsToMold.size() > 0) {
        for (Inspection__c child : childVisitsToMold) {
          child.put(fieldname, masterVisit.get(fieldname));    
        }  
      }
    }
    
}