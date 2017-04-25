public class EEC_CaseOnClosedProviderController {
    
    protected final Case c;

    public EEC_CaseOnClosedProviderController(ApexPages.StandardController ctr){
        this.c = (Case) ctr.getRecord();
    }
    
    public void updateReminder(){
        if((c.Account.Provider_Status__c == 'Voluntary Closure' || 
            c.Account.Provider_Status__c == 'Application Withdrawn / Closed') && 
           c.Account.RecordType.Name != 'Unlicensed Provider' && 
           !c.Provider_Closed_Reminder__c){
           		Case c = [SELECT Id, Provider_Closed_Reminder__c FROM Case WHERE Id =: c.Id];
                c.Provider_Closed_Reminder__c = true;
                update c;
        	}
    }
  }