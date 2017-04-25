public  class EEC_ContactTriggerHandler {
    
    public List<Contact> ct {get; set;}
    public List<Contact> newC {get; set;}
    public Map<Id,Contact> oldC {get; set;}
    public Map<Id,Id> CCMap {get; set;}
    public Set<id> contactIdSet {get; set;}
    private static list<case> caselist = new list<case> ();
    //private string contactid;
        
    public EEC_ContactTriggerHandler(List<Contact> newListC, Map<Id,Contact> oldMapC){
        this.newC = newListC;
        this.oldC = oldMapC;
    }
    
   
    public static void updateUser(List<Contact> newListC,List<Contact> oldListC, Map<Id,Contact> oldMapC,  Map<Id,Contact> newMapC){

        Map<Id,Contact> accounttoupdate = new  Map<Id,Contact>();
        
           // for contact
        set<ID> contactidset = new  set<ID>();        
        Map<Id,User> usermap= new  Map<Id,User>();
        list<User> userstoUpdate = new list<User>(); 
        
        //forloop for contact
        for(Contact newContact : newListC){
            
            Contact oldContact = oldMapC.get(newContact.id);
            system.debug('====>'+UserInfo.getUserType());
            system.debug('====>'+newContact);
            if( (oldContact.FirstName != newContact.FirstName || 
                         oldContact.LastName != newContact.LastName || 
                         oldContact.Title != newContact.Title ||  
                         oldContact.MobilePhone != newContact.MobilePhone || 
                         oldContact.Email != newContact.Email ||                          
                         oldContact.Phone != newContact.Phone ||
                         oldContact.Extension__c!= newContact.Extension__c||
                         oldContact.Salutation != newContact.Salutation))
                          {
                             contactidset.add(newContact.id);    
                          }          
                          
                          if( newContact.Role__c == 'Main Contact / Licensee'
                             && (oldContact.Email != newContact.Email ||                          
                                 oldContact.Phone != newContact.Phone))
                          {
                             accounttoupdate.put(newContact.AccountId, newContact);    
                          } 
                          
                      }
                      
          if(contactidset.size()>0){            
        for(User userrecord: [SELECT Id,FirstName,LastName,Title,MobilePhone,Email,Phone,Contact.Salutation,Contact.Extension__c,ContactId   FROM User WHERE ContactId =: contactidset ]){
            usermap.put(userrecord.ContactId ,userrecord);
         }   
       // system.debug('accounttoupdate: ' + accounttoupdate);
        if(accounttoupdate.keySet().size()>0){   
        
        List<Account> listAccounts = new List<Account>();
                 
        for(Account accountrecord: [SELECT Id,Provider_Email__c,Phone,RecordTypeID  FROM Account WHERE Id in : accounttoupdate.keySet()]){
           if((Schema.SObjectType.Account.getRecordTypeInfosByName().get('FCC Assistant').getRecordTypeId() == accountrecord.recordTypeID || Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family Child Care').getRecordTypeId() == accountrecord.recordTypeID)){
           Account accrecord= new Account(id = accountrecord.id);
           accrecord.Provider_Email__c = accounttoupdate.get(accountrecord.Id).Email;
            accrecord.Phone   = accounttoupdate.get(accountrecord.Id).Phone;
            listAccounts.add(accrecord);
         } 
           
        // system.debug('listAccounts: ' + listAccounts);
         update listAccounts;
         }
         }
         //Savepoint sp = Database.setSavepoint();
        map<id,String> userIDUsernameMap = new map<id,String>();
        for(ID contactID : contactidset){
        
            if(usermap.get(contactID) != null && ((UserInfo.getUserType() == 'CspLitePortal' && UserInfo.getUserID() == usermap.get(contactID).id) || UserInfo.getUserType() == 'Standard')){
                User userrecord = new User(id = usermap.get(contactID).id);
                userrecord.FirstName = newMapC.get(contactID).FirstName;
                userrecord.LastName = newMapC.get(contactID).LastName ;
                userrecord.Title = newMapC.get(contactID).Title ;
                userrecord.MobilePhone= newMapC.get(contactID).MobilePhone;
                userrecord.Email = newMapC.get(contactID).Email ;
                //userrecord.UserName = newMapC.get(contactID).Email;
                userrecord.Phone = newMapC.get(contactID).Phone ;
                
                userrecord.Salutation__c = newMapC.get(contactID).Salutation;
                userrecord.Extension = newMapC.get(contactID).Extension__c ;
                if(userrecord.Email != userrecord.UserName){
                    userIDUsernameMap.put(userrecord.id,userrecord.email);
                }
                userstoUpdate.add(userrecord);
            }
        }
        if(userstoUpdate.size()>0){
       
        update userstoUpdate;
        userupdate(userIDUsernameMap);
        
      }
       } 
         
    }
    
    @future
    public static void userupdate(map<id,string> useridUsernameMap){
        list<User> userlist = new list<User>();
        for(ID userID : useridUsernameMap.keyset()){
            userlist.add(new User(id = userID,UserName = useridUsernameMap.get(userID))); 
        }
       // system.debug('======'+userlist);
        update userlist;
    //update userstoUpdate;
    
    }
    
    public void createTransaction(){
    
        User portalUser = [SELECT Id, IsPortalEnabled, UserType  FROM USER WHERE Id =: Userinfo.getUserId() LIMIT 1];
        if(portalUser.UserType == 'PowerCustomerSuccess' || portalUser.UserType == 'CustomerSuccess'){
        Id fccRecordTypeId = EEC_RecordTypeUtil.findByName('ACCOUNT.FCC').Id;
        
        for(Contact newContact : newC){
            Contact oldContact = oldC.get(newContact.id);
            
            Account provider = [SELECT Id, Recordtype.Name, RecordTypeId FROM Account 
                                WHERE ID IN (SELECT AccountId FROM user WHERE id = :Userinfo.getUserId()) LIMIT 1];
            
            
            if((oldContact.FirstName != newContact.FirstName || 
               oldContact.LastName != newContact.LastName) && fccRecordTypeId == provider.RecordTypeId &&
              (portalUser.IsPortalEnabled == true || portalUser.UserType == 'PowerCustomerSuccess')){
                  
                Licensing_Transaction__c lt = new Licensing_Transaction__c();
                
                lt.RecordTypeId = EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.FCC_Change_of_Name').Id;
                lt.Prior_First_Name__c = oldContact.FirstName;
                lt.Prior_Last_Name__c = oldContact.LastName;
                lt.New_First_Name__c = newContact.FirstName;
                lt.New_Last_Name__c = newContact.LastName;
                lt.Proposed_New_Provider_Name__c = newContact.FirstName + ' ' + newContact.LastName;
                lt.Provider__c = oldContact.AccountId;
                lt.Status__c = 'Submitted';
                lt.Submission_Date__c = Date.today();
                lt.Submitter__c = Userinfo.getUserId();
                lt.Source__c = 'Provider Portal';
                
                insert lt;
                }
            }
        }
    }
   public void AccountMandatory(){
       contactidset = new Set<id>();
       CCMap = new Map<Id,Id>();
       for(contact c : newC){
         contactidset.add(c.id);
       }
       caselist =[SELECT id,Contactid,Foster_Parent__c FROM Case WHERE contactid IN: contactidset];
       for(Case Cs : caselist){
          CCMap.put(Cs.contactid,Cs.id);
       }
       for(Contact Ct: newC){
        	if(ct.accountid == null && CCMap.get(Ct.id)==null)
         		ct.adderror('All Contacts must have either an Associated Case or Provider Name');
       }
    }    
     public void createContactRole(){        
        set<ID> contactid = new  set<ID>();
        list<contact> updatelist = new list<contact>();
        for(Contact newContact : newC){
           contactid.add(newContact.id);
        }
        list<Contact> Con = new list<contact>([Select id,name,accountid,account.Provider_Status__c,account.Is_GSA__c,account.CreatedDate,Role__c from contact where id IN: contactid]);
        for(Contact C : Con){
            Date myDate = date.newinstance(C.account.createddate.year(), C.account.createddate.month(), C.account.createddate.day());
            if(C.account.Provider_Status__c == 'Attended to PPM Meeting' && mydate == date.today() && C.account.Is_GSA__c == true && string.isnotBlank(C.Role__c)){
	            Contact_Role__c CR = new Contact_Role__c();
	            CR.Start_Date__c = date.today();
	            CR.Role__c = C.Role__c;
	            CR.Contact__c = C.id;
	            CR.Provider__c = C.Accountid;
	             
	            insert CR;
	            
	            C.Role__c = '';
	            
	            Updatelist.add(C);
        	}
        }
        update Updatelist;
     }
}