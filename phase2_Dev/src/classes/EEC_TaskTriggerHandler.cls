public with sharing class EEC_TaskTriggerHandler {
    
    public List<Task> newTaskList {get; set;}
    public Map<Id,Lead> leadMap {get; set;}
    public Map<Id,Investigation__c> invMap {get; set;}
    public static boolean FirstRun {get; set;}
    private Boolean getBulkAfter = false;
    
    public EEC_TaskTriggerHandler(List<Task> newList){
        newTaskList = newList;
        if(FirstRun == null){
            FirstRun = true;
        }
    }
    
    public void bulkAfter(){
        Set<Id> leadIds = new Set<Id>();
        Set<Id> invIds = new Set<Id>();
        for(Task tsk : newTaskList){
            if(String.isNotBlank(tsk.Subject) && tsk.Subject.contains('75 - FCC PPM Meeting - Certificate of Attendance') && tsk.whoId != null){
                leadIds.add(tsk.WhoId);
            }
            else if(String.isNotBlank(tsk.Subject) && (tsk.Subject.contains('Prepare and send investigation report to Provider') || tsk.Subject.contains('Review Non-Compliant Items Corrective Actions') || tsk.Subject != null) && tsk.WhatId != null){
                invIds.add(tsk.WhatId);
            }
        }
        if(leadIds != null && leadIds.size() > 0){
            leadMap = new Map<Id,Lead>([select Id,Status,PPM_Meeting_Attended_Date__c from Lead where Id in :leadIds]);
        }
        if(invIds != null && invIds.size() > 0){
            invMap = new Map<Id, Investigation__c>([SELECT ID, Name,Activities_Status__c FROM Investigation__c WHERE Id IN: invIds]);
        }
        this.getBulkAfter = true;
    }
    public void reopenInvestigationActivityStatus(){
        List<Investigation__c> updateInvs = new List<Investigation__c>();
        
        if(!getBulkAfter){
            bulkAfter();
        }
        if(invMap != null && invMap.size() > 0){
            for(Task tsk : newTaskList){
                System.debug('Inv Map' + invMap);
                Investigation__c inv = invMap.get(tsk.WhatId);
                if(invMap.keySet().contains(tsk.WhatId) && tsk.Status == 'Not Started' && (String.isBlank(inv.Activities_Status__c) || inv.Activities_Status__c == 'Closed')){
                    inv.Activities_Status__c = 'Open';
                    updateInvs.add(inv);
                }
            }
        }
        if(updateInvs.size() > 0){
            update updateInvs;
        }
    }
    public void updateInvestigationActivityStatus(){
        List<Investigation__c> updateInvs = new List<Investigation__c>();
        
        if(!getBulkAfter){
            bulkAfter();
        }
        if(invMap != null && invMap.size() > 0){
            for(Task tsk : newTaskList){
                if(tsk.Status == 'Completed' && invMap.keySet().contains(tsk.WhatId)){
                    Investigation__c inv = invMap.get(tsk.WhatId);
                    inv.Activities_Status__c = 'Closed';
                    Integer openTasks = [SELECT COUNT() FROM Task WHERE WhatId =: inv.Id AND Status != 'Completed'];
                    if(openTasks != null && openTasks < 1){
                        updateInvs.add(inv);
                    }
                }
            }
            if(updateInvs.size() > 0)
                update updateInvs;
        }
    }
    
    public void updateLeads(){
        List<Lead> updateLeads = new List<Lead>();
        if(leadMap != null && leadMap.size() > 0){
            if(!getBulkAfter){
                bulkAfter();
            }
            for(Lead ld : leadMap.values()){
                ld.status = 'Attended';
                if(ld.PPM_Meeting_Attended_Date__c == null){
                    ld.PPM_Meeting_Attended_Date__c = Date.Today();
                }
                updateLeads.add(ld);
            }
            update updateLeads;
        }
    }
}