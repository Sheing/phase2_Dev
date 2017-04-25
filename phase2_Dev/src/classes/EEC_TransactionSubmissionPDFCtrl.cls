public with sharing class EEC_TransactionSubmissionPDFCtrl {
    public Boolean isFccAssistant { get; set; }
    public Account provider { get; set; }
    public Licensing_Transaction__c LT { get; set; }
    public List<Household_Member__c> ihmList { get; set; }
    public List<Employment_History__c> ehList { get; set; }
    public List<Training_Experience__c> teList { get; set; }
    public List<Room__c> roomList { get; set; }
    public List<FCC_Provider_Assistants__c> Assistants { get; set; }
    
      public EEC_TransactionSubmissionPDFCtrl(ApexPages.StandardController ctrl){
      	this.LT=(Licensing_Transaction__c) ctrl.getRecord();
      	ihmList = new List<Household_Member__c> ();
      	ehList = new List<Employment_History__c>();
      	teList = new list<Training_Experience__c>();
      	Assistants = new list<FCC_Provider_Assistants__c>();
      	roomList = new list<Room__c>();
        String ltId = LT.id;
        LT = [select id,name,Provider__c,Provider__r.id,Last_Reached_Step__c,RecordType.name from Licensing_Transaction__c where id =: ltId];
        string AccId = LT.Provider__r.id;
        provider = [SELECT Id,name, License_Type__c,Provider_city_text__c, State__c, Recordtype.DeveloperName, RecordType.Name, License_Status__c, First_Issue_Date__c, Renewal_date__c, Provider_Status__c,
                Accept_Referral__c, Certified_As__c, Allow_New_Application_as_Provider__c, Allow_Renewal_as_Assistant__c, Can_Communicate_in_English__c, PPM_Meeting_Attended_Date__c, capacity__c,
                ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, Phone, Unlisted_Phone_Number__c, Alternate_Phone__c, Fax, Provider_Email__c,
                Provider_Address_1__c, Provider_Address_2__c, Provider_City__c, Provider_City__r.Name, Provider_Zip_Code__c , Live_at_this_address__c, 
                Language__c, Preferred_Language__c, Race__c, Is_GSA__c, Is_R_P__c,Is_Placement__c, Is_Residential__c
                FROM Account WHERE Id = :AccId];
         ihmList = [select Relationship_to_Provider__c, Provider__c, Occupation__c, Name, Licensing_Transactions__c, Last_Name__c, Id, Number_of_Hours_Home_During_Child_Care__c,
                                              First_Name__c, Email_Address__c, Date_of_Birth__c, Current__c, Current_School_Grade__c, CreatedDate
                                              From Household_Member__c where Licensing_Transactions__c = :ltId];
         ehList = [Select Name, Contact__c, Licensing_Transaction__c, Position__c, Start_Date__c, End_Date__c, Reason_for_Leaving__c, Employer__c, Employer_Address__c, Employer_Phone__c 
                    From Employment_History__c where Licensing_Transaction__c = :ltId];  
        teList = [Select Id, Name, Contact__c, Licensing_Transactions__c, Topic__c, Date_of_the_Training__c, Number_of_Training_Hours__c From Training_Experience__c where Licensing_Transactions__c = :ltId];                                  
        roomList = [Select Id, Name, Source_Transaction__c, Current__c, Use__c, Dimension_Length_feet__c, Dimension_Width_feet__c, Dimension_Square_Feet__c, Floor_Level__c, Provider_Name__c From Room__c where Source_Transaction__c = :ltId];
        
        Assistants = [SELECT Id, Name, FCC_Assistant__r.Name,FCC_Assistant__r.License_Status__c, 
                                                                           FCC_Assistant__r.Current_License_Number__c, 
                                                                           FCC_Assistant__r.Renewal_Date__c, 
                                                                           FCC_Assistant__r.License_Type__c, 
                                                                           FCC_Assistant__r.Certified_As__c,
                                                                           Start_Date__c, End_Date__c 
                                                                           From FCC_Provider_Assistants__c 
                                                                           Where Licensing_Transaction__c =: ltId];
        isFccAssistant = false;
        if (provider.RecordType.name == 'FCC Assistant') {
          isFccAssistant = true;
          system.debug(isFccAssistant);
        }
        
        if(LT.Last_Reached_Step__c != null && !isFccAssistant && provider.RecordType.name.equalsIgnoreCase('Family Child Care') && LT.Recordtype.name.equalsIgnoreCase('FCC Assistant Renewal')){
          isFccAssistant = true;
          system.debug(isFccAssistant);
        }
        
        if(LT.Last_Reached_Step__c != null && isFccAssistant && provider.RecordType.name.equalsIgnoreCase('FCC Assistant') && LT.Recordtype.name.equalsIgnoreCase('FCC New License')){
          isFccAssistant = false;
        }
        system.debug(isFccAssistant);
      }
}