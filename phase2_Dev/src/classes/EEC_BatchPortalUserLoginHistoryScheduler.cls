global class EEC_BatchPortalUserLoginHistoryScheduler implements schedulable{

    public void execute (SchedulableContext sc) { 
   
    EEC_BatchPortalUserLoginHistoryUpdate ur = new EEC_BatchPortalUserLoginHistoryUpdate('SELECT Id, LastLoginDate, ' + 
                       'Contact.Id, Contact.Has_Logged_In__c ' +
            		   'FROM User WHERE LastLoginDate != null AND IsPortalEnabled = true ' +
            		   'AND IsActive = true AND Contact.Has_Logged_In__c = false');
        
    id buser = database.executebatch(ur, 10);
         
  }
}