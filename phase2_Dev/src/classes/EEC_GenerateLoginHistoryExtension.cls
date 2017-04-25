public class EEC_GenerateLoginHistoryExtension {

    private Id conId;

    public EEC_GenerateLoginHistoryExtension(ApexPages.StandardController ctr){
        this.conId = ctr.getId();
    } 
    
    public List<Login_History__c> getLoginHistory(){
        
        List<Login_History__c> lHistory = new List<Login_History__c>();
        User[] user = [SELECT Id FROM User WHERE IsActive = true AND IsPortalEnabled = true AND contactId = :conId];
        if(user.size() > 0){
            lHistory = [
                SELECT Browser__c, LoginType__c, Platform__c, Status__c, Id, LoginTime__c 
                  FROM Login_History__c 
                WHERE UserId__c =: user[0].Id
                AND LoginTime__c = LAST_N_DAYS:120 
                ORDER BY LoginTime__c DESC
            ]; 
        }
        
        return lHistory;

    }
}