public with sharing class EEC_UserTriggerHandler {
    
    List<User> newList;
    Map<Id,User> oldMap;
    Map<Id,Account> accountMap;
    Map<Id,Contact> contactMap;
    Set<Id> hasActiveUsers;
    
    public EEC_UserTriggerHandler(List<User> newList,Map<Id,User> oldMap){
        this.newList = newList;
        this.oldMap = oldMap;
    }
    
    public void bulkAfter(){
        
        Set<Id> accountIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        hasActiveUsers = new Set<Id>();
        
        for(User usr :newList){
            if(usr.AccountId != null){
                accountIds.add(usr.AccountId);
            }
            if(user.ContactId != null)
                contactIds.add(usr.ContactId);
        }
        
        if(accountIds != null && accountIds.size() > 0){
            accountMap = new Map<Id,Account>([select Id,Electronic_Communication__c,Provider_Email__c,OwnerId from Account where Id in :accountIds]);
            for(User usr :[select Id,isActive,IsPortalEnabled,AccountId from User where AccountId in :accountIds and isActive = true]){
                hasActiveUsers.add(usr.AccountId);
            }
        }
        if(contactIds != null && contactIds.size() > 0){
            contactMap = new Map<Id,Contact>([SELECT Id,Name,Is_Portal_User__c,Has_Logged_In__c FROM Contact WHERE ID IN: contactIds]);
        }
        
    }
    
    public void updateActiveAccounts(){
        List<Account> updateAccounts = new List<Account>();
        Account newAccnt;
        Boolean sUpdate = false;
        for(User usr :newList){
            if(usr.IsPortalEnabled && usr.AccountId != null && usr.isActive){
                newAccnt = accountMap.get(usr.AccountId);
                sUpdate = false;
                if(!newAccnt.Electronic_Communication__c){
                    newAccnt.Electronic_Communication__c = true;
                    sUpdate = true;
                }
                if(String.isBlank(newAccnt.Provider_Email__c)){
                    newAccnt.Provider_Email__c = usr.Email;
                    sUpdate = true;
                }
                if(sUpdate){
                    updateAccounts.add(newAccnt);
                }
            }
        }
        if(updateAccounts != null && updateAccounts.size() > 0){
            try{
                update updateAccounts;
                } catch(Exception e){
                    System.debug(e);
                }
            
        }
    }
    
    public void updateActiveContacts(){
        List<Contact> updateContacts = new List<Contact>();
        Contact newCon;
        Set<Id> updatedIds = new Set<Id>();
        for(User usr :newList){
          if(usr.IsPortalEnabled && user.ContactId != null && usr.IsActive){
                newCon = contactMap.get(usr.ContactId);
                if(!newCon.Is_Portal_User__c){
                    newCon.Is_Portal_User__c = true;
                    if(usr.LastLoginDate != null)
                        newCon.Has_Logged_In__c = true;
                    updateContacts.add(newCon);
                    updatedIds.add(newCon.Id);
                }
                if(!updatedIds.contains(newCon.Id) && newCon.Is_Portal_User__c && usr.LastLoginDate != null){
                    newCon.Has_Logged_In__c = true;
                  updateContacts.add(newCon);
                }
            }
        }
        if(updateContacts != null && updateContacts.size() > 0){
            try{
        update updateContacts;
      } catch(Exception e){
                System.debug('error-->' + e);
        System.debug(e);
      }
        }
    }
    
    public void updateInActiveAccounts(){
        Account newAccnt;
        User oldUsr;
        Map<Id,Id> accntIdMap = new Map<Id,Id>();
        for(User usr :newList){
            oldUsr = oldMap.get(usr.Id);
            if(oldUsr.IsPortalEnabled && oldUsr.isActive && !usr.isActive){
                newAccnt = accountMap.get(oldUsr.AccountId);
                if(hasActiveUsers == null || newAccnt.Provider_Email__c == usr.Email || !hasActiveUsers.contains(usr.AccountId)){
                    accntIdMap.put(newAccnt.Id,newAccnt.OwnerId);
                }
            }
        }
        if(accntIdMap != null && accntIdMap.size() > 0){
            createTasks(accntIdMap);
        }
    }
    
    public static void updatecontact(List<User> oldUser,List<User> newUser,Map<Id,User> oldMap,Map<Id,User> newMap){
        Map<Id,User> usermap = new Map<Id,User>();
        Set<ID> useridset = new Set<ID>();
        Set<ID> contactIDSet = new Set<ID>();
        List<Contact> contacttoupdate = new List<Contact>();
        
            System.debug('my method');
            for(User newuserrec : newUser){
                User olduserrec= oldMap.get(newuserrec.id);
                System.debug('fname'+newuserrec.FirstName);
                System.debug('fname'+olduserrec.FirstName);
                  if(olduserrec.FirstName != newuserrec.FirstName || 
                         olduserrec.LastName != newuserrec.LastName || 
                         olduserrec.Title != newuserrec.Title ||  
                         olduserrec.MobilePhone != newuserrec.MobilePhone || 
                         olduserrec.Email != newuserrec.Email ||                          
                         olduserrec.Phone != newuserrec.Phone ||
                         olduserrec.Extension != newuserrec.Extension||                        
                          olduserrec.Salutation__c != newuserrec.Salutation__c)
                          {
                             useridset.add(newuserrec.id);
                             if(newuserrec.contactID != null ){contactIDSet.add(newuserrec.contactID);
                                 usermap.put(newuserrec.contactID ,newuserrec);}
                          }          
            }
            
             if(contactIDSet.size()>0 && usermap != null)
             {
              for(Contact conrecord: [SELECT Id,FirstName,Extension__c,Salutation,LastName,Title,MobilePhone,Email,Phone FROM Contact WHERE id in :contactIDSet]){
                     conrecord.FirstName = usermap.get(conrecord.id).FirstName ;
                      conrecord.LastName = usermap.get(conrecord.id).LastName;
                       conrecord.Title = usermap.get(conrecord.id).Title ;
                        conrecord.MobilePhone= usermap.get(conrecord.id).MobilePhone;
                         conrecord.Email = usermap.get(conrecord.id).Email ;
                          conrecord.Phone = usermap.get(conrecord.id).Phone ;
                          conrecord.Extension__c = usermap.get(conrecord.id).Extension ;
                          conrecord.Salutation = usermap.get(conrecord.id).Salutation__c;
                          contacttoupdate.add(conrecord);
                        
              }
   
    }
    
    if(contacttoupdate.size()>0){
       
        update contacttoupdate ;
        
      }  
   }
    
    @future
    public static void createTasks(Map<Id,Id> accntIdMap){
        List<Task> insertTasks = new List<Task>();
        
        for(Id accntId : accntIdMap.keySet()){
            Task tsk = new Task();
            tsk.Subject = 'Electronic Communication Issue on Provider';
            tsk.Description = 'Please check one these 2 cases may have happen: this provider has "Electronic Communication" checked but no more active Portal user, or the email address of the provider is associated to a non-active Portal user';
            tsk.Priority = 'Normal';
            tsk.ActivityDate = Date.today().addDays(3);
            tsk.Status = 'Not Started';
            tsk.OwnerId = accntIdMap.get(accntId);
            tsk.WhatId = accntId;
            insertTasks.add(tsk);
        }
        
        insert insertTasks;
    }
}