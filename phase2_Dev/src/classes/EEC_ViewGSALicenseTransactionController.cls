public without sharing class EEC_ViewGSALicenseTransactionController implements EEC_AssistantInterface{
    public Id ltId { get; set; }
    public Account provider { get; set; }
    public Licensing_Transaction__c licenseTransation { get; set; }
    public String licenseRecordTypeName { get; set; }
    public String licenseRecordTypeLabel { get; set; }
    public String memberId { get; set; }
    public List<Variance_on_Regulation__c> varianceList {get;set;}
    public List<Contact_Role__c> listPartner{get;set;}
    public Contact_Role__c individualOwner{get;set;}
    public Contact_Role__c pastAdmin{get;set;}
    public Contact_Role__c currentAdmin{get;set;}
    public Contact_Role__c pastBoardChair{get;set;}
    public Contact_Role__c currentBoardChair{get;set;}
    public List<Contact_Role__c> listAdministrator{get;set;}
    public List<SelectOption> typeOfOwnership{get;set;}
    
    public EEC_ViewGSALicenseTransactionController() {
        ltId = ApexPages.currentPage().getParameters().get('ltID');
        memberId = ApexPages.currentPage().getParameters().get('member');
        getLicenseTrans();
    }
    
    public void getLicenseTrans() {
        List<Licensing_Transaction__c> ltList = [Select Provider__r.Name, RecordType.DeveloperName, RecordType.Name, Name,Program_licensed_or_approved_by_agency__c,
                                                 By_whom__c,Date_of_Expiration__c,Name_of_contract_administrator__c,
                                                 Address_of_admin_for_funding_source__c,Number_of_Open_Foster_Homes__c,
                                                 Group_Type__c,
                                                 Provider__r.Summer_Camp_Permit__c,
                                                 Provider__r.Camp_Permit_Issue_Date__c,
                                                 Provider__r.RecordType.Name,
                                                 Provider__r.RecordType.DeveloperName,
                                                 Provider__r.Provider_Address_1__c,
                                                 Provider__r.Provider_Address_2__c,
                                                 Provider__r.Provider_City__c,
                                                 Provider__r.Provider_City__r.Name,
                                                 Provider__r.Provider_Zip_Code__c,
                                                 Provider__r.State__c,
                                                 New_Street_Address_1__c,
                                                 New_Street_Address_2__c,
                                                 New_City__c,
                                                 New_Zip_Code__c,
                                                 Moving_Date__c,
                                                 Date_Care_Resumes__c,
                                                 ProgramContracted__c,
                                                 ProgramLicensedOrApproved__c,
                                                 New_Address_Phone_Number__c,
                                                 Provider__r.ShippingAddress,
                                                 Provider__r.ShippingStreet,
                                                 Provider__r.ShippingCity,
                                                 Provider__r.ShippingPostalCode,
                                                 Provider__r.ShippingState,
                                                 Provider__r.Phone,
                                                 Provider__r.Alternate_Phone__c,
                                                 Provider__r.Fax,
                                                 Provider__r.Provider_Email__c,
                                                 Provider__r.Account_books_Responsible__c,
                                                 Provider__r.Capacity__c,
                                                 Small_Group_Capacity__c,
                                                 Infant_Capacity__c,
                                                 Infant_Toddler_Capacity__c,
                                                 Toddler_Capacity__c,
                                                 Toddler_Preschool_Capacity__c,
                                                 Preschool_Capacity__c,
                                                 Preschool_SA_Capacity__c,
                                                 Kindergarten_Capacity__c,
                                                 School_Age_Capacity__c,
                                                 Multi_Age_Group_Capacity__c,
                                                 Total_License_Capacity_Requested__c,
                                                 Minimum_Age_Limit_Requested_Years__c,
                                                 Minimum_Age_Limit_Requested_Months__c,
                                                 Maximum_Age_Limit_Requested_Years__c,
                                                 Maximum_Age_Limit_Requested_Months__c,
                                                 Operation_Type__c,
                                                 Operation_Start_Month__c,
                                                 Operation_End_Month__c,
                                                 Available_Days_Full_day_program__c,
                                                 Start_Time_Full_day_program__c,
                                                 End_Time_Full_day_program__c,
                                                 Available_Days_Morning_program__c,
                                                 Start_Time_Morning_program__c,
                                                 End_Time_Morning_program__c,
                                                 Available_Days_Afternoon_program__c,
                                                 Start_Time_Afternoon_program__c,
                                                 End_Time_Afternoon_program__c,
                                                 Provide_Extended_Days1__c,
                                                 Extended_Days_Available__c,
                                                 Drop_in_Service1__c,
                                                 Evenings_Service1__c,
                                                 Summer_Camp_Service1__c,
                                                 Cafeteria_Used_During_Program_Hours1__c,
                                                 Gym_Facility_Used_During_Program_Hours1__c,
                                                 Accounts_Responsible__c,
                                                 Indoor_Square_Footage__c,
                                                 Number_of_toilets_c__c,
                                                 Number_of_sinks__c,
                                                 Lead_Paint_Compliance__c,
                                                 Lead_Paint_Detailed_Inspection__c,
                                                 Building_Inspection_Max_Capacity__c,
                                                 Building_inspection_expiration_Date__c,
                                                 Building_Codes_c__c,
                                                 Health_Inspection_Expiration_Date__c,
                                                 Fire_Inspection_Issue_date__c,
                                                 Integrated_Pest_Management_Date__c,
                                                 Drinking_Water_Source__c,
                                                 Well_Water_Test_date__c,
                                                 Outdoor_Square_footage__c,
                                                 Pool_available_during_program_hours1__c,
                                                 Pool_roof_inspection_date__c,
                                                 Offsite_outdoor_play_location1__c,
                                                 Commute_to_offsite_play_location__c,
                                                 Transportation_provided1__c,
                                                 Other_Approved_Additional_Space__c,
                                                 Indoor_ADA_Compliant__c,
                                                 Outdoor_ADA_Compliant__c,
                                                 PWS_Public_Water_Source_Number__c,
                                                 Records_Responsible__c,
                                                 Children_Records_Responsible__c,
                                                 Personnel_Records_Responsible__c,
                                                 Financial_Documentation_Responsible__c,
                                                 Staff_Schedule_Responsible__c,
                                                 ECE_program_Responsible__c,
                                                 Kindergarten_Responsible__c,
                                                 School_age_Responsible__c,
                                                 Services_4_Disable_children_Responsible__c,
                                                 Daily_activities_Responsible__c,
                                                 Equipment_Responsible__c,
                                                 Staff_Development_Responsible__c,
                                                 Staff_Training_Responsible__c,
                                                 Staff_Orientation_Responsible__c,
                                                 Staff_Supervision_Responsible__c,
                                                 Parent_Involvement_Responsible__c,
                                                 Social_Services_Responsible__c,
                                                 Infant_Toddler_Program_Responsible__c,
                                                 Ownership_Type__c,
                                                 Umbrella__r.Name,
                                                 Umbrella__r.Provider_Address_1__c,
                                                 Umbrella__r.Provider_City__c,
                                                 Umbrella__r.Provider_Zip_Code__c,
                                                 Umbrella__r.State__c,
                                                 NewUmbrella_Alternate_Phone__c,
                                                 NewUmbrella_City__c,
                                                 NewUmbrella_Date_of_Incorporation__c,
                                                 NewUmbrella_Director_Email__c,
                                                 NewUmbrella_Director_First_Name__c,
                                                 NewUmbrella_Director_Last_Name__c,
                                                 NewUmbrella_Director_Phone__c,
                                                 NewUmbrella_Director_Title__c,
                                                 NewUmbrella_Email__c,
                                                 NewUmbrella_Fax__c,
                                                 NewUmbrella_Phone__c,
                                                 NewUmbrella_Place_of_Incorporation__c,
                                                 NewUmbrella_State__c,
                                                 NewUmbrella_Street_Address_1__c,
                                                 NewUmbrella_Street_Address_2__c,
                                                 NewUmbrella_Zip_Code__c,
                                                 Level_of_care__c,
                                                 Characteristics_of_children_served__c,
                                                 Gender_of_children_served__c,
                                                 Minimum_age_of_children_served__c,
                                                 Maximum_age_of_children_served__c,
                                                 Requested_capacity__c,
                                                 Number_of_children_placed_in_care__c,
                                                 Awake_Staff_to_child_ratio__c,
                                                 Asleep_Staff_to_child_ratio__c,
                                                 Ratio_comments__c,
                                                 Restraint_method__c,
                                                 Working_with_which_Referral_Agencies__c,
                                                 Other_Referral_Agency__c,
                                                 Technical_Assistance__c,
                                                 Transaction_Special_Requests_Comments__c,
                                                 International_adoption_countries__c,
                                                 Other_countries__c,
                                                 Number_of_Adoptive_Placements__c,
                                                 Number_of_Foster_Homes__c,
                                                 Number_of_birth_mothers_recving_services__c,
                                                 Birth_mothers_making_adoption_plans__c,
                                                 Number_of_Waiting_Families__c,
                                                 Families_recving_home_study_services__c,
                                                 Recving_search_and_or_reunion_services__c,
                                                 Number_recving_Search_reunion_services__c,
                                                 Number_of_Reunions_Facilitated__c,
                                                 Number_of_Child_Assessments__c,
                                                 Number_of_Home_Study_Services__c,
                                                 Families_recving_case_mgmt_services__c,
                                                 Families_recving_information_referral__c,
                                                 DCF_Nb_Children_Placed_In_Care__c,
                                                 Existing_Fiduciary_Admin_relationships1__c,
                                                 Use_of_physical_restraints1__c,
                                                 Status__c,
                                                 Reason_Closed_Cancelled__c,
                                                 Last_Reached_Step__c,
                                                 (Select Id,Associated_Regulation__c,Associated_Regulation__r.Name,Associated_Regulation__r.Regulation_Number__c,
                                                  Associated_Regulation__r.Article__c,Provider_Alternative_Method_to_Comply__c,
                                                  Provider_Understanding_of_Regulation__c From Variance_on_Regulations__r)
                                                 
                                                 From Licensing_Transaction__c where Id = :ltId];
        
        if (ltList != null && ltList.size() > 0) {
            licenseTransation = ltList.get(0);
            licenseRecordTypeName = licenseTransation.RecordType.DeveloperName;
            licenseRecordTypeLabel = licenseTransation.RecordType.Name;
            provider = [select Id, Recordtype.DeveloperName, RecordType.Name, License_Status__c, First_Issue_Date__c, Renewal_date__c, Provider_Status__c, capacity__c,
                        Accept_Referral__c, Can_Communicate_in_English__c, PPM_Meeting_Attended_Date__c,
                        ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, Phone, Unlisted_Phone_Number__c, Alternate_Phone__c, Fax, Provider_Email__c,
                        Provider_Address_1__c, Provider_Address_2__c, Provider_City__c, Provider_Zip_Code__c, Live_at_this_address__c, Language__c, Preferred_Language__c
                        from Account where Id = :licenseTransation.Provider__c];
            
            varianceList = licenseTransation.Variance_on_Regulations__r;
            
            List<Contact_Role__c> listContactRole = [SELECT id, Name,Current_Formula__c,Contact__c,Contact__r.FirstName,Contact__r.LastName,
                                                     Contact__r.MailingStreet,Contact__r.MailingCity,Contact__r.MailingPostalCode,Contact__r.MailingState,
                                                     Contact__r.Phone,Contact__r.Email,Contact__r.Holds_FCC_License__c,End_Date__c,End_Role_Licensing_Transaction__c,
                                                     Portal_Access__c,Provider__c,Role__c,Schedule_Administrative_Hours__c,Schedule_Teaching_Hours__c,Start_Date__c,
                                                     Start_Role_Licensing_Transaction__c,Contact__r.Title,Contact__r.Role__c FROM Contact_Role__c 
                                                     WHERE Provider__c=: provider.Id];
            
            listPartner = new List<Contact_Role__c>();
            listAdministrator = new List<Contact_Role__c>();
            
            for(Contact_Role__c contactrecord : listContactRole){
                if(contactrecord.Role__c == 'Partner'){   
                    listPartner.add(contactrecord);
                }
                else if(contactrecord.Role__c == 'Administrative Designee' && contactrecord.Current_Formula__c == true){
                    listAdministrator.add(contactrecord);
                }
                else if(contactrecord.Role__c == 'Program Director / Administrative Head' && contactrecord.End_Role_Licensing_Transaction__c == licenseTransation.id && contactrecord.Current_Formula__c == true){
                    pastAdmin = contactrecord;
                }
                else if(contactrecord.Role__c == 'Program Director / Administrative Head'  && (contactrecord.End_Role_Licensing_Transaction__c == null && contactrecord.End_Date__c == null)){
                    currentAdmin = contactrecord;
                }
                else if(contactrecord.Role__c == 'Owner' && contactrecord.Current_Formula__c == true){
                    individualOwner = contactrecord;
                }
                else if((contactrecord.Role__c == 'Board Chair' && contactrecord.End_Role_Licensing_Transaction__c == licenseTransation.id && contactrecord.Current_Formula__c == true)){
                    pastBoardChair = contactrecord;            
                }
                else if(contactrecord.Role__c == 'Board Chair'  && (contactrecord.End_Role_Licensing_Transaction__c == null && contactrecord.End_Date__c == null)){
                    currentBoardChair = contactrecord;
                }
            }
            
            typeOfOwnership = gettypeOfOwnership();
        }
        else{
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Provide a valid Licensing Transaction Id');
            ApexPages.addMessage(msg);
            return;
        }
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('True', 'Yes'));
        options.add(new SelectOption('False', 'No'));
        return options;
    }
    
    public List<SelectOption> getPickItems() {
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        return options;
    }
    
    public Pagereference CancelTransaction() {
        licenseTransation.Status__c = 'Cancelled';
        licenseTransation.Reason_Closed_Cancelled__c = 'Cancelled by portal user';
        //update licenseTransation;
        
        licenseTransation = EEC_ContactRoleUtil.updateLicensingTransaction(licenseTransation);
        
        PageReference pPage = page.EEC_PortalProviderPage;
        if (memberId != null)
            pPage.getParameters().put('member', EEC_Util.encryptGetParam(memberId));
        return pPage;
    }
    
    public Pagereference backInstruction() {
        PageReference pPage = page.EEC_PortalProviderPage;
        if (memberId != null)
            pPage.getParameters().put('member', EEC_Util.encryptGetParam(memberId));
        return pPage;
    }
    
    public PageReference viewInstruction()
    {
        PageReference pPage;
        pPage = Page.EEC_ViewLicensingAttachment;
        return pPage;
    }

    public Pagereference editInstruction() {
        PageReference pPage;
        if(licenseTransation.Last_Reached_Step__c == 'Attachments'){
    		if(provider.RecordType.Name == 'Family Child Care' || provider.RecordType.Name == 'FCC Assistant'){
	            pPage = Page.EEC_LicenseTransactionAttachments;
	        }
	        else if(provider.RecordType.Name == 'Large Group' || provider.RecordType.Name == 'Small Group' || provider.RecordType.Name == 'Large and Small Group Umbrella' ){
	            pPage = Page.EEC_LicensingAttachment;
	        }
	        else if(provider.RecordType.Name == 'R&P Umbrella' || provider.RecordType.Name == 'Temporary Shelter' || provider.RecordType.Name == 'Group Care'
	                || provider.RecordType.Name == 'Foster Care Agency' || provider.RecordType.Name == 'Adoption Agency'){
	            pPage = Page.EEC_LicensingAttachment;
	        }
	        else{
	        	pPage = Page.EEC_LicensingAttachment;
	        }
    	}
    	else if(licenseTransation.Last_Reached_Step__c == 'Review Summary and Submission'){
    		if(provider.RecordType.Name == 'Family Child Care' || provider.RecordType.Name == 'FCC Assistant'){
	            pPage = Page.EEC_ReviewSummarySubmission;
	        }
	        else if(provider.RecordType.Name == 'Large Group' || provider.RecordType.Name == 'Small Group' || provider.RecordType.Name == 'Large and Small Group Umbrella' ){
	            pPage = Page.EEC_GSAReviewSummary;
	        }
	        else if(provider.RecordType.Name == 'R&P Umbrella' || provider.RecordType.Name == 'Temporary Shelter' || provider.RecordType.Name == 'Group Care'
	                || provider.RecordType.Name == 'Foster Care Agency' || provider.RecordType.Name == 'Adoption Agency'){
	            pPage = Page.EEC_RP_ReviewSummary;
	        }
	        else{
	        	pPage = Page.EEC_GSAReviewSummary;
	        }
    	}
    	else{
        	pPage = EEC_Util.lastStepMap.get(licenseTransation.Last_Reached_Step__c);
    	}
        pPage.getParameters().put('ltId', licenseTransation.Id);
        pPage.getParameters().put('accountId', provider.Id);
        return pPage;
    }
    
    /**
* getCtrlInstance
* 
* This function will return an instance of this controller with interface reference.
* @author Darkis
* @return EEC_ViewTransactionController
*/
    public EEC_ViewGSALicenseTransactionController getCtrlInstance() {
        return this;
    }
    
    /*-----Interface Methods-----*/
    public void updateAssistantWrapperList(List<EEC_AssistantListCtrl.AssistantInfoWrap> providerAssistantWrappers) {
        
    }
    
    public Licensing_Transaction__c getBaseLicenseTransaction() {
        return licenseTransation;
    }
    
    public String getBaseLicenseRecordTypeName() {
        return licenseRecordTypeName;
    }
    
    public List<SelectOption> gettypeOfOwnership() {
        List<SelectOption> options = new List<SelectOption> ();
        options.add(new SelectOption('Doing Business As (DBA)', 'Doing Business As (DBA)'));
        options.add(new SelectOption('Non-Profit Corp.', 'Non-Profit Corp.'));
        options.add(new SelectOption('For Profit Corp.', 'For Profit Corp.'));
        options.add(new SelectOption('Partnership', 'Partnership'));
        options.add(new SelectOption('Individual', 'Individual'));
        options.add(new SelectOption('LLC', 'LLC'));
        
        return options;
    }
}