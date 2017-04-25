global class EEC_BatchFCCLicenseRenewalScheduler implements schedulable {
  
  public void execute (SchedulableContext sc) {
    
   
    EEC_BatchFCCLicenseRenewal fr = new EEC_BatchFCCLicenseRenewal('Select Id,Start_Renewal_Workflow__c,License_Status__c,Renewal_date__c,Recordtype.Name, OwnerId,Provider_Status__c from Account  where License_Status__c = \'Licensed\' ' +
                                                               ' and (Recordtype.Name = \'Family Child Care\' OR Recordtype.Name = \'FCC Assistant\' '+ 
            												   ' OR Recordtype.Name = \'Group Care\' ' +
            												   ' OR Recordtype.Name = \'Temporary Shelter\' ' +
                                                         	   ' OR Recordtype.Name = \'Adoption Agency\' ' +
                                                               ' OR Recordtype.Name = \'Foster Care Agency\' ' +
                                                               ' OR Recordtype.Name = \'Large Group\' ' +    
                                                         	   ' OR Recordtype.Name = \'Small Group\') ');
    id boccemea = database.executebatch(fr,10);
  }
  
}