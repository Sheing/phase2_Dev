global class EEC_BatchLoginHistoryUpdate implements Database.Batchable <sObject>{

    String pQuery = '';
    global EEC_BatchLoginHistoryUpdate(String query) 
    {
        this.pQuery =  query;
    }
    
    global EEC_BatchLoginHistoryUpdate()
    {
        this.pQuery =  'SELECT Browser, LoginType, Platform, Status, Id, LoginTime,UserId ' +
            		   'FROM LoginHistory ' +
            		   'WHERE UserId IN (SELECT Id FROM User WHERE IsActive = true AND IsPortalEnabled = true) ' +
            		   ' AND LoginTime = LAST_N_DAYS:120 ORDER BY LoginTime DESC';
    }
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(pQuery);
    } 
    global void execute(Database.BatchableContext BC, List<LoginHistory> loginHistory)
    {
        List<Login_History__c> loginHistoryInsertList = new List<Login_History__c>();
        
        List<Login_History__c> lHist = [SELECT Id,Name FROM Login_History__c WHERE CreatedDate <> TODAY];
        if(lHist <> null && lHist.size() > 0)
            Database.delete(lHist);
                
        for(LoginHistory h : loginHistory){
           Login_History__c lh = new Login_History__c();
           lh.Browser__c = h.Browser;
           lh.LoginTime__c = h.LoginTime;
           lh.Status__c = h.Status;
           lh.Platform__c = h.Platform;
           lh.LoginType__c = h.LoginType;
           lh.UserId__c = h.UserId; 
            
           loginHistoryInsertList.add(lh); 
       }
       
       if (loginHistoryInsertList <> null && loginHistoryInsertList.size() > 0){
           Database.insert(loginHistoryInsertList);
       }
    }
    global void finish(Database.BatchableContext BC)
    {
        
    }
  }