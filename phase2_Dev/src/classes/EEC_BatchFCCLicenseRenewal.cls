global class EEC_BatchFCCLicenseRenewal implements Database.Batchable <sObject>{
    
    String pQuery = '';
    global EEC_BatchFCCLicenseRenewal(String query)
    {
        this.pQuery =  query;
    }
    
    global EEC_BatchFCCLicenseRenewal()
    {
        this.pQuery =  'Select Id,name,Start_Renewal_Workflow__c,License_Status__c,Renewal_date__c,Recordtype.Name,Is_Provider_With_Licensing_Transaction__c, OwnerId,Provider_Status__c from Account  where License_Status__c = \'Licensed\' ' +
                                                               ' and (Recordtype.Name = \'Family Child Care\' OR Recordtype.Name = \'FCC Assistant\' '+ 
            												   ' OR Recordtype.Name = \'Group Care\' ' +
                                                         	   ' OR Recordtype.Name = \'Adoption Agency\' ' +
                                                         	   ' OR Recordtype.Name = \'Temporary Shelter\' ' +
                                                               ' OR Recordtype.Name = \'Foster Care Agency\' ' +
                                                               ' OR Recordtype.Name = \'Large Group\' ' +    
                                                         	   ' OR Recordtype.Name = \'Small Group\') ';
         //for testing for Ben
         //this.pQuery = 'Select id,name,Start_Renewal_Workflow__c,Renewal_date__c,Recordtype.Name,Is_Provider_With_Licensing_Transaction__c, OwnerId,License_Status__c from Account where id =\'0012100000LKWEZ\' ';                                                	   
    }
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(pQuery);
    } 
     
    global void execute(Database.BatchableContext BC, List <Account> providerList)
    {    
        Set<Id> provIds = new Set<Id>();
        Date cDate =  System.today();
        List<Account> providerupdatelist = new List<Account>();
        List<Task> providerTasks = new List<Task>();
                        
        for(Account provider : providerList){
            
            Task tsk = new Task();
            tsk.WhatId = provider.Id;
            tsk.OwnerId = provider.OwnerId;
            tsk.Status = 'Not Started';
            tsk.Priority = 'High';
          
          //FCC Assistant Update
          
          if(provider.Renewal_date__c != null && provider.License_Status__c != null)
          system.debug('MMMM'+provider.Renewal_date__c.addDays(30)+cdate+provider.License_Status__c);
          {                                                      
            if (cdate == provider.Renewal_date__c.addDays(30) && provider.License_Status__c=='Licensed' &&!provider.License_Status__c.contains('freeze') &&(provider.Recordtype.Name == 'Group Care'
                || provider.Recordtype.Name == 'Adoption Agency' || provider.Recordtype.Name == 'Foster Care Agency' || provider.Recordtype.Name == 'Small Group' || provider.Recordtype.Name == 'Large Group')){
               
               tsk.Subject = Provider.name + ' - Renewal Application Not Submitted - 30 days after expiration notice';
               tsk.ActivityDate = Date.today().addDays(2);
               tsk.Priority = 'Normal';
               if(provider.Recordtype.Name == 'FCC Assistant')
                       tsk.Priority = 'High';  
            }
            
            else{
                if (cdate == provider.Renewal_date__c && provider.License_Status__c=='Licensed' && (provider.Recordtype.Name == 'Group Care'|| 
                   provider.Recordtype.Name == 'Adoption Agency' || provider.Recordtype.Name == 'Foster Care Agency' || provider.Recordtype.Name == 'Small Group' || provider.Recordtype.Name == 'Large Group')){
                   tsk.Subject = Provider.name + ' - Renewal Application Not Submitted - On expiration date notice';
                   tsk.ActivityDate = Date.today().addDays(2);
                }
                else if (cdate == provider.Renewal_date__c.addDays(-30) && provider.License_Status__c=='Licensed' && Provider.Is_Provider_With_Licensing_Transaction__c==true ){
                   
                       tsk.Priority = 'Normal';
                   tsk.Subject = Provider.name + ' - Renewal Application Not Submitted - 30 days prior expiration notice';
                   tsk.ActivityDate = Date.today().addDays(5);
                
                }
                else{
                  List<Licensing_Transaction__c>  r =[SELECT Id, Provider__c FROM Licensing_Transaction__c 
                                                    WHERE Provider__c  = :provider.Id 
                                                    AND (Recordtype.Name = 'FCC Renewal' 
                                                         OR Recordtype.Name = 'FCC Assistant Renewal'
                                                         OR Recordtype.Name = 'GSA Renewal'
                                                         OR Recordtype.Name = 'Placement Renewal'
                                                         OR Recordtype.Name = 'Residential Renewal') 
                                                    AND (Submission_Date__c >= :cDate - 365 ) 
                                                    AND status__c in ('Submitted','Under Review','Pending Manager Approval','Approved By Manager','Closed (License Issued / Updated)')];
                  
                  if ((provider.Renewal_date__c.addDays(45) >= cDate) && Provider.Is_Provider_With_Licensing_Transaction__c==true && (provider.Renewal_date__c.addDays(-120) <= cDate) && r.size() == 0 && provider.License_Status__c == 'Licensed' /*-- F. Lecoq / 03/15/2016 - LEAD3432 -- && provider.Start_Renewal_Workflow__c == false*/ ){                     
                     system.debug('MMMMM'+provider.Renewal_date__c+Provider.Is_Provider_With_Licensing_Transaction__c+Provider.License_Status__c);
                     provider.Start_Renewal_Workflow__c = true;
                  }
                 else{
                     provider.Start_Renewal_Workflow__c = false;
                 }
                } 
             } 
             providerupdatelist.add(provider);
             providerTasks.add(tsk);
          }
             
         }
                       
        if (providerupdatelist <> null && providerupdatelist.size() > 0){
               
            Database.update(providerupdatelist);
            Database.insert(providerTasks);
        }
       
    }  
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
}