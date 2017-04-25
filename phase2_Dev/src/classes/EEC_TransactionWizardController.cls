public with sharing class EEC_TransactionWizardController implements EEC_AssistantInterface,EEC_VarianceInterface,EEC_ContactRoleInterface {
    
    private static final Integer SAVE_AND_NEXT = 1;
    private static final Integer SAVE_AND_PREVIOUS = 2;
    private static final Integer SAVE_AND_RETURN = 3;
    private static final Integer MODE_REVIEW = 4;
    
    // AWS Variables
    private AWSKeys credentials { get; set; }
    private String AWSCredentialName = 'eec';
    public String accessKey { get; set; } 
    public String bucketItemAccess { get; set; }
    public String bucketName { get; set; }
    public String portalUrl { get; set; }
     
    public Account provider { get; set; }
    public Additional_Information__c licenseInfo{ get; set; }
    public LEAD_Configuration__c leadConfiguration { get; set; }
    //public String licenseInstructionMessage { get; set; }
    public Licensing_Transaction__c licenseTransation { get; set; }
    public String licenseRecordTypeName { get; set; }
    public String licenseRecordTypeLabel { get; set; }
    public String formattedLicenseRecordTypeLabel { get; set; }   
    public List<Household_Member__c> ihmList { get; set; } 
    public List<Employment_History__c> ehList { get; set; }
    public List<Room__c> roomList { get; set; }
    public List<ContactRoleWrapperclass> contactRoleList{get;set;}
    public List<ContactRoleWrapperclass> contactAdminRoleList{get;set;}
    public List<Contact_Role__c> removeRoleList{get;set;}
    public ContactRoleWrapperclass adminHead{get;set;}
    public ContactRoleWrapperclass existingDirector{get;set;}
    public ContactRoleWrapperclass existingBoardChair{get;set;}
    public ContactRoleWrapperclass boardchair {get;set;}
    public ContactRoleWrapperclass pboardchair {get;set;}
    public ContactRoleWrapperclass designateboard {get;set;}
    public ContactRoleWrapperclass  administrativehead  {get;set;}
    public ContactRoleWrapperclass  ownerContactRole  {get;set;}
    public List<Training_Experience__c> teList { get; set; }
    public Integer rowNum { get; set; }
    
    public Contact cntct { get; set; }
    public String selectPreviousInv { get; set; }
    public List<String> selectedHestElems { get; set; }
    public String selectedHestStr { get; set; }
    public String selectedWaterStr { get; set; }
    public String providerRecordType {get; set;}
    public String saveAndReturnLabel {get; set;} 
    public String submissionDisclaimer {get; set;}   
    public List<String> gsaRecordTypeMap {get; set;}
    public List<Additional_Information__c>  licensesheld {get; set;}
    public List<Additional_Information__c>  licensesinprogress {get; set;}
    public List<Additional_Information__c>  criminalaction {get; set;}
    public List<Additional_Information__c>  investigation {get; set;}
    public String programLicensedAgency {get; set;}
    public String physicalRestraint {get; set;}
    public String extendedDays{get; set;}
    public String programContacted {get; set;}
    public string selectedContact{get;set;}
    public string selectedBoardContact{get;set;}
    public string sumOfCapacities{get; set;}
    public string selectedUmbrellaId{get;set;}
    public Account umbrella{get;set;}
    public Boolean referralAgency {get;set;}
    public Boolean interCountries {get; set;}
    public Boolean otherCount {get; set;}
    public Boolean dcfSpecial {get; set;}
    public Boolean characterRadio {get; set;}
    public string designatedboardchecked{get;set;}
    public string DropinService{get;set;}
    public string EveningsService{get;set;}
    public string SummerCampService{get;set;}
    public string CafeteriaUsed{get;set;}
    public string GymFacility{get;set;}
    public string Constructedpost {get;set;}
    public string DetailedInspection{get;set;}
    public string Poolavailable{get;set;}
    public string Offsiteoutdoor{get;set;}  
    public string Transportationprovided{get;set;} 
    public string PortalAccess{get;set;}
    public string designatedboardcheckedrp {get;set;}  
    public string physicalrestraints{get;set;}  
    public string GroupType{get;set;}
    public String smallGroup{get; set;}
    public String largeGroup{get; set;}
    public String programcontracted{get; set;} 
    public String ExistingFiduciary{get; set;}
   //VariancesList
    public List<EEC_VarianceListCtrl.VarianceInfoWrap> varianceInfoWrappers { get; set; }
    
    //Placement Agency page 
    public List<Additional_Information__c>  heldLicense {get; set;}
    public Additional_Information__c oldHeldLicense;
    public Additional_Information__c oldCriminalAct;
    public List<Licensing_Transaction__c> nonCancelledTransaction;
    public List<Additional_Information__c>  relatedLicense {get; set;}
    public List<Additional_Information__c>  criminalAct {get; set;}
    public List<Additional_Information__c>  federalInv {get; set;}
    
    Map<String, String> recordTypeMap = new Map<String, String> {
        'New Application' => 'FCC_New_License',
        'Apply for Renewal' => 'FCC_Renewal',
        'Apply for an Upgrade' => 'FCC_License_Upgrade',
        'Apply for a Change of Address' => 'Change_of_Address',
        'Apply for Renewal as an Assistant' => 'FCC_Assistant_Renewal',    
        'Notify EEC - Change of Room usage' => 'FCC_Change_Room_Floor_Level',
        'Notify EEC - Change of Household Members / Individuals Regularly on the Premises' => 'FCC_Change_of_Household',
        'Request Re-Issuance of License / Certificate' => 'Re_issuance_of_License_Cert',
        'Re-Activate License / Certificate' => 'FCC_Re_Active',
        'De-Activate License / Certificate' => 'FCC_Inactivate',
        'Close Prior To Expiration' => 'Close_Prior_Expiration',
        'Apply for a Decrease of Licensed Capacity' => 'FCC_Downgrade_Capacity',
        'Request a Variance on Regulations' =>'Variance_On_Regulation_Request'
        };
                
    Map<String, String> gsaRecordType = new Map<String, String> {
        'New Application (Provisional)' => 'GSA_New_License,Placement_New_License,Residential_New_License',
        'New Application (Regular)' => 'GSA_Renewal,Placement_Renewal,Residential_License_Renewal',
        'Apply for Renewal (without move)' => 'GSA_Renewal,Placement_Renewal,Residential_License_Renewal',
        'Apply for a License Change (excluding Move)' => 'GSA_License_Change,Placement_Change_in_License,Residential_Change_in_License',
        'Apply for a Move or License Renewal with Move' => 'GSA_Move,Placement_Move,Residential_Move',
        'Report a Change in Program Name' => 'Change_of_Provider_Name',
        'Report a Change in Ownership or Designation of Administrative Authority' => 'GSA_Change_of_Admin_Authority',
        'Report a Change in Ownership or Administrative Designee' => 'R_P_Change_of_Admin_Authority',
        'Request Re-issuance of License or Certificate' => 'Re_issuance_of_License_Cert',
        'Close Prior To Expiration' => 'Close_Prior_Expiration',
        'Request a Variance on Regulations' =>'Variance_On_Regulation_Request'
        };    
                            
    Map<String, String> assistantRecordTypeMap = new Map<String, String> {
        'Apply for an Upgrade' => 'FCC_Assistant_License_Upgrade',
        'New Application' => 'FCC_Assistant_New_License',
        'Apply for Renewal' => 'FCC_Assistant_Renewal',
        'Apply to be licensed as FCC Provider' => 'FCC_New_License',    
        'Request Re-Issuance of License / Certificate' => 'Re_issuance_of_License_Cert',
        'Re-Activate License / Certificate' => 'FCC_Re_Active',
        'De-Activate License / Certificate' => 'FCC_Inactivate',
        'Close Prior To Expiration' => 'Close_Prior_Expiration',
        'Request a Variance on Regulations' =>'Variance_On_Regulation_Request'
        };
                                        
    List<Household_Member__c> removeHMList { get; set; }
    List<Employment_History__c> removeEHList { get; set; }
    List<Room__c> removeRoomList { get; set; }
    List<Training_Experience__c> removeTeList { get; set; }
    List<FileMap__c> transactionAttachments {get;set;}
    public Map<String, Map<String, String>> transactionAttachmentsMap { get; set; }
    public Map<Id, String> transactionAttachmentsUrlMap { get; set; }
    public String fileToDelete { get; set; }
    public User loggedUser{get;set;}
    
    Boolean initHH = false;
    Boolean initLS = false;
    Boolean initIndoor = false;
    Boolean initTraining = false;
    
    // Household Member Table Variables
    public String MembersJson { get; set; }
    public String MembersToDeleteJson { get; set; }
    public String ihmListJson { get; set; }
    // Attachment variables.
    public List<S3_File__c> attachments { get; set; }
    public List<S3_File__c> additionalTrainingAttachments { get; set; }
    public String indoorAttachmentsJson { get; set; }
    public String attachmentsJson { get; set; }
    public String trainingAttachmentsJson { get; set; }
    public String transCertCheckboxFieldname { get; set; }
    public String memberId { get; set; }
    
    // Attachment edit variables.
    public String fileToEditId { get; set; }
    public String fileToEditDescription { get; set; }
    public Boolean renderAttachLib {get; set;}
    public Transaction_Document__c  transDoc{get; set;}
    public String docId{get; set;}
    public String docName{get; set;}
    public string selectedDocumentId{get;set;}
    
    public Boolean isFccAssistant { get; set; }
    public List<Document_Type__c> listDocumentType {get;set;}
    public List<DocumentAttachmentWrapper> listRequiredDocument{get;set;}
    public List<DocumentAttachmentWrapper> listOptionalDocument{get;set;}
    public List<DocumentAttachmentWrapper> listIndividualDocument{get;set;}
    public List<DocumentAttachmentWrapper> listVarianceDocument{get;set;}
    public Map<string, List<DocumentAttachmentWrapper>> mapVarianceDocument{get;set;}
    public Map<string, string> mapVarianceIds{get;set;}
    public Map<string, List<DocumentAttachmentWrapper>> mapIndividualDocument{get;set;}
    public List<DocumentAttachmentWrapper> listAdditionalDocument{get;set;}
    
    public string clickedobjectId{get;set;}
    public string clickedobjectType{get;set;}
    public boolean isPopupOpen{get;set;}
    public string comments{get;set;}
    public string tranDocumentName{get;set;}
    
    
    public String umbrellaName { get; set; }
    public String cityName{get;set;}
    public String errorMessage { get; set; }
    public List<Account> queryResults { get; set; }
    public boolean isNewUmbrella{get;set;}
    public List<SelectOption> listCity{get;set;}
    public string newCityName{get;set;}
    public string selectedStateName{get;set;}
    public string transactionDocumentId{get;set;}
    public string transactionDocumentComment{get;set;}
    public List<selectOption> listLicenseRequested{get;set;}
    public List<Contact> listContact{get;set;}
    public string previousPageName{get;set;}
    
    public class DocumentAttachmentWrapper{
        public string Types{get;set;}
        public string TypeName{get;set;}
        public string Description{get;set;}
        public string FileName{get;set;}
        public string AttachmentStatus{get;set;}
        public string DocComments{get;set;}
        public string Individual{get;set;}
        public string Role{get;set;}
        public string Mandatory{get;set;}
        public string VarianceRegulationArticle{get;set;}
        public string Name{get;set;}
        public string VarianceRegulationId{get;set;}
        public string ContactRoleId{get;set;}
        public string TransactionDocumentId{get;set;}
    }
    
    public EEC_TransactionWizardController() {
        try{
        String ltId = ApexPages.currentPage().getParameters().get('ltId');
        memberId = ApexPages.currentPage().getParameters().get('member');
        docId = ApexPages.currentPage().getParameters().get('docId');
        docName = ApexPages.currentPage().getParameters().get('docName');
        listCity = new List<SelectOption>();
        isPopupOpen = false;
        
        transDoc = new Transaction_Document__c();
       
        if(docName!=null){
            renderAttachLib = true;
        }
        String accountId = '';
        
        if (String.isNotBlank(memberId)) {
            accountId = memberId;
        }
        else {
            List<Account> tempAccount = [Select Id,OwnerID From Account Where ID in(Select Accountid From User Where id = :Userinfo.getUserId()) Limit 1];
            if (tempAccount != null && tempAccount.size() == 1) {
                accountId = tempAccount.get(0).Id;
            }
        }
        provider = new Account();
        if (accountId == '')
            accountId = ApexPages.currentPage().getParameters().get('accountId');
        provider = [SELECT Id,name,ownerid, License_Type__c,Provider_city_text__c, State__c, Recordtype.DeveloperName, RecordType.Name, License_Status__c, First_Issue_Date__c, Renewal_date__c, Provider_Status__c,
                    Accept_Referral__c,Account_books_Responsible__c,Records_Responsible__c, Personnel_Records_Responsible__c,Children_s_Records_Responsible__c,
                    Staff_Schedules_Responsible__c,Early_Childhood_Education_Program_Resp__c,Kindergarten_Responsible__c,School_Age_Responsible__c,Services_for_Children_w_Disability_Resp__c,Daily_Activities_Responsible__c,Equipment_Responsible__c,
                    Indoor_Square_Footage__c,Number_of_toilets__c,Number_of_sinks__c,Lead_Paint_Compliance__c,Detailed_Inspection__c,Building_Inspection_Max_Capacity__c,Building_inspection_expiration_Date__c,Building_Codes__c,Health_Inspection_Expiration_Date__c,Fire_Inspection_Issue_date__c,
                    MinAgeServed__c,MaxAgeServed__c,Awake_Ratio__c,Asleep_Ratio__c,Ratio_Comment__c,Use_Physical_Restraints__c,Restraint_Method__c,Referral_Agency__c,
                    Gender__c,Integrated_Pest_Management_Date__c,Well_Water_Test_date__c,PWS_Public_Water_Source_Number__c,Capacity_Small_Group__c,Infant_birth_15_mo__c,Infant_Toddler_birth_33_mo__c,Toddler_15_mo_33_mo__c,Toddler_Preschool_15_mo_K__c,Preschool_33_mo_K__c,Preschool_SA_33_mo_8_yr__c,Kindergarten__c,School_Age_5_yr_14_yr__c,Multi_Age_Group_birth_14_yr__c,
                    School_Year_To__c ,School_Year_From__c, Camp_Permit_Issue_Date__c,Summer_Camp_Permit__c,Staff_Development_Responsible__c,Staff_Training_Responsible__c,Staff_Orientation_Responsible__c,Staff_Supervision_Responsible__c,Parent_Involvement_Responsible__c,Social_Services_Responsible__c,Infant_Toddler_Program_Responsible__c,
                    Certified_As__c, Allow_New_Application_as_Provider__c, Allow_Renewal_as_Assistant__c, Can_Communicate_in_English__c, PPM_Meeting_Attended_Date__c, capacity__c,Outdoor_Square_footage__c,Pool_roof_inspection_date__c,Other_Approved_Additional_Space__c,ShippingPostalCode, Phone, Unlisted_Phone_Number__c, Alternate_Phone__c, Fax, Provider_Email__c,
                    Characteristics_of_children_served_pickl__c,Level_of_Care__c,International_Adoption_Countries__c,Other_Countries__c,Other_Referral_Agency__c,No_Adoptive_Placements__c,Number_of_Foster_Homes__c,No_Birth_Mothers_Receiving_Services__c,No_Birth_Mothers_Making_Adoption_Plan__c,Number_of_Waiting_Families__c,No_Families_Rec_Home_Stdy_Serv_Only__c,
                    Recving_search_and_or_reunion_services__c,No_Indiv_Rec_Search_and_or_Reunion_Serv__c,Number_of_Reunions_Facilitated__c,Number_of_Child_Assessments__c,Number_of_Home_Study_Services__c,No_of_Families_Rec_Case_Mgmt_Services__c,No_Families_Receiving_Info_and_Referral__c,Number_of_Children_Placed_in_Care__c,ShippingStreet, ShippingCity, ShippingState, 
                    Extended_Day_Provided__c,Provider_Address_1__c, Provider_Address_2__c, Provider_City__c, Provider_City__r.Name, Provider_Zip_Code__c , Live_at_this_address__c,Language__c, Preferred_Language__c, Race__c, Is_GSA__c, Is_R_P__c,Is_Placement__c, Is_Residential__c,(SELECT Id, Status__c,New_Name__c,RecordType.DeveloperName, Took_FCC_Orientation__c FROM Licensing_Transactions__r order BY CreatedDate DESC),
                    Full_School_Year__c, Full_Day_Program_Available_On__c, Full_Day_Program_Available_From__c, Half_Day_Morning_Program_Available_On__c, Half_Day_Morning_Program_Available_From__c, Half_Day_Afternoon_Program_Available_On__c, Half_Day_Afternoon_Program_Avail_From__c, Evenings_Service_Provided__c, Has_Camp_Capacity__c, Total_Staff__c, Full_Day_Program_Available_To__c, Half_Day_Morning_Program_Available_To__c, 
                    Half_Day_Afternoon_Program_Available_To__c, Extended_Day_Available_On__c, Drop_In_Service_Provided__c, Summer_Camp_Services_Provided__c, Cafeteria_Approved__c, Gym_Approved__c 
                    FROM Account WHERE Id = :accountId];
        
        listContact = [select Id, Name from Contact where AccountId =: accountId];
        
        providerRecordType = provider.RecordType.Name;
        //provider.recalculateFormulas();  
        List<Contact> conList = new List<Contact>();
        if(provider.Is_GSA__c || provider.Is_R_P__c){
            conList = [select FirstName, LastName, BirthDate, MobilePhone, Prof_Qualification_Reg_Number__c,(Select id,Role__c from Contact_Roles__r where Role__c like 'Main Contact%') from Contact where AccountId = :provider.Id];
        }else{
            conList = [select FirstName, LastName, BirthDate, MobilePhone, Prof_Qualification_Reg_Number__c from Contact
                       where AccountId = :provider.Id and Role__c like 'Main Contact%' ORDER BY CreatedDate DESC LIMIT 1];
        }                        
        if (conList != null && conList.size() > 0) {
            cntct = conList.get(0);
        }
        leadConfiguration = [Select Visit_Narrative_Summary_Default__c, SystemModstamp, Portal_Transaction_Introduction__c,
                             Number_of_days_for_Investigation_Visit__c, No_of_Days_Prior_Corr_Action_Deadline__c, No_of_Days_For_Investigation_Due_Date__c, Name,
                             Large_Group_Instruction__c, Investigation__c, Investig_Non_comp_Default_if_Any__c, Follow_up_Visit_Estimated_Deadline__c, Transaction_Submission_Disclaimer__c, Transaction_Attachments_New__c, Transaction_Attachments_Renewal__c, Transaction_Attachments_Upgrade__c from LEAD_Configuration__c where Name = :providerRecordType];
                             
        loggedUser = [select Id, Name, contactId, UserType from User where Id = :UserInfo.getUserId()];
        
        submissionDisclaimer = leadConfiguration.Transaction_Submission_Disclaimer__c;
        
        if (String.isNotBlank(ltId)) {
            getLicenseTrans(ltId);
        }
        else {
            licenseTransation = new Licensing_Transaction__c();
        }
        
        //Placement Agency Page licenseHeld
        nonCancelledTransaction = new List<Licensing_Transaction__c>();
        nonCancelledTransaction = [Select Id,Status__c,Provider__c From Licensing_Transaction__c where Status__c !='Cancelled (by Applicant)' AND Provider__c=: provider.Id];
        List<Id> licenseTranId  = new List<Id>();
        
        if(nonCancelledTransaction.size()!=0){
            for(Licensing_Transaction__c ltHeld : nonCancelledTransaction){
                licenseTranId.add(ltHeld.Id);
            }
        }
               
        Id addInfoId   = Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('Other Licenses Held').getRecordTypeId();
        oldHeldLicense = new Additional_Information__c();
        heldLicense    = new List<Additional_Information__c>();
        
        try {
            if (licenseTranId.size()!=0) {
                oldHeldLicense = [select Id,Name_of_Licensee__c,Provider__c,Type_of_License__c,State_Country_Issuing_the_License__c,License_Number__c,Licensing_Transaction__c,RecordTypeID From Additional_Information__c where Licensing_Transaction__c IN: licenseTranId AND RecordTypeID =:addInfoId Order BY lastModifiedDate DESC];       
            }
        }catch (exception e){
            oldHeldLicense = null;
        }   
       
        if (licenseTransation.Out_of_state_childcare_related_licenses1__c == 'Yes') {
            checkHeld();
        }
        //placement agency multipicklist
        if(licenseTransation.Characteristics_of_children_served__c!=null){
            characterRadio = true;
        }else {
            characterRadio = false;
        }
        if(licenseTransation.Building_Codes_c__c == null){
            bldgCheck = false;
        }else{
            bldgCheck = true;
        }
        if(licenseTransation.Working_with_which_Referral_Agencies__c == null){
            refCheck = false;
        }else{
            refCheck = true;
        }
        
        //Placement Agency RelatedLicense
        relatedLicense = new List<Additional_Information__c>();
        Id addRelatedId =  Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('Other License Applications').getRecordTypeId();
        
        if (licenseTransation.Out_of_state_license_appl_in_process1__c =='Yes') {
            checkRelated();
        }
        
        //Placement Agency Page Criminal Act
        Id addCriminId = Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('Admin/civil/criminal action detail').getRecordTypeId();
        oldCriminalAct = new Additional_Information__c();
        criminalAct    = new List<Additional_Information__c>();
        
        try {
            if (licenseTranId.size()!=0) {
                oldCriminalAct = [select Id,Name_Admin_civil_criminal_action__c, Provider__c,Nature_of_Proceedings__c,Caption__c,Docket_Number__c,Name_of_court_or_administrative_body__c, Address_of_court__c, Disposition__c,RecordTypeID From Additional_Information__c where Licensing_Transaction__c IN: licenseTranId AND RecordTypeID =:addCriminId Order BY lastModifiedDate DESC];       
            }
        }catch (exception e){
            oldCriminalAct = null;
        }   
        
        if (licenseTransation.Admin_Civil_criminal_action_last_5_yrs1__c =='Yes') {
            checkCriminal();
        }
        
        //Placement Agency Page FederalInvestigation
        federalInv     = new List<Additional_Information__c>();
        Id addFedId =  Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('State/federal investigation detail').getRecordTypeId();
        
        if (licenseTransation.State_Federal_investigation_last_5_yrs1__c=='Yes') {
            checkFederal();
        }
        
        if(licenseTransation.Program_licensed_or_approved_by_agency__c){            
            programLicensedAgency ='Yes';
        }else if(!licenseTransation.Program_licensed_or_approved_by_agency__c){
            programLicensedAgency ='No';
        }
        
        if(licenseTransation.Is_your_program_contracted__c){
            programContacted ='Yes';
        }else if(!licenseTransation.Is_your_program_contracted__c){
            programContacted ='No';
        }
        /*Loading Default values for the record at the time of creation */
        smallGroup = 'Small Group (<=10)';
        largeGroup = 'Large Group (>10)';
   
        if(LicenseRecordTypeName == 'GSA_New_License'||LicenseRecordTypeName =='GSA_Change_of_Admin_Authority'||LicenseRecordTypeName == 'GSA_Renewal'||LicenseRecordTypeName == 'GSA_License_Change'||LicenseRecordTypeName == 'GSA_Move'){
            if(licenseTransation.Camp_Permit_Issue_Date__c == null){
                licenseTransation.Camp_Permit_Issue_Date__c = provider.Camp_Permit_Issue_Date__c;
            }
        }
        
        /*Loading Default values for record types other than New License*/
        if(LicenseRecordTypeName != 'Residential_New_License'){
            if(licenseTransation.Level_of_care__c == ''||licenseTransation.Level_of_care__c == null){
                licenseTransation.Level_of_care__c = provider.Level_of_Care__c;
            }
            if(licenseTransation.Characteristics_of_children_served__c == ''||licenseTransation.Characteristics_of_children_served__c == null){
                licenseTransation.Characteristics_of_children_served__c = provider.Characteristics_of_children_served_pickl__c; 
            }
            if(licenseTransation.Gender_of_children_served__c == ''||licenseTransation.Gender_of_children_served__c == null){
                licenseTransation.Gender_of_children_served__c = provider.Gender__c;
            }
            if(licenseTransation.Minimum_age_of_children_served__c == ''||licenseTransation.Minimum_age_of_children_served__c == null){
                licenseTransation.Minimum_age_of_children_served__c = provider.MinAgeServed__c; 
            }
            if(licenseTransation.Maximum_age_of_children_served__c == ''||licenseTransation.Maximum_age_of_children_served__c == null){
                licenseTransation.Maximum_age_of_children_served__c = provider.MaxAgeServed__c;
            }            
            if(licenseTransation.Awake_Staff_to_child_ratio__c == ''||licenseTransation.Awake_Staff_to_child_ratio__c == null){
                licenseTransation.Awake_Staff_to_child_ratio__c = provider.Awake_Ratio__c;  
            }   
            if(licenseTransation.Asleep_Staff_to_child_ratio__c == ''||licenseTransation.Asleep_Staff_to_child_ratio__c == null){
                licenseTransation.Asleep_Staff_to_child_ratio__c = provider.Asleep_Ratio__c;    
            }   
            if(licenseTransation.Ratio_comments__c == ''||licenseTransation.Ratio_comments__c == null){
                licenseTransation.Ratio_comments__c = provider.Ratio_Comment__c;
            }  
            if(licenseTransation.Restraint_Method__c == ''||licenseTransation.Restraint_Method__c == null){
                licenseTransation.Restraint_Method__c = provider.Restraint_Method__c;    
            }   
            if(licenseTransation.Working_with_which_Referral_Agencies__c == ''||licenseTransation.Working_with_which_Referral_Agencies__c == null){
                licenseTransation.Working_with_which_Referral_Agencies__c = provider.Referral_Agency__c;
            }   
            if(licenseTransation.Other_Referral_Agency__c == ''||licenseTransation.Other_Referral_Agency__c == null){
                licenseTransation.Other_Referral_Agency__c = provider.Other_Referral_Agency__c;    
            }
        }
        
          /*Loading Default values for GSA record types other than New License*/
        if(LicenseRecordTypeName != 'GSA_New_License'){
            if(licenseTransation.Operation_Type__c == ''||licenseTransation.Operation_Type__c == null){
                licenseTransation.Operation_Type__c = provider.Full_School_Year__c;    
            } 
            if(licenseTransation.Operation_Start_Month__c == ''||licenseTransation.Operation_Start_Month__c == null){
                licenseTransation.Operation_Start_Month__c = provider.School_Year_From__c;
            }
            if(licenseTransation.Operation_End_Month__c == ''||licenseTransation.Operation_End_Month__c == null){
                licenseTransation.Operation_End_Month__c = provider.School_Year_To__c;
            }
            if(licenseTransation.Available_Days_Full_day_program__c == ''||licenseTransation.Available_Days_Full_day_program__c == null){
               licenseTransation.Available_Days_Full_day_program__c = provider.Full_Day_Program_Available_On__c;
            }
            if(licenseTransation.Start_Time_Full_day_program__c == ''||licenseTransation.Start_Time_Full_day_program__c == null){
               licenseTransation.Start_Time_Full_day_program__c = provider.Full_Day_Program_Available_From__c;
            }
            if(licenseTransation.End_Time_Full_day_program__c == ''||licenseTransation.End_Time_Full_day_program__c == null){
               licenseTransation.End_Time_Full_day_program__c = provider.Full_Day_Program_Available_To__c;
            }
            if(licenseTransation.Available_Days_Morning_program__c == ''||licenseTransation.Available_Days_Morning_program__c == null){
               licenseTransation.Available_Days_Morning_program__c = provider.Half_Day_Morning_Program_Available_On__c;
            }
            if(licenseTransation.Start_Time_Morning_program__c == ''||licenseTransation.Start_Time_Morning_program__c == null){
               licenseTransation.Start_Time_Morning_program__c = provider.Half_Day_Morning_Program_Available_From__c;
            }
            if(licenseTransation.End_Time_Morning_program__c == ''||licenseTransation.End_Time_Morning_program__c == null){
                licenseTransation.End_Time_Morning_program__c = provider.Half_Day_Morning_Program_Available_To__c;
            }
            if(licenseTransation.Available_Days_Afternoon_program__c == ''||licenseTransation.Available_Days_Afternoon_program__c == null){
               licenseTransation.Available_Days_Afternoon_program__c = provider.Half_Day_Afternoon_Program_Available_On__c;
            }
            if(licenseTransation.Start_Time_Afternoon_program__c == ''||licenseTransation.Start_Time_Afternoon_program__c == null){  
               licenseTransation.Start_Time_Afternoon_program__c = provider.Half_Day_Afternoon_Program_Avail_From__c;
            }
            if(licenseTransation.End_Time_Afternoon_program__c == ''||licenseTransation.End_Time_Afternoon_program__c == null){
               licenseTransation.End_Time_Afternoon_program__c = provider.Half_Day_Afternoon_Program_Available_To__c;
            }
            if(licenseTransation.Provide_Extended_Days1__c == ''||licenseTransation.Provide_Extended_Days1__c == null){ 
               licenseTransation.Provide_Extended_Days1__c = String.ValueOf(provider.Extended_Day_Provided__c == true?'Yes':'No');
            }
            if(licenseTransation.Extended_Days_Available__c == ''||licenseTransation.Extended_Days_Available__c == null){ 
               licenseTransation.Extended_Days_Available__c = provider.Extended_Day_Available_On__c;
            }
            if(licenseTransation.Drop_in_Service1__c == null){ 
              licenseTransation.Drop_in_Service1__c = String.ValueOf(provider.Drop_In_Service_Provided__c == true?'Yes':'No');
            }
            if(licenseTransation.Evenings_Service1__c == null){ 
               licenseTransation.Evenings_Service1__c = String.ValueOf(provider.Evenings_Service_Provided__c == true?'Yes':'No');
            }
            if(licenseTransation.Summer_Camp_Service1__c == null){
               licenseTransation.Summer_Camp_Service1__c = String.ValueOf(provider.Summer_Camp_Services_Provided__c == true?'Yes':'No');
            }
            if(licenseTransation.Cafeteria_Used_During_Program_Hours1__c == null){
               licenseTransation.Cafeteria_Used_During_Program_Hours1__c = String.ValueOf(provider.Cafeteria_Approved__c == true?'Yes':'No');
            }
            if(licenseTransation.Gym_Facility_Used_During_Program_Hours1__c == null){ 
               licenseTransation.Gym_Facility_Used_During_Program_Hours1__c = String.ValueOf(provider.Gym_Approved__c == true?'Yes':'No');
            }
            
        }else if(LicenseRecordTypeName == 'GSA_New_License'){
            if (licenseTransation.Operation_Type__c == null){
                licenseTransation.Provide_Extended_Days1__c = null;
                licenseTransation.Drop_in_Service1__c = null;
                licenseTransation.Evenings_Service1__c = null;         
                licenseTransation.Summer_Camp_Service1__c = null;
                licenseTransation.Cafeteria_Used_During_Program_Hours1__c = null;
                licenseTransation.Gym_Facility_Used_During_Program_Hours1__c = null;
            }           
        }
         
        if(LicenseRecordTypeName == 'GSA_New_License' && licenseTransation.Group_Type__c != 'Small Group' && providerRecordType !='Large Group'){
        }else if(LicenseRecordTypeName == 'GSA_Renewal'||LicenseRecordTypeName == 'GSA_License_Change'||LicenseRecordTypeName == 'GSA_Move'||LicenseRecordTypeName == 'GSA_Change_of_Admin_Authority'){
            if(licenseTransation.Group_Type__c == null||licenseTransation.Group_Type__c == ''){
                if(providerRecordType=='Small Group'){
                    licenseTransation.Group_Type__c = 'Small Group (<=10)';
                }else if(providerRecordType=='Large Group'){
                    licenseTransation.Group_Type__c = 'Large Group (>10)';
                }
            }
        }
        
        credentials = new AWSKeys(AWSCredentialName);
        accessKey = credentials.key; 

        AWS_Config__c aws = AWS_Config__c.getInstance();
        bucketName = aws.S3_Bucket_Name__c;
        bucketItemAccess = aws.S3_Access_Control_Level__c;
        
        // Get the page url for form submit. 
        String baseURL = URL.getSalesforceBaseUrl().toExternalForm(); // it will return: < https://cs14.salesforce.com >
        String PageURL = ApexPages.currentPage().getUrl(); // it will return: < /apex/myVFpage?id=906F00000008w9wIAA >
        portalUrl = baseURL + PageURL;
        generateAttachmentMappings();
        refreshAttachmentsList();
        retrieveAddtionalTrainingAttachmentsList();
        
        isFccAssistant = false;
        if (providerRecordType == 'FCC Assistant') {
            isFccAssistant = true;
            saveAndReturnLabel = 'Save and Return to Assistant';  
        }
        else
            saveAndReturnLabel = 'Save and Return to Provider';  
        
        if(licenseTransation.Last_Reached_Step__c != null && !isFccAssistant && providerRecordType.equalsIgnoreCase('Family Child Care') && licenseRecordTypeLabel.equalsIgnoreCase('FCC Assistant Renewal')){
            isFccAssistant = true;
            try{
                submissionDisclaimer = (String)[Select Transaction_Submission_Disclaimer__c from LEAD_Configuration__c where Name = 'FCC Assistant'].Transaction_Submission_Disclaimer__c;
            } catch(Exception e){ System.debug(e.getMessage()); }               
        }
        if(licenseTransation.Last_Reached_Step__c != null && isFccAssistant && providerRecordType.equalsIgnoreCase('FCC Assistant') && licenseRecordTypeLabel.equalsIgnoreCase('FCC New License')){
            isFccAssistant = false; 
            try{
                submissionDisclaimer = (String)[Select Transaction_Submission_Disclaimer__c from LEAD_Configuration__c where Name = 'Family Child Care'].Transaction_Submission_Disclaimer__c;      
            } catch(Exception e){ System.debug(e.getMessage()); }
        } 

        if(provider.Use_Physical_Restraints__c){
            physicalRestraint = 'Yes';
        }else{
            physicalRestraint = 'No';
        }
        
        sumOfCapacities = ''+licenseTransation.Total_License_Capacity_Requested__c;

        selectedBoardContact = '--Select--';
        selectedContact = '--Select--';
        
        minAge = ''+licenseTransation.Minimum_Age_Limit_Requested_Years__c;
        minMon = ''+licenseTransation.Minimum_Age_Limit_Requested_Months__c;
        maxAge = ''+licenseTransation.Maximum_Age_Limit_Requested_Years__c;
        maxMon = ''+licenseTransation.Maximum_Age_Limit_Requested_Months__c;
        
        minAgeRes = ''+provider.MinAgeServed__c;
        maxAgeRes = ''+provider.MaxAgeServed__c;
        
        string query = 'select Allow_use_of_Umbrella_Level_Document__c, Individual_Document__c, Related_Role__c, Id, Description__c, LEAD_Configuration__r.Name, Name, Need_to_be_Updated_at_each_new_Transacti__c, Optional_for_Transactio_Type__c, Required_For_Transaction_Type__c FROM Document_Type__c WHERE LEAD_Configuration__r.Name = \''
        + providerRecordType + '\' AND (Required_For_Transaction_Type__c INCLUDES (\'' + licenseTransation.RecordType.Name + '\') OR Optional_for_Transactio_Type__c INCLUDES(\'' + licenseTransation.RecordType.Name +'\'))';
        
        listDocumentType = database.query(query);
        
        doGetAttachmentList();
        
        }catch(exception e){
            system.debug('error:'+e);
            system.debug('line number :'+e.getLineNumber());
        }        
    }

    public void doGetCity(){
        List<City__c> listCities = [select Id, Name from City__c where State__c =: licenseTransation.NewUmbrella_State__c];
        listCity = new List<SelectOption>();
        
        listCity.add(new SelectOption('--Select--','--Select--'));
        for(City__c city : listCities){
            listCity.add(new SelectOption(city.Name, city.Name));
        }
    }

  public PageReference query() {
    try{
        queryResults = new List<Account>();
        errorMessage = '';
        
        if (String.isBlank(umbrellaName) && String.isBlank(cityName)) {
            errorMessage = 'Enter at least one criteria before you start your search';
            return null;
        }
        if (!String.isBlank(umbrellaName)) {
           umbrellaName = '%'+umbrellaName+'%';
        }
        if (!String.isBlank(cityName)) {
           cityName = '%'+cityName+'%';
        }
        queryResults = [select Id, Name, Provider_Address_1__c, Provider_city_text__c, Provider_Zip_Code__c , State__c
                            from Account where RecordType.Name = 'Umbrella' and (Name like : umbrellaName or Provider_City__r.Name like : cityName)];
        if (queryResults.size() == 0) {
            errorMessage = 'Based on these criteria, no Umbrella were found. Please review your search criteria.';
        }
    } catch(Exception e) {
        System.debug('Error: ' + e.getMessage());
        errorMessage = 'An error has occured attempting to get your results. Please try again.';
    }
    return null;
  }
  
  public PageReference addUmbrella(){
    try{        
        licenseTransation.NewUmbrella_City__c = newCityName;
        licenseTransation = EEC_ContactRoleUtil.updateLicensingTransaction(licenseTransation);
    }
     catch(Exception e) {
        System.debug('Error: ' + e.getMessage());
        errorMessage = 'An error has occured attempting to save new umbrella. Please try again later.';
    }
    return null;
  }
  
    public void AddLicenseHeld(){
        Id addInfoId =  Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('Other Licenses Held').getRecordTypeId();
        try{
            if(oldHeldLicense!=null && oldHeldLicense.id!=null) {
                heldLicense.add(new Additional_Information__c(recordTypeId = addInfoId,Name_of_Licensee__c = oldHeldLicense.Name_of_Licensee__c, Licensing_Transaction__c = licenseTransation.Id, Provider__c = provider.id, Type_of_License__c = oldHeldLicense.Type_of_License__c,State_Country_Issuing_the_License__c = oldHeldLicense.State_Country_Issuing_the_License__c,License_Number__c = oldHeldLicense.License_Number__c));
            }else{
                heldLicense.add(new Additional_Information__c(recordTypeId = addInfoId,Name_of_Licensee__c = '',Type_of_License__c = '',Licensing_Transaction__c = licenseTransation.Id, Provider__c = provider.id, State_Country_Issuing_the_License__c = '',License_Number__c = ''));
            }
            if(heldLicense.size()!=0){
                disableHeld = false;
            }
        }catch(exception e){
            system.debug('exception:'+e.getCause());
        }        
    }
    
    public boolean disableHeld { get; set; }
    public void DeleteLicenseHeld(){
        if (heldLicense.size()!=0) {
            heldLicense.remove(heldLicense.size()-1);
        }
        if (heldLicense.size()==0) {
            disableHeld = true;
        }        
    }
    
    public void checkHeld(){
        heldLicense.clear();
        if (licenseTransation.Out_of_state_childcare_related_licenses1__c=='Yes') {
            AddLicenseHeld();
        }
    }
    
    public void AddCriminalAct(){
        Id addCriminId = Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('Admin/civil/criminal action detail').getRecordTypeId();
        try {
            if (oldCriminalAct!=null && oldCriminalAct.id!=null) {
                criminalAct.add(new Additional_Information__c(recordTypeId = addCriminId, Name_Admin_civil_criminal_action__c = oldCriminalAct.Name_Admin_civil_criminal_action__c,Licensing_Transaction__c = licenseTransation.Id, Provider__c = provider.id, Nature_of_Proceedings__c = oldCriminalAct.Nature_of_Proceedings__c, Caption__c = oldCriminalAct.Caption__c ,Docket_Number__c = oldCriminalAct.Docket_Number__c ,Name_of_court_or_administrative_body__c = oldCriminalAct.Name_of_court_or_administrative_body__c, Address_of_court__c = oldCriminalAct.Address_of_court__c, Disposition__c = oldCriminalAct.Disposition__c));
            }else {
                criminalAct.add(new Additional_Information__c(recordTypeId = addCriminId, Name_Admin_civil_criminal_action__c = '', Nature_of_Proceedings__c = '',Licensing_Transaction__c = licenseTransation.Id, Provider__c = provider.id, Caption__c = '', Docket_Number__c = '', Name_of_court_or_administrative_body__c = '', Address_of_court__c = '', Disposition__c = ''));
            }
            if (criminalAct.size()!=0) {
                disableCriminal = false;    
            }
        }catch (exception e){
            system.debug('exception:'+e.getCause());
        }
    }
    
    public boolean disableCriminal { get; set; }
    public void DeleteCriminalHeld(){
        if (criminalAct.size()!=0) {
            criminalAct.remove(criminalAct.size()-1);   
        }
        if (criminalAct.size()==0) {
            disableCriminal = true;
        }
    }
    
    public void checkCriminal(){
        criminalAct.clear();
        if (licenseTransation.Admin_Civil_criminal_action_last_5_yrs1__c=='Yes') {
            AddCriminalAct();
        }
    }
    
    public boolean disableFederal { get; set; }
    public void AddFederalInv () {
        Id addFedId =  Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('State/federal investigation detail').getRecordTypeId();
        federalInv.add(new Additional_Information__c(recordTypeId = addFedId, Name_of_Person_Agency_Investigated__c = '',Licensing_Transaction__c = licenseTransation.Id, Provider__c = provider.id, State_and_or_Federal_Agency__c = '', Nature_of_Investigation__c = ''));
        if (federalInv.size()!=0) {
            disableFederal = false;
        }
    }
    
    public void DeleteFederalInv(){
        if (federalInv.size()!=0) { 
            federalInv.remove(federalInv.size()-1);
        }
        if (federalInv.size()==0) {
            disableFederal = true;
        }
    }
    
    public void checkFederal(){
        federalInv.clear();
        if (licenseTransation.State_Federal_investigation_last_5_yrs1__c=='Yes') {
            AddFederalInv();
        }
    }
    
    public boolean disableRelated { get; set; }
    public void AddRelatedLicense () {
        Id addRelatedId =  Schema.SObjectType.Additional_Information__c.getRecordTypeInfosByName().get('Other License Applications').getRecordTypeId();
        relatedLicense.add(new Additional_Information__c(recordTypeId = addRelatedId,Name_of_Applicant__c = '',Licensing_Transaction__c = licenseTransation.Id, Provider__c = provider.id, State_Country_of_Applicant__c = '',Name_of_Licensing_Authority__c = '',Address_of_Licensing_authority__c = '', Phone_No_of_Licensing_Authority__c = '',Status_of_Application__c = ''));
        if (relatedLicense.size()!=0) {
            disableRelated = false;
        }
    }
    
    public void DeleteRelatedLicense () {
        if (relatedLicense.size()!=0) {
            relatedLicense.remove(relatedLicense.size()-1); 
        }
        if (relatedLicense.size()==0) {
            disableRelated =true;
        }
    }
    
    public void checkRelated(){
        relatedLicense.clear();
        if (licenseTransation.Out_of_state_license_appl_in_process1__c=='Yes') {
            AddRelatedLicense();
        }
    }
    
   public void uploadAttachment(){
       isPopupOpen = false;
       String attachmentbody = ApexPages.currentPage().getParameters().get('attachmentbody');
       String clickedId = ApexPages.currentPage().getParameters().get('clickedId');
       String clickedType = ApexPages.currentPage().getParameters().get('clickedType');
       String documentTypeId = ApexPages.currentPage().getParameters().get('documentTypeId');
       
        try {
          // List of S3Objects. 
          if (!String.isBlank(attachmentbody)) {
            // Convert the json into S3_Files.
            List<S3_File__c> s3FilesList = (List<S3_File__c>) JSON.deserialize(attachmentbody, List<S3_File__c>.class);
            upsert s3FilesList;
            
            List<Transaction_Document__c> listTransactionDocument = new List<Transaction_Document__c>();
            
            for(S3_File__c file : s3FilesList){
               Transaction_Document__c transactionDocument = new Transaction_Document__c();
               
               if(clickedType == 'Required' || clickedType == 'Optional'){
                List<Transaction_Document__c> listTransDocument = [select Id from Transaction_Document__c where
                                            Licensing_Transaction__c =: licenseTransation.Id and
                                            Mode__c =: clickedType and Document_Type__c=: documentTypeId];
                /*if(listTransDocument.size() > 0){
                    transactionDocument.Id = listTransDocument[0].Id;
                }*/
                EEC_ContactRoleUtil.deleteTransactionDocuments(listTransDocument);
               }
               else if(clickedType == 'Individual'){
                /*List<Transaction_Document__c> listTransDocument = [select Id from Transaction_Document__c where
                                            Licensing_Transaction__c =: licenseTransation.Id and
                                            Mode__c =: clickedType and Document_Type__c=: documentTypeId
                                            and Contact_Role__c =: clickedId];
                if(listTransDocument.size() > 0){
                    transactionDocument.Id = listTransDocument[0].Id;
                }
                EEC_ContactRoleUtil.deleteTransactionDocuments(listTransDocument);*/
               }
               transactionDocument.Comments__c = comments;
               //transactionDocument.Date_Attached__c = system.today();
               
               //if(transactionDocument.Id == null){
               // transactionDocument.Licensing_Transaction__c = licenseTransation.Id;
               //}
               transactionDocument.Licensing_Transaction__c = licenseTransation.Id;
               if(string.isNotBlank(documentTypeId))
                transactionDocument.Document_Type__c = documentTypeId;
               
               transactionDocument.Mode__c = clickedType;
               //transactionDocument.S3_File__c = file.Id;
               transactionDocument.Status__c = 'New Attachment';
               if(clickedType == 'Variance'){
                transactionDocument.Variance_on_Regulation__c = clickedId;
               }
               /*else if(clickedType == 'Individual'){
                transactionDocument.Contact_Role__c = clickedId;
               }*/
               //transactionDocument.Name = tranDocumentName;
               listTransactionDocument.add(transactionDocument);
            }
            
            EEC_ContactRoleUtil.upsertTransactionDocument(listTransactionDocument);
          }
          generateAttachmentMappings();
        } catch(Exception e) {
          System.debug('-----> Error: ' + e.getMessage());
          ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
          ApexPages.addMessage(errMsg);
        } 
        
       tranDocumentName = '';
       comments = string.valueof(date.today());

       doGetAttachmentList();
    }
    
    public void doOpenAttachment(){
        isPopupOpen = true; 
        tranDocumentName = '';
        comments = string.valueof(date.today());      
    }
    
    public PageReference doUpdateComments(){        
         String trandocId = ApexPages.currentPage().getParameters().get('trandocId');
         String trandocComments = ApexPages.currentPage().getParameters().get('trandocComments');
         List<Transaction_Document__c> listTransactionDocument = new List<Transaction_Document__c>();
         Transaction_Document__c transactionDocument = [select Id, Comments__c from Transaction_Document__c where Id=: trandocId];
         
         transactionDocument.Comments__c = trandocComments;
        
        listTransactionDocument.add(transactionDocument);    
        EEC_ContactRoleUtil.upsertTransactionDocument(listTransactionDocument);
        return null;
    }
    
    @testVisible private void doGetAttachmentList(){
        listRequiredDocument = new List<DocumentAttachmentWrapper>();
        listOptionalDocument = new List<DocumentAttachmentWrapper>();
        listIndividualDocument = new List<DocumentAttachmentWrapper>();
        listVarianceDocument = new List<DocumentAttachmentWrapper>();
        mapVarianceDocument = new Map<string, List<DocumentAttachmentWrapper>>();
        mapIndividualDocument = new Map<string, List<DocumentAttachmentWrapper>>();
        listAdditionalDocument = new List<DocumentAttachmentWrapper>();
        
        List<Document__c> listProviderDocuments = [select Id, Document_Type__c, Approved_for_Future_Usage__c from Document__c where (Provider__c =: provider.Id or Provider__c =: licenseTransation.Umbrella__c) order by createddate desc];
        
        List<Transaction_Document__c> listTransactionDocument = [select Comments__c, Name, Document__c, Document_Type__c,
        Last_Status_Date__c, Licensing_Transaction__c, Mode__c, Note_For_Revision__c, Status__c, Variance_on_Regulation__c,
        Document_Type__r.Name,Document_Type__r.Description__c
        //Contact_Role__r.Role__c,Contact_Role__r.Contact__r.FirstName,Contact_Role__r.Contact__r.LastName,
        //S3_File__r.Filename__c,S3_File__c,
        //Document__r.Original_File_Name__c 
        from Transaction_Document__c
        where Licensing_Transaction__c =: licenseTransation.Id];
        
        List<Variance_on_Regulation__c> listVariance = [select Id, Name, Associated_Regulation__r.Name from Variance_on_Regulation__c
        where Source_Transaction__c =: licenseTransation.Id];
        
         List<Contact_Role__c> tempcontactrole = new  List<Contact_Role__c>();
        /**Check Ownership type**/
        
        String query = 'SELECT id, Name,Current_Formula__c,Contact__c,Contact__r.FirstName,Contact__r.LastName,Contact__r.MailingStreet,Contact__r.MailingCity,Contact__r.MailingPostalCode,Contact__r.MailingState,Contact__r.Phone,Contact__r.Email,Contact__r.Holds_FCC_License__c,End_Date__c,End_Role_Licensing_Transaction__c,Portal_Access__c,Provider__c,Role__c,Schedule_Administrative_Hours__c,Schedule_Teaching_Hours__c,Start_Date__c,Start_Role_Licensing_Transaction__c,Contact__r.Title,Contact__r.Role__c FROM Contact_Role__c ';
        query = query + 'WHERE Provider__c=\''+licenseTransation.Provider__c+'\' ORDER BY Start_Date__c ASC NULLS FIRST';
        
        tempcontactrole = Database.query(query);
        
        Map<Id, List<Transaction_Document__c>> mapDocumentTypeDocs = new Map<Id, List<Transaction_Document__c>>();
        Map<Id, List<Transaction_Document__c>> mapVarianceDocuments = new Map<Id, List<Transaction_Document__c>>();
        
        for(Transaction_Document__c transactionDocument : listTransactionDocument){
            List<Transaction_Document__c> listDocs;
            if(mapDocumentTypeDocs.get(transactionDocument.Document_Type__c) == null){
                listDocs = new List<Transaction_Document__c>();
            }
            else{
                listDocs = mapDocumentTypeDocs.get(transactionDocument.Document_Type__c);
            }
            listDocs.add(transactionDocument);
            mapDocumentTypeDocs.put(transactionDocument.Document_Type__c, listDocs);
            
            if(transactionDocument.Variance_on_Regulation__c != null){
                List<Transaction_Document__c> listVarianceDocs;
                if(mapDocumentTypeDocs.get(transactionDocument.Variance_on_Regulation__c) == null){
                    listVarianceDocs = new List<Transaction_Document__c>();
                }
                else{
                    listVarianceDocs = mapDocumentTypeDocs.get(transactionDocument.Variance_on_Regulation__c);
                }
                listVarianceDocs.add(transactionDocument);
                mapVarianceDocuments.put(transactionDocument.Variance_on_Regulation__c, listVarianceDocs);
            }
        }
        
        for(Transaction_Document__c transactionDoc : listTransactionDocument){
            if(transactionDoc.Mode__c == 'Additional'){
                DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                DocumentAttachmentWrapper.Types = transactionDoc.Document_Type__c;
                DocumentAttachmentWrapper.TypeName = transactionDoc.Document_Type__r.Name;
                DocumentAttachmentWrapper.Description = transactionDoc.Document_Type__r.Description__c;
                /*if(transactionDoc.S3_File__c != null){
                    DocumentAttachmentWrapper.FileName = transactionDoc.S3_File__r.Filename__c;
                }
                else{
                    DocumentAttachmentWrapper.FileName = transactionDoc.Document__r.Original_File_Name__c;
                }*/
                DocumentAttachmentWrapper.Name = transactionDoc.Name;
                DocumentAttachmentWrapper.AttachmentStatus = transactionDoc.Status__c;
                DocumentAttachmentWrapper.DocComments = transactionDoc.Comments__c;
                DocumentAttachmentWrapper.TransactionDocumentId = transactionDoc.Id;
                listAdditionalDocument.add(DocumentAttachmentWrapper);
            }
        }
        
        boolean isDocumentExist = false;
        for(Document_Type__c documentType : listDocumentType){
            if(documentType.Required_For_Transaction_Type__c.contains(licenseTransation.RecordType.Name) && documentType.Individual_Document__c == false){
                if(mapDocumentTypeDocs.get(documentType.Id) != null){
                    List<Transaction_Document__c> listDocs = mapDocumentTypeDocs.get(documentType.Id);
                    isDocumentExist = false;
                    for(Transaction_Document__c transactionDoc : listDocs){
                        if(transactionDoc.Mode__c == 'Required'){
                            DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                            DocumentAttachmentWrapper.Types = documentType.Id;
                            DocumentAttachmentWrapper.TypeName = documentType.Name;
                            DocumentAttachmentWrapper.Description = documentType.Description__c;
                            /*if(transactionDoc.S3_File__c != null){
                                DocumentAttachmentWrapper.FileName = transactionDoc.S3_File__r.Filename__c;
                            }
                            else{
                                DocumentAttachmentWrapper.FileName = transactionDoc.Document__r.Original_File_Name__c;
                            }*/
                            DocumentAttachmentWrapper.Name = transactionDoc.Name;
                            DocumentAttachmentWrapper.AttachmentStatus = transactionDoc.Status__c;
                            DocumentAttachmentWrapper.DocComments = transactionDoc.Comments__c;
                            DocumentAttachmentWrapper.TransactionDocumentId = transactionDoc.Id;
                            listRequiredDocument.add(DocumentAttachmentWrapper);
                            isDocumentExist = true;
                            break;
                        }
                    }
                    if(isDocumentExist == false){
                         if(documentType.Need_to_be_Updated_at_each_new_Transacti__c == true){
                            isDocumentExist = false;
                            for(Document__c document : listProviderDocuments){
                                if(document.Document_Type__c == documentType.Id){
                                    DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                                    DocumentAttachmentWrapper.Types = documentType.Id;
                                    DocumentAttachmentWrapper.TypeName = documentType.Name;
                                    DocumentAttachmentWrapper.Description = documentType.Description__c;
                                    //DocumentAttachmentWrapper.FileName = document.Original_File_Name__c;
                                    DocumentAttachmentWrapper.Name = documentType.Name;
                                    DocumentAttachmentWrapper.AttachmentStatus = 'Approved';
                                    DocumentAttachmentWrapper.DocComments = '';
                                    listOptionalDocument.add(DocumentAttachmentWrapper);
                                    isDocumentExist = true;
                                    break;
                                }
                            }
                            if(isDocumentExist == false){
                                DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                                DocumentAttachmentWrapper.Types = documentType.Id;
                                DocumentAttachmentWrapper.TypeName = documentType.Name;
                                DocumentAttachmentWrapper.Description = documentType.Description__c;
                                DocumentAttachmentWrapper.FileName = '';
                                DocumentAttachmentWrapper.Name = documentType.Name;
                                DocumentAttachmentWrapper.AttachmentStatus = '';
                                DocumentAttachmentWrapper.DocComments = '';
                                listOptionalDocument.add(DocumentAttachmentWrapper);
                            }
                        }
                        else{
                            DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                            DocumentAttachmentWrapper.Types = documentType.Id;
                            DocumentAttachmentWrapper.TypeName = documentType.Name;
                            DocumentAttachmentWrapper.Description = documentType.Description__c;
                            DocumentAttachmentWrapper.FileName = '';
                            DocumentAttachmentWrapper.Name = documentType.Name;
                            DocumentAttachmentWrapper.AttachmentStatus = '';
                            DocumentAttachmentWrapper.DocComments = '';
                            listRequiredDocument.add(DocumentAttachmentWrapper);
                        }
                    }
                }
                else{
                    if(documentType.Need_to_be_Updated_at_each_new_Transacti__c == true){
                        isDocumentExist = false;
                        for(Document__c document : listProviderDocuments){
                            if(document.Document_Type__c == documentType.Id){
                                DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                                DocumentAttachmentWrapper.Types = documentType.Id;
                                DocumentAttachmentWrapper.TypeName = documentType.Name;
                                DocumentAttachmentWrapper.Description = documentType.Description__c;
                                //DocumentAttachmentWrapper.FileName = document.Original_File_Name__c;
                                DocumentAttachmentWrapper.Name = documentType.Name;
                                DocumentAttachmentWrapper.AttachmentStatus = 'Approved';
                                DocumentAttachmentWrapper.DocComments = '';
                                listRequiredDocument.add(DocumentAttachmentWrapper);
                                isDocumentExist = true;
                                break;
                            }
                        }
                        if(isDocumentExist == false){
                            DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                            DocumentAttachmentWrapper.Types = documentType.Id;
                            DocumentAttachmentWrapper.TypeName = documentType.Name;
                            DocumentAttachmentWrapper.Description = documentType.Description__c;
                            DocumentAttachmentWrapper.FileName = '';
                            DocumentAttachmentWrapper.Name = documentType.Name;
                            DocumentAttachmentWrapper.AttachmentStatus = '';
                            DocumentAttachmentWrapper.DocComments = '';
                            listRequiredDocument.add(DocumentAttachmentWrapper);
                        }
                    }
                    else{
                        DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                        DocumentAttachmentWrapper.Types = documentType.Id;
                        DocumentAttachmentWrapper.TypeName = documentType.Name;
                        DocumentAttachmentWrapper.Description = documentType.Description__c;
                        DocumentAttachmentWrapper.FileName = '';
                        DocumentAttachmentWrapper.Name = documentType.Name;
                        DocumentAttachmentWrapper.AttachmentStatus = '';
                        DocumentAttachmentWrapper.DocComments = '';
                        listRequiredDocument.add(DocumentAttachmentWrapper);
                    }
                }
            }
            
            if(documentType.Optional_for_Transactio_Type__c.contains(licenseTransation.RecordType.Name) && documentType.Individual_Document__c == false){
                if(mapDocumentTypeDocs.get(documentType.Id) != null){
                    List<Transaction_Document__c> listDocs = mapDocumentTypeDocs.get(documentType.Id);
                    isDocumentExist = false;                    
                    for(Transaction_Document__c transactionDoc : listDocs){
                        if(transactionDoc.Mode__c == 'Optional'){
                            DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                            DocumentAttachmentWrapper.Types = documentType.Id;
                            DocumentAttachmentWrapper.TypeName = documentType.Name;
                            DocumentAttachmentWrapper.Description = documentType.Description__c;
                            /*if(transactionDoc.S3_File__c != null){
                                DocumentAttachmentWrapper.FileName = transactionDoc.S3_File__r.Filename__c;
                            }
                            else{
                                DocumentAttachmentWrapper.FileName = transactionDoc.Document__r.Original_File_Name__c;
                            }*/
                            DocumentAttachmentWrapper.Name = transactionDoc.Name;
                            DocumentAttachmentWrapper.AttachmentStatus = transactionDoc.Status__c;
                            DocumentAttachmentWrapper.DocComments = transactionDoc.Comments__c;
                            DocumentAttachmentWrapper.TransactionDocumentId = transactionDoc.Id;
                            listOptionalDocument.add(DocumentAttachmentWrapper);
                            isDocumentExist = true;
                            break;
                        }
                    }
                    if(isDocumentExist == false){
                        if(documentType.Need_to_be_Updated_at_each_new_Transacti__c == true){
                            isDocumentExist = false;
                            for(Document__c document : listProviderDocuments){
                                if(document.Document_Type__c == documentType.Id){
                                    DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                                    DocumentAttachmentWrapper.Types = documentType.Id;
                                    DocumentAttachmentWrapper.TypeName = documentType.Name;
                                    DocumentAttachmentWrapper.Description = documentType.Description__c;
                                    //DocumentAttachmentWrapper.FileName = document.Original_File_Name__c;
                                    DocumentAttachmentWrapper.Name = documentType.Name;
                                    DocumentAttachmentWrapper.AttachmentStatus = 'Approved';
                                    DocumentAttachmentWrapper.DocComments = '';
                                    listOptionalDocument.add(DocumentAttachmentWrapper);
                                    isDocumentExist = true;
                                    break;
                                }
                            }
                            if(isDocumentExist == false){
                                DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                                DocumentAttachmentWrapper.Types = documentType.Id;
                                DocumentAttachmentWrapper.TypeName = documentType.Name;
                                DocumentAttachmentWrapper.Description = documentType.Description__c;
                                DocumentAttachmentWrapper.FileName = '';
                                DocumentAttachmentWrapper.Name = documentType.Name;
                                DocumentAttachmentWrapper.AttachmentStatus = '';
                                DocumentAttachmentWrapper.DocComments = '';
                                listOptionalDocument.add(DocumentAttachmentWrapper);
                            }
                        }
                        else{
                            DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                            DocumentAttachmentWrapper.Types = documentType.Id;
                            DocumentAttachmentWrapper.TypeName = documentType.Name;
                            DocumentAttachmentWrapper.Description = documentType.Description__c;
                            DocumentAttachmentWrapper.FileName = '';
                            DocumentAttachmentWrapper.Name = documentType.Name;
                            DocumentAttachmentWrapper.AttachmentStatus = '';
                            DocumentAttachmentWrapper.DocComments = '';
                            listOptionalDocument.add(DocumentAttachmentWrapper);
                        }
                    }
                }
                else{
                    if(documentType.Need_to_be_Updated_at_each_new_Transacti__c == true){
                        isDocumentExist = false;
                        for(Document__c document : listProviderDocuments){
                            if(document.Document_Type__c == documentType.Id){
                                DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                                DocumentAttachmentWrapper.Types = documentType.Id;
                                DocumentAttachmentWrapper.TypeName = documentType.Name;
                                DocumentAttachmentWrapper.Description = documentType.Description__c;
                                //DocumentAttachmentWrapper.FileName = document.Original_File_Name__c;
                                DocumentAttachmentWrapper.Name = documentType.Name;
                                DocumentAttachmentWrapper.AttachmentStatus = 'Approved';
                                DocumentAttachmentWrapper.DocComments = '';
                                listOptionalDocument.add(DocumentAttachmentWrapper);
                                isDocumentExist = true;
                                break;
                            }
                        }
                        if(isDocumentExist == false){
                            DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                            DocumentAttachmentWrapper.Types = documentType.Id;
                            DocumentAttachmentWrapper.TypeName = documentType.Name;
                            DocumentAttachmentWrapper.Description = documentType.Description__c;
                            DocumentAttachmentWrapper.FileName = '';
                            DocumentAttachmentWrapper.Name = documentType.Name;
                            DocumentAttachmentWrapper.AttachmentStatus = '';
                            DocumentAttachmentWrapper.DocComments = '';
                            listOptionalDocument.add(DocumentAttachmentWrapper);
                        }
                    }
                    else{
                        DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                        DocumentAttachmentWrapper.Types = documentType.Id;
                        DocumentAttachmentWrapper.TypeName = documentType.Name;
                        DocumentAttachmentWrapper.Description = documentType.Description__c;
                        DocumentAttachmentWrapper.FileName = '';
                        DocumentAttachmentWrapper.Name = documentType.Name;
                        DocumentAttachmentWrapper.AttachmentStatus = '';
                        DocumentAttachmentWrapper.DocComments = '';
                        listOptionalDocument.add(DocumentAttachmentWrapper);
                    }
                }
            }
            if(documentType.Individual_Document__c == true){
                List<Transaction_Document__c> listDocs = mapDocumentTypeDocs.get(documentType.Id);
                
                Set<Id> setRoleId = new Set<Id>();
                
                if(listDocs != null){
                    for(Transaction_Document__c transactionDoc : listDocs){
                        if(transactionDoc.Mode__c == 'Individual'){
                            DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                            DocumentAttachmentWrapper.Types = documentType.Id;
                            DocumentAttachmentWrapper.TypeName = documentType.Name;
                            DocumentAttachmentWrapper.Description = documentType.Description__c;
                            /*if(transactionDoc.S3_File__c != null){
                                DocumentAttachmentWrapper.FileName = transactionDoc.S3_File__r.Filename__c;
                            }
                            else{
                                DocumentAttachmentWrapper.FileName = transactionDoc.Document__r.Original_File_Name__c;
                            }*/
                            //DocumentAttachmentWrapper.Individual = transactionDoc.Contact_Role__r.Contact__r.FirstName + ' ' + transactionDoc.Contact_Role__r.Contact__r.LastName;
                            //DocumentAttachmentWrapper.Role = transactionDoc.Contact_Role__r.Role__c;
                            //DocumentAttachmentWrapper.ContactRoleId = transactionDoc.Contact_Role__c;
                            DocumentAttachmentWrapper.Name = transactionDoc.Name;
                            DocumentAttachmentWrapper.AttachmentStatus = transactionDoc.Status__c;
                            DocumentAttachmentWrapper.DocComments = transactionDoc.Comments__c;
                            DocumentAttachmentWrapper.TransactionDocumentId = transactionDoc.Id;
                            if(documentType.Required_For_Transaction_Type__c.contains(licenseTransation.RecordType.Name)){
                                DocumentAttachmentWrapper.Mandatory = 'Mandatory';
                            }
                            else{
                                DocumentAttachmentWrapper.Mandatory = 'Optional';
                            }
                            //setRoleId.add(transactionDoc.Contact_Role__c);
                            listIndividualDocument.add(DocumentAttachmentWrapper);
                        }
                    }
                }
                for(Contact_Role__c contactRole : tempcontactrole){
                    if(contactRole.Role__c == documentType.Related_Role__c && !setRoleId.contains(contactRole.Id)){
                        DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                        DocumentAttachmentWrapper.Types = documentType.Id;
                        DocumentAttachmentWrapper.TypeName = documentType.Name;
                        DocumentAttachmentWrapper.Description = documentType.Description__c;
                        DocumentAttachmentWrapper.FileName = '';
                        DocumentAttachmentWrapper.Name = documentType.Name;
                        DocumentAttachmentWrapper.AttachmentStatus = '';
                        DocumentAttachmentWrapper.DocComments = '';
                        //DocumentAttachmentWrapper.Individual = contactRole.Contact__r.FirstName + ' ' + ContactRole.Contact__r.LastName;
                        //DocumentAttachmentWrapper.Role = contactRole.Role__c;
                        if(documentType.Required_For_Transaction_Type__c.contains(licenseTransation.RecordType.Name)){
                            DocumentAttachmentWrapper.Mandatory = 'Mandatory';
                        }
                        else{
                            DocumentAttachmentWrapper.Mandatory = 'Optional';
                        }
                        DocumentAttachmentWrapper.ContactRoleId = contactRole.Id;
                        listIndividualDocument.add(DocumentAttachmentWrapper);
                    }
                }
            }
        }
        
        mapVarianceIds = new Map<string, string>();
        boolean isExist = false;
        for(Variance_on_Regulation__c variance : listVariance){
            isExist = false;
            for(Transaction_Document__c transactionDoc : listTransactionDocument){
                if(variance.Id == transactionDoc.Variance_on_Regulation__c){                    
                    List<DocumentAttachmentWrapper> listVarianceDocs;
                    if(mapVarianceDocument.get(variance.Id) == null){
                        listVarianceDocs = new List<DocumentAttachmentWrapper>();
                    }
                    else{
                        listVarianceDocs = mapVarianceDocument.get(variance.Id);
                    }
                    DocumentAttachmentWrapper DocumentAttachmentWrapper = new DocumentAttachmentWrapper();
                    DocumentAttachmentWrapper.VarianceRegulationArticle = variance.Associated_Regulation__r.Name;
                    DocumentAttachmentWrapper.VarianceRegulationId = variance.Id;
                    DocumentAttachmentWrapper.Name = transactionDoc.Name;
                    /*if(transactionDoc.S3_File__c != null){
                        DocumentAttachmentWrapper.FileName = transactionDoc.S3_File__r.Filename__c;
                    }
                    else{
                        DocumentAttachmentWrapper.FileName = transactionDoc.Document__r.Original_File_Name__c;
                    }*/
                    DocumentAttachmentWrapper.DocComments = transactionDoc.Comments__c;
                    DocumentAttachmentWrapper.AttachmentStatus = transactionDoc.Status__c;
                    DocumentAttachmentWrapper.TransactionDocumentId = transactionDoc.Id;
                    listVarianceDocs.add(DocumentAttachmentWrapper);
                    mapVarianceDocument.put(variance.Id, listVarianceDocs);
                    isExist = true;
                }
            }
            mapVarianceIds.put(variance.Id, variance.Associated_Regulation__r.Name);
            if(isExist == false){
                List<DocumentAttachmentWrapper> listVarianceDocs = new List<DocumentAttachmentWrapper>();
                mapVarianceDocument.put(variance.Id, listVarianceDocs);
            }
        }
    }
    
    public void sumCapacity(){      
        sumOfCapacities = ''+(
        (provider.Infant_birth_15_mo__c == null ? 0 : provider.Infant_birth_15_mo__c) + 
        (provider.Infant_Toddler_birth_33_mo__c == null ? 0 : provider.Infant_Toddler_birth_33_mo__c) + 
        (provider.Toddler_15_mo_33_mo__c == null ? 0 : provider.Toddler_15_mo_33_mo__c) + 
        (provider.Toddler_Preschool_15_mo_K__c == null ? 0 : provider.Toddler_Preschool_15_mo_K__c) + 
        (provider.Preschool_33_mo_K__c == null ? 0 : provider.Preschool_33_mo_K__c) + 
        (provider.Preschool_SA_33_mo_8_yr__c == null ? 0 : provider.Preschool_SA_33_mo_8_yr__c) + 
        (provider.Kindergarten__c == null ? 0 : provider.Kindergarten__c) + 
        (provider.School_Age_5_yr_14_yr__c == null ? 0 : provider.School_Age_5_yr_14_yr__c) + 
        (provider.Multi_Age_Group_birth_14_yr__c == null ? 0 : provider.Multi_Age_Group_birth_14_yr__c));
    }
    
    public String getRecordTypeJson() {
        return JSON.serialize(recordTypeMap);
    }
    
    public List<String> getButtonList() {
        List<String> ibwList = new List<String> ();
        Boolean hasNewLicense = false;
        Boolean hasRenewal = false;
        Boolean hasLicenseUpgrade = false;
        Boolean hasChangeOfAddress = false;
        Boolean hasChangeOfRoom = false;  
        Boolean hasChangeOfHousehold = false;
        Boolean hasReActivate = false;
        Boolean hasRequestReIssuance = false;    
        Boolean hasInActivate = false;
        Boolean hasClosePrior = false;
        Boolean hasAssistantRenewal = false;
        Boolean hasAssistantUpgrade = false;
        Boolean hasAssistantNew = false;
        Boolean hasGSANewLicense = false;  
        Boolean hasGSARenewal = false;
        Boolean hasGSAMove = false;
        Boolean hasGSALicenseChange = false;
        Boolean hasGSAChangeOfAdmin = false;
        Boolean hasResidentialNewLicense = false;  
        Boolean hasResidentialRenewal = false;
        Boolean hasResidentialMove = false;
        Boolean hasResidentialLicenseChange = false;
        Boolean hasPlacementNewLicense = false;  
        Boolean hasPlacementRenewal = false;
        Boolean hasPlacementMove = false;
        Boolean hasPlacementLicenseChange = false; 
        Boolean hasChangeOfProviderName = false;
        Boolean hasRPChangeOfAdmin = false;
        Boolean hasLicenseDowngrade = false;
        Boolean hasVarianceRegulation = false;
        String ltRecordTypeName;

        if (provider.Licensing_Transactions__r != null) {
            List<Licensing_Transaction__c> lstTrans = [SELECT Ownership_Type__c ,Id,New_Name__c,RecordType.DeveloperName, Status__c 
                                                       FROM Licensing_Transaction__c 
                                                       WHERE Provider__c = : provider.Id];  
            for (Licensing_Transaction__c lt : lstTrans) {
                ltRecordTypeName = lt.RecordType.DeveloperName;

                if (ltRecordTypeName == 'FCC_New_License' && isStatusClosed(lt.Status__c)) {
                    hasNewLicense = true;
                } else if (ltRecordTypeName == 'FCC_Renewal' && isStatusClosed(lt.Status__c)) {
                    hasRenewal = true;
                } else if (ltRecordTypeName == 'FCC_License_Upgrade' && isStatusClosed(lt.Status__c)) {
                    hasLicenseUpgrade = true;
                } else if (ltRecordTypeName == 'Change_of_Address' && isStatusClosed(lt.Status__c)) {
                    hasChangeOfAddress = true;
                } else if (ltRecordTypeName == 'FCC_Change_Room_Floor_Level' && isStatusClosed(lt.Status__c)) {
                    hasChangeOfRoom = true;    
                } else if (ltRecordTypeName == 'FCC_Change_of_Household' && isStatusClosed(lt.Status__c)) {
                    hasChangeOfHousehold = true;
                } else if (ltRecordTypeName == 'FCC_Re_Active' && isStatusClosed(lt.Status__c)) {
                    hasReActivate = true;
                } else if (ltRecordTypeName == 'FCC_Inactivate' && isStatusClosed(lt.Status__c)) {
                    hasInActivate = true;
                } else if (ltRecordTypeName == 'Close_Prior_Expiration' && isStatusClosed(lt.Status__c)) {
                    hasClosePrior = true;
                } else if (ltRecordTypeName == 'FCC_Assistant_Renewal' && isStatusClosed(lt.Status__c)) {
                    hasAssistantRenewal = true;
                } else if (ltRecordTypeName == 'FCC_Assistant_License_Upgrade' && isStatusClosed(lt.Status__c)) {
                    hasAssistantUpgrade = true;
                } else if (ltRecordTypeName == 'FCC_Assistant_New_License' && isStatusClosed(lt.Status__c)) {
                    hasAssistantNew = true;
                } else if (ltRecordTypeName == 'Re_issuance_of_License_Cert' && isStatusClosed(lt.Status__c)) {
                    hasRequestReIssuance = true;
                } else if (ltRecordTypeName == 'GSA_New_License' && isStatusClosed(lt.Status__c)) {
                    hasGSANewLicense = true;
                } else if (ltRecordTypeName == 'GSA_Move' && isStatusClosed(lt.Status__c)) {
                    hasGSAMove = true;
                } else if (ltRecordTypeName == 'GSA_Renewal' && isStatusClosed(lt.Status__c)) {
                    hasGSARenewal = true;
                } else if (ltRecordTypeName == 'GSA_License_Change' && isStatusClosed(lt.Status__c)) {
                    hasGSALicenseChange = true;
                } else if (ltRecordTypeName == 'GSA_Change_of_Admin_Authority' && isStatusClosed(lt.Status__c)) {
                    hasGSAChangeOfAdmin = true;
                } else if (ltRecordTypeName == 'Change_of_Provider_Name' && isStatusClosed(lt.Status__c)) {
                    hasChangeOfProviderName = true;
                } else if (ltRecordTypeName == 'Residential_New_License' && isStatusClosed(lt.Status__c)) {
                    hasResidentialNewLicense = true;
                } else if (ltRecordTypeName == 'Residential_Move' && isStatusClosed(lt.Status__c)) {
                    hasResidentialMove = true;
                } else if (ltRecordTypeName == 'Residential_License_Renewal' && isStatusClosed(lt.Status__c)) {
                    hasResidentialRenewal = true;
                } else if (ltRecordTypeName == 'Residential_Change_in_License' && isStatusClosed(lt.Status__c)) {
                    hasResidentialLicenseChange = true;
                } else if (ltRecordTypeName == 'Placement_New_License' && isStatusClosed(lt.Status__c)) {
                    hasPlacementNewLicense = true;
                } else if (ltRecordTypeName == 'Placement_Move' && isStatusClosed(lt.Status__c)) {
                    hasPlacementMove = true;
                } else if (ltRecordTypeName == 'Placement_Renewal' && isStatusClosed(lt.Status__c)) {
                    hasPlacementRenewal = true;
                } else if (ltRecordTypeName == 'Placement_Change_in_License' && isStatusClosed(lt.Status__c)) {
                    hasPlacementLicenseChange = true;
                } else if (ltRecordTypeName == 'R_P_Change_of_Admin_Authority' && isStatusClosed(lt.Status__c)) {
                    hasRPChangeOfAdmin = true;
                } else if (ltRecordTypeName == 'FCC_Downgrade_Capacity' && isStatusClosed(lt.Status__c)) {
                    hasLicenseDowngrade = true;
                } else if (ltRecordTypeName == 'Variance_On_Regulation_Request' && isStatusClosed(lt.Status__c)) {
                    hasVarianceRegulation = true;
                }
            }
        }
        gsaRecordTypeMap = new List<String>();  
        
        if(provider.Is_GSA__c || provider.Is_R_P__c){  
            if((provider.First_Issue_Date__c == null || (provider.Renewal_date__c != null && provider.Renewal_date__c.addDays(120) < Date.Today())) && provider.License_Status__c != 'Licensed' && !hasGSANewLicense && !hasResidentialNewLicense && !hasPlacementNewLicense ){
                gsaRecordTypeMap.add('New Application (Provisional)');  
            }  
            if(provider.Renewal_date__c != null && provider.License_Status__c == 'Licensed' && provider.License_Type__c != null && provider.License_Type__c.contains('Provisional') && (provider.Renewal_date__c.addDays(120) >= Date.Today() && provider.Renewal_date__c.addDays(-120) <= Date.Today()) && !hasGSARenewal &&!hasPlacementRenewal &&!hasResidentialRenewal){
                gsaRecordTypeMap.add('New Application (Regular)');
            }
            if(provider.Renewal_date__c != null && provider.License_Status__c == 'Licensed' && provider.License_Type__c != null && !provider.License_Type__c.contains('Provisional') && (provider.Renewal_date__c.addDays(120) >= Date.Today() && provider.Renewal_date__c.addDays(-120) <= Date.Today()) && !hasGSARenewal && !hasPlacementRenewal && !hasResidentialRenewal){
                gsaRecordTypeMap.add('Apply for Renewal (without move)');    
            }
            if(provider.Is_R_P__c && provider.Is_Placement__c && provider.License_Type__c != null && !provider.License_Type__c.contains('Provisional') && provider.Provider_Status__c != 'Inactive' &&  provider.License_Status__c == 'Licensed' && !hasPlacementRenewal && !hasPlacementLicenseChange && !hasPlacementMove){
                gsaRecordTypeMap.add('Apply for a License Change (excluding Move)');    
            }else if(provider.Is_R_P__c && provider.Is_Residential__c && provider.License_Type__c != null && !provider.License_Type__c.contains('Provisional') && provider.License_Status__c == 'Licensed' && provider.Provider_Status__c !='Inactive' && !hasResidentialRenewal && !hasResidentialMove && !hasResidentialLicenseChange){
                gsaRecordTypeMap.add('Apply for a License Change (excluding Move)');    
            }else if(provider.Is_GSA__c && provider.License_Type__c != null && !provider.License_Type__c.contains('Provisional') && provider.Provider_Status__c !='Inactive' && provider.License_Status__c == 'Licensed' && !hasGSARenewal && !hasGSAMove && !hasGSALicenseChange){
                gsaRecordTypeMap.add('Apply for a License Change (excluding Move)');    
            }
            if(provider.License_Type__c != null && !provider.License_Type__c.contains('Provisional') && provider.Provider_Status__c !='Inactive' && provider.License_Status__c == 'Licensed' && !hasGSARenewal && !hasGSAMove && !hasGSALicenseChange && !hasPlacementRenewal && !hasPlacementMove && !hasPlacementLicenseChange && !hasResidentialRenewal && !hasResidentialLicenseChange && !hasResidentialMove ){
                gsaRecordTypeMap.add('Apply for a Move or License Renewal with Move');    
            }
            if(provider.Is_GSA__c && provider.License_Status__c == 'Licensed' && provider.Provider_Status__c !='Inactive' && !hasGSAChangeOfAdmin && !hasGSARenewal && !hasGSAMove && !hasGSALicenseChange){
                gsaRecordTypeMap.add('Report a Change in Ownership or Designation of Administrative Authority');    
            }
            if(provider.Is_R_P__c && provider.License_Status__c == 'Licensed' && provider.Provider_Status__c !='Inactive' && !hasRPChangeOfAdmin && !hasResidentialMove && !hasResidentialRenewal && !hasResidentialLicenseChange && !hasPlacementMove && !hasPlacementRenewal && !hasPlacementLicenseChange){
                gsaRecordTypeMap.add('Report a Change in Ownership or Administrative Designee');    
            }
            if(provider.License_Status__c == 'Licensed' && provider.Provider_Status__c !='Inactive' && !hasChangeOfProviderName){
                gsaRecordTypeMap.add('Report a Change in Program Name');    
            }
            if (provider.License_Status__c == 'Licensed' && provider.Provider_Status__c !='Inactive' && !hasRequestReIssuance) {
                gsaRecordTypeMap.add('Request Re-issuance of License or Certificate');
            }
            if (provider.License_Status__c == 'Licensed' && !hasClosePrior) {
                gsaRecordTypeMap.add('Close Prior To Expiration');
            }
            gsaRecordTypeMap.add('Cancel'); 
        }
        /*if(provider.Is_R_P__c && provider.License_Status__c == 'Licensed' && provider.Provider_Status__c !='Inactive' && !hasRPChangeOfAdmin 
&& !hasResidentialRenewal && !hasResidentialMove && !hasResidentialLicenseChange 
&& !hasPlacementMove && !hasPlacementRenewal && !hasPlacementLicenseChange){
gsaRecordTypeMap.add('Report a Change in Ownership or Administrative Designee');    
}  
if(provider.Is_R_P__c && provider.Is_Placement__c && !provider.License_Type__c.contains('Provisional') && provider.License_Status__c == 'Licensed' && provider.Provider_Status__c !='Inactive' && !hasPlacementRenewal && !hasPlacementLicenseChange && !hasPlacementMove){
gsaRecordTypeMap.add('Apply for a License Change (excluding Move)');    
}
if(provider.Is_R_P__c && provider.Is_Residential__c && !provider.License_Type__c.contains('Provisional') && provider.License_Status__c == 'Licensed' && provider.Provider_Status__c !='Inactive' && !hasResidentialRenewal && !hasResidentialMove && !hasResidentialLicenseChange){
gsaRecordTypeMap.add('Apply for a License Change (excluding Move)');    
}*/  
        /*Only if Provider.Record_Type = "Family Child Care" and (First Issue Date is NULL OR Expiration Date + 120 days <= Today) and 
there is no other New License Transaction "Non Submitted", "Submitted" or "Under Review" (=> not Cancelled)*/
        if (providerRecordType == 'Family Child Care' && (provider.First_Issue_Date__c == null || (provider.renewal_date__c != null && provider.renewal_date__c < Date.Today().addDays(- 120))) && !hasNewLicense) {
            ibwList.add('New Application');
        }
        
        /*Only if Provider.Record_Type = "Family Child Care" and (Today - 120 days <= Expiration Date <= Today + 120 days) and 
there is no other Renewal License Transaction with status "Non Submitted" or "Submitted" or "Under Review" (=> not Cancelled)*/
        
        if (providerRecordType == 'Family Child Care' && (provider.renewal_date__c != null && provider.renewal_date__c >= Date.Today().addDays(- 120) && provider.renewal_date__c <= Date.Today().addDays(120)) && !hasRenewal) {
            ibwList.add('Apply for Renewal');
        }
        
        /*Only if "Allow Renewal as Assistant" = True, and there is no other "FCC Assistant Renewal" Transaction attached to
that provider  in status "Non Submitted", "Submitted", "Under Review", "Pending Manager Approval", "Approved By Manager"*/  
        
        if (providerRecordType == 'Family Child Care' && provider.Allow_Renewal_as_Assistant__c && !hasAssistantRenewal)  {
            ibwList.add('Apply for Renewal as an Assistant');
        }  
        
        /*Only if Provider.Record_Type = "Family Child Care" and License Status = Licensed, and 
there is no other Renewal License Transaction / License Upgrade Transaction with status "Non Submitted" or "Submitted" or "Under Review" (=> not Cancelled)*/
        if (providerRecordType == 'Family Child Care' && provider.License_Status__c == 'Licensed' && provider.Capacity__c != null && (provider.Capacity__c.contains('6') || provider.Capacity__c.contains('8')) && (!hasRenewal && !hasLicenseUpgrade)) {
            ibwList.add('Apply for an Upgrade');
        }
        
        /*Only if Provider.Record_Type = "Family Child Care" and License Status = Licensed, and 
there is no other Renewal License Transaction / License Upgrade / Change of Address Transaction with status "Non Submitted" or "Submitted" or "Under Review" (=> not Cancelled)*/
        if (providerRecordType == 'Family Child Care' && provider.License_Status__c == 'Licensed' && (!hasRenewal && !hasLicenseUpgrade && !hasChangeOfAddress)) {
            ibwList.add('Apply for a Change of Address');
        }
        
        /*Only if Provider.Record_Type = "Family Child Care" and License Status = Licensed, and 
there is no other Renewal License Transaction / License Upgrade / Change of Address Transaction with status "Non Submitted" or "Submitted" or "Under Review" (=> not Cancelled) */
        if (providerRecordType == 'Family Child Care' && provider.License_Status__c == 'Licensed' && (!hasRenewal && !hasLicenseUpgrade && !hasChangeOfAddress && !hasChangeOfRoom)) {
            ibwList.add('Notify EEC - Change of Room usage');
        }
        
        /*Only if Provider.Record_Type = "Family Child Care" and License Status = Licensed, and 
there is no other Renewal License Transaction / License Upgrade / Change in Household with status "Non Submitted" or "Submitted" or "Under Review" (=> not Cancelled)           
*/
        if (providerRecordType == 'Family Child Care' && provider.License_Status__c == 'Licensed' && (!hasRenewal && !hasLicenseUpgrade && !hasChangeOfHousehold)) {
            ibwList.add('Notify EEC - Change of Household Members / Individuals Regularly on the Premises');
        }
        
        /*Only if Provider.Record_Type = "Family Child Care" and License Status = Licensed*/
        if ((providerRecordType == 'Family Child Care' || isFccAssistant) && provider.License_Status__c == 'Licensed' && !hasRequestReIssuance) {
            ibwList.add('Request Re-Issuance of License / Certificate');
        }
        
        /*Only if Provider.Record_Type = "Family Child Care" and License Status = Licensed, and 
Provider Status = Inactive  and there is no other Re-Activate License transactions with status "Non Submitted" or "Submitted" or "Under Review" (=> not Cancelled)*/
        if ((providerRecordType == 'Family Child Care' || isFccAssistant) && provider.License_Status__c == 'Licensed' && provider.Provider_Status__c == 'Inactive' && !hasReActivate) {
            ibwList.add('Re-Activate License / Certificate');
        }
        
        /*Only if Provider.Record_Type = "Family Child Care" and License Status = Licensed, and 
there is no other De-Activate License transactions with status "Non Submitted" or "Submitted" or "Under Review" (=> not Cancelled)  */
        if ((providerRecordType == 'Family Child Care' || isFccAssistant) && provider.License_Status__c == 'Licensed' && provider.Provider_Status__c != 'Inactive' && !hasInActivate) {
            ibwList.add('De-Activate License / Certificate');
        }
        
        /*Only if Provider.Record_Type = "Family Child Care" and License Status = Licensed, and 
there is no other Close Prior Expiration transactions with status "Non Submitted" or "Submitted" or "Under Review" (=> not Cancelled)*/
        if (providerRecordType == 'Family Child Care'  && provider.License_Status__c == 'Licensed' && !hasClosePrior) {
            ibwList.add('Close Prior To Expiration');
        }
        
        /*----- FCC Assistant ------*/
        if (providerRecordType == 'FCC Assistant' && (provider.First_Issue_Date__c == null || (provider.renewal_date__c != null && provider.renewal_date__c < Date.Today().addDays(- 120))) && !hasAssistantNew) {
            ibwList.add('New Application');
        }
        if (providerRecordType == 'FCC Assistant' && provider.License_Status__c == 'Licensed' && !hasClosePrior) {
            ibwList.add('Close Prior To Expiration');
        }
        
        if (providerRecordType == 'FCC Assistant' && (provider.renewal_date__c != null && provider.renewal_date__c >= Date.Today().addDays(- 120) && provider.renewal_date__c <= Date.Today().addDays(120)) && !hasAssistantRenewal) {
            ibwList.add('Apply for Renewal');
        }
        
        if (providerRecordType == 'FCC Assistant' && provider.Allow_New_Application_as_Provider__c && !hasNewLicense) {
            ibwList.add('Apply to be licensed as FCC Provider');
        }  
        
        if (providerRecordType == 'FCC Assistant' && provider.License_Status__c == 'Licensed' && !hasAssistantUpgrade && !hasAssistantRenewal) {
            ibwList.add('Apply for an Upgrade');
        }
        
        if (providerRecordType == 'Family Child Care' && provider.License_Status__c == 'Licensed' && provider.Capacity__c != null && (provider.Capacity__c.contains('7') || provider.Capacity__c.contains('8') || provider.Capacity__c.contains('9') || provider.Capacity__c.contains('10')) && !hasAssistantUpgrade && !hasAssistantRenewal && !hasLicenseDowngrade) {
            ibwList.add('Apply for a Decrease of Licensed Capacity');
        }
        
        if ((providerRecordType == 'Family Child Care' || provider.Is_GSA__c == true || provider.Is_R_P__c == true) && provider.License_Status__c == 'Licensed' && !hasVarianceRegulation) {
            ibwList.add('Request a Variance on Regulations');
        }
        
        ibwList.add('Cancel');
        return ibwList;
    }
    
    public void clearAttachLib(){        
        transDoc = new Transaction_Document__c();
        docName = '';
        docId = '';
        renderAttachLib = false;        
    }
    
    public void setDocNameId(String docName,String docId){
        this.docName = docName;
        this.docId = docId;
    }
        
    public void addDocument(){
        if(docName!=''&&docId!=''){
            transDoc.Document__c = Id.valueof(docId);
            transDoc.Licensing_Transaction__c = Id.valueof(ApexPages.currentPage().getParameters().get('ltId'));
            transDoc.Mode__c = 'Additional';
            Boolean apprForUs = Boolean.valueof(ApexPages.currentPage().getParameters().get('apprForUs'));
            if(apprForUs){
                transDoc.Status__c = 'Approved';
            }else{
                transDoc.Status__c = 'New Attachment';
            }
            insert transDoc;
        }
    }
    
    public PageReference callIntakeForms() {
        licenseRecordTypeLabel = ApexPages.currentPage().getParameters().get('buttonLabel');
        
        if (licenseRecordTypeLabel == 'cancel') {
            PageReference pPage = page.EEC_PortalProviderPage;
            return pPage;
        }
        Intake__c[] intakeForm = [SELECT Id,Name, FormVersion__c FROM Intake__c WHERE
                                  FormVersion__r.Form__r.Name =: gsaRecordType.get(licenseRecordTypeLabel)
                                  AND FormVersion__r.Status__c = 'Published'];
        
        if(intakeForm.size() > 0){ 
            PageReference pPage = new PageReference('/iffIntakePage?#/intake/' + intakeForm[0].Id);
            pPage.setRedirect(true);  
            return pPage;
        }
        else
            return null;
    }
    
    public PageReference callTransaction() {
        licenseRecordTypeLabel = ApexPages.currentPage().getParameters().get('buttonLabel');
        if (licenseRecordTypeLabel == 'cancel') {
            PageReference pPage = page.EEC_PortalProviderPage;
            return pPage;
        }
        
        if (providerRecordType == 'FCC Assistant') {
            LicenseRecordTypeName = assistantRecordTypeMap.get(licenseRecordTypeLabel);
        }else if(provider.Is_GSA__c ||provider.Is_R_P__c ){
            if(licenseRecordTypeLabel == 'New Application (Provisional)' && (providerRecordType == 'Small Group'||providerRecordType == 'Large Group') ){
                LicenseRecordTypeName = gsaRecordType.get(licenseRecordTypeLabel).split(',')[0];
                licenseTransation.License_Type__c ='First Provisional';
            }else if((licenseRecordTypeLabel == 'New Application (Provisional)' && (providerRecordType == 'Foster Care Agency'||providerRecordType == 'Adoption Agency'))){
                LicenseRecordTypeName = gsaRecordType.get(licenseRecordTypeLabel).split(',')[1];
                licenseTransation.License_Type__c ='First Provisional';
            }else if((licenseRecordTypeLabel == 'New Application (Provisional)' && (providerRecordType == 'Group Care'||providerRecordType == 'Temporary Shelter'))){
                LicenseRecordTypeName = gsaRecordType.get(licenseRecordTypeLabel).split(',')[2];
                licenseTransation.License_Type__c ='First Provisional';
            }else if(licenseRecordTypeLabel == 'New Application (Regular)' && (providerRecordType == 'Small Group'||providerRecordType == 'Large Group')){
                LicenseRecordTypeName = gsaRecordType.get(licenseRecordTypeLabel).split(',')[0];
                licenseTransation.Renewal_Type__c = 'Provisional to Regular';
                licenseTransation.License_Type__c ='Regular';
            }else if(licenseRecordTypeLabel == 'New Application (Regular)' && (providerRecordType == 'Foster Care Agency'||providerRecordType == 'Adoption Agency')){
                LicenseRecordTypeName = gsaRecordType.get(licenseRecordTypeLabel).split(',')[1];
                licenseTransation.Renewal_Type__c = 'Provisional to Regular';
                licenseTransation.License_Type__c ='Regular';
            }else if(licenseRecordTypeLabel == 'New Application (Regular)' && (providerRecordType == 'Group Care'||providerRecordType == 'Temporary Shelter')){
                LicenseRecordTypeName = gsaRecordType.get(licenseRecordTypeLabel).split(',')[2];
                licenseTransation.Renewal_Type__c = 'Provisional to Regular';
                licenseTransation.License_Type__c ='Regular';
            }else if(licenseRecordTypeLabel == 'Apply for Renewal (without move)' &&(providerRecordType == 'Small Group'||providerRecordType == 'Large Group')  ){
                LicenseRecordTypeName = gsaRecordType.get(licenseRecordTypeLabel).split(',')[0];
                licenseTransation.Renewal_Type__c ='Renewal';
            }else if(licenseRecordTypeLabel == 'Apply for Renewal (without move)' &&(providerRecordType == 'Foster Care Agency'||providerRecordType == 'Adoption Agency')){
                LicenseRecordTypeName = gsaRecordType.get(licenseRecordTypeLabel).split(',')[1];
                licenseTransation.Renewal_Type__c ='Renewal';
            }else if(licenseRecordTypeLabel == 'Apply for Renewal (without move)' &&(providerRecordType == 'Group Care'||providerRecordType == 'Temporary Shelter')){
                LicenseRecordTypeName = gsaRecordType.get(licenseRecordTypeLabel).split(',')[2];
                licenseTransation.Renewal_Type__c ='Renewal';
            }else if(licenseRecordTypeLabel == 'Apply for a Move or License Renewal with Move' &&(providerRecordType == 'Small Group'||providerRecordType == 'Large Group')){
                LicenseRecordTypeName = gsaRecordType.get(licenseRecordTypeLabel).split(',')[0];
            }else if(licenseRecordTypeLabel == 'Apply for a Move or License Renewal with Move' &&(providerRecordType == 'Foster Care Agency'||providerRecordType == 'Adoption Agency')){
                LicenseRecordTypeName = gsaRecordType.get(licenseRecordTypeLabel).split(',')[1];
            }else if(licenseRecordTypeLabel == 'Apply for a Move or License Renewal with Move' &&(providerRecordType == 'Group Care'||providerRecordType == 'Temporary Shelter')){
                LicenseRecordTypeName = gsaRecordType.get(licenseRecordTypeLabel).split(',')[2];
            }else if(licenseRecordTypeLabel == 'Apply for a License Change (excluding Move)' && provider.Is_Residential__c && provider.Is_R_P__c) {
                LicenseRecordTypeName = gsaRecordType.get(licenseRecordTypeLabel).split(',')[2];
            }else if(licenseRecordTypeLabel == 'Apply for a License Change (excluding Move)' && provider.Is_Placement__c && provider.Is_R_P__c){
                LicenseRecordTypeName = gsaRecordType.get(licenseRecordTypeLabel).split(',')[1];
            }else if(licenseRecordTypeLabel == 'Apply for a License Change (excluding Move)'){
                LicenseRecordTypeName = gsaRecordType.get(licenseRecordTypeLabel).split(',')[0];
            }else{
                LicenseRecordTypeName = gsaRecordType.get(licenseRecordTypeLabel);
            }
        } else {
            LicenseRecordTypeName = recordTypeMap.get(licenseRecordTypeLabel);
        }
        
        if (String.isblank(licenseTransation.Provider__c)) {
            licenseTransation.Provider__c = provider.Id;
        }
        
        licenseTransation.Last_Reached_Step__c = 'Instructions';
        licenseTransation.Status__c = 'To Submit';
        //check added by LD to fix the FLOW error
        if (LicenseRecordTypeName != null){
            licenseTransation.RecordTypeId = EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.' + LicenseRecordTypeName).Id;
        }
        upsert licenseTransation;
        
        PageReference pPage;
        /*if(licenseRecordTypeLabel == 'Request a Variance on Regulations'){
            pPage = Page.EEC_TechnicalAssistance;
        }
        else{*/
        pPage = Page.EEC_TransactionInstructions;
        //}
        pPage.getParameters().put('ltId', licenseTransation.Id);
        if (String.isNotBlank(memberId))
            pPage.getParameters().put('member', memberId);
        pPage.setRedirect(true);
        return pPage;
    }
    
    public Pagereference cancelInstruction() {
    	Licensing_Transaction__c lt = new Licensing_Transaction__c(id = licenseTransation.id);
        if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
            lt.Status__c = 'Cancelled (by Applicant)';
            lt.Reason_Closed_Cancelled__c = 'Cancelled by portal user';         
            update lt;                	 
            PageReference pPage = page.EEC_PortalProviderPage;
            if (String.isNotBlank(memberId))
                pPage.getParameters().put('member', EEC_Util.encryptGetParam(memberId));
            return pPage;                       
        }
        else{
        	lt.Status__c = 'Cancelled (by EEC User)';
            lt.Reason_Closed_Cancelled__c = 'Cancelled by EEC user';
            update lt;
            return null;    
        }
    }
    public Pagereference previousInstruction() {
        return Page.EEC_TransactionIntroduction;
    }
    
    Public void addMemberIDPageParameter(PageReference pPage, Boolean encrypt) {
        if (String.isNotBlank(memberId)) {
            if (encrypt)
                pPage.getParameters().put('member', EEC_Util.encryptGetParam(memberId));
            else
                pPage.getParameters().put('member', memberId);
        }
    }
    
    public Pagereference submitInstruction() {
        if (licenseTransation.Provider__c == null) {
            licenseTransation.Provider__c = provider.Id;
        }
        if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
            //check added by LD to fix the FLOW error
            if(loggedUser != null){
                licenseTransation.Submitter__c = Userinfo.getUserId();
            }
            
            licenseTransation.Status__c = 'Submitted';
            licenseTransation.Last_Reached_Step__c = '';
        }
        //check added by LD to fix the FLOW error
        if (LicenseRecordTypeName != null){
            licenseTransation.RecordTypeId = EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.' + LicenseRecordTypeName).Id;
        }
        upsert licenseTransation;
        PageReference pPage;
        if(LicenseRecordTypeName=='FCC_Downgrade_Capacity'){
            if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
                pPage = page.EEC_ViewTransaction;                        
                pPage.getParameters().put('ltId', licenseTransation.Id);
            }
        }
        else{
            if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
                pPage = page.EEC_PortalProviderPage;
            }
        }
        if(pPage != null){
            addMemberIDPageParameter(pPage, false);
        }
        return pPage;
    }
    
    public Pagereference nextInstruction() {
        if (String.isblank(licenseTransation.Provider__c)) {
            licenseTransation.Provider__c = provider.Id;
        }
        licenseTransation.Last_Reached_Step__c = 'Transaction / Provider Information';
        licenseTransation.Status__c = 'To Submit';
        licenseTransation.RecordTypeId = EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.' + LicenseRecordTypeName).Id;
        upsert licenseTransation;
        
        licenseTransation = [SELECT Ownership_Type__c,Provider__r.Ownerid,Provider__r.FirstDateTakenFCCII__c, Provider__r.License_Type__c, FCC_Educator_Assistant_is_working_with__c, Id, name, Date_Taken_Intro_EEC_in_MA_orientation__c, IsProviderUpgrade__c, IsAssistantUpgradeToCertified__c, Last_Reached_Step__c, RecordTypeId, Provider__c, 
                             License_Requested__c, New_Street_Address_1__c, New_Street_Address_2__c,Previous_Street_Address_1__c,Previous_Street_Address_2__c,Previous_City__c,Previous_Zip_Code__c, Previous_City__r.Name, Previous_State__c, 
                             Provide_Extended_Days1__c,Extended_Days_Available__c,Gym_Facility_Used_During_Program_Hours1__c,Drop_in_Service1__c,Evenings_Service1__c,Summer_Camp_Service1__c,Cafeteria_Used_During_Program_Hours1__c,
                             Start_Time_Afternoon_program__c,End_Time_Afternoon_program__c,Available_Days_Afternoon_program__c,Available_Days_Full_day_program__c,Start_Time_Morning_program__c,End_Time_Morning_program__c,Available_Days_Morning_program__c,Start_Time_Full_day_program__c,End_Time_Full_day_program__c,New_City__c,New_Name__c,New_City__r.Name, New_Zip_Code__c, Live_at_New_Address__c, Moving_Date__c, Date_Care_Resumes__c, New_Address_Phone_Number__c,
                             Work_Phone_Number__c, New_Phone_Number_Unlisted__c, Caring_For_Children_Not_Related__c, Evening_Overnight_Weekend_Care__c, Children_Home_Schooled__c, Children_Home_Schooled_Description__c,
                             ProgramLicensedOrApproved__c,ProgramContracted__c,Infant_Capacity__c,Operation_Type__c,Small_Group_Capacity__c,Infant_Toddler_Capacity__c,Toddler_Capacity__c,Toddler_Preschool_Capacity__c,Preschool_Capacity__c,Preschool_SA_Capacity__c,
                             Kindergarten_Capacity__c,School_Age_Capacity__c,Multi_Age_Group_Capacity__c,Total_License_Capacity_Requested__c,Minimum_Age_Limit_Requested_Years__c,
                             Minimum_Age_Limit_Requested_Months__c,Maximum_Age_Limit_Requested_Months__c,Maximum_Age_Limit_Requested_Years__c,Existing_Fiduciary_Admin_relationships1__c,
                             Approved_Foster_Care_Provider__c, Approved_Foster_Care_Provider_Descrip__c, Becoming_Foster_Care_Provider__c, Becoming_Foster_Care_Provider_Descrip__c,
                             Business_Operated_Out_of_Own_Home__c, Bus_Operated_Out_of_Own_Home_Descrip__c, Use_Family_Child_Care_System__c, Use_Family_Child_Care_System_Descrip__c,
                             Previous_Involvement_with_EEC_for_Unlice__c, Previous_Application_Certif_with_EEC__c, Prev_App_Certif_with_EEC_Descrip__c, Prev_App_Certif_with_Another_State__c,
                             Prev_App_Certif_with_Another_State_Desc__c, Certificate_of_License_Revoked_Suspend__c, Certificate_or_License_Surrendered__c, Revocation_Suspension_Surrender_Reas__c,
                             Pool_available_during_program_hours1__c ,Child_Emergency_Injury_Last_3_Years__c, Child_Emerg_Injury_Last_3_Years_Descrip__c, Charged_or_Arrested_for_Crime__c, Charges_Description__c, Dealings_with_Child_Prot_Child_Welfar__c,
                             Dealing_with_Child_Prot_Welfar_Descri__c, Registering_as_Sex_Offender__c, Sex_Offender_Nature_of_Incident__c, Restraining_Order_Issued__c, Use_of_Alcoholic_Bev_Narcotics_Drugs__c,
                             Experience_Caring_for_Children_QUalifica__c, Alcoholic_Bev_Narcotics_Drugs_Desc__c, Abused_or_neglected_a_child__c, Abused_or_neglected_a_child_Description__c, Transaction_Special_Requests_Comments__c, Steps_for_Guiding_Child_Behavior__c, Medical_Emergency_Steps__c, Caring_for_your_own_children_Years__c, Caring_for_your_own_children_Months__c, Caring_for_your_own_children_Hrs_Week__c, Caring_for_other_peoples_children_Years__c, Caring_for_other_peoples_children_Month__c, Caring_for_other_peoples_children_Hr_Wk__c, Other_Children_Kindergarten_Years__c, Other_Children_Kindergarten_Months__c, Other_Children_Kindergarten_Hrs_Week__c, Submitter__r.Name, Assigned_User_Email__c,
                             New_Umbrella_Name__c,
                             Provider__r.Capacity__c,
                            New_Umbrella_Business_Name__c,
                            NewUmbrella_Place_of_Incorporation__c,
                            NewUmbrella_Date_of_Incorporation__c,
                            NewUmbrella_Street_Address_1__c,
                            NewUmbrella_Street_Address_2__c,
                            NewUmbrella_State__c,
                            NewUmbrella_City__c,
                            NewUmbrella_Zip_Code__c,
                            NewUmbrella_Phone__c,
                            NewUmbrella_Alternate_Phone__c,
                            NewUmbrella_Fax__c,
                            NewUmbrella_Email__c,
                            NewUmbrella_Director_First_Name__c,
                            NewUmbrella_Director_Last_Name__c,
                            NewUmbrella_Director_Title__c,
                            NewUmbrella_Director_Phone__c,
                            NewUmbrella_Director_Email__c,
                            Transaction_Configuration__r.EEC_Licensing_Transaction_Instructions__c
                             from Licensing_Transaction__c where Id = :licenseTransation.Id];
        PageReference pPage = Page.EEC_TransactionProvider;
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage, false);
        pPage.setRedirect(true);
        return pPage;
    }
    
    public Pagereference saveAndNextTransactionProvider() {
        ihmList = new List<Household_Member__c> ();
        removeHMList = new List<Household_Member__c> ();
        Set<Id> recordTypeIdSet = new Set<Id> ();
        
        if (isFccAssistant) {
            if (LicenseRecordTypeName == 'FCC_Assistant_New_License' || licenseTransation.IsAssistantUpgradeToCertified__c) {
                licenseTransation.Last_Reached_Step__c = 'EEC Involvement Experience & Professional Exp.';
            } else if (LicenseRecordTypeName == 'FCC_Assistant_License_Upgrade') {
                licenseTransation.Last_Reached_Step__c = 'Background Information';
            } else {
                licenseTransation.Last_Reached_Step__c = 'Daily Routine & Activities';
            }
        } else {
            if (LicenseRecordTypeName == 'FCC_New_License' || LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'Change_of_Address' ||
                LicenseRecordTypeName == 'FCC_License_Upgrade' || LicenseRecordTypeName == 'FCC_Change_of_Household') {
                    licenseTransation.Last_Reached_Step__c = 'Household Members';
                }
            else {
                licenseTransation.Last_Reached_Step__c = 'Indoor / Outdoor space information';
            }
        }
        //R&P and GSA 
        if((LicenseRecordTypeName == 'GSA_New_License' 
            || LicenseRecordTypeName =='GSA_Move'
            ||  LicenseRecordTypeName =='GSA_Change_of_Admin_Authority'
            || LicenseRecordTypeName =='GSA_Renewal')
             ){
            licenseTransation.Last_Reached_Step__c = 'Corporation and Administrator Information';
            provider.Electronic_Communication__c = true;
        }else if(LicenseRecordTypeName =='GSA_License_Change' ){
            licenseTransation.Last_Reached_Step__c = 'Capacity Info';
            provider.Electronic_Communication__c = true;
        }
        if(LicenseRecordTypeName =='GSA_Move'){
            licenseTransation.Previous_City__c = provider.Provider_City__c;
            licenseTransation.Previous_State__c = provider.State__c;
            licenseTransation.Previous_Street_Address_1__c = provider.Provider_Address_1__c;
            licenseTransation.Previous_Street_Address_2__c = provider.Provider_Address_2__c;
            licenseTransation.Previous_Zip_Code__c = provider.Provider_Zip_Code__c;
        }
        if((LicenseRecordTypeName == 'Placement_New_License'
             || LicenseRecordTypeName == 'Placement_Renewal'
             || LicenseRecordTypeName == 'Placement_Move'
            || LicenseRecordTypeName == 'R_P_Change_of_Admin_Authority') 
            || (LicenseRecordTypeName == 'Residential_New_License'
                || LicenseRecordTypeName == 'Residential_License_Renewal'
                || LicenseRecordTypeName == 'Residential_Move')){
            licenseTransation.Last_Reached_Step__c = 'Corporation and Administrator Info';
            provider.Electronic_Communication__c = true;
        }else if(LicenseRecordTypeName == 'Residential_Change_in_License' ){
            licenseTransation.Last_Reached_Step__c = 'Residential Program Details';
            provider.Electronic_Communication__c = true;
        }else if(LicenseRecordTypeName == 'Placement_Change_in_License'){
            licenseTransation.Last_Reached_Step__c = 'Placement Agency Additional Information';
            provider.Electronic_Communication__c = true;
        }
        if(licenseTransation.Last_Reached_Step__c != null && !isFccAssistant && providerRecordType.equalsIgnoreCase('FCC Assistant') && licenseRecordTypeLabel.equalsIgnoreCase('FCC New License')){
            provider.State__c = 'MA';   
        } 
        
        update licenseTransation;
        update provider;
        if (cntct != null) {
            update cntct;
        }
        
        recordTypeIdSet.add(EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.FCC_New_License').Id);
        recordTypeIdSet.add(EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.FCC_Renewal').Id);
        recordTypeIdSet.add(EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.Change_of_Address').Id);
        recordTypeIdSet.add(EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.FCC_License_Upgrade').Id);
        recordTypeIdSet.add(EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.FCC_Change_of_Household').Id);
        licenseTransation = [select Ownership_Type__c,Provider__r.FirstDateTakenFCCII__c,Provider__r.Ownerid, Provider__r.License_Type__c, FCC_Educator_Assistant_is_working_with__c, IsAssistantUpgradeGT6__c, Date_Taken_Intro_EEC_in_MA_orientation__c, Taken_Intro_to_EEC_in_Mass_Orientation__c, Id, name, IsProviderUpgrade__c, IsAssistantUpgradeToCertified__c, Last_Reached_Step__c, Drinking_Water_Source__c, Exits_Descriptions__c, RecordTypeId, Provider__c, Technical_Assistance__c, Caring_For_Children_Not_Related__c,
                             Evening_Overnight_Weekend_Care__c, Children_Home_Schooled__c, Children_Home_Schooled_Description__c, New_Street_Address_1__c,Previous_Street_Address_1__c,Previous_Street_Address_2__c,Previous_City__c,Previous_Zip_Code__c, Previous_City__r.Name, Previous_State__c,
                             New_Street_Address_2__c,New_Name__c, New_City__c,New_City__r.Name, New_Zip_Code__c, Live_at_New_Address__c, Moving_Date__c, Date_Care_Resumes__c, New_Address_Phone_Number__c,
                             Infant_Capacity__c,Infant_Toddler_Capacity__c,Toddler_Capacity__c,Toddler_Preschool_Capacity__c,Preschool_Capacity__c,Preschool_SA_Capacity__c,
                            Kindergarten_Capacity__c,School_Age_Capacity__c,Multi_Age_Group_Capacity__c,Total_License_Capacity_Requested__c,Minimum_Age_Limit_Requested_Years__c,
                            Minimum_Age_Limit_Requested_Months__c,Maximum_Age_Limit_Requested_Months__c,Maximum_Age_Limit_Requested_Years__c,
                                ProgramContracted__c,ProgramLicensedOrApproved__c,Provider__r.Capacity__c,
                                Transaction_Configuration__r.EEC_Licensing_Transaction_Instructions__c,
                            Work_Phone_Number__c, New_Phone_Number_Unlisted__c, Approved_Foster_Care_Provider__c, Approved_Foster_Care_Provider_Descrip__c,
                             Becoming_Foster_Care_Provider__c, Becoming_Foster_Care_Provider_Descrip__c, License_Requested__c, Business_Operated_Out_of_Own_Home__c, Abused_or_neglected_a_child__c, Abused_or_neglected_a_child_Description__c,
                             Bus_Operated_Out_of_Own_Home_Descrip__c, Alcoholic_Bev_Narcotics_Drugs_Desc__c, Use_Family_Child_Care_System__c, Use_Family_Child_Care_System_Descrip__c, Working_With_Assistant__c, Transaction_Special_Requests_Comments__c,
                             Caring_for_your_own_children_Years__c, Caring_for_your_own_children_Months__c, Caring_for_your_own_children_Hrs_Week__c,
                             Caring_for_other_peoples_children_Years__c, Caring_for_other_peoples_children_Month__c, Caring_for_other_peoples_children_Hr_Wk__c,
                             Other_Children_Kindergarten_Years__c, Other_Children_Kindergarten_Months__c, Other_Children_Kindergarten_Hrs_Week__c, Steps_for_Guiding_Child_Behavior__c, Medical_Emergency_Steps__c, Submitter__r.Name, Assigned_User_Email__c
                             from Licensing_Transaction__c where Id = :licenseTransation.Id];
        
        if (isFccAssistant) {
            PageReference pPage;
            
            if (LicenseRecordTypeName == 'FCC_Assistant_New_License' || licenseTransation.IsAssistantUpgradeToCertified__c) {
                pPage = Page.EEC_AssistantInvolvementExperience;
            } else if (LicenseRecordTypeName == 'FCC_Assistant_License_Upgrade') {
                pPage = Page.EEC_BackgroundInformation;
            } else {
                pPage = Page.EEC_Transaction_DailyRandA;
            }
            
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;
        }
        
        List<Household_Member__c> tempHMList = [select relationship_to_Provider__c, Provider__c, Occupation__c, Name, Licensing_Transactions__c, Last_Name__c, Id, Number_of_Hours_Home_During_Child_Care__c,
                                                First_Name__c, Email_Address__c, Date_of_Birth__c, Current__c, Current_School_Grade__c, CreatedDate from Household_Member__c where Licensing_Transactions__c = :licenseTransation.Id];
        PageReference pPage;
        
        if (LicenseRecordTypeName == 'FCC_New_License' || LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'Change_of_Address' ||
            LicenseRecordTypeName == 'FCC_License_Upgrade' || LicenseRecordTypeName == 'FCC_Change_of_Household') {
                
                if (tempHMList == null || tempHMList.size() == 0) {
                    List<Household_Member__c> thmList = [select Id, Licensing_Transactions__c from Household_Member__c where Provider__c = :provider.Id and
                                                         (licensing_transactions__R.Status__c != 'Cancelled (by Applicant)' and licensing_transactions__R.Status__c != 'Closed (EEC Application Incomplete / Denied)' ) and
                                                         licensing_transactions__r.RecordTypeId in :recordTypeIdSet order by Licensing_Transactions__r.CreatedDate desc];
                    if (thmList != null && thmList.size() > 0) {
                        Household_Member__c thm = thmList.get(0);
                        List<Household_Member__c> hmList = [select Relationship_to_Provider__c, Provider__c, Occupation__c, Name, Licensing_Transactions__c, Last_Name__c, Id, Number_of_Hours_Home_During_Child_Care__c,
                                                            First_Name__c, Email_Address__c, Date_of_Birth__c, Current__c, Current_School_Grade__c, CreatedDate
                                                            From Household_Member__c where Licensing_Transactions__c = :thm.Licensing_Transactions__c];
                        Household_Member__c iHm;
                        for (Household_Member__c hm : hmList) {
                            iHm = new Household_Member__c();
                            iHm.Relationship_to_Provider__c = hm.Relationship_to_Provider__c;
                            iHm.Provider__c = hm.provider__c;
                            iHm.Occupation__c = hm.Occupation__c;
                            iHm.Licensing_Transactions__c = licenseTransation.Id;
                            iHm.Last_Name__c = hm.Last_Name__c;
                            iHm.First_Name__c = hm.First_Name__c;
                            iHm.Email_Address__c = hm.Email_Address__c;
                            iHm.Date_of_Birth__c = hm.Date_of_Birth__c;
                            iHm.Current__c = hm.Current__c;
                            iHm.Current_School_Grade__c = hm.Current_School_Grade__c;
                            iHm.Number_of_Hours_Home_During_Child_Care__c = hm.Number_of_Hours_Home_During_Child_Care__c;
                            ihmList.add(iHm);
                        }
                        insert ihmList;
                    }
                }
                else {
                    ihmList = tempHMList;
                }
                ihmListJson = JSON.serialize(ihmList);
                pPage = Page.EEC_HouseholdMembers;
          }
            //For GSA and R&P, redirect it to Ownership / Administrator Info page
         else if((LicenseRecordTypeName == 'GSA_New_License'
            || LicenseRecordTypeName =='GSA_Move'
            || LicenseRecordTypeName =='GSA_Renewal'
            ||  LicenseRecordTypeName =='GSA_Change_of_Admin_Authority')
             || (LicenseRecordTypeName == 'Placement_New_License'
             || LicenseRecordTypeName == 'Placement_Renewal'
             || LicenseRecordTypeName == 'Placement_Move'
            || LicenseRecordTypeName == 'R_P_Change_of_Admin_Authority') 
            || (LicenseRecordTypeName == 'Residential_New_License'
                || LicenseRecordTypeName == 'Residential_License_Renewal'
                || LicenseRecordTypeName == 'Residential_Move')){
            pPage = Page.EEC_OwnershipAdministratorInfo;
         }
         else if(LicenseRecordTypeName =='GSA_License_Change'){
            pPage = Page.EEC_CapacityInformation;
         }
         else if(LicenseRecordTypeName == 'Residential_Change_in_License'){
            pPage = Page.EEC_ResidentialProgramDetail;
         }
         else if(LicenseRecordTypeName == 'Placement_Change_in_License'){
            pPage = Page.EEC_PlacementAgency;
         }
         else if(LicenseRecordTypeName == 'Variance_On_Regulation_Request'){
            pPage = Page.EEC_TechnicalAssistance;
         }
         else {
            if (!initIndoor) {
                initializeIndoor();
            }
            pPage = Page.EEC_IndoorSpacePage;            
        }
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage, false);
        pPage.setRedirect(true);
        return pPage;
    }
    
    public Pagereference saveAndPreviousTransactionProvider() {        
        if (isFccAssistant) {
            licenseTransation.Last_Reached_Step__c = 'Instructions';
        } else if (LicenseRecordTypeName == 'FCC_New_License' || LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'Change_of_Address' ||
                   LicenseRecordTypeName == 'FCC_License_Upgrade' || LicenseRecordTypeName == 'FCC_Change_of_Household') {
                       licenseTransation.Last_Reached_Step__c = 'Household Members';
                   }else if((LicenseRecordTypeName == 'GSA_New_License' 
            || LicenseRecordTypeName =='GSA_License_Change' 
            || LicenseRecordTypeName =='GSA_Move'
            || LicenseRecordTypeName =='GSA_Renewal'
            ||  LicenseRecordTypeName =='GSA_Change_of_Admin_Authority')
             || (LicenseRecordTypeName == 'Placement_New_License'
             || LicenseRecordTypeName == 'Placement_Renewal'
             || LicenseRecordTypeName == 'Placement_Move'
            || LicenseRecordTypeName == 'R_P_Change_of_Admin_Authority') 
            || (LicenseRecordTypeName == 'Residential_New_License'
                || LicenseRecordTypeName == 'Residential_License_Renewal'
                || LicenseRecordTypeName == 'Residential_Move'
                ||LicenseRecordTypeName == 'Residential_Change_in_License'||LicenseRecordTypeName == 'Placement_Change_in_License')){
                                licenseTransation.Last_Reached_Step__c = 'Transaction / Provider Information';
                                provider.Electronic_Communication__c = true;
                    }
                   
        update licenseTransation;
        update provider;
        if (cntct != null) {
            update cntct;
        }
        PageReference pPage;
        if(string.IsNotBlank(previousPageName)){
            if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
            }
            else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
            }
            else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                    || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                pPage = EEC_Util.lastRPStepMap.get(previousPageName);
            }
        }
        else{
            pPage = Page.EEC_TransactionInstructions;
        }
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage, false);
        pPage.setRedirect(true);
        return pPage;
    }
    
    public Pagereference saveAndReturnTransactionProvider() {
        if (LicenseRecordTypeName == 'FCC_New_License' || LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'Change_of_Address' ||
            LicenseRecordTypeName == 'FCC_License_Upgrade' || LicenseRecordTypeName == 'FCC_Change_of_Household') {
                licenseTransation.Last_Reached_Step__c = 'Household Members';
            }else if((LicenseRecordTypeName == 'GSA_New_License' 
            || LicenseRecordTypeName =='GSA_License_Change' 
            || LicenseRecordTypeName =='GSA_Move'
            || LicenseRecordTypeName =='GSA_Renewal'
            ||  LicenseRecordTypeName =='GSA_Change_of_Admin_Authority')
             || (LicenseRecordTypeName == 'Placement_New_License'
             || LicenseRecordTypeName == 'Placement_Renewal'
             || LicenseRecordTypeName == 'Placement_Move'
            || LicenseRecordTypeName == 'R_P_Change_of_Admin_Authority') 
            || (LicenseRecordTypeName == 'Residential_New_License'
                || LicenseRecordTypeName == 'Residential_License_Renewal'
                || LicenseRecordTypeName == 'Residential_Move')){
                                licenseTransation.Last_Reached_Step__c = 'Transaction / Provider Information';
                                provider.Electronic_Communication__c = true;
                    }
        else {
            licenseTransation.Last_Reached_Step__c = 'Indoor / Outdoor space information';
        }
        update licenseTransation;
        update provider;
        if (cntct != null) {
            update cntct;
        }
        if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
                PageReference pPage = page.EEC_PortalProviderPage;
                addMemberIDPageParameter(pPage, true);
                return pPage;                       
        }
        else{
            return new PageReference('javascript:window.close()');
        }
    }
    
    public void AddRow()
    {
        ihmList.add(new Household_Member__c());
    }
    
    public void delRow()
    {
        rowNum = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        Household_Member__c tHM = ihmList.get(rowNum);
        if (String.isNotBlank(tHM.Id)) {
            removeHMList.add(ihmList.get(rowNum));
        }
        ihmList.remove(rowNum);
    }
    
    public void AddRowLS() {
        
    }
    
    public void delRowLS() {
    }
    
    public void AddRowEH()
    {
        if (ehList == null) {
            ehList = new List<Employment_History__c> ();
        }
        ehList.add(new Employment_History__c());
    }
    
    public void delRowEH()
    {
        if (removeEHList == null) {
            removeEHList = new List<Employment_History__c> ();
        }
        rowNum = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        Employment_History__c tEH = ehList.get(rowNum);
        if (String.isNotBlank(tEH.Id)) {
            removeEHList.add(ehList.get(rowNum));
        }
        ehList.remove(rowNum);
    }
    
    public void delRowRoom()
    {
        if (removeRoomList == null) {
            removeRoomList = new List<Room__c> ();
        }
        rowNum = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        Room__c rm = roomList.get(rowNum);
        if (String.isNotBlank(rm.Id)) {
            removeRoomList.add(roomList.get(rowNum));
        }
        roomList.remove(rowNum);
    }
    
    public void AddRowRoom()
    {
        if (roomList == null) {
            roomList = new List<Room__c> ();
        }
        roomList.add(new Room__c());
    }
    
    public void delRowTE()
    {
        if (removeTEList == null) {
            removeTEList = new List<Training_Experience__c> ();
        }
        rowNum = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        Training_Experience__c rm = teList.get(rowNum);
        if (String.isNotBlank(rm.Id)) {
            removeTEList.add(teList.get(rowNum));
        }
        teList.remove(rowNum);
    }
    
    public void AddRowTE()
    {
        if (teList == null) {
            teList = new List<Training_Experience__c> ();
        }
        teList.add(new Training_Experience__c());
    }
    
    public Pagereference CancelTransaction() {
        system.debug('1');
        Licensing_Transaction__c lt = new Licensing_Transaction__c(id = licenseTransation.id);
        
        if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
            system.debug('2');
            lt.Status__c = 'Cancelled (by Applicant)';
            lt.Reason_Closed_Cancelled__c = 'Cancelled by portal user';         
            update lt;
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage, true);
            return pPage;
        }
        else{
            system.debug('3');
            lt.Status__c = 'Cancelled (by EEC User)';
            lt.Reason_Closed_Cancelled__c = 'Cancelled by EEC user';
            update lt;
            system.debug('4');
            return new PageReference('javascript:window.close();');
        }
    }
    
    public Pagereference SaveAndNextHH() {
        try {
            saveHH();
            initHH = true;
            if (LicenseRecordTypeName == 'FCC_New_License' || LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'FCC_License_Upgrade') {
                rowNum = 0;
                licenseTransation.Last_Reached_Step__c = 'License Status and Capacity';
                update licenseTransation;
                if (!initLS) {
                    initializeLS();
                }
                PageReference pPage = Page.EEC_LicenseStatusCapacityInfo;
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage, false);
                pPage.setRedirect(true);
                return pPage;
            }
            else if (LicenseRecordTypeName == 'Change_of_Address') {
                licenseTransation.Last_Reached_Step__c = 'Indoor / Outdoor space information';
                update licenseTransation;
                if (!initIndoor) {
                    initializeIndoor();
                }
                PageReference pPage = Page.EEC_IndoorSpacePage;
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage, false);
                pPage.setRedirect(true);
                return pPage;
            }
            else if (LicenseRecordTypeName == 'FCC_Change_of_Household') {
                licenseTransation.Last_Reached_Step__c = 'Daily Routine Activities / Technical Assistance';
                update licenseTransation;
                
                PageReference pPage = Page.EEC_TechnicalAssistance;
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage, false);
                pPage.setRedirect(true);
                return pPage;
            }
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage, true);
            return pPage;
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndPreviousHH() {
        try {
            saveHH();
            licenseTransation.Last_Reached_Step__c = 'Household Members';
            update licenseTransation;
            
            PageReference pPage;
            if(string.IsNotBlank(previousPageName)){
                if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                    pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                    pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                        || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                    pPage = EEC_Util.lastRPStepMap.get(previousPageName);
                }
            }
            else{
                pPage = Page.EEC_TransactionProvider;
            }
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndReturnHH() {
        try {
            saveHH();
            licenseTransation.Last_Reached_Step__c = 'Household Members';
            update licenseTransation;
            if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
                PageReference pPage = page.EEC_PortalProviderPage;
                addMemberIDPageParameter(pPage, true);
                return pPage;                       
            }
            else{
                return new PageReference('javascript:window.close()');
            }
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    private void saveHH() {
        if (ihmList != null && ihmList.size() > 0) {
            for (Household_Member__c thm : ihmList) {
                if (thm.Id == null) {
                    thm.Current__c = false;
                    thm.Provider__c = provider.Id;
                    thm.Licensing_Transactions__c = licenseTransation.Id;
                }
            }
            upsert ihmList;
            ihmListJson = JSON.serialize(ihmList);
        }
        
        if (removeHMList != null && removeHMList.size() > 0) {
            delete removeHMList;
        }
    }
    
    public Pagereference SaveAndNextTA() {
        try {
            PageReference pPage;
            
            if (isFccAssistant) {
                licenseTransation.Last_Reached_Step__c = 'Background Information';
                pPage = Page.EEC_BackgroundInformation;
             } 
             else {
                if (LicenseRecordTypeName == 'FCC_New_License' || LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'FCC_License_Upgrade' || LicenseRecordTypeName == 'Variance_On_Regulation_Request') {
                    licenseTransation.Last_Reached_Step__c = 'Attachments';
                    if (!initLS) {
                        initializeLS();
                    }
                    refreshAttachmentsList();
                    
                    pPage = Page.EEC_LicenseTransactionAttachments;
                 }
                else if (LicenseRecordTypeName == 'Change_of_Address' || LicenseRecordTypeName == 'FCC_Change_of_Household' || LicenseRecordTypeName == 'FCC_Change_Room_Floor_Level') {
                    licenseTransation.Last_Reached_Step__c = 'Review Summary and Submission';
                    pPage = Page.EEC_ReviewSummarySubmission;
                }
            }
            
            //GSA - Added by LD - >>> - LEAD-3830
            if((LicenseRecordTypeName == 'GSA_New_License' 
                || LicenseRecordTypeName =='GSA_License_Change' 
                || LicenseRecordTypeName =='GSA_Move'
                || LicenseRecordTypeName =='GSA_Renewal'
                || LicenseRecordTypeName =='GSA_Change_of_Admin_Authority'
                )){ 
                    licenseTransation.Last_Reached_Step__c = 'Attachments';
                    if (!initLS) {
                       initializeLS();
                    }                        
                    pPage = Page.EEC_LicensingAttachment;
             }
             //R&P - Added by LD - >>> - LEAD-3830
             if((LicenseRecordTypeName == 'Placement_New_License'
                 || LicenseRecordTypeName == 'Placement_Renewal'
                 || LicenseRecordTypeName == 'Placement_Move'
                 || LicenseRecordTypeName == 'Placement_Change_in_License') 
                 || (LicenseRecordTypeName == 'Residential_New_License'
                    || LicenseRecordTypeName == 'Residential_License_Renewal'
                    || LicenseRecordTypeName == 'Residential_Change_in_License'
                    || LicenseRecordTypeName == 'Residential_Move'
                    || LicenseRecordTypeName == 'R_P_Change_of_Admin_Authority')){
                    licenseTransation.Last_Reached_Step__c = 'Attachments';
                    if (!initLS) {
                       initializeLS();
                    }
                        
                    pPage = Page.EEC_LicensingAttachment;
              }
              
               //Variances to Update - LEAD-3830
           if(LicenseRecordTypeName.contains('Placement') || LicenseRecordTypeName.contains('Residential') || LicenseRecordTypeName.contains('GSA') 
            || LicenseRecordTypeName == 'FCC_New_License'
            || LicenseRecordTypeName == 'FCC_Renewal'
            || LicenseRecordTypeName == 'FCC_License_Upgrade'
            || LicenseRecordTypeName == 'Change_of_Address'
            || LicenseRecordTypeName == 'FCC_Change_Room_Floor_Level'
            || LicenseRecordTypeName == 'Variance_On_Regulation_Request'
            ){
                 List<Variance_on_Regulation__c> variancesToUpsert = new List<Variance_on_Regulation__c> ();

                    if (varianceInfoWrappers != null && varianceInfoWrappers.size() > 0) {
                      for (EEC_VarianceListCtrl.VarianceInfoWrap wrapper : varianceInfoWrappers) {
                        variancesToUpsert.add(wrapper.varianceReg);
                      }
                      upsert variancesToUpsert;
                    }
            }
            update licenseTransation;
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
            system.debug(e.getMessage());
        }
        return null;
    }
    
    public Pagereference SaveAndPreviousTA() {
        try {
            PageReference pPage;
            if(string.IsNotBlank(previousPageName)){
                if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                    pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                    pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                        || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                    pPage = EEC_Util.lastRPStepMap.get(previousPageName);
                }
                
                if (isFccAssistant) {
                    licenseTransation.Last_Reached_Step__c = 'Daily Routine Activities / Technical Assistance';
                }               
                if (LicenseRecordTypeName == 'FCC_Change_of_Household') {
                    licenseTransation.Last_Reached_Step__c = 'Daily Routine Activities / Technical Assistance';
                }
                else if (LicenseRecordTypeName.contains('GSA') == false && LicenseRecordTypeName.contains('Residential') == false && LicenseRecordTypeName.contains('Placement') == false){
                    licenseTransation.Last_Reached_Step__c = 'Daily Routine Activities / Technical Assistance';
                }            
                if((LicenseRecordTypeName == 'GSA_New_License' 
                    || LicenseRecordTypeName =='GSA_License_Change' 
                    || LicenseRecordTypeName =='GSA_Move'
                    || LicenseRecordTypeName =='GSA_Renewal')
                     ){
                   licenseTransation.Last_Reached_Step__c = 'Technical Assistance Info';
                }
                else if(licenseRecordTypeName == 'GSA_Change_of_Admin_Authority'){
                   licenseTransation.Last_Reached_Step__c = 'Technical Assistance Info';
                }
                if((LicenseRecordTypeName == 'Placement_New_License'
                     || LicenseRecordTypeName == 'Placement_Renewal'
                     || LicenseRecordTypeName == 'Placement_Move'
                     || LicenseRecordTypeName == 'R_P_Change_of_Admin_Authority') 
                     || (LicenseRecordTypeName == 'Residential_New_License'
                     || LicenseRecordTypeName == 'Residential_Move')){                
                        licenseTransation.Last_Reached_Step__c = 'Technical Assistance Info';
                }
                if(LicenseRecordTypeName == 'Residential_Change_in_License' || LicenseRecordTypeName == 'Residential_License_Renewal' || LicenseRecordTypeName == 'Residential_New_License'){
                    licenseTransation.Last_Reached_Step__c = 'Technical Assistance Info';
                }
            }
            else{            
                if (isFccAssistant) {
                    pPage = Page.EEC_AssistantInvolvementExperience;
                    licenseTransation.Last_Reached_Step__c = 'Daily Routine Activities / Technical Assistance';
                }               
                if (LicenseRecordTypeName == 'FCC_Change_of_Household') {
                    pPage = Page.EEC_HouseholdMembers;
                    licenseTransation.Last_Reached_Step__c = 'Daily Routine Activities / Technical Assistance';
                }
                else if (LicenseRecordTypeName.contains('GSA') == false && LicenseRecordTypeName.contains('Residential') == false && LicenseRecordTypeName.contains('Placement') == false){
                    pPage = Page.EEC_IndoorSpacePage;
                    licenseTransation.Last_Reached_Step__c = 'Daily Routine Activities / Technical Assistance';
                }            
                //GSA -- Added by LD --->>>--- LEAD-3830 
                if((LicenseRecordTypeName == 'GSA_New_License' 
                    || LicenseRecordTypeName =='GSA_License_Change' 
                    || LicenseRecordTypeName =='GSA_Move'
                    || LicenseRecordTypeName =='GSA_Renewal')
                     ){
                       licenseTransation.Last_Reached_Step__c = 'Technical Assistance Info';
                       pPage = Page.EEC_IndoorSpacePage;
                }
                else if(licenseRecordTypeName == 'GSA_Change_of_Admin_Authority'){
                    licenseTransation.Last_Reached_Step__c = 'Technical Assistance Info';
                    pPage = Page.EEC_DesignationOfAdministrative;
                }
                //R&P -- Added by LD --->>>--- LEAD-3830 
                if((LicenseRecordTypeName == 'Placement_New_License'
                     || LicenseRecordTypeName == 'Placement_Renewal'
                     || LicenseRecordTypeName == 'Placement_Move'
                    || LicenseRecordTypeName == 'R_P_Change_of_Admin_Authority') 
                    || (LicenseRecordTypeName == 'Residential_New_License'
                        
                        || LicenseRecordTypeName == 'Residential_Move')){                
                        licenseTransation.Last_Reached_Step__c = 'Technical Assistance Info';
                        pPage = Page.EEC_IndoorSpacePage;                
                }
                if(LicenseRecordTypeName == 'Residential_Change_in_License' || LicenseRecordTypeName == 'Residential_License_Renewal' || LicenseRecordTypeName == 'Residential_New_License'){
                    licenseTransation.Last_Reached_Step__c = 'Technical Assistance Info';
                    pPage = Page.EEC_ResidentialProgramDetail;  
                }
                
                 if(LicenseRecordTypeName == 'Placement_New_License' || LicenseRecordTypeName == 'Placement_Renewal' || LicenseRecordTypeName == 'Placement_Move' || LicenseRecordTypeName == 'Placement_Change_in_License'){
                    licenseTransation.Last_Reached_Step__c = 'Technical Assistance Info';
                    pPage = Page.EEC_PlacementAgency;  
                } 
                if(licenseRecordTypeName == 'Variance_On_Regulation_Request'){
                    licenseTransation.Last_Reached_Step__c = 'Technical Assistance Info';
                    pPage = Page.EEC_TransactionProvider;
                }
            }
            //Variances to Update - LEAD-3830
            if(LicenseRecordTypeName.contains('Placement') || LicenseRecordTypeName.contains('Residential') || LicenseRecordTypeName.contains('GSA') 
                || LicenseRecordTypeName == 'FCC_New_License'
                || LicenseRecordTypeName == 'FCC_Renewal'
                || LicenseRecordTypeName == 'FCC_License_Upgrade'
                || LicenseRecordTypeName == 'Change_of_Address'
                || LicenseRecordTypeName == 'FCC_Change_Room_Floor_Level'
                || LicenseRecordTypeName == 'Variance_On_Regulation_Request'
            ){
                 List<Variance_on_Regulation__c> variancesToUpsert = new List<Variance_on_Regulation__c> ();

                    if (varianceInfoWrappers != null && varianceInfoWrappers.size() > 0) {
                      for (EEC_VarianceListCtrl.VarianceInfoWrap wrapper : varianceInfoWrappers) {
                        variancesToUpsert.add(wrapper.varianceReg);
                      }
                      upsert variancesToUpsert;
                    }
            }            
            update licenseTransation;
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;            
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
   public Pagereference SaveAndReturnTA() {
        try {
                if (LicenseRecordTypeName.contains('FCC')){
               licenseTransation.Last_Reached_Step__c = 'Daily Routine Activities / Technical Assistance';
                }
                else{
                        licenseTransation.Last_Reached_Step__c = 'Technical Assistance Info';
                }
            //Variances to Update - LEAD-3830
            if(LicenseRecordTypeName.contains('Placement') || LicenseRecordTypeName.contains('Residential') || LicenseRecordTypeName.contains('GSA') 
                || LicenseRecordTypeName == 'FCC_New_License'
                || LicenseRecordTypeName == 'FCC_Renewal'
                || LicenseRecordTypeName == 'FCC_License_Upgrade'
                || LicenseRecordTypeName == 'Change_of_Address'
                || LicenseRecordTypeName == 'FCC_Change_Room_Floor_Level'
                || LicenseRecordTypeName == 'Variance_On_Regulation_Request'
            ){
                 List<Variance_on_Regulation__c> variancesToUpsert = new List<Variance_on_Regulation__c> ();
                    if (varianceInfoWrappers != null && varianceInfoWrappers.size() > 0) {
                      for (EEC_VarianceListCtrl.VarianceInfoWrap wrapper : varianceInfoWrappers) {
                        variancesToUpsert.add(wrapper.varianceReg);
                      }
                      upsert variancesToUpsert;
                    }
            }
            update licenseTransation;
            if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
                PageReference pPage = page.EEC_PortalProviderPage;
                addMemberIDPageParameter(pPage, true);
                return pPage;                       
            }
            else{
                return new PageReference('javascript:window.close()');
            }
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndNextLS() {
        try {
            if (LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'FCC_License_Upgrade') {
                licenseTransation.Last_Reached_Step__c = 'Background Information';
                update licenseTransation;
                
                PageReference pPage = Page.EEC_BackgroundInformation;
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage, false);
                pPage.setRedirect(true);
                return pPage;
            } else {
                licenseTransation.Last_Reached_Step__c = 'EEC Involvement Experience & Professional Exp.';
                update licenseTransation;
                PageReference pPage = Page.EEC_InvolvementExperience;
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage, false);
                pPage.setRedirect(true);
                return pPage;
            }
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndPreviousLS() {
        try {
            licenseTransation.Last_Reached_Step__c = 'License Status and Capacity';
            update licenseTransation;
            PageReference pPage;
            if(string.IsNotBlank(previousPageName)){
                if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                    pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                    pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                        || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                    pPage = EEC_Util.lastRPStepMap.get(previousPageName);
                }
            }
            else{
                pPage = Page.EEC_HouseholdMembers;
            }
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndReturnLS() {
        try {
            licenseTransation.Last_Reached_Step__c = 'License Status and Capacity';
            update licenseTransation;
            if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
                PageReference pPage = page.EEC_PortalProviderPage;
                addMemberIDPageParameter(pPage, true);
                return pPage;
            }
            else{
                return new PageReference('javascript:window.close()');
            }    
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference showLSDesc() {
        return null;
    }
    
    public Pagereference setLicensedAgency() {
        if(programLicensedAgency=='Yes'){
            licenseTransation.Program_licensed_or_approved_by_agency__c = true;
        }else{
            licenseTransation.Program_licensed_or_approved_by_agency__c = false;
        }
        if(programContacted=='Yes'){
            licenseTransation.Is_your_program_contracted__c = true;
        }else{
            licenseTransation.Is_your_program_contracted__c = false;
        }
        
        return null;
    }
    
    public Pagereference showAddAssistanceDesc() {
        return null;
    }
    
    public Pagereference showCBDesc() {
        selectedHestStr = '';
        if (selectedHestElems != null) {
            for (String tstr : selectedHestElems) {
                selectedHestStr = selectedHestStr + tStr + ',';
            }
        }
        else {
            selectedHestElems = new List<String> ();
        }
        // Re-map the mappings to remove the attachment.
        generateAttachmentMappings();
        refreshAttachmentsList();
        return null;
    }
    
    public PageReference showWaterUpload() {
        if (String.isBlank(selectedWaterStr)) {
            selectedWaterStr = '';
        } else {
            selectedWaterStr = selectedWaterStr.equalsIgnoreCase('Town Water Supply') ? 'Private Water Supply' : 'Town Water Supply';
        }
        // Re-map the mappings to remove the attachment.
        generateAttachmentMappings();
        refreshAttachmentsList();
        return null;
    }
    
    public Pagereference SaveAndNextEH() {
        try {
            PageReference pPage;
            if (isFccAssistant && LicenseRecordTypeName != 'FCC_Assistant_License_Upgrade') {
                licenseTransation.Last_Reached_Step__c = 'Daily Routine and Activities';
                pPage = Page.EEC_Transaction_DailyRandA;
            } else {
                licenseTransation.Last_Reached_Step__c = 'Background Information';
                pPage = Page.EEC_BackgroundInformation;
            }
            update licenseTransation;
            saveEH();
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;
        } catch(Exception e) {
            system.debug('error: ' + e.getMessage());
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndPreviousEH() {
        try {
            licenseTransation.Last_Reached_Step__c = 'EEC Involvement Experience & Professional Exp.';
            update licenseTransation;
            saveEH();
            
            PageReference pPage;
            if(string.IsNotBlank(previousPageName)){
                if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                    pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                    pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                        || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                    pPage = EEC_Util.lastRPStepMap.get(previousPageName);
                }
            }
            else{
                if (isFccAssistant) {
                    pPage = Page.EEC_TransactionProvider;
                } else {
                    pPage = Page.EEC_Transaction_AssistantInfo;
                }
            }
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndReturnEH() {
        try {
            licenseTransation.Last_Reached_Step__c = 'EEC Involvement Experience & Professional Exp.';
            update licenseTransation;
            saveEH();
            if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
                PageReference pPage = page.EEC_PortalProviderPage;
                addMemberIDPageParameter(pPage, true);
                return pPage;                       
            }
            else{
                return new PageReference('javascript:window.close()');
            }
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndNextBI() {
        try {
            licenseTransation.Last_Reached_Step__c = 'Training Information';
            update licenseTransation;
            if (!initTraining) {
                initializeTraining();
            }
            generateAttachmentMappings();
            retrieveAddtionalTrainingAttachmentsList();
            
            PageReference pPage = Page.EEC_TrainingInformation;
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndPreviousBI() {
        try {
            licenseTransation.Last_Reached_Step__c = 'Background Information';
            update licenseTransation;
            PageReference pPage;
            if(string.IsNotBlank(previousPageName)){
                if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                    pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                    pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                        || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                    pPage = EEC_Util.lastRPStepMap.get(previousPageName);
                }
            }
            else{
                pPage = determineBIPreviousPage();
            }
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    private PageReference determineBIPreviousPage() {
        if (isFccAssistant) {
            if (LicenseRecordTypeName != 'FCC_Assistant_License_Upgrade') {
                return Page.EEC_Transaction_DailyRandA;
            }
            
            if (!licenseTransation.IsAssistantUpgradeToCertified__c) {
                return Page.EEC_TransactionProvider;
            }
            
            return Page.EEC_AssistantInvolvementExperience;
        }
        
        if (LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'FCC_License_Upgrade') {
            return Page.EEC_Transaction_AssistantInfo;
        } else {
            return Page.EEC_InvolvementExperience;
        }
    }
    
    public Pagereference SaveAndReturnBI() {
        try {
             licenseTransation.Last_Reached_Step__c = 'Background Information';
            update licenseTransation;
            if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){             
                PageReference pPage = page.EEC_PortalProviderPage;
                addMemberIDPageParameter(pPage, true);
                return pPage;
            }
            else{
                return new PageReference('javascript:window.close()');
            }
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndNextRoom() {
        licenseTransation.Last_Reached_Step__c = 'Daily Routine Activities / Technical Assistance';
        saveRoom();
        
        PageReference pPage = Page.EEC_TechnicalAssistance;
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage, false);
        pPage.setRedirect(true);
        return pPage;
    }
    
    public Pagereference SaveAndPreviousRoom() {
        try {
            licenseTransation.Last_Reached_Step__c = 'Indoor / Outdoor space information';
            saveRoom();
            PageReference pPage;
            if(string.IsNotBlank(previousPageName)){
                if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                    pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                    pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                        || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                    pPage = EEC_Util.lastRPStepMap.get(previousPageName);
                }
            }
            else{
                if (LicenseRecordTypeName == 'FCC_Change_Room_Floor_Level') {
                    pPage = Page.EEC_TransactionProvider;
                }
                else if (LicenseRecordTypeName == 'FCC_New_License' || LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'FCC_License_Upgrade') {
                    generateAttachmentMappings();
                    retrieveAddtionalTrainingAttachmentsList();                 
                    pPage = Page.EEC_TrainingInformation;
                }
                else {
                    pPage = Page.EEC_HouseholdMembers;                  
                }
            }
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndReturnRoom() {
        try {
            licenseTransation.Last_Reached_Step__c = 'Indoor / Outdoor space information';
            saveRoom();
            if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
                PageReference pPage = page.EEC_PortalProviderPage;
                addMemberIDPageParameter(pPage, true);
                return pPage;                       
            }
            else{
                return new PageReference('javascript:window.close()');
            }
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndNextTE() {
        try {
            PageReference pPage;
            
            if (isFccAssistant) {
                licenseTransation.Last_Reached_Step__c = 'Assistant Review Summary and Submission';
                pPage = Page.EEC_ReviewSummarySubmissionAssistant;
            } else {
                licenseTransation.Last_Reached_Step__c = 'Indoor / Outdoor space information';
                pPage = Page.EEC_IndoorSpacePage;
            }
            saveTE();
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndPreviousTE() {
        try {
            licenseTransation.Last_Reached_Step__c = 'Training Information';
            saveTE();
            PageReference pPage;
            if(string.IsNotBlank(previousPageName)){
                if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                    pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                    pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                        || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                    pPage = EEC_Util.lastRPStepMap.get(previousPageName);
                }
            }
            else{
                pPage = Page.EEC_BackgroundInformation;
            }
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndReturnTE() {
        try {
            licenseTransation.Last_Reached_Step__c = 'Training Information';
            saveTE();
            if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
                PageReference pPage = page.EEC_PortalProviderPage;
                addMemberIDPageParameter(pPage, true);
                pPage.setRedirect(true);
                return pPage;
            }
            else{
                return new PageReference('javascript:window.close()');
            }
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public PageReference SaveAndNextAttachment() {
        try {
            licenseTransation.Last_Reached_Step__c = 'Attachments';
            
            licenseTransation = EEC_ContactRoleUtil.updateLicensingTransaction(licenseTransation);
            try{
                refreshAttachmentsList();
                if(renderAttachLib){
                        addDocument();
                }
            }catch(Exception e){
                system.debug(e);
            }
            if(LicenseRecordTypeLabel == 'Placement_New_License' || 
             LicenseRecordTypeLabel == 'Residential_New_License' || 
             LicenseRecordTypeLabel == 'Placement_Renewal' ||
             LicenseRecordTypeLabel == 'Residential_License_Renewal' ||
             LicenseRecordTypeLabel == 'Placement_Change_in_License' ||
             LicenseRecordTypeLabel == 'Residential_Change_in_License' ||
             LicenseRecordTypeLabel == 'Placement_Move' ||
             LicenseRecordTypeLabel == 'Residential_Move' ||
             LicenseRecordTypeLabel == 'R_P_Change_of_Admin_Authority'){
             PageReference pPage = Page.EEC_RP_ReviewSummary;
             pPage.getParameters().put('ltId', licenseTransation.Id);
             addMemberIDPageParameter(pPage, false);
             pPage.setRedirect(true);
             return pPage;
            }else if(LicenseRecordTypeLabel == 'GSA_New_License' || 
             LicenseRecordTypeLabel == 'GSA_Renewal' || 
             LicenseRecordTypeLabel == 'GSA_License_Change' ||
             LicenseRecordTypeLabel == 'GSA_Move' ||
             LicenseRecordTypeLabel == 'GSA_Change_of_Admin_Authority' ){
             PageReference pPage = Page.EEC_GSAReviewSummary;
             pPage.getParameters().put('ltId', licenseTransation.Id);
             addMemberIDPageParameter(pPage, false);
             pPage.setRedirect(true);
             return pPage;
            }else{
            PageReference pPage = Page.EEC_ReviewSummarySubmission;
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;
             }
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public PageReference SaveAndPreviousAttachment() {
        try {
            licenseTransation.Last_Reached_Step__c = 'Attachments';
           
            licenseTransation = EEC_ContactRoleUtil.updateLicensingTransaction(licenseTransation);
            try{
                refreshAttachmentsList();
                if(renderAttachLib){
                        addDocument();
                }
            }catch(Exception e){
                system.debug(e);
            }
            PageReference pPage;
            if(string.IsNotBlank(previousPageName)){
                if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                    pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                    pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                        || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                    pPage = EEC_Util.lastRPStepMap.get(previousPageName);
                }
            }
            else{
                pPage = Page.EEC_TechnicalAssistance;
            }
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public PageReference SaveAndReturnAttachment() {
        try {
            licenseTransation.Last_Reached_Step__c = 'Attachments';
            licenseTransation = EEC_ContactRoleUtil.updateLicensingTransaction(licenseTransation);
            try{
                refreshAttachmentsList();
                if(renderAttachLib){
                        addDocument();
                }
            }catch(Exception e){
                system.debug(e);
            }
            if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
                PageReference pPage = page.EEC_PortalProviderPage;
                addMemberIDPageParameter(pPage, true);
                pPage.setRedirect(true);
                return pPage;                       
            }
            else{
                return new PageReference('javascript:window.close()');
            }
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference previousRS() {
        try {
            // Update the last step.
            licenseTransation.Last_Reached_Step__c = 'Review Summary and Submission';
            update licenseTransation;
            
            PageReference pPage;
            if(string.IsNotBlank(previousPageName)){
                if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                    pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
                    system.debug('previousPageName: ' + previousPageName);
                }
                else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                    pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                        || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                    pPage = EEC_Util.lastRPStepMap.get(previousPageName);
                }
            }
            else{
                if (isFccAssistant) {
                    pPage = Page.EEC_TrainingInformation;
                }               
                // If New, Renewal, or Upgrade then back to attachments. Else go to TA.  
                if (LicenseRecordTypeName == 'FCC_New_License' || LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'FCC_License_Upgrade' || LicenseRecordTypeName == 'Variance_On_Regulation_Request') {
                    refreshAttachmentsList();                   
                    pPage = Page.EEC_LicenseTransactionAttachments;
                }
                else{
                    pPage = Page.EEC_TechnicalAssistance;
                }
            }
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    public Pagereference submitRS() {


        if(checkMandatoryDocuments())
        {
            if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                                UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){

                System.debug('Entered If');
                licenseTransation.Submitter__c = Userinfo.getUserId();
                licenseTransation.Status__c = 'Submitted';
                licenseTransation.Submission_Date__c = Date.today();
                licenseTransation.Source__c = 'Provider Portal';
                update licenseTransation;
                createAndInsertAttachment(licenseTransation.id);
                // PageReference pPage = page.EEC_PortalProviderPage;
                // addMemberIDPageParameter(pPage, true);
                // pPage.setRedirect(true);
                // return pPage;
                return null;
            }
            else{
                System.debug('Entered Else');
                return null;    
            }
        }
        else{
            System.debug('Entered Other Else');
            return null;
        }

    }

    public PageReference returnToProvider()
    {
        PageReference pPage = page.EEC_PortalProviderPage;
        addMemberIDPageParameter(pPage, true);
        pPage.setRedirect(true);
        return pPage;
    }

    
    private boolean checkMandatoryDocuments()
    {
        List<Transaction_Document__c> listTransactionDocument = [SELECT ID, Document__c, Document__r.Document_Name__c                                                                    
                                                                FROM Transaction_Document__c
                                                                WHERE 
                                                                Licensing_Transaction__c = :licenseTransation.id
                                                                AND Document_Type__r.Submit_Transaction_Only_If_Uploaded__c = true
                                                                AND Document__r.Attachment_Status__c = 'No Attachment'
                                                                ];
        
        System.debug('listTransactionDocument: ' + listTransactionDocument);
        if(listTransactionDocument.size() >0)
        {
            String errMsg='';
            for(Transaction_Document__c transactionDocument : listTransactionDocument)
            {
                System.debug('transactionDocument.Document__r.Document_Name__c: ' + transactionDocument.Document__r.Document_Name__c);
                errMsg = errMsg + ', ' + transactionDocument.Document__r.Document_Name__c;
            }
            System.debug('errMsg: ' + errMsg);
            if(errMsg.length()>0)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'The following mandatory document(s) have not been uploaded:' + errMsg.removeStart(', ') + '. Please, go back to the Attachment section and upload these document.'));
                return false;
            }
        }

        return true;

    }

    @future(callout=true)
    public static void createAndInsertAttachment(Id Ltid) {
        string username = userinfo.getname();
        string Cdate = system.today().format();
        PageReference pagePdf = new PageReference('/apex/EEC_TransactionSubmissionPDF');
        pagePdf.getParameters().put('Id', Ltid);
        list<Licensing_Transaction__c> lt = new list<Licensing_Transaction__c>([select id,name,recordtype.name from Licensing_Transaction__c where id =: Ltid]);
        string Lttype = lt[0].recordtype.name;
        Blob pdfPageBlob;
        if(!test.isRunningTest())
            pdfPageBlob = pagePdf.getContent();
        else
            pdfPageBlob=Blob.valueOf('Unit Test');
        
        Attachment a = new Attachment();
        a.Body = pdfPageBlob;
        a.ParentID = Ltid;
        a.Name = 'Transaction Submitted'+' - '+Lttype+'-'+Cdate+'-'+username+'.pdf';
        a.Description = 'Report Submitted';
        insert a;
    }
    public Pagereference SaveAndReturnRS() {
        licenseTransation.Last_Reached_Step__c = (isFccAssistant ? 'Assistant Review Summary and Submission' : 'Review Summary and Submission');
        update licenseTransation;
        if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage, true);
            pPage.setRedirect(true);
            return pPage;                       
        }
        else{
            return new PageReference('javascript:window.close()');
        }
    }
    
    private void saveLS() {
        
    }
    
    private void saveEH() {        
        if (ehList != null) {
            for (Employment_History__c eh : ehList) {
                if (loggedUser.contactId != null) {
                    eh.Contact__c = loggedUser.contactId;
                }
                else{
                    if(listContact.size() > 0)
                        eh.Contact__c = listContact[0].Id;
                }
                if (eh.Licensing_Transaction__c == null && licenseTransation.Id != null)
                    eh.Licensing_Transaction__c = licenseTransation.Id;
            }
            upsert ehList;
        }
        
        if (removeEHList != null && removeEHList.size() > 0) {
            delete removeEHList;
        }
    }
    
    private void saveRoom() {
        String selectedHest = '';
        Boolean Start = true;
        if (!selectedHestElems.isEmpty()) {
            for (String Str : selectedHestElems) {
                if (Start) {
                    selectedHest = Str;
                    Start = false;
                } else {
                    selectedHest = selectedHest + ';' + Str;
                }
            }
        }
        licenseTransation.Heating_Elements__c = selectedHest;
        update licenseTransation;
        
        if (roomList != null) {
            for (Room__c rm : roomList) {
                rm.Current__c = false;
                if (rm.Id == null) {
                    rm.Source_Transaction__c = licenseTransation.Id;
                }
            }
            upsert roomList;
        }
        
        if (removeRoomList != null && removeRoomList.size() > 0) {
            delete removeRoomList;
        }
    }
    
    private void saveTE() {
        update licenseTransation;
        
        if (teList != null) {
            for (Training_Experience__c tfa : teList) {
                if (tfa.Id == null) {
                    if (loggedUser.contactId != null) {
                        tfa.Contact__c = loggedUser.contactId;
                    }
                    else{
                        tfa.Contact__c = cntct.Id;
                    }
                }
                tfa.Licensing_Transactions__c = licenseTransation.Id;
            }
            upsert teList;
        }
        
        if (removeTEList != null && removeTEList.size() > 0) {
            delete removeTEList;
        }
    }
    
    public Boolean getIsTransactionEditiable() {
        return(licenseTransation.Status__c == 'To Submit');
    }
    
    private Boolean isStatusClosed(String status) {
        return(status == 'Submitted' || status == 'To Submit' || status == 'Under Review' || status == 'Pending Manager Approval' || status == 'Approved By Manager');
    }
    
    private void initializeLS() {
        initLS = true;
        Set<Id> recordTypeIdSet = new Set<Id> ();
        if (LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'FCC_License_Upgrade') {
            recordTypeIdSet.add(EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.FCC_New_License').Id);
            recordTypeIdSet.add(EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.FCC_Renewal').Id);
            recordTypeIdSet.add(EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.FCC_License_Upgrade').Id);
            
            List<Licensing_Transaction__c> tltList = [select Ownership_Type__c ,Provider__r.Ownerid,Provider__r.FirstDateTakenFCCII__c, Provider__r.License_Type__c, FCC_Educator_Assistant_is_working_with__c, IsAssistantUpgradeGT6__c, Upload_Certificate_Intro_to_EEC_in_Mass__c, Date_Taken_Intro_EEC_in_MA_orientation__c, Id, Taken_Intro_to_EEC_in_Mass_Orientation__c, Caring_For_Children_Not_Related__c, Steps_for_Guiding_Child_Behavior__c, Medical_Emergency_Steps__c, Evening_Overnight_Weekend_Care__c, Children_Home_Schooled__c, Working_With_Assistant__c,
                                                      Children_Home_Schooled_Description__c, Approved_Foster_Care_Provider__c, Approved_Foster_Care_Provider_Descrip__c,
                                                      Becoming_Foster_Care_Provider_Descrip__c, Business_Operated_Out_of_Own_Home__c, Bus_Operated_Out_of_Own_Home_Descrip__c,
                                                      Use_Family_Child_Care_System__c, Use_Family_Child_Care_System_Descrip__c, Becoming_Foster_Care_Provider__c,
                                                      Previous_Involvement_with_EEC_for_Unlice__c,New_Name__c, Previous_Application_Certif_with_EEC__c, Prev_App_Certif_with_EEC_Descrip__c, Prev_App_Certif_with_Another_State__c,
                                                      Prev_App_Certif_with_Another_State_Desc__c, Abused_or_neglected_a_child__c, Abused_or_neglected_a_child_Description__c, Certificate_of_License_Revoked_Suspend__c, Certificate_or_License_Surrendered__c, Revocation_Suspension_Surrender_Reas__c,
                                                      Experience_Caring_for_Children_QUalifica__c, Child_Emergency_Injury_Last_3_Years__c, Child_Emerg_Injury_Last_3_Years_Descrip__c, Charged_or_Arrested_for_Crime__c,
                                                      Charges_Description__c, Dealings_with_Child_Prot_Child_Welfar__c, Dealing_with_Child_Prot_Welfar_Descri__c, Registering_as_Sex_Offender__c, Sex_Offender_Nature_of_Incident__c,
                                                      Restraining_Order_Issued__c, Alcoholic_Bev_Narcotics_Drugs_Desc__c, Use_of_Alcoholic_Bev_Narcotics_Drugs__c, Work_Phone_Number__c, Transaction_Special_Requests_Comments__c, Caring_for_your_own_children_Years__c, Caring_for_your_own_children_Months__c, Caring_for_your_own_children_Hrs_Week__c, Caring_for_other_peoples_children_Years__c, Caring_for_other_peoples_children_Month__c, Caring_for_other_peoples_children_Hr_Wk__c, Other_Children_Kindergarten_Years__c, Other_Children_Kindergarten_Months__c, Other_Children_Kindergarten_Hrs_Week__c, Submitter__r.Name, Assigned_User_Email__c,
                                                      (select Id, First_Name__c, Last_Name__c, Mailing_Address__c, License_Number__c, License_Expiration_Date__c from FCC_Assistants__r)
                                                      from Licensing_Transaction__c where provider__c = :provider.Id and Id != :licenseTransation.Id and (Status__c != 'Cancelled (by Applicant)' and Status__c != 'Closed (EEC Application Incomplete / Denied)') order by createddate desc limit 1];
            if (tltList != null && tltList.size() > 0) {
                Licensing_Transaction__c lt = tltList.get(0);
                licenseTransation.Caring_For_Children_Not_Related__c = lt.Caring_For_Children_Not_Related__c;
                licenseTransation.Evening_Overnight_Weekend_Care__c = lt.Evening_Overnight_Weekend_Care__c;
                licenseTransation.Children_Home_Schooled__c = lt.Children_Home_Schooled__c;
                licenseTransation.Children_Home_Schooled_Description__c = lt.Children_Home_Schooled_Description__c;
                licenseTransation.Approved_Foster_Care_Provider__c = lt.Approved_Foster_Care_Provider__c;
                licenseTransation.Approved_Foster_Care_Provider_Descrip__c = lt.Approved_Foster_Care_Provider_Descrip__c;
                licenseTransation.Becoming_Foster_Care_Provider__c = lt.Becoming_Foster_Care_Provider__c;
                licenseTransation.Becoming_Foster_Care_Provider_Descrip__c = lt.Becoming_Foster_Care_Provider_Descrip__c;
                licenseTransation.Business_Operated_Out_of_Own_Home__c = lt.Business_Operated_Out_of_Own_Home__c;
                licenseTransation.Bus_Operated_Out_of_Own_Home_Descrip__c = lt.Bus_Operated_Out_of_Own_Home_Descrip__c;
                licenseTransation.Use_Family_Child_Care_System__c = lt.Use_Family_Child_Care_System__c;
                licenseTransation.Use_Family_Child_Care_System_Descrip__c = lt.Use_Family_Child_Care_System_Descrip__c;
                licenseTransation.Working_With_Assistant__c = lt.Working_With_Assistant__c;
            }
        }
    }
    
    
    
    private void initializeIndoor() {
        selectedHestElems = new List<String> ();
        initIndoor = true;
        List<Licensing_Transaction__c> tltList = [select Id, Ownership_Type__c ,FCC_Educator_Assistant_is_working_with__c, FCC_Residence_Description__c, Steps_for_Guiding_Child_Behavior__c, Medical_Emergency_Steps__c, At_Least_2_Exits__c, Exits_Descriptions__c, Heating_Elements__c,
                                                  (select Id, Name, Use__c, Dimension_Length_feet__c, Dimension_Width_feet__c, Floor_Level__c From Rooms__r),
                                                  Need_Assist_to_Barricade_Heating_Units__c, Drinking_Water_Source__c,New_Name__c, Outdoor_Space_Changed__c, Outdoor_Space_Changes_Description__c, Transaction_Special_Requests_Comments__c, Caring_for_your_own_children_Years__c, Caring_for_your_own_children_Months__c, Caring_for_your_own_children_Hrs_Week__c, Caring_for_other_peoples_children_Years__c, Caring_for_other_peoples_children_Month__c, Caring_for_other_peoples_children_Hr_Wk__c, Other_Children_Kindergarten_Years__c, Other_Children_Kindergarten_Months__c, Other_Children_Kindergarten_Hrs_Week__c, Submitter__r.Name, Assigned_User_Email__c
                                                  from Licensing_Transaction__c where provider__c = :provider.Id and Id != :licenseTransation.Id and (Status__c != 'Cancelled (by Applicant)' and Status__c != 'Closed (EEC Application Incomplete / Denied)') and
                                                  RecordType.DeveloperName in('FCC_New_License', 'FCC_License_Upgrade', 'FCC_Renewal', 'FCC_Change_Room_Floor_Level', 'Change_of_Address') order by createddate desc limit 1];
        Licensing_Transaction__c lt;
        roomList = new List<Room__c> ();
        if (tltList != null && tltList.size() > 0 && LicenseRecordTypeName != 'FCC_New_License') {
            lt = tltList.get(0);
            licenseTransation.FCC_Residence_Description__c = lt.FCC_Residence_Description__c;
            licenseTransation.At_Least_2_Exits__c = lt.At_Least_2_Exits__c;
            licenseTransation.Exits_Descriptions__c = lt.Exits_Descriptions__c;
            licenseTransation.Heating_Elements__c = lt.Heating_Elements__c;
            licenseTransation.Need_Assist_to_Barricade_Heating_Units__c = lt.Need_Assist_to_Barricade_Heating_Units__c;
            licenseTransation.Drinking_Water_Source__c = lt.Drinking_Water_Source__c;
            licenseTransation.Outdoor_Space_Changed__c = lt.Outdoor_Space_Changed__c;
            licenseTransation.Outdoor_Space_Changes_Description__c = lt.Outdoor_Space_Changes_Description__c;
            if (String.isNotEmpty(lt.Heating_Elements__c)) {
                selectedHestElems = lt.Heating_Elements__c.split(';');
            }
            Room__c tRoom;
            if (lt.Rooms__r != null && lt.Rooms__R.size() > 0) {
                for (Room__c rm : lt.Rooms__r) {
                    tRoom = new Room__c();
                    tRoom.Name = rm.Name;
                    tRoom.Use__c = rm.Use__c;
                    tRoom.Dimension_Length_feet__c = rm.Dimension_Length_feet__c;
                    tRoom.Dimension_Width_feet__c = rm.Dimension_Width_feet__c;
                    tRoom.Floor_Level__c = rm.Floor_Level__c;
                    tRoom.Source_Transaction__c = licenseTransation.Id;
                    roomList.add(tRoom);
                }
                insert roomList;
            }
        }
    }
    
    public void initializeTraining() {
        initTraining = true;
        List<Licensing_Transaction__c> tltList = [select Id, Provider__r.FirstDateTakenFCCII__c, Upload_Certificate_Intro_to_EEC_in_Mass__c, Date_Taken_Intro_EEC_in_MA_orientation__c, Taken_Intro_to_EEC_in_Mass_Orientation__c, Belong_to_Food_Program__c, Which_Food_Program__c, Took_Medication_Administration_Training__c, RecordType.DeveloperName,
                                                  Date_Med_Administration_Training_Taken__c, Took_Transportation_Training__c,New_Name__c,
                                                  Date_Transportation_Training_Taken__c, Took_SIDS_Training__c, Date_Last_SIDS_Training_Taken__c, Took_USDA_Nutrition_Training__c,
                                                  Date_USDA_Nutrition_Training_Taken__c, Took_Upgrading_Capacity_Training__c, Date_Upgrading_Capacity_Training_Taken__c,
                                                  Took_FCC_Orientation__c, Date_FCC_Orientation_Taken__c, CPR_Certified__c, CPR_Certification_Issue_Date__c, First_Aid_Certified__c,
                                                  First_Aid_Certification_Issue_Date__c, Took_FCC_Orientation_Module_1__c, Date_FCC_Orientation_Mod_1_Taken__c,
                                                  (select Id, Name, Topic__c, Number_of_Training_Hours__c, Date_of_the_Training__c from Training_Experience__r) from
                                                  Licensing_Transaction__c where provider__c = :provider.Id and Id != :licenseTransation.Id and (Status__c != 'Cancelled (by Applicant)' and Status__c != 'Closed (EEC Application Incomplete / Denied)') and
                                                  RecordType.DeveloperName in('FCC_New_License', 'FCC_License_Upgrade', 'FCC_Renewal') order by createddate desc limit 1];
        Licensing_Transaction__c lt;
        Licensing_Transaction__c rlt;
        teList = new List<Training_Experience__c> ();
        if (tltList != null && tltList.size() > 0) {
            lt = tltList.get(0);
            licenseTransation.Belong_to_Food_Program__c = lt.Belong_to_Food_Program__c;
            licenseTransation.Which_Food_Program__c = lt.Which_Food_Program__c;
            licenseTransation.Took_Medication_Administration_Training__c = lt.Took_Medication_Administration_Training__c;
            licenseTransation.Date_Med_Administration_Training_Taken__c = lt.Date_Med_Administration_Training_Taken__c;
            licenseTransation.Took_Transportation_Training__c = lt.Took_Transportation_Training__c;
            licenseTransation.Date_Transportation_Training_Taken__c = lt.Date_Transportation_Training_Taken__c;
            licenseTransation.Took_USDA_Nutrition_Training__c = lt.Took_USDA_Nutrition_Training__c;
            licenseTransation.Date_USDA_Nutrition_Training_Taken__c = lt.Date_USDA_Nutrition_Training_Taken__c;
            licenseTransation.Took_Upgrading_Capacity_Training__c = lt.Took_Upgrading_Capacity_Training__c;
            licenseTransation.Date_Upgrading_Capacity_Training_Taken__c = lt.Date_Upgrading_Capacity_Training_Taken__c;
            licenseTransation.Took_FCC_Orientation__c = lt.Took_FCC_Orientation__c;
            licenseTransation.Date_FCC_Orientation_Taken__c = lt.Date_FCC_Orientation_Taken__c;
            licenseTransation.Took_FCC_Orientation_Module_1__c = lt.Took_FCC_Orientation_Module_1__c;
            licenseTransation.Date_FCC_Orientation_Mod_1_Taken__c = lt.Date_FCC_Orientation_Mod_1_Taken__c;
            
            for (Licensing_Transaction__c lt1 : tltList) {
                if (lt.RecordType.DeveloperName == 'FCC_Renewal') {
                    rlt = lt1;
                    Training_Experience__c te;
                    if (rlt.Training_Experience__r != null && rlt.Training_Experience__r.size() > 0) {
                        for (Training_Experience__c rm : lt.Training_Experience__r) {
                            te = new Training_Experience__c();
                            te.Topic__c = rm.Topic__c;
                            te.Date_of_the_Training__c = rm.Date_of_the_Training__c;
                            te.Number_of_Training_Hours__c = rm.Number_of_Training_Hours__c;
                            te.Licensing_Transactions__c = licenseTransation.Id;
                            if (loggedUser.contactId != null) {
                                te.Contact__c = loggedUser.contactId;
                            }
                            teList.add(te);
                        }
                        insert teList;
                    }
                    break;
                }
            }
            
        }
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        return options;
    }
        
    public List<SelectOption> getSupply() {
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('Private Water Supply', 'Private Water Supply'));
        options.add(new SelectOption('Town Water Supply', 'Town Water Supply'));
        return options;
    }
   
    public List<SelectOption> getGrps() {
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('Small Group (<=10)', 'Small Group (<=10)'));
        options.add(new SelectOption('Large Group (>10)', 'Large Group (>10)'));
        return options;
    }
    

/**
*Operation Period - Full Day Program
* @author Rohit
*/
    public List<SelectOption> weekDays {
     get {
       List<SelectOption> options = new List<SelectOption>();
       for( Schema.PicklistEntry f : Licensing_Transaction__c.Available_Days_Full_day_program__c.getDescribe().getPicklistValues()) {
         options.add(new SelectOption(f.getValue(), f.getLabel()));
        } 
       return options;
     }  
     set;
    }
    
    public String[] selectedDay { 
     get {
        String[] selected = new List<String>();
        List<SelectOption> sos = this.weekDays;
        for(SelectOption s : sos) {
        if (this.licenseTransation.Available_Days_Full_day_program__c !=null && this.licenseTransation.Available_Days_Full_day_program__c.contains(s.getValue()))
           selected.add(s.getValue());
        }
        return selected;
     }public set {
        String selectedCheckBox = '';
        for(String s : value) {
         if (selectedCheckBox == '') 
           selectedCheckBox += s;
         else selectedCheckBox += ';' + s;
        }
        licenseTransation.Available_Days_Full_day_program__c = selectedCheckBox;
               if(selectedCheckBox!=null ||selectedCheckBox!=''){
                        isSelectedDay=true;
                }else{
                      isSelectedDay=false;
                }
     }
   }
    public Boolean isSelectedDay {get; set;} 
    
    public void opsFullDay(){
        isSelectedDay = true;
    }
    
/**
*Operation Period - Half Day Morning Program
* @author Rohit
*/
    public List<SelectOption> weekHalfDays {
     get {
       List<SelectOption> options = new List<SelectOption>();
       for( Schema.PicklistEntry f : Licensing_Transaction__c.Available_Days_Morning_program__c.getDescribe().getPicklistValues()) {
         options.add(new SelectOption(f.getValue(), f.getLabel()));
        } 
       return options;
     }  
     set;
    }
    
    public String[] selectedHalfDay { 
     get {
        String[] selected = new List<String>();
        List<SelectOption> sos = this.weekHalfDays;
        for(SelectOption s : sos) {
        if (this.licenseTransation.Available_Days_Morning_program__c !=null && this.licenseTransation.Available_Days_Morning_program__c.contains(s.getValue()))
           selected.add(s.getValue());
        }
        return selected;
     }public set {
        String selectedHalfCheckBox = '';
        for(String s : value) {
         if (selectedHalfCheckBox == '') 
           selectedHalfCheckBox += s;
         else selectedHalfCheckBox += ';' + s;
        }
        licenseTransation.Available_Days_Morning_program__c = selectedHalfCheckBox;
                if(selectedHalfCheckBox!=null ||selectedHalfCheckBox!=''){
                        isSelectedHalfDay=true;
                }else{
                        isSelectedHalfDay=false;
                }
     }
   }
    public Boolean isSelectedHalfDay {get; set;} 
    
    /**
*Operation Period - Half Day Afternoon Program
* @author Rohit
*/
    public List<SelectOption> weekHalfAfterDays {
     get {
       List<SelectOption> options = new List<SelectOption>();
       for( Schema.PicklistEntry f : Licensing_Transaction__c.Available_Days_Afternoon_program__c.getDescribe().getPicklistValues()) {
         options.add(new SelectOption(f.getValue(), f.getLabel()));
        } 
       return options;
     }  
     set;
    }
    
    public String[] selectedHalfAfterDay { 
     get {
        String[] selected = new List<String>();
        List<SelectOption> sos = this.weekHalfAfterDays;
        for(SelectOption s : sos) {
        if (this.licenseTransation.Available_Days_Afternoon_program__c !=null && this.licenseTransation.Available_Days_Afternoon_program__c.contains(s.getValue()))
           selected.add(s.getValue());
        }
        return selected;
     }public set {
        String selectedHalfAfterCheckBox = '';
        for(String s : value) {
         if (selectedHalfAfterCheckBox == '') 
           selectedHalfAfterCheckBox += s;
         else selectedHalfAfterCheckBox += ';' + s;
        }
        licenseTransation.Available_Days_Afternoon_program__c = selectedHalfAfterCheckBox;
                if(selectedHalfAfterCheckBox!=null ||selectedHalfAfterCheckBox!=''){
                        isSelectedHalfAfterDay=true;
                }else{
                        isSelectedHalfAfterDay =false;
                }
     }
   }
    public Boolean isSelectedHalfAfterDay {get; set;} 
      /**
*Operation Period - Extended Days
* @author Rohit
*/
    public List<SelectOption> weekExtendDays {
     get {
       List<SelectOption> options = new List<SelectOption>();
       for( Schema.PicklistEntry f : Licensing_Transaction__c.Extended_Days_Available__c.getDescribe().getPicklistValues()) {
         options.add(new SelectOption(f.getValue(), f.getLabel()));
        } 
       return options;
     }  
     set;
    }
    
    public Boolean isSelectedExtendDay {get; set;} 
    
    public String[] selectedExtendDay { 
     get {
        String[] selected = new List<String>();
        List<SelectOption> sos = this.weekExtendDays;
        for(SelectOption s : sos) {
        if (this.licenseTransation.Extended_Days_Available__c !=null && this.licenseTransation.Extended_Days_Available__c.contains(s.getValue()))
           selected.add(s.getValue());
        }
        return selected;
     }public set {
        String selectedExtendedDaysCheckBox = '';
        for(String s : value) {
         if (selectedExtendedDaysCheckBox == '') 
           selectedExtendedDaysCheckBox += s;
         else selectedExtendedDaysCheckBox += ';' + s;
        }
        licenseTransation.Extended_Days_Available__c = selectedExtendedDaysCheckBox;
                if(selectedExtendedDaysCheckBox!=null ||selectedExtendedDaysCheckBox!=''){
                        isSelectedExtendDay=true;
                }else{
                        isSelectedExtendDay =false;
                }
     }
   }

    public List<SelectOption> getHeatingElements() {
        
        List<SelectOption> hElements = new List<SelectOption> ();
        Schema.DescribeFieldResult fieldResult = Licensing_Transaction__c.Heating_Elements__c.getDescribe();
        list<schema.picklistentry> values = fieldResult.getPickListValues();
        for (Schema.PicklistEntry a : values)
        {
            hElements.add(new SelectOption(a.getValue(), a.getLabel()));
        }
        
        return hElements;
    }
    
    public void getLicenseTrans(String ltId) {
        selectedHestElems = new List<String> ();
        List<Licensing_Transaction__c> ltList = [Select Commute_to_offsite_play_location__c ,Provider__r.Recordtype.Name,Umbrella__r.Provider_Zip_Code__c,Umbrella__r.State__c,Umbrella__r.Provider_Address_1__c,Umbrella__r.Provider_City__c,Provider__r.Umbrella_Members__c ,Working_with_which_Referral_Agencies__c,Level_of_care__c,Gender_of_children_served__c ,Minimum_age_of_children_served__c,Requested_capacity__c ,Awake_Staff_to_child_ratio__c ,Asleep_Staff_to_child_ratio__c,Use_of_physical_restraints1__c,Restraint_method__c,Ratio_comments__c ,Maximum_age_of_children_served__c  ,Characteristics_of_children_served__c , Provider__r.Is_Residential__c,Ownership_Type__c ,Provider__r.Summer_Camp_Permit__c,Provider__r.Provider_Address_1__c,Provider__r.Provider_Address_2__c,Provider__r.Provider_City__c,Provider__r.Provider_Zip_Code__c,Provider__r.State__c,Provider__r.ShippingStreet,Provider__r.ShippingCity,Provider__r.ShippingPostalCode,Provider__r.ShippingState ,Provider__r.Phone, Provider__r.Alternate_Phone__c,Provider__r.Fax ,Provider__r.Provider_Email__c,Provider__r.Capacity__c    ,Provider__r.Ownerid,Provider__r.FirstDateTakenFCCII__c,Provider__r.Name, Provider__r.License_Type__c, FCC_Educator_Assistant_is_working_with__c, IsAssistantUpgradeGT6__c, Upload_Certificate_Intro_to_EEC_in_Mass__c, Date_Taken_Intro_EEC_in_MA_orientation__c, Taken_Intro_to_EEC_in_Mass_Orientation__c, IsProviderUpgrade__c, IsAssistantUpgradeToCertified__c, l.Working_With_Assistant__c, l.Work_Phone_Number__c, l.Which_Food_Program__c, l.Well_Water_Test_Evidence__c, l.Use_of_Alcoholic_Bev_Narcotics_Drugs__c, l.Use_Family_Child_Care_System__c, l.Took_FCC_Orientation__c, RecordType.DeveloperName, RecordType.Name,
                                                 l.Use_Family_Child_Care_System_Descrip__c, l.Upgrading_Capacity_Training_Cert__c, l.Under_Review_Start_Date__c, l.USDA_Nutrition_Training_Evidence__c, l.Transportation_Training_Cert__c, l.Training_Review__c, l.New_Phone_Number_Unlisted__c,l.Accounts_Responsible__c,l.Records_Responsible__c,l.Personnel_Records_Responsible__c,l.Children_Records_Responsible__c,l.Financial_Documentation_Responsible__c,l.Staff_Schedule_Responsible__c,l.ECE_program_Responsible__c,l.Kindergarten_Responsible__c,l.School_age_Responsible__c,l.Services_4_Disable_children_Responsible__c,l.Daily_activities_Responsible__c,l.Equipment_Responsible__c,l.Staff_Development_Responsible__c,l.Staff_Training_Responsible__c,l.Staff_Orientation_Responsible__c,l.Staff_Supervision_Responsible__c,l.Parent_Involvement_Responsible__c,l.Social_Services_Responsible__c,l.Infant_Toddler_Program_Responsible__c,l.Indoor_Square_Footage__c,l.Number_of_toilets_c__c,l.Number_of_sinks__c,l.Lead_Paint_Compliance__c,l.Lead_Paint_Detailed_Inspection__c,l.Building_Inspection_Max_Capacity__c,l.Building_inspection_expiration_Date__c,l.Building_Codes_c__c,l.Health_Inspection_Expiration_Date__c , Fire_Inspection_Issue_date__c ,                                                l.Total_Payment_Received__c,l.Group_Type__c,l.Camp_Permit_Issue_Date__c,l.Summer_Camp_Permit__c, l.Took_Upgrading_Capacity_Training__c, l.Took_USDA_Nutrition_Training__c,l.New_Name__c, l.New_City__c,l.New_City__r.Name,l.Previous_State__c, l.Took_Transportation_Training__c, l.Took_SIDS_Training__c, l.Took_Medication_Administration_Training__c, l.New_State__c,
                                                 l.To_Process_Flag__c, l.Technical_Assistance__c, l.Tax_Certification_Status__c, l.Submission_Date__c, l.Name, l.Approved_Foster_Care_Provider_Descrip__c, l.Tax_Certification_Statement_Request_Date__c, l.Tax_Cert_Statement_Signed_Date__c, l.Submitter__c, l.Submitter_Email_Address__c,Integrated_Pest_Management_Date__c ,Well_Water_Test_date__c ,PWS_Public_Water_Source_Number__c ,Outdoor_Square_footage__c ,Pool_available_during_program_hours1__c,Transportation_provided1__c,Offsite_outdoor_play_location1__c ,Pool_roof_inspection_date__c  ,Other_Approved_Additional_Space__c ,Indoor_ADA_Compliant__c ,Outdoor_ADA_Compliant__c ,Umbrella__r.Name,  Operation_Start_Month__c ,Operation_End_Month__c ,                                             l.Stove_Meets_Requirements_Evidence__c, l.Status__c, l.Source__c, l.Sex_Offender_Nature_of_Incident__c, l.SIDS_Training_Cert__c, l.Revocation_Suspension_Surrender_Reas__c, l.Restraining_Order_Issued__c, l.Restraining_Order_Description__c, l.Registering_as_Sex_Offender__c,
                                                 l.RecordTypeId, l.Alcoholic_Bev_Narcotics_Drugs_Desc__c, l.Reason_for_Request__c, l.Reason_Closed_Cancelled__c, l.Ready_for_Closing__c, l.Provider__c, l.Previous_Involvement_with_EEC_for_Unlice__c, l.Previous_Application_Certif_with_EEC__c, l.Prev_App_Certif_with_EEC_Descrip__c, l.Prev_App_Certif_with_Another_State__c,Other_Referral_Agency__c,International_adoption_countries__c,Other_countries__c,Number_of_Adoptive_Placements__c,Number_of_Foster_Homes__c,Number_of_birth_mothers_recving_services__c,Birth_mothers_making_adoption_plans__c,Number_of_Waiting_Families__c ,Families_recving_home_study_services__c,Recving_search_and_or_reunion_services__c,DCF_Nb_Children_Placed_In_Care__c,
                                                 l.Prev_App_Certif_with_Another_State_Desc__c,l.Address_of_admin_for_funding_source__c,l.Name_of_contract_administrator__c,l.Is_your_program_contracted__c,l.Date_of_Expiration__c,l.By_whom__c, l.Outdoor_Space_Changes_Description__c, l.Outdoor_Space_Changed__c, l.Other_Person_BRC_Consent_Completed__c, l.Other_Info_Reviewed__c, l.Other_Condition__c, l.Observations_Comments__c, l.No_Condition_Flag__c,Provider__r.Camp_Permit_Issue_Date__c,
                                                 l.Number_of_Open_Foster_Homes__c,l.Number_of_children_placed_in_care__c,l.New_Zip_Code__c, l.New_Street_Address_2__c, l.New_Street_Address_1__c, l.New_Address_Phone_Number__c, l.Need_Assist_to_Barricade_Heating_Units__c, l.Moving_Date__c, l.Missing_Elements_For_Finalizing__c, l.Medication_Administration_Training_Cert__c,Number_recving_Search_reunion_services__c,Number_of_Reunions_Facilitated__c,Number_of_Child_Assessments__c,Number_of_Home_Study_Services__c,Families_recving_case_mgmt_services__c ,Families_recving_information_referral__c, 
                                                 l.Start_Time_Afternoon_program__c,l.End_Time_Afternoon_program__c,l.Available_Days_Afternoon_program__c,provider__r.Umbrella_Members__r.Name,provider__r.Umbrella_Members__r.Provider_Address_1__c,provider__r.Umbrella_Members__r.Provider_City__c,provider__r.Umbrella_Members__r.Provider_Zip_Code__c,provider__r.Umbrella_Members__r.State__c,
                                                 l.Live_at_New_Address__c,l.Available_Days_Full_day_program__c,l.Start_Time_Morning_program__c,l.End_Time_Morning_program__c,l.Available_Days_Morning_program__c,l.Start_Time_Full_day_program__c,l.End_Time_Full_day_program__c, l.Licensee_BRC_Consent_Status__c, l.Licensee_BRC_Consent_Signed_Date__c, l.Licensee_BRC_Consent_Request_Date__c, Submitter__r.FirstName, Submitter__r.LastName, Assigned_To__r.FirstName, Assigned_To__r.LastName, Assigned_To__r.Phone, Assigned_To__r.Email,
                                                 l.ProgramLicensedOrApproved__c,l.ProgramContracted__c,Out_of_state_childcare_related_licenses1__c,Out_of_state_license_appl_in_process1__c,Admin_Civil_criminal_action_last_5_yrs1__c,State_Federal_investigation_last_5_yrs1__c,
                                                 l.License_Type__c,l.Operation_Type__c,l.Small_Group_Capacity__c, l.License_Requested__c, l.License_Issue_Date__c, l.Program_licensed_or_approved_by_agency__c,l.License_Expiration_Date__c, l.Last_Reached_Step__c, l.Indoor_Outdoor_Space_Review__c, l.Id, l.Heating_Elements__c, l.Floors_Description__c, l.First_Aid_Certified__c, l.First_Aid_Certification_Issue_Date__c,
                                                 l.First_Aid_Certificate__c, l.Fee_Paid__c, l.FCC_Residence_Description__c, l.FCC_Orientation_Module_II_Evidence__c, FCC_Orientation_Module_I_Evidence__c, l.Experience_Caring_for_Children_QUalifica__c,l.Previous_Street_Address_1__c,l.Previous_Street_Address_2__c,l.Previous_City__c,l.Previous_City__r.Name,l.Previous_Zip_Code__c,
                                                 l.Infant_Capacity__c,l.Infant_Toddler_Capacity__c,l.Toddler_Capacity__c,l.Toddler_Preschool_Capacity__c,l.Preschool_Capacity__c,l.Preschool_SA_Capacity__c,
                                                 l.Kindergarten_Capacity__c,l.School_Age_Capacity__c,l.Multi_Age_Group_Capacity__c,l.Total_License_Capacity_Requested__c,l.Minimum_Age_Limit_Requested_Years__c,
                                                 l.Provide_Extended_Days1__c,l.Extended_Days_Available__c,l.Gym_Facility_Used_During_Program_Hours1__c,l.Drop_in_Service1__c,l.Evenings_Service1__c,Summer_Camp_Service1__c,l.Cafeteria_Used_During_Program_Hours1__c,
                                                 l.Minimum_Age_Limit_Requested_Months__c,l.Maximum_Age_Limit_Requested_Months__c,l.Maximum_Age_Limit_Requested_Years__c,                                                 
                                                 l.Exits_Descriptions__c, l.Evening_Overnight_Weekend_Care__c, l.Drinking_Water_Source__c, l.Document_Information_Missing__c, l.Document_Info_Missing_Initial_Date__c, l.Dealings_with_Child_Prot_Child_Welfar__c, l.Dealing_with_Child_Prot_Welfar_Descri__c,
                                                 l.Date_Upgrading_Capacity_Training_Taken__c, l.Date_USDA_Nutrition_Training_Taken__c, l.Date_Transportation_Training_Taken__c, l.Date_Med_Administration_Training_Taken__c,
                                                 l.Date_Last_SIDS_Training_Taken__c, l.Date_FCC_Orientation_Taken__c, l.Date_Closed__c, l.Date_Care_Resumes__c, l.Date_Activity_Ends__c, l.Daily_Routine_and_Activities__c, l.Condition_Added__c, l.Children_Home_Schooled__c, l.Children_Home_Schooled_Description__c, l.Child_Emergency_Injury_Last_3_Years__c,
                                                 l.Child_Emerg_Injury_Last_3_Years_Descrip__c, l.Charges_Description__c, l.Charged_or_Arrested_for_Crime__c, l.Certificate_or_License_Surrendered__c, l.Certificate_of_License_Revoked_Suspend__c, l.Caring_For_Children_Not_Related__c, l.Capacity__c, l.CPR_Certified__c, l.CPR_Certification_Issue_Date__c,
                                                 l.CPR_Certificate__c, l.Business_Operated_Out_of_Own_Home__c, l.Bus_Operated_Out_of_Own_Home_Descrip__c, l.Belong_to_Food_Program__c, l.Becoming_Foster_Care_Provider__c, l.Becoming_Foster_Care_Provider_Descrip__c, l.At_Least_2_Exits__c, l.Associated_Fee__c, l.Assigned_To__c, l.Approved_by_Manager__c, l.Approved_Foster_Care_Provider__c,
                                                 l.Date_FCC_Orientation_Mod_1_Taken__c, l.Took_FCC_Orientation_Module_1__c, l.Abused_or_neglected_a_child__c, l.Abused_or_neglected_a_child_Description__c, l.Transaction_Special_Requests_Comments__c, l.Steps_for_Guiding_Child_Behavior__c, l.Medical_Emergency_Steps__c, l.Caring_for_your_own_children_Years__c, l.Caring_for_your_own_children_Months__c, l.Caring_for_your_own_children_Hrs_Week__c, l.Caring_for_other_peoples_children_Years__c, l.Caring_for_other_peoples_children_Month__c, l.Caring_for_other_peoples_children_Hr_Wk__c, l.Other_Children_Kindergarten_Years__c, l.Other_Children_Kindergarten_Months__c, l.Other_Children_Kindergarten_Hrs_Week__c, l.Submitter__r.Name, l.Assigned_User_Email__c,
                                                 l.Want_Designated_Primary_Contact__c,
                                                 Provider__r.Type_of_Ownership__c,
                                                 Existing_Fiduciary_Admin_relationships1__c ,
                                                 New_Umbrella_Name__c,
                                                New_Umbrella_Business_Name__c,
                                                NewUmbrella_Place_of_Incorporation__c,
                                                NewUmbrella_Date_of_Incorporation__c,
                                                NewUmbrella_Street_Address_1__c,
                                                NewUmbrella_Street_Address_2__c,
                                                NewUmbrella_State__c,
                                                NewUmbrella_City__c,
                                                NewUmbrella_Zip_Code__c,
                                                NewUmbrella_Phone__c,
                                                NewUmbrella_Alternate_Phone__c,
                                                NewUmbrella_Fax__c,
                                                NewUmbrella_Email__c,
                                                NewUmbrella_Director_First_Name__c,
                                                NewUmbrella_Director_Last_Name__c,
                                                NewUmbrella_Director_Title__c,
                                                NewUmbrella_Director_Phone__c,
                                                Contact_Roles_Copied__c,
                                                Transaction_Configuration__r.EEC_Licensing_Transaction_Instructions__c,
                                                NewUmbrella_Director_Email__c,(Select Id,Associated_Regulation__c,Associated_Regulation__r.Name,Associated_Regulation__r.Regulation_Number__c,Associated_Regulation__r.Article__c,Provider_Alternative_Method_to_Comply__c,Provider_Understanding_of_Regulation__c From Variance_on_Regulations__r)
                                                 From Licensing_Transaction__c l where Id = :ltId];
        
        if (ltList != null && ltList.size() > 0) {
            licenseTransation = ltList.get(0);
            licenseRecordTypeName = licenseTransation.RecordType.DeveloperName;
            licenseRecordTypeLabel = licenseTransation.RecordType.Name;
            if(licenseRecordTypeName=='R_P_Change_of_Admin_Authority'){
                formattedLicenseRecordTypeLabel = 'R&P Change of Admin Authority';
            }else{
                formattedLicenseRecordTypeLabel = licenseRecordTypeName.replaceAll('_', ' ');   
            }
            
            system.debug('Inst: ' + licenseTransation.Transaction_Configuration__r.EEC_Licensing_Transaction_Instructions__c);
            listLicenseRequested = new List<selectOption>();
            listLicenseRequested.add(new SelectOption('','--Select--'));
            
            if(string.isNotBlank(licenseTransation.Provider__r.Capacity__c) && licenseTransation.Provider__r.Capacity__c.contains('10')){
                listLicenseRequested.add(new SelectOption('Up to 8 Children; 2 School Aged','Up to 8 Children; 2 School Aged'));
                listLicenseRequested.add(new SelectOption('Up to 6 Children','Up to 6 Children'));
            }
            else{
                listLicenseRequested.add(new SelectOption('Up to 6 Children','Up to 6 Children'));
            }
            selectedUmbrellaId = licenseTransation.Umbrella__c;
            
            provider = [select Id,name,Ownerid, Race__c, License_Type__c,Is_GSA__c ,Is_R_P__c , Allow_Renewal_as_Assistant__c,State__c, Recordtype.DeveloperName, RecordType.Name, License_Status__c, First_Issue_Date__c, Renewal_date__c, Provider_Status__c,
                        Accept_Referral__c, Account_books_Responsible__c,Records_Responsible__c,Personnel_Records_Responsible__c,Children_s_Records_Responsible__c,Financial_Documentation_Responsible__c,Staff_Schedules_Responsible__c,Early_Childhood_Education_Program_Resp__c,Kindergarten_Responsible__c,School_Age_Responsible__c,Services_for_Children_w_Disability_Resp__c,Daily_Activities_Responsible__c,Equipment_Responsible__c,
                        Indoor_Square_Footage__c,Number_of_toilets__c,Number_of_sinks__c,Lead_Paint_Compliance__c,Detailed_Inspection__c,Building_Inspection_Max_Capacity__c,Building_inspection_expiration_Date__c,Building_Codes__c,Health_Inspection_Expiration_Date__c,Fire_Inspection_Issue_date__c,Integrated_Pest_Management_Date__c,Well_Water_Test_date__c,PWS_Public_Water_Source_Number__c,
                        School_Year_To__c ,School_Year_From__c, Half_Day_Afternoon_Program_Available_On__c,Half_Day_Afternoon_Program_Avail_From__c,Half_Day_Afternoon_Program_Available_To__c,Half_Day_Morning_Program_Available_On__c,Half_Day_Morning_Program_Available_From__c,Half_Day_Morning_Program_Available_To__c,Full_Day_Program_Available_To__c,
                        Gender__c,Full_Day_Program_Available_From__c,Extended_Day_Available_On__c ,Full_Day_Program_Available_On__c,Full_School_Year__c,Capacity_Small_Group__c,Infant_birth_15_mo__c,Infant_Toddler_birth_33_mo__c,Toddler_15_mo_33_mo__c,Toddler_Preschool_15_mo_K__c,Preschool_33_mo_K__c,Preschool_SA_33_mo_8_yr__c,Kindergarten__c,School_Age_5_yr_14_yr__c,Multi_Age_Group_birth_14_yr__c,
                        MinAgeServed__c,MaxAgeServed__c,Awake_Ratio__c,Asleep_Ratio__c,Ratio_Comment__c,Use_Physical_Restraints__c,Restraint_Method__c,Referral_Agency__c,
                        Characteristics_of_children_served_pickl__c,Level_of_Care__c,International_Adoption_Countries__c,Other_Countries__c,Other_Referral_Agency__c,No_Adoptive_Placements__c,
                        Number_of_Foster_Homes__c,No_Birth_Mothers_Receiving_Services__c,No_Birth_Mothers_Making_Adoption_Plan__c,Number_of_Waiting_Families__c,No_Families_Rec_Home_Stdy_Serv_Only__c,
                        Recving_search_and_or_reunion_services__c,No_Indiv_Rec_Search_and_or_Reunion_Serv__c,Number_of_Reunions_Facilitated__c,Number_of_Child_Assessments__c,Number_of_Home_Study_Services__c,
                        No_of_Families_Rec_Case_Mgmt_Services__c,No_Families_Receiving_Info_and_Referral__c,Number_of_Children_Placed_in_Care__c,Camp_Permit_Issue_Date__c,Summer_Camp_Permit__c,Staff_Development_Responsible__c,Staff_Training_Responsible__c,Staff_Orientation_Responsible__c,Staff_Supervision_Responsible__c,Parent_Involvement_Responsible__c,Social_Services_Responsible__c,Infant_Toddler_Program_Responsible__c,Outdoor_Square_footage__c,Pool_roof_inspection_date__c,Offsite_outdoor_play_location__c,Other_Approved_Additional_Space__c,
                        Certified_As__c, Allow_New_Application_as_Provider__c,  Can_Communicate_in_English__c, PPM_Meeting_Attended_Date__c, capacity__c,
                        ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, Phone, Unlisted_Phone_Number__c, Alternate_Phone__c, Fax, Provider_Email__c,
                        Extended_Day_Provided__c,Provider_Address_1__c, Provider_Address_2__c, Provider_City__c, Provider_City__r.Name, Provider_Zip_Code__c, Live_at_this_address__c, Language__c, Preferred_Language__c
                        ,Drop_In_Service_Provided__c, Evenings_Service_Provided__c, Summer_Camp_Services_Provided__c, Cafeteria_Approved__c, Gym_Approved__c 
                        from Account where Id = :licenseTransation.Provider__c];
            
            ihmList = [Select Id, Provider__c, Licensing_Transactions__c, Current__c, First_Name__c, Last_Name__c, Date_of_Birth__c, Relationship_to_Provider__c, Occupation__c, Number_of_Hours_Home_During_Child_Care__c, Current_School_Grade__c, Email_Address__c From Household_Member__c where Licensing_Transactions__c = :licenseTransation.Id];
            ihmListJson = JSON.serialize(ihmList);
            ehList = [Select Name, Contact__c, Licensing_Transaction__c, Position__c, Start_Date__c, End_Date__c, Reason_for_Leaving__c, Employer__c, Employer_Address__c, Employer_Phone__c From Employment_History__c where Licensing_Transaction__c = :licenseTransation.Id];
            roomList = [Select Id, Name, Source_Transaction__c, Current__c, Use__c, Dimension_Length_feet__c, Dimension_Width_feet__c, Dimension_Square_Feet__c, Floor_Level__c, Provider_Name__c From Room__c where Source_Transaction__c = :licenseTransation.Id];
            teList = [Select Id, Name, Contact__c, Licensing_Transactions__c, Topic__c, Date_of_the_Training__c, Number_of_Training_Hours__c From Training_Experience__c where Licensing_Transactions__c = :licenseTransation.Id];
            initHH = true;
            initLS = true;
            initIndoor = true;
            initTraining = true;
            if (String.isNotEmpty(licenseTransation.Heating_Elements__c)) {
                selectedHestElems = licenseTransation.Heating_Elements__c.split(';');
            }
        }
    }
    
    /**
* UpdateMembersList
* 
* This function will process two JSON strings and put them into the overall Household_Member List.
* @author Darkis
* @param MembersJson String The json containing all the members currently or newly added to the table.
* @param MembersToDeleteJson String The json containing all the members that are to be deleted from the transaction.
*/
    public void UpdateMembersList() {
        try {
            List<Household_Member_Json_Wrapper> memberWrapperList;
            List<Household_Member__c> memberList = new List<Household_Member__c> ();
            
            if (!String.isBlank(MembersJson)) {
                memberWrapperList = (List<Household_Member_Json_Wrapper>) JSON.deserialize(MembersJson, List<Household_Member_Json_Wrapper>.class);
                
                for (Household_Member_Json_Wrapper memberWrapper : memberWrapperList) {
                    memberList.add(memberWrapper.convertToHouseholdMember());
                }
                ihmList = memberList;
                ihmListJson = JSON.serialize(ihmList);
            }
            
            if (!String.isBlank(MembersToDeleteJson)) {
                memberWrapperList = (List<Household_Member_Json_Wrapper>) JSON.deserialize(MembersToDeleteJson, List<Household_Member_Json_Wrapper>.class);
                memberList = new List<Household_Member__c> ();
                
                for (Household_Member_Json_Wrapper mw : memberWrapperList) {
                    memberList.add(mw.convertToHouseholdMember());
                }
                removeHMList = memberList;
            }
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
    }
    
    /**
* Household_Member_Json_Wrapper
* 
* This wrapper class is used to process Household Member Json strings into usable Household_Member__c objects.
* @author Darkis
*/
    public class Household_Member_Json_Wrapper {
        // Variables here
        public String Id { get; set; }
        public String First_Name { get; set; }
        public String Last_Name { get; set; }
        public String Date_of_Birth { get; set; }
        public String Relationship_to_Provider { get; set; }
        public String Occupation { get; set; }
        public String Number_of_Hours_Home_During_Child_Care { get; set; }
        public String Current_School_Grade { get; set; }
        public String Email_Address { get; set; }
        
        /**
* convertToHouseholdMember
* 
* This function will take the processed Json and convert it into a usable Household_Member__c object for saving.
* @author Darkis
*/
        public Household_Member__c convertToHouseholdMember() {
            Household_Member__c member = new Household_Member__c(
                First_Name__c = this.First_Name,
                Last_Name__c = this.Last_Name,
                Date_of_Birth__c = Date.parse(this.Date_of_Birth),
                Relationship_to_Provider__c = this.Relationship_to_Provider,
                Occupation__c = this.Occupation,
                Number_of_Hours_Home_During_Child_Care__c = Decimal.valueOf(this.Number_of_Hours_Home_During_Child_Care),
                Current_School_Grade__c = this.Current_School_Grade,
                Email_Address__c = this.Email_Address
            );
            // If the ID is not null/empty/blank then set it for updating.  
            if (String.isNotBlank(this.Id)) {
                member.Id = this.Id;
            }
            return member;
        }
    }
    
    /**
* processAttachmentJson
* 
* This function will accept a json parameter of files decriptions to save to the transaction object.
* @author Darkis
*/
    public void processAttachmentJson(String jsonStr) {
        try {
            // List of S3Objects. 
            if (!String.isBlank(jsonStr)) {
                // Convert the json into S3_Files.
                List<S3_File__c> s3FilesList = (List<S3_File__c>) JSON.deserialize(jsonStr, List<S3_File__c>.class);
                upsert s3FilesList;
                // Get all the current FileMap records for the object and ensure we don't create any duplicates.  
                Set<Id> fileMappingIds = (new Map<Id, FileMap__c> ([Select S3_File__c From FileMap__c Where Object_Id__c = :licenseTransation.Id])).keySet();
                List<FileMap__c> filesToMap = new List<FileMap__c> ();
                // Loop through all the files in the list and verify any that are new to be added. 
                for (S3_File__c file : s3FilesList) {
                    if (!fileMappingIds.contains(file.Id)) {
                        filesToMap.add(new FileMap__c(
                            Object_Name__c = String.valueOf(licenseTransation.getSObjectType()),
                            Object_Id__c = licenseTransation.Id,
                            S3_File__c = file.Id
                        ));
                    }
                }
                // Insert the new files that need to be mapped.   
                insert filesToMap;
            }
        } catch(Exception e) {
            System.debug('-----> Error: ' + e.getMessage());
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
    }
    
    /**
* saveAttachmentsFromJson
* 
* This function will send both the indoor json and full attachment json string to be processed.
* @author Darkis
*/
    public void saveAttachmentsFromJson() {
        try {
            // List of S3Objects. 
            if (!String.isBlank(indoorAttachmentsJson)) {
                processAttachmentJson(indoorAttachmentsJson);
            }
        } catch(Exception e) {
            System.debug('-----> Error: ' + e.getMessage());
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
    }
    
    public void saveAllAttachmentsFromJson() {
        try {
            if (!String.isBlank(attachmentsJson)) {
                processAttachmentJson(attachmentsJson);
            }
        } catch(Exception e) {
            System.debug('-----> Error: ' + e.getMessage());
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
    }
    
    public void saveTrainingAttachmentsFromJson() {
        try {
            if (!String.isBlank(trainingAttachmentsJson)) {
                processAttachmentJson(trainingAttachmentsJson);
            }
        } catch(Exception e) {
            System.debug('-----> Error: ' + e.getMessage());
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
    }
    
    /**
* renderExisitingElements 
* 
* These functions will verify that certain files have been mapped correctly.
* @author Darkis
*/
    public Boolean getRenderExistingHeatingAttachment() {
        return transactionAttachmentsMap.containsKey('evidence_stove_meets_requirements');
    }
    
    public Boolean getRenderExistingWaterAttachment() {
        return transactionAttachmentsMap.containsKey('evidence_of_well_water_test');
    }
    
    public Boolean getRenderExistingMedicationAttachment() {
        return transactionAttachmentsMap.containsKey('med_administration_training_evidence');
    }
    
    public Boolean getRenderExistingTransportationAttachment() {
        return transactionAttachmentsMap.containsKey('transportation_training_evidence');
    }
    
    public Boolean getRenderExistingSidsAttachment() {
        return transactionAttachmentsMap.containsKey('sids_training_evidence');
    }
    
    public Boolean getRenderExistingUsdaAttachment() {
        return transactionAttachmentsMap.containsKey('usda_nutrition_training_evidence');
    }
    
    public Boolean getRenderExistingUpgradeAttachment() {
        return transactionAttachmentsMap.containsKey('upgrade_capacity_training_evidence');
    }
    
    public Boolean getRenderExistingOrientationAttachment() {
        return transactionAttachmentsMap.containsKey('fcc_orientation_mod_II_training_evidence');
    }
    
    public Boolean getRenderExistingCprAttachment() {
        return transactionAttachmentsMap.containsKey('cpr_certification_evidence');
    }
    
    public Boolean getRenderExistingFirstAidAttachment() {
        return transactionAttachmentsMap.containsKey('first_aid_certification_evidence');
    }
    
    public Boolean getRenderExistingOrientationModuleAttachment() {
        return transactionAttachmentsMap.containsKey('fcc_orientation_module_1_evidence');
    }
    
    public Boolean getRenderExistingIntroEECModuleAttachment() {
        return transactionAttachmentsMap.containsKey('intro_fcc_module_evidence');
    }
    
    /**
* deleteAttachment
* 
* This function will delete the FileMap__c and S3_File__c record for a specified file along with trigger an async function to delete the file from S3.
* @author Darkis
* @param String fileToDelete The name of the file to delete from the UI.
*/
    public PageReference deleteAttachment() {
        // Delete the FileMap and S3_File Records.
        List<FileMap__c> listFileMap = [Select Id, S3_File__r.Filename__c From FileMap__c Where Object_Id__c = :licenseTransation.Id AND S3_File__r.Filename__c = :fileToDelete];
        
        if(listFileMap.size() > 0){
            delete listFileMap;
            
            // Delete the S3_File reference in Sforce.
            S3_File__c file = [Select Id From S3_File__c Where Id = :listfileMap[0].S3_File__c LIMIT 1];
            delete file;
        }
        // Invoke the future method to delete the object in S3 using the SOAP API.
        if (!Test.isRunningTest()) {
            deleteS3FileReference(bucketName, licenseTransation.Id + '/' + fileToDelete);
        }
        // Check for the transaction certification field name. If it exists then uncheck the field 
        if (!String.isBlank(transCertCheckboxFieldname)) {
            licenseTransation.put(transCertCheckboxFieldname, false);
        }
        
        // Re-map the mappings to remove the attachment.
        generateAttachmentMappings();
        refreshAttachmentsList();
        retrieveAddtionalTrainingAttachmentsList();
        return null;
    }
    
    /**
* @future
* deleteS3FileReference
* 
* This future function will do a SOAP callout to S3 to delete the file reference provided. 
* @author Darkis
* @param String bucketName The name of the bucket the file resides in.
* @param String filename The name of the file along with any prefixs necessary.
*/
    @future(callout = true)
    public static void deleteS3FileReference(String bucketName, String filename) {
        // Delete the file from S3 using the SOAP API.  
        EEC_S3ComponentCtrl.deleteFile(bucketName, filename);
    }
    
    /** filename
* generateMultiplePolicySignature
* 
* This function will call the S3ComponentCtrl to generate multiple or single policy and signature combos for specified files to upload to S3.
* @author Darkis
* @param String bucket The name of the bucket to save to.
* @param String acl The permission level of the file. Typically this would be 'authenticated-read' for our purposes. 
* @param String fileJson A JSON string of all the files to be uploaded from the Angular Controller.
*/
    @RemoteAction
    public static List<Map<String, String>> generateMultiplePolicySignature(String bucket, String acl, String fileJson) {
        List<Map<String, String>> returnJson = new List<Map<String, String>> ();
        List<EEC_S3ComponentCtrl.FileTypeJsonWrapper> fileTypeWrapperList = (List<EEC_S3ComponentCtrl.FileTypeJsonWrapper>) JSON.deserialize(fileJson, List<EEC_S3ComponentCtrl.FileTypeJsonWrapper>.class);
        // Loop through the files given and get all the necessary policy/sig combos.
        for (EEC_S3ComponentCtrl.FileTypeJsonWrapper wrapper : fileTypeWrapperList) {
            returnJson.add(EEC_S3ComponentCtrl.generatePolicySignature(bucket, acl, wrapper.filename, wrapper.type, null));
        }
        return returnJson;
    }
    
    /**
* getRoomTableVisibility
* 
* This function will check the room list size and inform the UI of the result.
* @author Darkis
*/
    public Boolean getRoomTableVisibility() {
        return roomList.size() == 0 ? false : true;
    }
    
    /**
* getHeatingEvidenceRequired
* 
* This function will verify the existance of the heating evidence requirement for file uploads.
* @author Darkis
*/
    public Boolean getHeatingEvidenceRequired() {
        if (selectedHestStr != null) {
            return selectedHestStr.contains('Coal / Pellet / Wood Burning Stove');
        }
        return false;
    }
    
    /**
* getHeatingIsBarricaded
* 
* This function will determine if the heating parameters require a 2nd question.
* @author Darkis
*/
    public Boolean getHeatingIsBarricaded() {
        showCBDesc();
        
        if (String.isBlank(selectedHestStr)) {
            return false;
        }
        
        if (selectedHestStr != null && ((selectedHestStr == 'Baseboards,') || (selectedHestStr == 'Vents / Grates,') || (selectedHestStr == 'Baseboards,Vents / Grates,'))) {
            return false;
        }
        return true;
    }
    
    /**
* getWaterIsPrivate
* 
* This function will determine if the water selection is private or Town. If the value has not been initialized it will be here.
* @author Darkis
*/
    public Boolean getWaterIsPrivate() {
        if (String.isBlank(selectedWaterStr) && licenseTransation.Drinking_Water_Source__c != null) {
            selectedWaterStr = licenseTransation.Drinking_Water_Source__c;
        }
        if (String.isBlank(selectedWaterStr)) {
            licenseTransation.Well_Water_Test_Evidence__c = false;
            return false;
        }
        if (selectedWaterStr != null && !selectedWaterStr.equalsIgnoreCase('private water supply')) {
            licenseTransation.Well_Water_Test_Evidence__c = true;
            return true;
        }
        licenseTransation.Well_Water_Test_Evidence__c = false;
        return false;
    }
    
    /**
* Change the lookup for city into select option
* @author Bemnet
* 
*/
    
    public EEC_PaginatedSelectList allCityList{
        get{
            if(allCityList == null){
                allCityList = new EEC_PaginatedSelectList();
                for (City__c c :[select id, Name, State__c from City__c where isdeleted = false order by Name]) {
                    allCityList.add(new SelectOption(c.id, c.name + ' (' + c.State__c + ')'));
                }
            }
            return allCityList;
        }
        set;
    } 
    public EEC_PaginatedSelectList maCityList{
        get{
            if(maCityList == null){
                maCityList = new EEC_PaginatedSelectList();
                for (City__c c :[select id, Name, State__c from City__c where State__c = 'MA' AND isdeleted = false order by Name]) {
                    maCityList.add(new SelectOption(c.id, c.name + ' (' + c.State__c + ')'));
                }
            }
            return maCityList;
        }
        set;
    }  
    
    
    public SelectOption[] getCityOptions() {
        SelectOption[] cities = new SelectOption[] { };
            cities.add(new SelectOption('', '--None--'));
        for (City__c c :[select id, Name, State__c from City__c where isdeleted = false order by Name]) {
            cities.add(new SelectOption(c.id, c.name + ' (' + c.State__c + ')'));
        }
        return cities;
    }
    public SelectOption[] getMACityOptions() {
        SelectOption[] cities = new SelectOption[] { };
            cities.add(new SelectOption('', '--None--'));
        for (City__c c :[select id, Name, State__c from City__c where State__c = 'MA' AND isdeleted = false order by Name]) {
            cities.add(new SelectOption(c.id, c.name + ' (' + c.State__c + ')'));
        }
        return cities;
    }  
    
    /**
* refreshAttachmentsList
* 
* This function will collect all the attachments for the transaction and store them into a list for use on the attachment page.
* @author Darkis 
*/
    public List<S3_File__c> refreshAttachmentsList() {
        attachments = new List<S3_File__c> ();
        List<FileMap__c> fileMappings = [Select Id, S3_File__r.Id, S3_File__r.CreatedDate, S3_File__r.Filename__c From FileMap__c Where Object_Id__c = :licenseTransation.Id];
        if (fileMappings.size() > 0) {
            Set<Id> fileIds = new Set<Id> ();
            
            for (FileMap__c filemap : fileMappings) {
                fileIds.add(filemap.S3_File__r.Id);
            }
            attachments = [Select Id, Filename__c, Content_Type__c, Description__c, CreatedDate From S3_File__c Where Id IN :fileIds];
            attachmentsJson = JSON.serialize(attachments);
            return attachments;
        } else {
            attachmentsJson = '';
        }
        return new List<S3_File__c> ();
    }
    
    public List<S3_File__c> retrieveAddtionalTrainingAttachmentsList() {
        additionalTrainingAttachments = new List<S3_File__c> ();
        
        List<FileMap__c> fileMappings = [Select Id, S3_File__r.Id From FileMap__c Where S3_File__r.Filename__c Like 'additional_training_%'];
        
        if (fileMappings.size() > 0) {
            Set<Id> fileIds = new Set<Id> ();
            
            for (FileMap__c filemap : fileMappings) {
                fileIds.add(fileMap.S3_File__r.Id);
            }
            
            additionalTrainingAttachments = [Select Id, Filename__c, CreatedDate From S3_File__c Where Id IN :fileIds];
            attachmentsJson = JSON.serialize(additionalTrainingAttachments);
            return additionalTrainingAttachments;
        } else {
            attachmentsJson = '';
        }
        return new List<S3_File__c> ();
    }
    
    public void generateAttachmentMappings() {
        // Get all attachments for the transaction.
        transactionAttachments = [Select Id, CreatedDate, S3_File__r.Id, S3_File__r.Filename__c, S3_File__r.Bucket__c, S3_File__r.Content_Type__c, S3_File__r.Prefix__c From FileMap__c Where Object_Id__c = :licenseTransation.Id ORDER BY CreatedDate DESC];
        // Initialize the Mapping.
        transactionAttachmentsMap = new Map<String, Map<String, String>> ();
        transactionAttachmentsUrlMap = new Map<Id, String> ();
        Set<Id> transactionFileIds = new Set<Id> ();
        // Loop through the file maps and creating a mapping based on filename.
        for (FileMap__c fileMap : transactionAttachments) {
            // Get the full filename including prefix if necessary for urls.
            String filename = (!String.isBlank(fileMap.S3_File__r.Prefix__c) ? fileMap.S3_File__r.Prefix__c + '/' + fileMap.S3_File__r.Filename__c : fileMap.S3_File__r.Filename__c);
            String[] filenameSplit = (fileMap.S3_File__r.Filename__c).split('\\.');
            // Generate an attribute map for the page.
            Map<String, String> fileAttributeMap = new Map<String, String> {
                'FileMap_Id' => fileMap.Id,
                    'File_Id' => fileMap.S3_File__r.Id,
                    'Bucket__c' => fileMap.S3_File__r.Bucket__c,
                    'Content_Type__c' => fileMap.S3_File__r.Content_Type__c,
                    'Prefix__c' => fileMap.S3_File__r.Prefix__c,
                    'Filename__c' => fileMap.S3_File__r.Filename__c
                    };
                        transactionAttachmentsMap.put(filenameSplit[0], fileAttributeMap);
            // Map the FileMap's temp urls for use on the page. 
            transactionAttachmentsUrlMap.put(fileMap.Id, EEC_S3ComponentCtrl.generateTempS3Url(fileMap.S3_File__r.Bucket__c, filename));
            // Add the file id to the ids list. 
            transactionFileIds.add(fileMap.S3_File__r.Id);
        }
        // Create a list of S3_File__c objects from the FileMap.
        List<S3_File__c> transactionFiles = [Select Id, Filename__c From S3_File__c Where Id IN :transactionFileIds];
        indoorAttachmentsJson = JSON.serialize(transactionFiles);
    }
    
    /**
* getAttachmentSpotlightText
* 
* This function will determine the type of license record and provide the correct description text needed for attachments.
* @author Darkis
*/
    public String getAttachmentSpotlightText() {
        String text = '';
        
        if (LicenseRecordTypeName.equalsIgnoreCase('FCC_New_License') || LicenseRecordTypeName.equalsIgnoreCase('GSA_New_License')
        || LicenseRecordTypeName.equalsIgnoreCase('Placement_New_License') || LicenseRecordTypeName.equalsIgnoreCase('Residential_New_License')) {
            text = leadConfiguration.Transaction_Attachments_New__c;
        } else if (LicenseRecordTypeName.equalsIgnoreCase('FCC_Renewal') || LicenseRecordTypeName.equalsIgnoreCase('GSA_Renewal')
        || LicenseRecordTypeName.equalsIgnoreCase('Placement_Renewal') || LicenseRecordTypeName.equalsIgnoreCase('Residential_License_Renewal')) {
            text = leadConfiguration.Transaction_Attachments_Renewal__c;
        } else if (LicenseRecordTypeName.equalsIgnoreCase('FCC_License_Upgrade') || LicenseRecordTypeName.equalsIgnoreCase('GSA_License_Change')
        || LicenseRecordTypeName.equalsIgnoreCase('Placement_Change_in_License') || LicenseRecordTypeName.equalsIgnoreCase('Residential_Change_in_License')) {
            text = leadConfiguration.Transaction_Attachments_Upgrade__c;
        }
        return text;
    }
    
    /**
* saveFileDescription
* 
* This function will save the new description for a specified file. 
* @author Darkis
* @param String fileToEditId The id of the file.
* @param String fileToEditDescription The new file description entered by the client.
*/
    public void saveFileDescription() {
        if (!String.isBlank(fileToEditId)) {
            S3_File__c file = [Select Id, Description__c From S3_File__c Where Id = :fileToEditId];
            file.Description__c = fileToEditDescription;
            update file;
        }
    }
    
    public List<EEC_Question> getBackgroundInformationQuestions() {
        if(providerRecordType == 'Family Child Care' && isFccAssistant) 
            providerRecordType = 'FCC Assistant'; 
        else if(providerRecordType == 'FCC Assistant' && !isFccAssistant)
            providerRecordType = 'Family Child Care'; 
        return EEC_QuestionService.getLicensingSectionQuestionsForProvider(
            EEC_QuestionService.Section.BackgroundInformation,
            providerRecordType
        );
    }
    
    /**
* getRequestedLicenseOptions
*    Gets the appropriate licence types based on the request and provider
*
* @return List<SelectOption> 
*/
    public List<SelectOption> getRequestedLicenseOptions() {
        List<SelectOption> options = new List<SelectOption> ();
        
        Schema.DescribeFieldResult fieldResult = Licensing_Transaction__c.License_Requested__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry f : ple)
        {
            if ((isFccAssistant && f.getLabel().containsIgnoreCase('Assistant') && !(LicenseRecordTypeName == 'FCC_Assistant_License_Upgrade' && f.getLabel() == 'Regular Assistant')) ||
                (!isFccAssistant && !f.getLabel().containsIgnoreCase('Assistant'))) {
                    options.add(new SelectOption(f.getLabel(), f.getValue()));
                }
        }
        
        return options;
    }
    
    /**
* DailyRandASave
*
* @description A one stop location for all traversal paths for the Daily Routine and Activities.
* @authour Darkis
* @param saveType Integer The save type attempted.
* @return PageReference 
*/
    public PageReference DailyRandASave() {
        PageReference pPage;
        Integer saveType = Integer.valueOf(ApexPages.currentPage().getParameters().get('saveType'));
        
        if (saveType == SAVE_AND_NEXT) {
            // Change the last step.
            licenseTransation.Last_Reached_Step__c = 'Background Information';
            // Setup the page.
            pPage = Page.EEC_BackgroundInformation;
            pPage.getParameters().put('ltId', licenseTransation.Id);
        } else if (saveType == SAVE_AND_PREVIOUS) {
            // Change the last step.
            licenseTransation.Last_Reached_Step__c = 'Daily Routine & Activities';
            // Setup the page.
            if(string.IsNotBlank(previousPageName)){
                if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                    pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
                    system.debug('previousPageName: ' + previousPageName);
                }
                else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                    pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                        || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                    pPage = EEC_Util.lastRPStepMap.get(previousPageName);
                }
            }
            else{
                if (LicenseRecordTypeName.equalsIgnoreCase('FCC_Assistant_Renewal')) {
                    pPage = (!licenseTransation.IsAssistantUpgradeToCertified__c
                             ? Page.EEC_TransactionProvider
                             : Page.EEC_AssistantInvolvementExperience);
                } else {
                    pPage = page.EEC_AssistantInvolvementExperience;
                }
            }
            pPage.getParameters().put('ltId', licenseTransation.Id);
        } else if (saveType == SAVE_AND_RETURN) {
            // Change the last step.
            licenseTransation.Last_Reached_Step__c = 'Daily Routine & Activities';
            // Setup the page.
            pPage = page.EEC_PortalProviderPage;
        }
        update licenseTransation;
        
        if (pPage != null) {
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
        }
        return pPage;
    }
    
    /**
* LicensingStatusCapacityInfoSave
*
* @description A one stop location for all traversal paths for the Licensing Status and Capacity.
* @authour Darkis
* @param saveType Integer The save type attempted.
* @return PageReference 
*/
    public PageReference LicensingStatusCapacityInfoSave() {
        PageReference pPage;
        Integer saveType = Integer.valueOf(ApexPages.currentPage().getParameters().get('saveType'));
        
        if (saveType == SAVE_AND_NEXT) {
            // Change the last step.
            licenseTransation.Last_Reached_Step__c = 'Assistant Information';
            // Setup the page.
            pPage = Page.EEC_Transaction_AssistantInfo;
            pPage.getParameters().put('ltId', licenseTransation.Id);
        } else if (saveType == SAVE_AND_PREVIOUS) {
            // Change the last step.
            licenseTransation.Last_Reached_Step__c = 'Licensing Status and Capacity';
            // Setup the page.
            if(string.IsNotBlank(previousPageName)){
                if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                    pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
                    system.debug('previousPageName: ' + previousPageName);
                }
                else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                    pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                        || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                    pPage = EEC_Util.lastRPStepMap.get(previousPageName);
                }
            }
            else{
                pPage = Page.EEC_HouseholdMembers;
            }
            pPage.getParameters().put('ltId', licenseTransation.Id);
        } else if (saveType == SAVE_AND_RETURN) {
            // Change the last step.
            licenseTransation.Last_Reached_Step__c = 'Licensing Status and Capacity';
            // Setup the page.
            if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
                pPage = page.EEC_PortalProviderPage;
            }
        }
        update licenseTransation;
        
        if (pPage != null) {
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
        }
        return pPage;
    }
    
    /**
* getIsAssistantUpgradeOrientationProvided
*
* @description This function will check if the assistant has already done a transaction with renewal or upgrade. 
* @author Darkis
* @return Boolean 
*/
    public Boolean getIsAssistantUpgradeOrientationProvided() {
        String ltRecordTypeName = '';
        List<Licensing_Transaction__c> transactionList = [Select Ownership_Type__c ,Id,New_Name__c,RecordType.DeveloperName, Took_FCC_Orientation__c, Assigned_User_Email__c From Licensing_Transaction__c Where Provider__c = :provider.Id AND Id != :licenseTransation.Id];
        
        if (transactionList != null && transactionList.size() > 0) {
            for (Licensing_Transaction__c lt : transactionList) {
                ltRecordTypeName = lt.RecordType.DeveloperName;
                if ((ltRecordTypeName == 'FCC_Assistant_Renewal' || ltRecordTypeName == 'FCC_Assistant_License_Upgrade') && lt.Took_FCC_Orientation__c != '') {
                    return true;
                }
            }
        }
        return false;
    }
    
    /**
* getIsAssistantReviewMode
*
* @description This function will check and see if the current summary page requested is the review or submit.
* @author Darkis
* @return Boolean 
*/
    public Boolean getIsAssistantReviewMode() {
        String mode = ApexPages.currentPage().getParameters().get('mode');
        return(mode != null && Integer.valueOf(mode) == MODE_REVIEW ? true : false);
    }
    
    /**
* editInstruction
*
* @description This function will sent the user to the correct last setup page from the view treansaction.
* @author Darkis
* @return Pagereference The page to send the user.
*/
    public Pagereference editInstruction() {
        PageReference pPage;
        system.debug('1');
        system.debug('licenseTransation.Last_Reached_Step__c: ' + licenseTransation.Last_Reached_Step__c);
        system.debug('providerRecordType: ' + providerRecordType);
        if(licenseTransation.Last_Reached_Step__c == 'Attachments'){
            system.debug('2');
            if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                pPage = Page.EEC_LicenseTransactionAttachments;
            }
            else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                pPage = Page.EEC_LicensingAttachment;
            }
            else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                    || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                pPage = Page.EEC_LicensingAttachment;
            }
            else{
                pPage = Page.EEC_LicensingAttachment;
            }
            system.debug('3');
        }
        else if(licenseTransation.Last_Reached_Step__c == 'Review Summary and Submission'){
            system.debug('4');
            if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                pPage = Page.EEC_ReviewSummarySubmission;
            }
            else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                pPage = Page.EEC_GSAReviewSummary;
            }
            else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                    || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                pPage = Page.EEC_RP_ReviewSummary;
            }
            else{
                pPage = Page.EEC_GSAReviewSummary;
            }
            system.debug('5');
        }
        else{
            system.debug('6');
            pPage = EEC_Util.lastStepMap.get(licenseTransation.Last_Reached_Step__c);
        }
        pPage.getParameters().put('ltId', licenseTransation.Id);
        pPage.setRedirect(true);
        return pPage;
    }
    
    /**
* LicensingStatusCapacityInfoSave
*
* @description A one stop location for all traversal paths for the Licensing Status and Capacity.
* @authour Darkis
* @param saveType Integer The save type attempted.
* @return PageReference 
*/
    public PageReference AssistantInfoSave() {
        PageReference pPage;
        Integer saveType = Integer.valueOf(ApexPages.currentPage().getParameters().get('saveType'));
        
        if (saveType == SAVE_AND_NEXT) {
            // Change the last step.
            licenseTransation.Last_Reached_Step__c = (LicenseRecordTypeName == 'FCC_New_License' ? 'EEC Involvement Experience & Professional Exp.' : 'Background Information');
            // Setup the page.
            pPage = (LicenseRecordTypeName == 'FCC_New_License' ? Page.EEC_InvolvementExperience : Page.EEC_BackgroundInformation);
            pPage.getParameters().put('ltId', licenseTransation.Id);
        } else if (saveType == SAVE_AND_PREVIOUS) {
            // Change the last step.
            licenseTransation.Last_Reached_Step__c = 'Assistant Information';
            // Setup the page.
            if(string.IsNotBlank(previousPageName)){
                if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                    pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
                    system.debug('previousPageName: ' + previousPageName);
                }
                else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                    pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                        || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                    pPage = EEC_Util.lastRPStepMap.get(previousPageName);
                }
            }
            else{
                pPage = Page.EEC_LicenseStatusCapacityInfo;
            }
            pPage.getParameters().put('ltId', licenseTransation.Id);
        } else if (saveType == SAVE_AND_RETURN) {
            // Change the last step.
            licenseTransation.Last_Reached_Step__c = 'Assistant Information';
            // Setup the page.
            if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
                pPage = page.EEC_PortalProviderPage;
            }
        }
        update licenseTransation;
        
        if (pPage != null) {
            addMemberIDPageParameter(pPage, true);
            pPage.setRedirect(true);
            return pPage;
        }
        else{
            return new PageReference('javascript:window.close()');
        }
    } 
    
    /**
    * getCtrlInstance
    * 
    * This function will return an instance of this controller with interface reference.
    * @author Darkis
    * @return EEC_TransactionWizardController
    */
    public EEC_TransactionWizardController getCtrlInstance() {
        return this;
    }
    
    /*-----Interface Methods-----*/
    public void updateAssistantWrapperList(List<EEC_AssistantListCtrl.AssistantInfoWrap> providerAssistantWrappers) {
        
    }
    public void updateContactRoleWrapperList (List<EEC_ContactRoleListCtrl.ContactRoleInfoWrap> ContactRoleInfoWrappers) {
        
    }
    
    public void updateVarianceWrapperList(List<EEC_VarianceListCtrl.VarianceInfoWrap> varianceInfoWrappers){
        this.varianceInfoWrappers = varianceInfoWrappers;
    }
    
    public Licensing_Transaction__c getBaseLicenseTransaction() {
        return licenseTransation;
    }
    
    public String getBaseLicenseRecordTypeName() {
        return LicenseRecordTypeName;
    }
    
    /***************************************GSA*******************************/
    
    public List<selectOption> getContactList(){     
        List<Contact> conList = [select FirstName, LastName from Contact where AccountId = :provider.Id];
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('', '--Select--'));
        options.add(new SelectOption('New Individual', 'New Individual'));
        for(Contact contact : conList){         
            options.add(new SelectOption(contact.Id, contact.FirstName  + ' ' + contact.LastName));
        }        
        return options;
    }
    
    public void doSelectUmbrella(){     
        if(string.isNotBlank(selectedUmbrellaId)){
            umbrella = [select Id, Name, State__c, Provider_city_text__c, 
                        Provider_Address_1__c, Provider_Address_2__c, Provider_City__c, Provider_City__r.Name, Provider_Zip_Code__c
                        from Account where Id=: selectedUmbrellaId];            
        }
    }
    
    public void doSelectDocument(){     
       String documentId = ApexPages.currentPage().getParameters().get('documentId');
       String documentName = ApexPages.currentPage().getParameters().get('documentName');
       
       String clickedId = ApexPages.currentPage().getParameters().get('clickedId');
       String clickedType = ApexPages.currentPage().getParameters().get('clickedType');
       String documentTypeId = ApexPages.currentPage().getParameters().get('documentTypeId');

       List<Transaction_Document__c> listtransactionDocument = new List<Transaction_Document__c>();
       
       Transaction_Document__c transactionDocument = new Transaction_Document__c();
       
       if(clickedType == 'Required' || clickedType == 'Optional'){
        List<Transaction_Document__c> listTransDocument = [select Id from Transaction_Document__c where
                                    Licensing_Transaction__c =: licenseTransation.Id and 
                                    Mode__c =: clickedType and Document_Type__c=: documentTypeId];
        EEC_ContactRoleUtil.deleteTransactionDocuments(listTransDocument);
       }
       else if(clickedType == 'Individual'){
        /*List<Transaction_Document__c> listTransDocument = [select Id from Transaction_Document__c where
                                    Licensing_Transaction__c =: licenseTransation.Id and
                                    Mode__c =: clickedType and Document_Type__c=: documentTypeId
                                    and Contact_Role__c =: clickedId];
        EEC_ContactRoleUtil.deleteTransactionDocuments(listTransDocument);*/
       }
       //transactionDocument.Date_Attached__c = system.today();
       
       transactionDocument.Document__c = documentId;
       transactionDocument.Licensing_Transaction__c = licenseTransation.Id;

       if(string.isNotBlank(documentTypeId))
        transactionDocument.Document_Type__c = documentTypeId;
       transactionDocument.Mode__c = clickedType;
       transactionDocument.Status__c = 'New Attachment';
       if(clickedType == 'Variance'){
        transactionDocument.Variance_on_Regulation__c = clickedId;
       }
       else if(clickedType == 'Individual'){
        //transactionDocument.Contact_Role__c = clickedId;
       }
       //transactionDocument.Name = documentName;

       listtransactionDocument.add(transactionDocument);
       
       EEC_ContactRoleUtil.upsertTransactionDocument(listtransactionDocument);     
       
       doGetAttachmentList();
    }
    
    public void newAdminHead(){
        if(selectedContact == 'New Individual'){
            administrativehead = new ContactRoleWrapperclass(true,true,null, null);
        }
        else if(String.isempty(selectedContact)){
            administrativehead = null;
        }
        else{
            Contact contact = [select Id, FirstName, LastName, Title, Email, Phone, MailingStreet,
             MailingCity, MailingPostalCode, MailingState, Role__c, Holds_FCC_License__c,Accountid from Contact where Id=: selectedContact];
            
            if(contact != null){
                administrativehead = new ContactRoleWrapperclass(false,true,contact, null); 
            }
        }
    }
    
    public void newBoardHead(){
        if(selectedBoardContact == 'New Individual'){
            designateboard = new ContactRoleWrapperclass(true,true,null, null);
        }
        else if(String.isempty(selectedBoardContact)){
            designateboard = null;
        }
        else{
            Contact contact = [select Id, FirstName, LastName, Title, Email, Phone, MailingStreet,
             MailingCity, MailingPostalCode, MailingState, Role__c, Holds_FCC_License__c,Accountid from Contact where Id=: selectedBoardContact];
            if(contact != null){
                designateboard = new ContactRoleWrapperclass(false,true,contact, null); 
            }
        }
    }
    
    //Type of Ownership
    public List<SelectOption> gettypeOfOwnership() {
        List<SelectOption> options = new List<SelectOption> ();
        if(LicenseRecordTypeName == 'GSA_New_License'||LicenseRecordTypeName == 'GSA_Move'||LicenseRecordTypeName == 'GSA_Renewal'||LicenseRecordTypeName == 'GSA_Change_of_Admin_Authority'){
            options.add(new SelectOption('Doing Business As (DBA)', 'Doing Business As (DBA)'));
            options.add(new SelectOption('Non-Profit Corp.', 'Non-Profit Corp.'));
            options.add(new SelectOption('For Profit Corp.', 'For Profit Corp.'));
            options.add(new SelectOption('Partnership', 'Partnership'));
            options.add(new SelectOption('Individual', 'Individual'));
            options.add(new SelectOption('LLC', 'LLC'));
        }
        else if(LicenseRecordTypeName == 'Placement_New_License' || LicenseRecordTypeName == 'Residential_New_License' 
                || LicenseRecordTypeName == 'Placement_Move' || LicenseRecordTypeName == 'Residential_Move' || LicenseRecordTypeName == 'Residential_License_Renewal'
               || LicenseRecordTypeName == 'Placement_Renewal' || LicenseRecordTypeName == 'Residential_Renewal'
               || LicenseRecordTypeName == 'Placement_Change_of_Admin_Authority' || LicenseRecordTypeName == 'Residential_Change_of_Admin_Authority'
               || LicenseRecordTypeName == 'R_P_Change_of_Admin_Authority'){                   
            options.add(new SelectOption('Non-Profit Corp.', 'Non-Profit Corp.'));
            options.add(new SelectOption('For Profit Corp.', 'For Profit Corp.'));
            options.add(new SelectOption('Partnership', 'Partnership'));
            options.add(new SelectOption('Individual', 'Individual'));
            options.add(new SelectOption('Unincorporated', 'Unincorporated'));
        }
        return options;
    }
    public boolean userAssociatedtoUmbrella{get;set;}
    public void pullContactRole(){      
        if(licenseTransation.Contact_Roles_Copied__c == false &&
        (
        LicenseRecordTypeName == 'Placement_Renewal' || LicenseRecordTypeName == 'Placement_Move' || 
        LicenseRecordTypeName == 'Placement_License_Change' || 
        LicenseRecordTypeName == 'Placement_Change_of_Admin_Authority' ||
        LicenseRecordTypeName == 'Residential_Renewal' || LicenseRecordTypeName == 'Residential_Move' || 
        LicenseRecordTypeName == 'Residential_License_Change' || 
        LicenseRecordTypeName == 'Residential_Change_of_Admin_Authority'
        )){
            List<Contact_Role__c> listContactRole = [select Id, Name, Contact__c,
            End_Date__c, End_Role_Licensing_Transaction__c, Portal_Access__c, Provider__c, Role__c,
            Schedule_Administrative_Hours__c, Schedule_Teaching_Hours__c, Start_Date__c, Start_Role_Licensing_Transaction__c
            from Contact_Role__c where Provider__c =: licenseTransation.Provider__c
            and (Role__c = 'Partner' or Role__c = 'Administrative Designee')
             and Current_Formula__c = true];
           
           List<Contact_Role__c> listNewContactRole = new List<Contact_Role__c>();
            
            for(Contact_Role__c contactRole : listContactRole){
                Contact_Role__c newContactRole = contactRole.clone(false, false, false, false);
                newContactRole.Start_Role_Licensing_Transaction__c = licenseTransation.Id;
                listNewContactRole.add(newContactRole);
            }
            EEC_ContactRoleUtil.upsertContactRole(listNewContactRole);
            
            licenseTransation.Contact_Roles_Copied__c = true;
            
            licenseTransation = EEC_ContactRoleUtil.updateLicensingTransaction(licenseTransation);
        }
        
        if(LicenseRecordTypeName != 'GSA_New_License' && LicenseRecordTypeName != 'Placement_New_License' && LicenseRecordTypeName != 'Residential_New_License'){
            licenseTransation.Ownership_Type__c = licenseTransation.Provider__r.Type_of_Ownership__c;
            if(licenseTransation.Provider__r.Type_of_Ownership__c == 'Doing Business As (DBA)'){
              licenseTransation.Ownership_Type__c = 'Doing Business As (DBA)';
            }
            else if(licenseTransation.Provider__r.Type_of_Ownership__c == 'Non-profit Corp.'){
              licenseTransation.Ownership_Type__c = 'Non-Profit Corp.';
            }
            else if(licenseTransation.Provider__r.Type_of_Ownership__c == 'For-profit Corp.'){
              licenseTransation.Ownership_Type__c = 'For Profit Corp.';
            }
            else if(licenseTransation.Provider__r.Type_of_Ownership__c == 'Partnership'){
              licenseTransation.Ownership_Type__c = 'Partnership';
            }
            else if(licenseTransation.Provider__r.Type_of_Ownership__c == 'Individual'){
              licenseTransation.Ownership_Type__c = 'Individual';
            }
        }
        if(contactrolelist == null){
            contactrolelist = new list<ContactRoleWrapperclass>();
        }
        if(!Test.isRunningTest()){
            //User UserRecord  = [SELECT id,Contact.Account.RecordTypeID,Contact.Accountid FROM USER WHERE id =: UserInfo.getUserId()];
            if(Schema.SObjectType.Account.getRecordTypeInfosById().get(licenseTransation.Provider__r.RecordTypeID).getname() == 'Umbrella'){
                userAssociatedtoUmbrella = true;
                umbrella = [SELECT id,Name,Provider_Address_1__c,Provider_Address_2__c,Provider_City__c,Provider_city_text__c,Provider_Zip_Code__c,State__c FROM Account WHERE id =: licenseTransation.Provider__c];
            }else if(licenseTransation.Umbrella__c != null){
                umbrella = [SELECT id,Name,Provider_Address_1__c,Provider_Address_2__c,Provider_City__c,Provider_city_text__c,Provider_Zip_Code__c,State__c FROM Account WHERE id =: licenseTransation.Umbrella__c];     
            }
        }
        else{
            if(licenseTransation.Umbrella__c != null)
                umbrella = [SELECT id,Name,Provider_Address_1__c,Provider_Address_2__c,Provider_City__c,Provider_city_text__c,Provider_Zip_Code__c,State__c FROM Account WHERE id =: licenseTransation.Umbrella__c];
        }
        if(contactAdminRoleList == null){
            contactAdminRoleList = new List<ContactRoleWrapperclass>();
        }
        List<Contact_Role__c> tempcontactrole = new  List<Contact_Role__c>();
        /**Check Ownership type**/
        
        String query = 'SELECT id, Name,Current_Formula__c,Contact__c,Contact__r.FirstName,Contact__r.LastName,Contact__r.MailingStreet,Contact__r.MailingCity,Contact__r.MailingPostalCode,Contact__r.MailingState,Contact__r.Phone,Contact__r.Email,Contact__r.Holds_FCC_License__c,End_Date__c,End_Role_Licensing_Transaction__c,Portal_Access__c,Provider__c,Role__c,Schedule_Administrative_Hours__c,Schedule_Teaching_Hours__c,Start_Date__c,Start_Role_Licensing_Transaction__c,Contact__r.Title,Contact__r.Role__c FROM Contact_Role__c ';
        query = query + 'WHERE Provider__c=\''+licenseTransation.Provider__c+'\' ORDER BY Start_Date__c ASC NULLS FIRST';
        
        tempcontactrole = Database.query(query);
        
        for(Contact_Role__c contactrecord:tempcontactrole){         
            //if((contactrecord.Role__c == 'Partner' && contactrecord.Start_Role_Licensing_Transaction__c == licenseTransation.id && LicenseRecordTypeName != 'GSA_New_License') || (LicenseRecordTypeName == 'GSA_New_License' && contactrecord.Role__c == 'Partner' && contactrecord.Current_Formula__c == true)){
            if((contactrecord.Role__c == 'Partner' && contactrecord.Current_Formula__c == true && LicenseRecordTypeName != 'GSA_New_License') || (contactrecord.Role__c == 'Partner' && (contactrecord.Start_Role_Licensing_Transaction__c == licenseTransation.id || contactrecord.End_Role_Licensing_Transaction__c == licenseTransation.id))){   
                ContactRoleWrapperclass wrapperrecord = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);                
                contactrolelist.add(wrapperrecord);    
            }
            else if(contactrecord.Role__c == 'Administrative Designee' && (contactrecord.Start_Role_Licensing_Transaction__c == licenseTransation.id || (contactrecord.End_Role_Licensing_Transaction__c == licenseTransation.id && contactrecord.Current_Formula__c == true))){
                ContactRoleWrapperclass wrapperrecord = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);                
                contactAdminRoleList.add(wrapperrecord);    
            }
            else if(contactrecord.Role__c == 'Program Director / Administrative Head' && contactrecord.End_Role_Licensing_Transaction__c == licenseTransation.id && contactrecord.Current_Formula__c == true){
                adminHead = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);
            }
            else if(contactrecord.Role__c == 'Program Director / Administrative Head'  && contactrecord.End_Role_Licensing_Transaction__c == null && contactrecord.End_Date__c == null){
                administrativehead = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);
                selectedContact = contactrecord.Contact__c;
            }
            else if((contactrecord.Role__c == 'Board Chair' && contactrecord.End_Role_Licensing_Transaction__c == licenseTransation.id && contactrecord.Current_Formula__c == true)){
                boardchair = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);            
            }
            else if(contactrecord.Role__c == 'Board Chair' && contactrecord.End_Role_Licensing_Transaction__c == null && contactrecord.End_Date__c == null){
                designateboard = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);
                selectedBoardContact = contactrecord.Contact__c;
            }
            else if(contactrecord.Role__c == 'Owner' && (contactrecord.Start_Role_Licensing_Transaction__c == licenseTransation.id || (contactrecord.End_Role_Licensing_Transaction__c == licenseTransation.id && contactrecord.Current_Formula__c == true))){
                ownerContactRole = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);
                if(contactrecord.Contact__r.Holds_FCC_License__c){
                    ownerContactRole.holdFCCLicense = 'Yes';
                    }else{
                    ownerContactRole.holdFCCLicense = 'No';} 
            }
        }
        for(Contact_Role__c contactrecord:tempcontactrole){
            if(contactrecord.Role__c == 'Program Director / Administrative Head'  && contactrecord.Current_Formula__c == true && contactrecord.Start_Role_Licensing_Transaction__c != licenseTransation.id && contactrecord.End_Role_Licensing_Transaction__c != licenseTransation.id ){
                existingDirector = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);
            }
            if(contactrecord.Role__c == 'Board Chair' && contactrecord.Current_Formula__c == true && contactrecord.Start_Role_Licensing_Transaction__c != licenseTransation.id && contactrecord.End_Role_Licensing_Transaction__c != licenseTransation.id ){
                existingBoardChair = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);            
            }
            if((contactrecord.Role__c == 'Board Chair' && contactrecord.Current_Formula__c == true) && boardchair == null){
                boardchair = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);
            }
            if(contactrecord.Role__c == 'Program Director / Administrative Head'  && contactrecord.Current_Formula__c == true && adminHead == null){
                adminHead = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);
            }
        }
        if(ownerContactRole == null){
            ownerContactRole = new ContactRoleWrapperclass(true,true,null, null);
        }
    }
    
    
    public string stringvalueoflicenseApprovedByAgency{get;set;}
    public string stringValueofuseofPhysicalrestraints{get;set;}
    public void initGSA_RSubmissionPage(){
        String ltId = ApexPages.currentPage().getParameters().get('ltId');
        if (String.isNotBlank(ltId)) {
            getLicenseTrans(ltId);
        }
          licensesheld = new List<Additional_Information__c>();
          licensesinprogress = new List<Additional_Information__c>();
          criminalaction = new List<Additional_Information__c>();
          investigation = new List<Additional_Information__c>();

        if(licenseTransation.Program_licensed_or_approved_by_agency__c){
            stringvalueoflicenseApprovedByAgency = 'Yes';
        }else{
            stringvalueoflicenseApprovedByAgency = 'No';
        }
          if(licenseTransation.Is_your_program_contracted__c){
                    programcontracted= 'Yes';
                }else{
                    programcontracted = 'No';
                } 
        if(contactrolelist == null){
            contactrolelist = new list<ContactRoleWrapperclass>();
        }
        List<Contact_Role__c> tempcontactrole = new  List<Contact_Role__c>();
        String query = 'SELECT id, Name,Current_Formula__c,Contact__c,Contact__r.FirstName,Contact__r.LastName,Contact__r.MailingStreet,Contact__r.MailingCity,Contact__r.MailingPostalCode,Contact__r.MailingState,Contact__r.Phone,Contact__r.Email,Contact__r.Holds_FCC_License__c,End_Date__c,End_Role_Licensing_Transaction__c,Portal_Access__c,Provider__c,Role__c,Schedule_Administrative_Hours__c,Schedule_Teaching_Hours__c,Start_Date__c,Start_Role_Licensing_Transaction__c,Contact__r.Title,Contact__r.Role__c FROM Contact_Role__c ';
        query = query + 'WHERE Provider__c=\''+licenseTransation.Provider__c+'\'';
        
        tempcontactrole = Database.query(query);
        for(Contact_Role__c contactrecord:tempcontactrole){
            if(contactrecord.Role__c == 'Partner'){
                ContactRoleWrapperclass wrapperrecord = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);
                contactrolelist.add(wrapperrecord);    
            }
            else if(contactrecord.Role__c == 'Owner' && contactrecord.Current_Formula__c == true){
                ownerContactRole = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);
                if(ownerContactRole.contact.Holds_FCC_License__c){
                    GroupType = 'Yes';
                }else{
                    GroupType = 'No';
                } 
            }
            else if(contactrecord.Role__c == 'Program Director / Administrative Head' && contactrecord.End_Role_Licensing_Transaction__c == licenseTransation.id && contactrecord.Current_Formula__c == true){
                adminHead = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);
            }
            else if(contactrecord.Role__c == 'Program Director / Administrative Head'  && contactrecord.End_Role_Licensing_Transaction__c == null && contactrecord.End_Date__c == null){
                administrativehead = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);
            }
            else if(contactrecord.Role__c == 'Administrative Designee'){
                designateboard = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);
                if(designateboard.contactrole.Portal_Access__c){
                designatedboardcheckedrp = 'Yes';
                }
                else{
                designatedboardcheckedrp = 'No';
                }
            }
            else if(contactrecord.Role__c == 'Board Chair'  && contactrecord.End_Role_Licensing_Transaction__c == null && contactrecord.End_Date__c == null){
                boardchair = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);       
            }
            if(contactrecord.End_Role_Licensing_Transaction__c == licenseTransation.id && contactrecord.Role__c == 'Board Chair' && contactrecord.Current_Formula__c == true){
                   pboardchair = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);
            }
        }
        
        for(Contact_Role__c contactrecord:tempcontactrole){
            if(administrativehead == null && contactrecord.Role__c == 'Program Director / Administrative Head'  && contactrecord.Current_Formula__c && contactrecord.End_Role_Licensing_Transaction__c != licenseTransation.id && contactrecord.Start_Role_Licensing_Transaction__c != licenseTransation.id){
                administrativehead = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord);
            }
            if(contactrecord.Role__c == 'Board Chair' && contactrecord.Current_Formula__c == true && boardchair == null && contactrecord.End_Role_Licensing_Transaction__c != licenseTransation.id && contactrecord.Start_Role_Licensing_Transaction__c != licenseTransation.id){                
                boardchair = new ContactRoleWrapperclass(false,false,contactrecord.contact__r, contactrecord); 
            }
        }
        
        List<Additional_Information__c> listAdditionalInfo = [Select Id,Name_of_Licensee__c
                                                ,State_Country_Issuing_the_License__c
                                                ,Provider__r.Type_of_Ownership__c 
                                                ,RecordTypeID
                                                ,License_Number__c
                                                ,Name_of_Applicant__c
                                                ,State_Country_of_Applicant__c
                                                ,Name_of_Licensing_Authority__c
                                                ,Address_of_Licensing_authority__c
                                                ,Phone_No_of_Licensing_Authority__c
                                                ,Status_of_Application__c
                                                ,Name_Admin_civil_criminal_action__c
                                                ,Nature_of_Proceedings__c
                                                ,   Caption__c
                                                ,Docket_Number__c
                                                ,Name_of_court_or_administrative_body__c
                                                ,Address_of_court__c
                                                ,Disposition__c
                                                ,Name_of_Person_Agency_Investigated__c
                                                ,State_and_or_Federal_Agency__c
                                                ,Nature_of_Investigation__c,Type_of_License__c  From Additional_Information__c 
                                                where Licensing_Transaction__c =: licenseTransation.Id];
                                                
        if(listAdditionalInfo != null && listAdditionalInfo.size() >0){            
            for(Additional_Information__c additionalInfoRecord : listAdditionalInfo){
                if(Schema.SObjectType.Additional_Information__c.getRecordTypeInfosById().get(additionalInfoRecord.recordtypeid).getname() == 'Other Licenses Held'){
                    licensesheld.add(additionalInfoRecord);
                }
                if(Schema.SObjectType.Additional_Information__c.getRecordTypeInfosById().get(additionalInfoRecord.recordtypeid).getname() == 'Other License Applications'){
                    licensesinprogress.add(additionalInfoRecord);
                }
                if(Schema.SObjectType.Additional_Information__c.getRecordTypeInfosById().get(additionalInfoRecord.recordtypeid).getname() == 'Admin/civil/criminal action detail'){
                    criminalaction.add(additionalInfoRecord);
                }
                if(Schema.SObjectType.Additional_Information__c.getRecordTypeInfosById().get(additionalInfoRecord.recordtypeid).getname() == 'State/federal investigation detail'){
                    investigation.add(additionalInfoRecord);
                }
            }
        }
        if(licenseTransation.Lead_Paint_Compliance__c == 'Yes'){
            Constructedpost= 'Yes'; 
        }else{
          Constructedpost= 'No'; 
        }
        if(licenseTransation.Lead_Paint_Detailed_Inspection__c == 'Yes'){
            DetailedInspection= 'Yes'; 
        }else{
          DetailedInspection= 'No'; 
        }
         if(licenseTransation.Use_of_physical_restraints1__c== 'Yes'){
            physicalrestraints= 'Yes'; 
        }else{
          physicalrestraints= 'No';   
        }
        if(ownerContactRole != null){
            if(ownerContactRole.contact.Holds_FCC_License__c == true){
                GroupType= 'Yes'; 
            }
        }
        else{
              GroupType= 'No';   
            }            
    }

     public void delAttachment(){        
        string rowNum = apexpages.currentpage().getparameters().get('index');      
        if(string.isNotBlank(rowNum)){
            Transaction_Document__c transactionDocument = [select Id from Transaction_Document__c
            where Id =: rowNum limit 1];
            
            if(transactionDocument != null)
                EEC_ContactRoleUtil.DeleteTransactionDocument(transactionDocument);
        }
        doGetAttachmentList();
    }
    
    public void addcontactrole(){
        if (contactRoleList == null) {
            contactRoleList = new List<ContactRoleWrapperclass> ();
        }
        contactRoleList.add(new ContactRoleWrapperclass(true,true,null,null));
    }
    
    public void delcontactRole()
    {
        if (contactRoleList == null) {
            contactRoleList = new List<ContactRoleWrapperclass> ();
        }
        if (removeRoleList == null) {
            removeRoleList = new List<Contact_Role__c> ();
        }
        
        rowNum = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        
        ContactRoleWrapperclass rm = contactRoleList.get(rowNum);
        if (String.isNotBlank(rm.contactrole.Id)) {
            removeRoleList.add(new Contact_Role__c(id = contactRoleList.get(rowNum).contactrole.Id));
        }
        contactRoleList.remove(rowNum);
    }
    
    public void addadmincontactrole(){
        if (contactAdminRoleList== null) {
            contactAdminRoleList = new List<ContactRoleWrapperclass> ();
        }
        contactAdminRoleList.add(new ContactRoleWrapperclass(true,true,null, null));
    }
    
    public void deladmincontactRole()
    {
        if (contactAdminRoleList == null) {
            contactAdminRoleList= new List<ContactRoleWrapperclass> ();
        }
        if (removeRoleList == null) {
            removeRoleList = new List<Contact_Role__c> ();
        }
        
        rowNum = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        ContactRoleWrapperclass rm = contactAdminRoleList.get(rowNum);
        if (String.isNotBlank(rm.contactrole.Id)) {
            removeRoleList.add(new Contact_Role__c(id = contactAdminRoleList.get(rowNum).contactrole.id));
        }
        contactAdminRoleList.remove(rowNum);
    }
    
    public void copyAll(){
        provider.Records_Responsible__c = provider.Account_books_Responsible__c;
        provider.Personnel_Records_Responsible__c = provider.Account_books_Responsible__c;
        provider.Children_s_Records_Responsible__c = provider.Account_books_Responsible__c;
        provider.Financial_Documentation_Responsible__c =provider.Account_books_Responsible__c;
        provider.Staff_Schedules_Responsible__c =provider.Account_books_Responsible__c;
        
        provider.Early_Childhood_Education_Program_Resp__c = provider.Account_books_Responsible__c;
        provider.Kindergarten_Responsible__c = provider.Account_books_Responsible__c;
        provider.School_Age_Responsible__c = provider.Account_books_Responsible__c;
        provider.Services_for_Children_w_Disability_Resp__c =provider.Account_books_Responsible__c;
        provider.Daily_Activities_Responsible__c =provider.Account_books_Responsible__c;
        provider.Equipment_Responsible__c =provider.Account_books_Responsible__c;
        
        provider.Staff_Development_Responsible__c = provider.Account_books_Responsible__c;
        provider.Staff_Training_Responsible__c =provider.Account_books_Responsible__c;
        provider.Staff_Orientation_Responsible__c =provider.Account_books_Responsible__c;
        provider.Staff_Supervision_Responsible__c = provider.Account_books_Responsible__c;
        provider.Parent_Involvement_Responsible__c = provider.Account_books_Responsible__c;
        provider.Social_Services_Responsible__c =provider.Account_books_Responsible__c;
        provider.Infant_Toddler_Program_Responsible__c =provider.Account_books_Responsible__c;
        
    }
    public void copyBusinessSec(){
        provider.Records_Responsible__c = provider.Account_books_Responsible__c;
        provider.Personnel_Records_Responsible__c = provider.Account_books_Responsible__c;
        provider.Children_s_Records_Responsible__c = provider.Account_books_Responsible__c;
        provider.Financial_Documentation_Responsible__c =provider.Account_books_Responsible__c;
        provider.Staff_Schedules_Responsible__c =provider.Account_books_Responsible__c;
    }
    
    public void copyDevelopSec(){        
        provider.Kindergarten_Responsible__c = provider.Early_Childhood_Education_Program_Resp__c;
        provider.School_Age_Responsible__c = provider.Early_Childhood_Education_Program_Resp__c;
        provider.Services_for_Children_w_Disability_Resp__c =provider.Early_Childhood_Education_Program_Resp__c;
        provider.Daily_Activities_Responsible__c =provider.Early_Childhood_Education_Program_Resp__c;
        provider.Equipment_Responsible__c =provider.Early_Childhood_Education_Program_Resp__c;
    }
    public void copyOtherSec(){        
        provider.Staff_Training_Responsible__c =provider.Staff_Development_Responsible__c;
        provider.Staff_Orientation_Responsible__c =provider.Staff_Development_Responsible__c;
        provider.Staff_Supervision_Responsible__c = provider.Staff_Development_Responsible__c;
        provider.Parent_Involvement_Responsible__c = provider.Staff_Development_Responsible__c;
        provider.Social_Services_Responsible__c =provider.Staff_Development_Responsible__c;
        provider.Infant_Toddler_Program_Responsible__c =provider.Staff_Development_Responsible__c;        
    }
    
    public Pagereference SaveAndNextOwnership() {
        try {
            Save('Next');
            if(LicenseRecordTypeName == 'GSA_License_Change' || LicenseRecordTypeName == 'Placement_Change_in_License' || LicenseRecordTypeName == 'Residential_Change_in_License'){
                PageReference pPage = Page.EEC_CapacityInformation;
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage, false);
                pPage.setRedirect(true);
                return pPage;
            }else  if(LicenseRecordTypeName == 'GSA_New_License'  || LicenseRecordTypeName == 'GSA_Renewal' || LicenseRecordTypeName == 'GSA_Move' || LicenseRecordTypeName == 'GSA_Change_of_Admin_Authority'){
                PageReference pPage = Page.EEC_DesignationOfAdministrative;
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage, false);
                pPage.setRedirect(true);
                return pPage;
            }
            else  if(LicenseRecordTypeName == 'Residential_New_License'
                || LicenseRecordTypeName == 'Residential_License_Renewal'
                || LicenseRecordTypeName == 'Residential_Move' || LicenseRecordTypeName == 'Residential_Renewal' ){
                PageReference pPage = Page.EEC_ResidentialProgramDetail;
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage, false);
                pPage.setRedirect(true);
                return pPage;
            }
            else  if(LicenseRecordTypeName == 'Placement_New_License'
                || LicenseRecordTypeName == 'Placement_Renewal' || LicenseRecordTypeName == 'Placement_Move' || 
                    LicenseRecordTypeName == 'Placement_License_Change'){
               // PageReference pPage = Page.EEC_AdditionalInformation; 
                   PageReference pPage = Page.EEC_PlacementAgency;
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage, false);
                pPage.setRedirect(true);
                return pPage;
            }
            else  if(LicenseRecordTypeName == 'R_P_Change_of_Admin_Authority'){
                PageReference pPage = Page.EEC_TechnicalAssistance;
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage, false);
                pPage.setRedirect(true);
                return pPage;
            }
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
            system.debug('Error: ' + e.getMessage());
        }
        return null;
    }
    
    private void Save(String direction){
        if(LicenseRecordTypeName == 'GSA_New_License'  || LicenseRecordTypeName == 'GSA_Renewal' || LicenseRecordTypeName == 'GSA_Move' || LicenseRecordTypeName == 'GSA_Change_of_Admin_Authority'){
            if(direction == 'Next'){
                licenseTransation.Last_Reached_Step__c = 'Designation of Administrative Responsibility';
            }            
        }
        if(LicenseRecordTypeName == 'GSA_License_Change' ){
            if(direction == 'Next'){
                licenseTransation.Last_Reached_Step__c = 'Capacity Information';
            }
        }
        if(direction == 'Previous' || direction == 'Return'){
            licenseTransation.Last_Reached_Step__c = 'Ownership and Administrator Info';
        }
        if(havesiteCordinator == 'Yes'){
            licenseTransation.Want_Designated_Primary_Contact__c = true;
        }else{
            licenseTransation.Want_Designated_Primary_Contact__c = false;
        }
        if(string.isNotEmpty(selectedUmbrellaId) && (licenseTransation.Ownership_Type__c == 'Non-Profit Corp.' || licenseTransation.Ownership_Type__c == 'For Profit Corp.' || licenseTransation.Ownership_Type__c == 'LLC')){
            licenseTransation.Umbrella__c = selectedUmbrellaId;
        }

        licenseTransation = EEC_ContactRoleUtil.updateLicensingTransaction(licenseTransation);
        List<Contact_Role__c> listContactRoles = new List<Contact_Role__c>();
        set<id> existingContactSet = new set<id>();
        list<Contact> listInsertContacts = new list<Contact>();
        list<Contact> listUpdateContacts = new list<Contact>();
        Set<Id> setContact = new Set<Id>();
        
        if(licenseTransation.Ownership_Type__c == 'Partnership' && LicenseRecordTypeName != 'GSA_License_Change'){
            for(ContactRoleWrapperclass contactRoleWrapper : contactrolelist){
                if(contactRoleWrapper.holdFCCLicense == 'Yes'){
                    contactRoleWrapper.contact.Holds_FCC_License__c = true;
                }else{
                    contactRoleWrapper.contact.Holds_FCC_License__c = false;
                }
                if(contactRoleWrapper.isNew){
                    contactRoleWrapper.contact.AccountId = provider.Id;
                    listInsertContacts.add(contactRoleWrapper.contact);
                }
                else{
                    if(!setContact.contains(contactRoleWrapper.contact.Id)){
                        setContact.add(contactRoleWrapper.contact.Id);
                        listUpdateContacts.add(contactRoleWrapper.contact);
                    }
                }
            }
        }
        if(LicenseRecordTypeName != 'GSA_License_Change'){
            for(ContactRoleWrapperclass contactRoleWrapper : contactAdminRoleList){
                if(contactRoleWrapper.isNew){
                    contactRoleWrapper.contact.AccountId = provider.Id;                
                    listInsertContacts.add(contactRoleWrapper.contact);
                }
                else{
                    if(!setContact.contains(contactRoleWrapper.contact.Id)){
                        setContact.add(contactRoleWrapper.contact.Id);
                        listUpdateContacts.add(contactRoleWrapper.contact);
                    }
                }
            }
        }
        if((licenseTransation.Ownership_Type__c == 'Individual' || licenseTransation.Ownership_Type__c == 'Doing Business As (DBA)') && LicenseRecordTypeName != 'GSA_License_Change'){
            if(ownerContactRole != null){
                if(ownerContactRole.holdFCCLicense == 'Yes'){
                    ownerContactRole.contact.Holds_FCC_License__c = true;
                }else{
                    ownerContactRole.contact.Holds_FCC_License__c = false;
                }
                if(ownerContactRole.isNew){
                    ownerContactRole.contact.AccountId = provider.Id;
                    listInsertContacts.add(ownerContactRole.contact);
                }
                else{
                    if(!setContact.contains(ownerContactRole.contact.Id)){
                        setContact.add(ownerContactRole.contact.Id);
                        listUpdateContacts.add(ownerContactRole.contact);
                    }
                }
            }
        }
        if(adminHead != null){
            if(!setContact.contains(adminHead.contact.Id)){
                setContact.add(adminHead.contact.Id);
                listUpdateContacts.add(adminHead.contact);
            }
        }
        if(administrativehead != null && administrativehead.contact != null){
            if(administrativehead.isNew){
                administrativehead.contact.AccountId = provider.Id;
                listInsertContacts.add(administrativehead.contact);
            }
            else{
                if(!setContact.contains(administrativehead.contact.Id)){
                    setContact.add(administrativehead.contact.Id);
                    listUpdateContacts.add(administrativehead.contact);
                }
            }
        }
        if(boardchair != null){
            if(!setContact.contains(boardchair.contact.Id)){
                setContact.add(boardchair.contact.Id);
                listUpdateContacts.add(boardchair.contact);
            }
        }
        if(designateboard!= null && designateboard.contact != null){
            if(designateboard.isNew){
                designateboard.contact.AccountId = provider.Id;
                listInsertContacts.add(designateboard.contact);
            }
            else{
                if(!setContact.contains(designateboard.contact.Id)){
                    setContact.add(designateboard.contact.Id);
                    listUpdateContacts.add(designateboard.contact);
                }
            }
        }

        if(listInsertContacts != null && listInsertContacts.size() > 0)
            listInsertContacts = EEC_ContactRoleUtil.insertContact(listInsertContacts);
        if(listUpdateContacts != null && listUpdateContacts.size() > 0)
            listUpdateContacts = EEC_ContactRoleUtil.updateContact(listUpdateContacts);
        Map<integer, Id> mapInsertContacts = new Map<integer, Id>();
        Map<integer, Id> mapUpdateContacts = new Map<integer, Id>();
        for(integer iCount = 0; iCount< listInsertContacts.size(); iCount++){
            mapInsertContacts.put(iCount + 1, listInsertContacts[iCount].Id);
        }
        for(integer iCount = 0; iCount< listUpdateContacts.size(); iCount++){
            mapUpdateContacts.put(iCount + 1, listUpdateContacts[iCount].Id);
        }
        
        integer iInsertCount = 1;
        integer iUpdateCount = 1;
        
        if(licenseTransation.Ownership_Type__c == 'Partnership' && LicenseRecordTypeName != 'GSA_License_Change'){
            for(ContactRoleWrapperclass contactRoleWrapper : contactrolelist){
                if(contactRoleWrapper.isNewRole){
                    Contact_Role__c contactRole = contactRoleWrapper.contactrole; 
                    contactRole.Contact__c = mapInsertContacts.get(iInsertCount);
                    contactRole.Provider__c = provider.Id;
                    contactRole.Start_Role_Licensing_Transaction__c = licenseTransation.id;
                    contactRole.Role__c = 'Partner';
                    listContactRoles.add(contactRole);
                    iInsertCount++;
                }
                else{
                    Contact_Role__c contactRole = contactRoleWrapper.contactrole;
                    contactRole.Role__c = 'Partner';
                    if(contactRole.End_Role_Licensing_Transaction__c != null && contactRole.End_Date__c != null){
                        contactRole.End_Role_Licensing_Transaction__c = licenseTransation.id;
                    }
                    listContactRoles.add(contactRole);
                    iUpdateCount++;
                }
            }
        }
        if(LicenseRecordTypeName != 'GSA_License_Change'){
            for(ContactRoleWrapperclass contactRoleWrapper : contactAdminRoleList){
                if(contactRoleWrapper.isNewRole){
                    Contact_Role__c contactRole = contactRoleWrapper.contactrole;
                    contactRole.Contact__c = mapInsertContacts.get(iInsertCount);
                    contactRole.Provider__c = provider.Id;
                    contactRole.Start_Role_Licensing_Transaction__c = licenseTransation.id;
                    if(contactRole.End_Role_Licensing_Transaction__c != null && contactRole.End_Date__c != null){
                            contactRole.End_Role_Licensing_Transaction__c = licenseTransation.id;
                    }
                    contactRole.Role__c = 'Administrative Designee';
                    listContactRoles.add(contactRole);
                    iInsertCount++;
                }
                else{
                    Contact_Role__c contactRole = contactRoleWrapper.contactrole;
                    contactRole.Role__c = 'Administrative Designee';
                    if(contactRole.End_Role_Licensing_Transaction__c != null && contactRole.End_Date__c != null){
                            contactRole.End_Role_Licensing_Transaction__c = licenseTransation.id;
                    }
                    listContactRoles.add(contactRole);
                    iUpdateCount++;
                }
            }
        }
        if((licenseTransation.Ownership_Type__c == 'Individual' || licenseTransation.Ownership_Type__c == 'Doing Business As (DBA)')  && LicenseRecordTypeName != 'GSA_License_Change'){
            if(ownerContactRole != null){
                if(ownerContactRole.isNewRole){
                    Contact_Role__c contactRole = ownerContactRole.contactrole;
                    contactRole.Contact__c = mapInsertContacts.get(iInsertCount);
                    contactRole.Provider__c = provider.Id;
                    contactRole.Role__c = 'Owner';
                    listContactRoles.add(contactRole);
                    iInsertCount++;
                }
                else{
                    Contact_Role__c contactRole = ownerContactRole.contactrole;
                    contactRole.Role__c = 'Owner';
                    listContactRoles.add(contactRole);
                    iUpdateCount++;
                }
            }
        }
        if(adminHead != null){
            adminHead.contactrole.Role__c = 'Program Director / Administrative Head';
            listContactRoles.add(adminHead.contactrole);
            iUpdateCount++;
        }
        
        if(administrativehead!= null && administrativehead.contactrole != null){
            if(administrativehead.isNewRole){            
                Contact_Role__c contactRole = administrativehead.contactrole;
                if(administrativehead.isNewRole && !administrativehead.isNew){
                   contactRole.Contact__c = mapUpdateContacts.get(iUpdateCount);
                    iUpdateCount++;
                    }else{
                contactRole.Contact__c = mapInsertContacts.get(iInsertCount);
                }
                contactRole.Provider__c = provider.Id;
                contactRole.Role__c = 'Program Director / Administrative Head';
                contactRole.Start_Role_Licensing_Transaction__c = licenseTransation.id;
                listContactRoles.add(contactRole);
                iInsertCount++;
            }
            else{
                Contact_Role__c contactRole = administrativehead.contactrole;
                if(contactRole.End_Date__c != null && contactRole.End_Role_Licensing_Transaction__c != null){
                    contactRole.End_Role_Licensing_Transaction__c = licenseTransation.id;
                }
                contactRole.Role__c = 'Program Director / Administrative Head';
                listContactRoles.add(contactRole);
                iUpdateCount++;
            }
        }
        if(boardchair != null){
            boardchair.contactrole.Role__c = 'Board Chair';
            if(boardchair.contactrole.End_Role_Licensing_Transaction__c != null && boardchair.contactrole.End_Date__c != null){
                boardchair.contactrole.End_Role_Licensing_Transaction__c = licenseTransation.id;
            }
            listContactRoles.add(boardchair.contactrole);
            iUpdateCount++;
        }
        if(designateboard != null && designateboard.contactrole != null){
            if(designateboard.isNewRole){
                Contact_Role__c contactRole = designateboard.contactrole;
                if(designateboard.isNewRole && !designateboard .isNew){
                   contactRole.Contact__c = mapUpdateContacts.get(iUpdateCount);
                    
                    iUpdateCount++;
                    }else{
                contactRole.Contact__c = mapInsertContacts.get(iInsertCount);
                }
                contactRole.Start_Role_Licensing_Transaction__c = licenseTransation.id;
                contactRole.Provider__c = provider.Id;
                contactRole.Role__c = 'Board Chair';
                listContactRoles.add(contactRole);
                iInsertCount++;
            }
            else{
                Contact_Role__c contactRole = designateboard.contactrole;
                contactRole.Role__c = 'Board Chair';
                listContactRoles.add(contactRole);
                iUpdateCount++;
            }
        }
        if(listContactRoles != null && listContactRoles.size() > 0){
            EEC_ContactRoleUtil.upsertContactRole(listContactRoles);
        }
        if(removeRoleList != null && removeRoleList.size() > 0){
            EEC_ContactRoleUtil.upsertContactRole(removeRoleList);
        }
    }
    
    public Pagereference SaveAndReturnOwnership() {
        try {
            Save('Return');
            if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
                PageReference pPage = page.EEC_PortalProviderPage;
                addMemberIDPageParameter(pPage, true);
                pPage.setRedirect(true);
                return pPage;
            }
            else{
                return new PageReference('javascript:window.close()');
            }           
        }catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
     public Pagereference SaveAndPreviousOwnership() {
        try {
            Save('Previous');
            PageReference pPage;
            if(string.IsNotBlank(previousPageName)){
                if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                    pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                    pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                        || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                    pPage = EEC_Util.lastRPStepMap.get(previousPageName);
                }
            }
            else{
                pPage = Page.eec_transactionprovider;
            }
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public PageReference SaveAndPreviousDesign() {
        licenseTransation.Last_Reached_Step__c = 'Designation of Admin Responsilibity';
        PageReference pPage;
        if(string.IsNotBlank(previousPageName)){
            if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
            }
            else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
            }
            else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                    || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                pPage = EEC_Util.lastRPStepMap.get(previousPageName);
            }
        }
        else{
            if(string.IsNotBlank(previousPageName)){
                if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                    pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                    pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                        || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                    pPage = EEC_Util.lastRPStepMap.get(previousPageName);
                }
            }
            else{
                pPage = page.EEC_OwnershipAdministratorInfo;
            }
        }
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage, false);
        pPage.setRedirect(true);
        return pPage;        
    }
    
     public PageReference SaveAndNextDesign() {
        try{
        PageReference pPage;
        if(LicenseRecordTypeName == 'GSA_New_License'||LicenseRecordTypeName == 'GSA_Move'||LicenseRecordTypeName == 'GSA_Renewal'||LicenseRecordTypeName == 'GSA_License_Change'){
            licenseTransation.Last_Reached_Step__c = 'Capacity Information';
            pPage = page.EEC_CapacityInformation;
        }else if(LicenseRecordTypeName == 'GSA_Change_of_Admin_Authority'){
            licenseTransation.Last_Reached_Step__c = 'Technical Assistance';
            pPage = page.EEC_TechnicalAssistance;
        }
        if(LicenseRecordTypeName == 'GSA_New_License'){
            update provider;
        }
        licenseTransation.Records_Responsible__c = provider.Records_Responsible__c;
        licenseTransation.Personnel_Records_Responsible__c = provider.Personnel_Records_Responsible__c;
        licenseTransation.Children_Records_Responsible__c = provider.Children_s_Records_Responsible__c;
        licenseTransation.Financial_Documentation_Responsible__c = provider.Financial_Documentation_Responsible__c;
        licenseTransation.ECE_program_Responsible__c = provider.Staff_Schedules_Responsible__c;
        licenseTransation.Staff_Schedule_Responsible__c = provider.Early_Childhood_Education_Program_Resp__c;
        licenseTransation.Kindergarten_Responsible__c = provider.Kindergarten_Responsible__c;
        licenseTransation.School_age_Responsible__c = provider.School_age_Responsible__c;
        licenseTransation.Services_4_Disable_children_Responsible__c = provider.Services_for_Children_w_Disability_Resp__c;
        licenseTransation.Daily_activities_Responsible__c = provider.Daily_Activities_Responsible__c;
        licenseTransation.Equipment_Responsible__c = provider.Equipment_Responsible__c;
        licenseTransation.Staff_Development_Responsible__c = provider.Staff_Development_Responsible__c;
        licenseTransation.Staff_Training_Responsible__c = provider.Staff_Training_Responsible__c;
        licenseTransation.Staff_Orientation_Responsible__c = provider.Staff_Orientation_Responsible__c;
        licenseTransation.Staff_Supervision_Responsible__c = provider.Staff_Supervision_Responsible__c;
        licenseTransation.Parent_Involvement_Responsible__c = provider.Parent_Involvement_Responsible__c;
        licenseTransation.Social_Services_Responsible__c = provider.Social_Services_Responsible__c;
        licenseTransation.Infant_Toddler_Program_Responsible__c = provider.Infant_Toddler_Program_Responsible__c;
        
        licenseTransation = EEC_ContactRoleUtil.updateLicensingTransaction(licenseTransation);
       
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage, false);
        pPage.setRedirect(true);
        return pPage;
        }catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public PageReference saveAndNextPlacement() {
         
         try {
            if (heldLicense.size()!=0) {
                insert heldLicense;
            }
            if (relatedLicense.size()!=0) {
                insert relatedLicense;
            }
            if (federalInv.size()!=0) {
                insert federalInv;
            }
            if (criminalAct.size()!=0) {
                insert criminalAct;
            }
         }catch (exception e){
            System.debug('exception'+e); 
         }
         
         PageReference pPage;
         licenseTransation.Last_Reached_Step__c = 'Placement Agency Additional Info';
         update licenseTransation;
         pPage = page.EEC_TechnicalAssistance;
         
         pPage.getParameters().put('ltId', licenseTransation.Id);
         addMemberIDPageParameter(pPage, false);
         pPage.setRedirect(true);
         return pPage;
    }
    
    public PageReference saveAndPreviousPlacement() {
        try {
            if (heldLicense.size()!=0) {
                insert heldLicense;
            }
            if (relatedLicense.size()!=0) {
                insert relatedLicense;
            }
            if (federalInv.size()!=0) {
                insert federalInv;
            }
            if (criminalAct.size()!=0) {
                insert criminalAct;
            }
         }catch (exception e){
            System.debug('exception'+e); 
         }
        update licenseTransation; 
        PageReference pPage;
        if(string.IsNotBlank(previousPageName)){
            if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
            }
            else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
            }
            else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                    || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                pPage = EEC_Util.lastRPStepMap.get(previousPageName);
            }
        }
        else{        
            if(LicenseRecordTypeName == 'Placement_Change_in_License'){
                pPage = page.eec_transactionprovider;
            }
            else{
                pPage = page.EEC_OwnershipAdministratorInfo;
            }
        }
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage, false);
        pPage.setRedirect(true);
        return pPage;        
    }
    
     public Pagereference saveAndReturnPlacement() {
         try {
            if (heldLicense.size()!=0) {
                insert heldLicense;
            }
            if (relatedLicense.size()!=0) {
                insert relatedLicense;
            }
            if (federalInv.size()!=0) {
                insert federalInv;
            }
            if (criminalAct.size()!=0) {
                insert criminalAct;
            }
         }catch (exception e){
            System.debug('exception'+e); 
         }

        update licenseTransation;
        if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage, true);
            return pPage;
        }
        else{
            return new PageReference('javascript:window.close()');
        }
    }
    
    public Pagereference saveAndReturnDesignation() {
        
        if((LicenseRecordTypeName == 'GSA_New_License' 
            || LicenseRecordTypeName =='GSA_License_Change' 
            || LicenseRecordTypeName =='GSA_Move'
            || LicenseRecordTypeName =='GSA_Renewal'
            ||  LicenseRecordTypeName =='GSA_Change_of_Admin_Authority')
             || (LicenseRecordTypeName == 'Placement_New_License'
             || LicenseRecordTypeName == 'Placement_Renewal'
             || LicenseRecordTypeName == 'Placement_Move'
            || LicenseRecordTypeName == 'R_P_Change_of_Admin_Authority') 
            || (LicenseRecordTypeName == 'Residential_New_License'
                || LicenseRecordTypeName == 'Residential_License_Renewal'
                || LicenseRecordTypeName == 'Residential_Move')){
                                provider.Electronic_Communication__c = true;
                                licenseTransation.Last_Reached_Step__c = 'Corporation and Administrator Info';
                    }
       
        update licenseTransation;
        update provider;
        if (cntct != null) {
            update cntct;
        }
        if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage, true);
            return pPage;
        }
        else{
            return new PageReference('javascript:window.close()');
        }
    }
       
    public Pagereference SaveAndPreviousCapacity() {
        try {
            licenseTransation.Last_Reached_Step__c = 'Operation Details';
            update provider;
            
            PageReference pPage;
            if(string.IsNotBlank(previousPageName)){
                if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                    pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                    pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
                }
                else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                        || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                    pPage = EEC_Util.lastRPStepMap.get(previousPageName);
                }
            }
            else{
                pPage = Page.EEC_CapacityInformation;
            }
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage, false);
            pPage.setRedirect(true);
            return pPage;
        } catch(Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public PageReference SaveAndNextCapacity(){
        
        PageReference pPage;
        if(LicenseRecordTypeName == 'GSA_New_License'||LicenseRecordTypeName == 'GSA_Move'||LicenseRecordTypeName == 'GSA_Renewal'||LicenseRecordTypeName == 'GSA_License_Change'){
            licenseTransation.Last_Reached_Step__c = 'Operation Details';
            pPage = page.EEC_OperationDetailInfo;
        }
        licenseTransation.Minimum_Age_Limit_Requested_Years__c = Decimal.valueOf(minAge);
        licenseTransation.Minimum_Age_Limit_Requested_Months__c = Decimal.valueOf(minMon);
        licenseTransation.Maximum_Age_Limit_Requested_Years__c = Decimal.valueOf(maxAge);
        licenseTransation.Maximum_Age_Limit_Requested_Months__c = Decimal.valueOf(maxMon);
        if(LicenseRecordTypeName == 'GSA_New_License'){
                update provider;
        }
        if(LicenseRecordTypeName == 'GSA_New_License'&&provider.RecordType.Name=='Small Group'){
            //licenseTransation.Small_Group_Capacity__c = provider.Capacity_Small_Group__c;
        }
        licenseTransation.Infant_Capacity__c = provider.Infant_birth_15_mo__c;
        licenseTransation.Infant_Toddler_Capacity__c= provider.Infant_Toddler_birth_33_mo__c;
        licenseTransation.Toddler_Capacity__c= provider.Toddler_15_mo_33_mo__c;
        licenseTransation.Toddler_Preschool_Capacity__c= provider.Toddler_Preschool_15_mo_K__c;
        licenseTransation.Preschool_Capacity__c= provider.Preschool_33_mo_K__c;
        licenseTransation.Preschool_SA_Capacity__c= provider.Preschool_SA_33_mo_8_yr__c;
        licenseTransation.Kindergarten_Capacity__c= provider.Kindergarten__c;
        licenseTransation.School_Age_Capacity__c= provider.School_Age_5_yr_14_yr__c;
        licenseTransation.Multi_Age_Group_Capacity__c= provider.Multi_Age_Group_birth_14_yr__c;
        
        update licenseTransation;
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage, false);
        pPage.setRedirect(true);
        return pPage;
        
    } 
    
    public PageReference SaveAndPreviousCapac() {
        licenseTransation.Last_Reached_Step__c = 'Capacity Information';
        PageReference pPage;
        if(string.IsNotBlank(previousPageName)){
            if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
            }
            else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
            }
            else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                    || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                pPage = EEC_Util.lastRPStepMap.get(previousPageName);
            }
        }
        else{
            if(LicenseRecordTypeName == 'GSA_New_License'||LicenseRecordTypeName == 'GSA_Renewal'){
                pPage = page.EEC_DesignationOfAdministrative;
            }else if(LicenseRecordTypeName == 'GSA_License_Change'||LicenseRecordTypeName == 'GSA_Move'){
                pPage = page.EEC_OwnershipAdministratorInfo;
            }
        }
        update provider;
        update licenseTransation;
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage, false);
        pPage.setRedirect(true);
        return pPage;        
    }
    
     public Pagereference saveAndReturnCapacity() {        
        if((LicenseRecordTypeName == 'GSA_New_License' 
            || LicenseRecordTypeName =='GSA_License_Change' 
            || LicenseRecordTypeName =='GSA_Move'
            || LicenseRecordTypeName =='GSA_Renewal'
            ||  LicenseRecordTypeName =='GSA_Change_of_Admin_Authority')
             || (LicenseRecordTypeName == 'Placement_New_License'
             || LicenseRecordTypeName == 'Placement_Renewal'
             || LicenseRecordTypeName == 'Placement_Move'
            || LicenseRecordTypeName == 'R_P_Change_of_Admin_Authority') 
            || (LicenseRecordTypeName == 'Residential_New_License'
                || LicenseRecordTypeName == 'Residential_License_Renewal'
                || LicenseRecordTypeName == 'Residential_Move')){
                                provider.Electronic_Communication__c = true;
                                licenseTransation.Last_Reached_Step__c = 'Capacity Information';
                    }
       
        update licenseTransation;
        update provider;
        if (cntct != null) {
            update cntct;
        }
        if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage, true);
            return pPage;
        }
        else{
            return new PageReference('javascript:window.close()');
        }
    }
    
    public PageReference SaveAndNextOperation(){
        licenseTransation.Last_Reached_Step__c = 'Indoor / Outdoor space info';
        PageReference  pPage = page.eec_indoorspacegsapage;
        update licenseTransation;
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage, false);
        pPage.setRedirect(true);
        return pPage;
    } 
    
    public PageReference SaveAndPreviousOperation() {        
        licenseTransation.Last_Reached_Step__c = 'Operation Details';
        PageReference pPage;
        if(string.IsNotBlank(previousPageName)){
            if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
            }
            else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
            }
            else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                    || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                pPage = EEC_Util.lastRPStepMap.get(previousPageName);
            }
        }
        else{
            pPage = page.eec_capacityinformation;
        }
        update licenseTransation;
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage, false);
        pPage.setRedirect(true);
        return pPage;        
    }
    
    public void udateDesignatedAdmin(){
    }
    
    public Pagereference saveAndReturnOperation() {        
        if((LicenseRecordTypeName == 'GSA_New_License' 
            || LicenseRecordTypeName =='GSA_License_Change' 
            || LicenseRecordTypeName =='GSA_Move'
            || LicenseRecordTypeName =='GSA_Renewal'
            ||  LicenseRecordTypeName =='GSA_Change_of_Admin_Authority')
             || (LicenseRecordTypeName == 'Placement_New_License'
             || LicenseRecordTypeName == 'Placement_Renewal'
             || LicenseRecordTypeName == 'Placement_Move'
            || LicenseRecordTypeName == 'R_P_Change_of_Admin_Authority') 
            || (LicenseRecordTypeName == 'Residential_New_License'
                || LicenseRecordTypeName == 'Residential_License_Renewal'
                || LicenseRecordTypeName == 'Residential_Move')){
                                
                                licenseTransation.Last_Reached_Step__c = 'Operation Details';
                    }
       
        update licenseTransation;
        update provider;
        if (cntct != null) {
            update cntct;
        }
        if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage, true);
            return pPage;
        }
        else{
            return new PageReference('javascript:window.close()');
        }
    }
    
    public PageReference SaveAndNextResidentialDetail(){        
        PageReference pPage;
        licenseTransation.Last_Reached_Step__c = 'Techincal Assistance Info';
        pPage = page.EEC_TechnicalAssistance;
        update licenseTransation;
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage, false);
        pPage.setRedirect(true);
        return pPage;        
    }
    
    public PageReference SaveAndPreviousResidentialDetail() {        
        PageReference pPage;
        licenseTransation.Last_Reached_Step__c = 'Residential Program Detail';
        if(string.IsNotBlank(previousPageName)){
            if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
            }
            else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
            }
            else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                    || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                pPage = EEC_Util.lastRPStepMap.get(previousPageName);
            }
        }
        else{
            if(LicenseRecordTypeName == 'Residential_New_License'||LicenseRecordTypeName == 'Residential_Move'||LicenseRecordTypeName == 'Residential_License_Renewal'){
                pPage = page.EEC_OwnershipAdministratorInfo;
            }else if(LicenseRecordTypeName == 'Residential_Change_in_License'){
                pPage = page.EEC_TransactionProvider;
            }
        }
        update licenseTransation;
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage, false);
        pPage.setRedirect(true);
        return pPage;        
    }
    
    public Pagereference saveAndReturnResidentialDetail() {        
        licenseTransation.Last_Reached_Step__c = 'Residential Program Detail';
             
        update licenseTransation;
        
        if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage, true);
            return pPage;
        }
        else{
            return new PageReference('javascript:window.close()');
        }
    }
    
    public PageReference SaveAndNextIndoorGSA(){        
        PageReference pPage;
        licenseTransation.Last_Reached_Step__c = 'Techincal Assistance Info';
        pPage = page.EEC_TechnicalAssistance;
        update licenseTransation;
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage, false);
        pPage.setRedirect(true);
        return pPage;        
    }
    
    public PageReference SaveAndPreviousIndoorGSA() {
        licenseTransation.Last_Reached_Step__c = 'Indoor / Outdoor space information';
        PageReference pPage;
        if(string.IsNotBlank(previousPageName)){
            if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
            }
            else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
            }
            else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                    || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                pPage = EEC_Util.lastRPStepMap.get(previousPageName);
            }
        }
        else{
            pPage = page.EEC_OperationDetailInfo;
        }
        update licenseTransation;
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage, false);
        pPage.setRedirect(true);
        return pPage;        
    }
    
    public Pagereference saveAndReturnIndoorGSA() {        
        licenseTransation.Last_Reached_Step__c = 'Indoor / Outdoor space information';
        update licenseTransation;
        if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage, true);
            return pPage;
        }
        else{
            return new PageReference('javascript:window.close()');
        }
    }
    
    public integer refAg{get; set;}
    public boolean refCheck{get; set;}
    public void otherReferral(){
        string str='';
        str=str+licenseTransation.Working_with_which_Referral_Agencies__c;
        if(licenseTransation.Working_with_which_Referral_Agencies__c == null){
            refAg=0;
            refCheck = false;
        }else{
            refAg=1;
            refCheck = true;
        }        
        if(str.contains('Other')){
            referralAgency = true;
        }else{
            referralAgency = false;
        }
    }
    public integer valCh {get; set;}
    public void internationalCountries(){
        string str='';
        str=str+licenseTransation.Characteristics_of_children_served__c;
        if(licenseTransation.Characteristics_of_children_served__c == null){
            valCh=0;
            characterRadio = false;
        }else{
            valCh=1;
            characterRadio = true;
        }
        if(str.contains('International Adoption')){
            interCountries = true;
        }else{
            interCountries = false;
        }
    }
    public Integer bldg{get; set;}
    public boolean bldgCheck {get; set;}
    public void bldgCode(){
        if(licenseTransation.Building_Codes_c__c == null){
            bldg=0;
            bldgCheck = false;
        }else{
            bldg=1;
            bldgCheck = true;
        }
    }
    public Integer intAdoptCount{get; set;}
    public boolean intAdoptCheck{get; set;}
    public void otherCountries(){
        string str='';
        str=str+licenseTransation.International_adoption_countries__c;
        if(licenseTransation.International_adoption_countries__c == null){
            intAdoptCount = 0;
            intAdoptCheck = false;
        }else{
            intAdoptCount = 1;
            intAdoptCheck = true;
        }
        if(str.contains('Other(s)')){
            otherCount= true;
        }else{
            otherCount= false;
        }
    }
    
    public void dcfSpecialNeeds(){
        string str='';
        str=str+licenseTransation.Level_of_care__c;
        if(str.contains('DCF/Special Needs')){
            dcfSpecial= true;
        }else{
            dcfSpecial= false;
        }
    }
    
  /*Capacity Page Min and Max years and months*/
    public string minAge {get; set;}
    public string maxAge {get; set;}
    public string minMon {get; set;}
    public string maxMon {get; set;}

    public List<SelectOption> getMinMaxYears() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('0','0'));
        options.add(new SelectOption('1','1'));
        options.add(new SelectOption('2','2'));
        options.add(new SelectOption('3','3'));
        options.add(new SelectOption('4','4'));
        options.add(new SelectOption('5','5'));
        options.add(new SelectOption('6','6'));
        options.add(new SelectOption('7','7'));
        options.add(new SelectOption('8','8'));
        options.add(new SelectOption('9','9'));
        options.add(new SelectOption('10','10'));
        options.add(new SelectOption('11','11'));
        options.add(new SelectOption('12','12'));
        options.add(new SelectOption('13','13'));
        options.add(new SelectOption('14','14'));
        return options;
    }    
    
    public List<SelectOption> getMinMaxMonths() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('0','0'));
        options.add(new SelectOption('1','1'));
        options.add(new SelectOption('2','2'));
        options.add(new SelectOption('3','3'));
        options.add(new SelectOption('4','4'));
        options.add(new SelectOption('5','5'));
        options.add(new SelectOption('6','6'));
        options.add(new SelectOption('7','7'));
        options.add(new SelectOption('8','8'));
        options.add(new SelectOption('9','9'));
        options.add(new SelectOption('10','10'));
        options.add(new SelectOption('11','11'));
        return options;
    }

    /*Minimum age and Maximum age for Residential Program Detail*/

    public string minAgeRes{get; set;}
    public string maxAgeRes{get; set;}
    
    public List<SelectOption> getMinMaxAge() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('0','0'));
        options.add(new SelectOption('1','1'));
        options.add(new SelectOption('2','2'));
        options.add(new SelectOption('3','3'));
        options.add(new SelectOption('4','4'));
        options.add(new SelectOption('5','5'));
        options.add(new SelectOption('6','6'));
        options.add(new SelectOption('7','7'));
        options.add(new SelectOption('8','8'));
        options.add(new SelectOption('9','9'));
        options.add(new SelectOption('10','10'));
        options.add(new SelectOption('11','11'));
        options.add(new SelectOption('12','12'));
        options.add(new SelectOption('13','13'));
        options.add(new SelectOption('14','14'));
        options.add(new SelectOption('15','15'));
        options.add(new SelectOption('16','16'));
        options.add(new SelectOption('17','17'));
        options.add(new SelectOption('18','18'));
        options.add(new SelectOption('19','19'));
        options.add(new SelectOption('20','20'));
        options.add(new SelectOption('21','21'));
        
        return options;
    }

    
    //wrapperclass for contactrole
    public class ContactRoleWrapperclass{
        //variable list
        public boolean isNew{get;set;}
        public boolean isNewRole{get;set;}
        public Contact_Role__c contactrole {get;set;}
        public Contact contact{get;set;}
        public String holdFCCLicense{get;set;}
        public String portalAccess{get;set;}
        //constructor
        public ContactRoleWrapperclass(Boolean isNew, Boolean isNewRole,Contact contactrecord, Contact_Role__c contactrole){
            if(contactrecord == null){
                contactrecord = new Contact();
            }
            if(contactrole == null){
                contactrole = new Contact_Role__c();
            }
            this.contact = contactrecord;
            this.contactrole = contactrole;
            this.isNew = isNew;
            this.isNewRole = isNewRole;
            if(contactrecord != null && contactrecord.Holds_FCC_License__c){
                holdFCCLicense = 'Yes';
            }else{
                holdFCCLicense = 'No';
            }
            if(contactrole != null && contactrole.Portal_Access__c){
                portalAccess= 'Yes';
            }else{
                portalAccess = 'No';
            }             
        }
    }
    
    public void initsubmmision(String ltId)
    {
        List<Licensing_Transaction__c> licentraslist = [SELECT Id,Name,Program_licensed_or_approved_by_agency__c,
        By_whom__c,Accounts_Responsible__c,Date_of_Expiration__c,Is_your_program_contracted__c,Name_of_contract_administrator__c,
        Address_of_admin_for_funding_source__c,Number_of_Open_Foster_Homes__c,Number_of_children_placed_in_care__c,
        Provider__r.State__c,Provider__r.Provider_Zip_Code__c,Provider__r.Provider_City__c,Provider__r.Provider_Address_2__c,
        Provider__r.Provider_Address_1__c,New_Street_Address_1__c,New_Street_Address_2__c,New_City__c,New_Zip_Code__c,
        Moving_Date__c,Date_Care_Resumes__c,New_Address_Phone_Number__c,Provider__r.ShippingStreet,Provider__r.ShippingCity,
        Provider__r.ShippingPostalCode,Provider__r.ShippingState,Provider__r.Phone,Provider__r.Alternate_Phone__c,
        Provider__r.Fax,Provider__r.Provider_Email__c,Ownership_Type__c,Umbrella__r.Name,Umbrella__r.Provider_Address_1__c,
        Umbrella__r.Provider_City__c,Umbrella__r.Provider_Zip_Code__c,Level_of_care__c,Characteristics_of_children_served__c,
        International_adoption_countries__c,Other_countries__c,Gender_of_children_served__c,Provider__r.Capacity__c,
        Requested_capacity__c,Awake_Staff_to_child_ratio__c,Asleep_Staff_to_child_ratio__c,Ratio_comments__c,
        Use_of_physical_restraints1__c,Restraint_method__c,Minimum_age_of_children_served__c,
        Maximum_age_of_children_served__c,Working_with_which_Referral_Agencies__c,Other_Referral_Agency__c,
        Number_of_Adoptive_Placements__c,Number_of_Foster_Homes__c,Number_of_birth_mothers_recving_services__c,
        Birth_mothers_making_adoption_plans__c,Number_of_Waiting_Families__c,Families_recving_home_study_services__c,
        Recving_search_and_or_reunion_services__c,Number_recving_Search_reunion_services__c,Number_of_Reunions_Facilitated__c,
        Number_of_Child_Assessments__c,Number_of_Home_Study_Services__c,Families_recving_case_mgmt_services__c,
        Families_recving_information_referral__c,DCF_Nb_Children_Placed_In_Care__c,
        Technical_Assistance__c,Transaction_Special_Requests_Comments__c FROM Licensing_Transaction__c where Id = :ltId];
    }
    
    public String havesiteCordinator{get;set;}
    
    public pagereference saveandpreviousGSASummary(){        
        licenseTransation.Last_Reached_Step__c = 'Review Summary and Submission';
        update licenseTransation;
        PageReference pPage;
        if(string.IsNotBlank(previousPageName)){
            if(providerRecordType == 'Family Child Care' || providerRecordType == 'FCC Assistant'){
                pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
            }
            else if(providerRecordType == 'Large Group' || providerRecordType == 'Small Group' || providerRecordType == 'Large and Small Group Umbrella' ){
                pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
            }
            else if(providerRecordType == 'R&P Umbrella' || providerRecordType == 'Temporary Shelter' || providerRecordType == 'Group Care'
                    || providerRecordType == 'Foster Care Agency' || providerRecordType == 'Adoption Agency'){
                pPage = EEC_Util.lastRPStepMap.get(previousPageName);
            }
        }
        else{
            pPage = Page.EEC_LicensingAttachment;
        }
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage, false);
        pPage.setRedirect(true);
        return pPage;
    }
    
    public pagereference saveandreturnTOProviderGSASummary(){
        licenseTransation.Last_Reached_Step__c = 'Review Summary and Submission';
        update licenseTransation;
        if(UserInfo.getUserType() == 'PowerPartner' || UserInfo.getUserType() == 'PowerCustomerSuccess' || 
                            UserInfo.getUserType() == 'CspLitePortal' || UserInfo.getUserType() == 'CustomerSuccess'){
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage, true);
            return pPage;                       
        }
        else{
            return new PageReference('javascript:window.close()');
        }
    }
}