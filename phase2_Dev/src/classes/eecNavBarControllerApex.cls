public with sharing class eecNavBarControllerApex {
    
	@AuraEnabled
    public static String getUserType() {
        return userinfo.getUserType();
    }
    
    @AuraEnabled
    public static String getContactId() {
        return userinfo.getUserType();
    }
    
    @AuraEnabled
    public static String getSitePrefix() {
        return userinfo.getUserType();
    }
    
    @AuraEnabled
    public static Account getAccount() {
        
        Account acc;
        
        try {          	
            acc = [SELECT Id, Name, Recordtype.Name, OwnerId FROM Account 
                       WHERE ID in (SELECT AccountId FROM USER WHERE id = :Userinfo.getUserId()) LIMIT 1];
          	return acc; 
        }    
        catch(Exception e) {
          return acc;  
        }
  }  
}