global class EEC_BatchPortalUserLoginHistoryUpdate implements Database.Batchable <sObject>{

    String pQuery = '';
    global EEC_BatchPortalUserLoginHistoryUpdate(String query)
    { 
        this.pQuery =  query;
    }
    
    global EEC_BatchPortalUserLoginHistoryUpdate()
    {
        this.pQuery =  'SELECT Id, LastLoginDate, ' + 
                       'Contact.Id, Contact.Has_Logged_In__c ' +
            		   'FROM User WHERE LastLoginDate != null AND IsPortalEnabled = true ' +
            		   'AND IsActive = true AND Contact.Has_Logged_In__c = false';
    }
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(pQuery);
    } 
    global void execute(Database.BatchableContext BC, List<User> userList)
    {
        Set<Id> userIds = new Set<Id>();
        List<Contact> contactUpdateList = new List<Contact>();
        
       for(User user : userList){
           Contact con = new Contact();
           con.Id = user.ContactId;
           con.Has_Logged_In__c = true;
           contactUpdateList.add(con);
       }
       if (contactUpdateList <> null && contactUpdateList.size() > 0){
           Database.update(contactUpdateList);
       }
    }
    global void finish(Database.BatchableContext BC)
    {
        if(!Test.isRunningTest()){
     		database.executebatch(new EEC_BatchLoginHistoryUpdate(), 10);    
        }
    }
}