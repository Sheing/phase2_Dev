public without sharing class EEC_PortalLandingController {
   
 //private String loggedInUser;//variable to store the logged in user id.
 public Account acc {get; set;}
 public User licensor {get;set;}
 public Lead_Configuration__c leadConfig {get;set;}   
 public String profileName {get;set;} 
 public List<MenuItem> lstMenuItems {get; set;}
 public List<Account> providerslist {get; set;}
 public Map<String, String> secureIdMap { get; set; } 
 public List<Licensing_Transaction__c> providerDraftLT {get; set;}
 public List<Licensing_Transaction__c> providerInProgressLT {get; set;}   
 public List<Licensing_Transaction__c> providerProcessedLT {get; set;}
    
 public List<Inspection_Item__c> visititems {get;set;}
 public List<Non_Compliant__c> noncompitems { get; set; }  
    
 public Boolean accessProviderFlag {get;set;}
 public Boolean accessUmbrellaFlag {get;set;}
 public integer remainingDays {get; set;} 
 public integer LeadconfigDays {get; set;}  
 public Boolean isFccAssistant {get; set;}   
 public void EEC_PortalLandingController(){

   accessProviderFlag=false;
   accessUmbrellaFlag=false;
   actionMethod();
 }
    
 public PageReference gotoPersonalPage() {
   Id uid = Userinfo.getUserId();
   USER u = [Select Id,ContactId from User where Id =: uid limit 1];
   PageReference contactPage = Page.EEC_ContactPage;
   contactPage.getParameters().put('Id',u.ContactId);
   contactPage.getParameters().put('page','home'); 
   contactPage.setRedirect(true);
   return contactPage;       
 }

 public pagereference actionMethod() {
   List<Profile> profiles = [SELECT Name from Profile where Id = :UserInfo.getProfileId() LIMIT 1]; 
   if(profiles.size() > 0) 
    profileName = profiles[0].Name;  
     
   acc = [SELECT Id, Name, RecordType.Name, RecordType.DeveloperName, Use_Physical_Restraints__c, Restraint_Method__c,
          Provider_Status__c,License_Type__c, Certified_As__c, License_Status__c, OwnerId,
           Capacity__c, Last_Issue_Date__c, Renewal_date__c,Is_GSA__c
          From Account where ID in (SELECT Accountid FROM User  WHERE id = :Userinfo.getUserId()) LIMIT 1 ]; 
   if(acc.Recordtype.Name.contains('FCC Assistant')){
       isFccAssistant = true;  
   }
   licensor = [SELECT Id, Name, Email FROM User WHERE Id = :acc.OwnerId Limit 1];
   if(acc.Renewal_date__c != null)  
    remainingDays = Date.today().daysBetween(acc.Renewal_date__c);
    system.debug('Remaining Days'+remainingdays);
   if (acc <> null ){       
     If (acc.Recordtype.Name.contains('Umbrella')){
       secureIdMap = new Map<String, String>();  
       getproviderslist(acc.Id);
       createSecureMemberMap();  
       accessUmbrellaFlag = true;
     }else{
       accessProviderFlag = true;
       providerDraftLT = getLicensingTransactionByStatus(acc.Id, new List<String>{'To Submit'}); 
       providerInProgressLT = getLicensingTransactionByStatus(acc.Id, new List<String>{'Under Review'});
       providerProcessedLT = getLicensingTransactionByStatus(acc.Id, new List<String>{'Closed (Processed)', 'Closed (License Issued / Updated)'});  
         
       visititems = [SELECT ID, Name 
                  FROM Inspection_Item__c 
                    WHERE Inspection_No__r.Provider_No__c = :acc.Id 
                    AND To_Review_on_Portal__c = true LIMIT 150];
    noncompitems = [SELECT Id, Name
                      FROM Non_Compliant__c 
                      WHERE Investigation__r.Provider_No__c = :acc.Id 
                      AND To_Review_on_Portal__c = true limit 150];
     }
      // Get the LEAD config.
   Lead_Configuration__c[] leadConfigs = [Select Id,Name, Portal_Home_Useful_Links__c, Portal_Home_Welcome__c, Portal_Home_Latest_News__c,GSA_days_Prior_Renewal_Can_Go_To_Meeting__c From Lead_Configuration__c Where Name = :acc.RecordType.Name];
  if(leadConfigs.size() > 0)
    {
        leadConfig = leadConfigs[0];
        LeadconfigDays = integer.valueof(leadConfig.GSA_days_Prior_Renewal_Can_Go_To_Meeting__c);
        system.debug('Lead Confid days'+LeadconfigDays);
    }
     getMenuItems();  
   }
     
  
   //   return accessProviderFlag;
   return null;  
 }
    public List<Licensing_Transaction__c> getLicensingTransactionByStatus(Id accountID, List<String> status){
        List<Licensing_Transaction__c> providerLTs = [SELECT Id, Name, Status__c, RecordType.Name, 
                                                      Last_Reached_Step__c, Assigned_To__r.Name  
                                                      FROM Licensing_Transaction__c  
                                                      WHERE Provider__c =: accountID AND Status__c IN: status ORDER BY CreatedDate DESC LIMIT 5];
        
        return providerLTs;
    }
    
    public Lead_Configuration__c getLeadConfiguration() {
        return leadConfig;
    }
 
    public Account getAccount(){
        return acc;
    }
    
    public void getproviderslist(Id accountId) {
      providerslist = [SELECT Id, Name, Provider_Number__c, Provider_city_text__c, 
                         Phone, License_Status__c, Provider_Status__c,Is_GSA__c
                         FROM Account WHERE Umbrella_Members__c = :accountId 
                         AND License_Status__c = 'Licensed'
                         ORDER BY Name ASC NULLS LAST
                         LIMIT 50];
    }
    private void createSecureMemberMap() {
        for (Account acc : providerslist) {
          secureIdMap.put(acc.Id, EncodingUtil.urlEncode(EEC_Util.encryptGetParam(acc.Id), 'UTF-8'));
        }
    }
               
    public PageReference goToProviderPage() {    
        PageReference pPage = page.EEC_PortalProviderPage;
        return pPage;
    }
    public PageReference goToUmbrellaPage() {
        PageReference pPage = page.EEC_Umbrella;
        return pPage;
    }
    
    public PageReference goToSubmitNewTransaction() {
        PageReference pPage = page.EEC_TransactionIntroduction;
        return pPage;
    }
   
   public PageReference noncomp() {
        PageReference pPage = page.EEC_PortalNonCompliancePage;
        return pPage;
   
    } 
   public PageReference investigationPage() {
        PageReference pPage = page.EEC_Interventionpage;
        return pPage;
        
    }
     public PageReference goToSubmitNewIncident() {
        PageReference pPage = page.EEC_CasesIncidentsPage;
        return pPage;
    }
    
    public PageReference goToSubmitNewRestraint() {
        PageReference pPage = Page.EEC_RestraintReport;
        return pPage;
    }

    public PageReference goToNonComplianceAction() {
        PageReference pPage = Page.EEC_PortalNonCompliancePage;
        return pPage;
    }
  public String getEncryptedAccountId() {
      return EncodingUtil.urlEncode(EEC_Util.encryptGetParam(acc.Id), 'UTF-8');
    }
    public void getMenuItems(){
        lstMenuItems = new List<MenuItem>();
        if(acc.Recordtype.Name.contains('Umbrella')){
            lstMenuItems.add(new MenuItem('Your Umbrella Information','Review your umbrella information, and select a provider to review','fa-umbrella','EEC_Umbrella'));
        }
        else if(acc.Recordtype.Name.contains('Assistant')){
            lstMenuItems.add(new MenuItem('Assistant Information','Review your certificate information as well as the transaction and other past interactions with EEC.','fa-user','EEC_PortalProviderPage'));
            lstMenuItems.add(new MenuItem('New Transaction','Create a new transaction (new license, renewal, upgrade..) and submit to EEC','fa-check-square-o','EEC_TransactionIntroduction'));
        }
        else{
            Integer visititems = [SELECT Count() FROM Inspection_Item__c 
                  WHERE Inspection_No__r.Provider_No__c = :acc.Id 
                  AND To_Review_on_Portal__c = true];
            lstMenuItems.add(new MenuItem('Provider Information','Review your provider and license information as well as the past and current transactions.','fa-user','EEC_PortalProviderPage'));
            lstMenuItems.add(new MenuItem('New Transaction','Create a new transaction (new license, renewal, upgrade..) and submit to EEC','fa-check-square-o','EEC_TransactionIntroduction'));
            if(acc.License_Status__c == 'Licensed'){
                lstMenuItems.add(new MenuItem('New Incident / Injury','Log a new self-reported incident/injury involving a child in your program.','fa-tasks','EEC_CasesIncidentsPage'));
            }
            if(visititems > 0){
                lstMenuItems.add(new MenuItem('Fill Non-Compliance Corrective Actions','Review your pending non-compliance statement and submit your corrective actions','fa-folder-open', 'EEC_PortalNonCompliancePage'));
            } 
            if(acc.Use_Physical_Restraints__c && acc.Restraint_Method__c != null && acc.Restraint_Method__c != 'NonRestraint ' && (acc.Recordtype.Name.contains('Temporary Shelter') || acc.Recordtype.Name.contains('Group Care'))){
                lstMenuItems.add(new MenuItem('Submit Quarterly Restraint Report','Submit a new Quarterly Restraint report to electronically to EEC.','fa-pie-chart' , 'EEC_RestraintReport'));
            }
           /* if(acc.RecordType.Name.contains('Foster Care Agency') || acc.RecordType.Name.contains('Adoption Agency')){
                lstMenuItems.add(new MenuItem('Submit Quarterly Agent Report','Submit a new Quarterly Agent report to electronically to EEC.','fa-pie-chart' , 'EEC_AgencyReport'));
            }
            */
            system.debug('MMMMM'+acc.Is_GSA__c+remainingdays+LeadconfigDays);
            if(acc.Is_GSA__c == true && remainingdays <= LeadconfigDays && remainingdays >= 0){
                lstMenuItems.add(new MenuItem('Renewal Meeting Registration','Manage your registration for the mandatory renewal meeting.','fa-pie-chart' , 'EEC_meetingRegistration'));
            system.debug('MMMM');
            }
            if(acc.Recordtype.Name.contains('Family') && acc.License_Status__c == 'Licensed'){
                lstMenuItems.add(new MenuItem('Update Affiliated Assistants','Update the list of FCC assistants working with you and submit the update to EEC','fa-street-view','EEC_AssistantUpdateList?param='+getEncryptedAccountId()));
            }            
        } 
        
        if (!acc.RecordType.DeveloperName.containsIgnoreCase('FCC')) {
          lstMenuItems.add(new MenuItem('Document Library','A gallery for all your portal documents and attachments.','fa-archive','EEC_DocumentLibrary'));
        }
    }
     
    public class MenuItem{
        public string name {get; set;} 
        public string description {get; set;}
        public string icon {get; set;}
        public string destination {get; set;}
        
        public MenuItem(string name, string description, string icon, string destination){
            this.name = name;
            this.description = description;
            this.icon = icon;
            this.destination = destination;
        }
    }
}