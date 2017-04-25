public without sharing class EEC_MeetingRegistrationController {
	public LEAD_Configuration__c leadConfiguration {get;set;}
	public string errorParticipantMessage{get;set;}
	public string errorMeetingMessage{get;set;}
	private string accountId{get;set;}
	public string participantId{get;set;}
	public string selectedMeetingId{get;set;}
	public string viewOnly{get;set;}
	public string selectedParticipantId{get;set;}
	public string selectedContact{get;set;}
	public boolean isViewOnly{get;set;}
	public Provider_Meeting__c providerMeeting{get;set;}
	public List<Provider_Meeting_Participant__c> listMeetingParticipant{get;set;}
	public List<Provider_Meeting__c> listMeeting{get;set;}
	public List<selectOption> listContacts{get;set;}
	public string errorMessage{get;set;}
	
    public EEC_MeetingRegistrationController() {
    	isViewOnly = true;
    	errorMessage = '';
    	User loggedUser = [select Id, Name, contactId from User where Id = :UserInfo.getUserId()];    	
    	Contact contact = [select Id, Account.Id, Account.RecordType.Name from Contact where Id =: loggedUser.contactId];    	
    	accountId = contact.Account.Id;    	
    	string providerRecordType = contact.Account.RecordType.Name;    	
    	leadConfiguration = [Select Registration_Page_Instruction__c from LEAD_Configuration__c where 
    												Name = :providerRecordType];	
		providerMeeting = new Provider_Meeting__c();		
		doGetParticipantDetails();
    }
    
    private void doGetParticipantDetails(){    	
    	listMeetingParticipant = [select Id, GSA_Renewal_Participant__r.Name, Scheduled_Start_Time__c, 
    							Provider_Meeting__c, GSA_Renewal_Participant__c,
    							Provider_Meeting__r.Meeting_Address__c from Provider_Meeting_Participant__c
    							where GSA_Renewal_Provider__c =: accountId
    							and Scheduled_Start_Time__c > TODAY
    							and Participation_Status__c= 'Registered'    							
    							and Meeting_Type__c = 'Renewal (GSA)'];
    	
    	if(listMeetingParticipant.size() == 0){
    		errorParticipantMessage = 'None of your team member is currently registered for an upcoming renewal meeting.';
    	}	
    	
    	listMeeting = [select Id, Scheduled_Start__c, Meeting_Address__c, Language__c, Number_of_Remaining_Spots__c,
    				Meeting_Region__r.FCC_Meeting_Default_Allowed_no_of_part__c,
    				Meeting_Region__r.Max_Nb_of_Participants_For_GSA_Renewal__c,
    				Expected_No_of_participants__c
    				from Provider_Meeting__c where Meeting_Status__c = 'Open for registration'
    				and Scheduled_Start__c > TODAY
    				and Meeting_Type__c = 'Renewal (GSA)' order by Scheduled_Start__c asc];		
    				
        if(listMeeting.size() == 0){
        	errorMeetingMessage = 'Currently, there is no meeting scheduled. Contact your licensor for more information.';
        }
    }
    
    public void doRegistration(){
    	Provider_Meeting_Participant__c providerParticipant = new Provider_Meeting_Participant__c();
    	providerParticipant.GSA_Renewal_Participant__c = selectedContact;
    	providerParticipant.GSA_Renewal_Provider__c = accountId;
    	providerParticipant.Participation_Status__c = 'Registered';
    	providerParticipant.Provider_Meeting__c = selectedMeetingId;
    	
    	insert providerParticipant;
    	
    	doGetParticipantDetails();	
    }
    
    public pageReference doBack(){
    	PageReference pageReference = Page.EEC_PortalLandingPage_2;
    	pageReference.setRedirect(true);
    	return pageReference;
    }
    
    public void doCancelRegistration(){
    	Provider_Meeting_Participant__c participant = [select Id, Participation_Status__c from 
        Provider_Meeting_Participant__c where Id =: selectedParticipantId];
        
        participant.Participation_Status__c = 'Cancelled';        
        update participant;
        
        doGetParticipantDetails();
    }
    
    public PageReference doViewMeetingDetail(){
    	if(viewOnly == 'yes'){
    		isViewOnly = true;
    	}
    	else{
    		isViewOnly = false;
    	}
    	errorMessage = '';
    	providerMeeting = [select Id, Scheduled_Start__c, Scheduled_End__c, 
    						Number_of_Remaining_Spots__c,
							Meeting_Address__c, Language__c, Meeting_Location_Description__c,
							Meeting_Region__r.Phone__c, Meeting_Region__r.Email__c,
							Meeting_Region__r.FCC_Meeting_Default_Allowed_no_of_part__c,
    						Meeting_Region__r.Max_Nb_of_Participants_For_GSA_Renewal__c,
    						Expected_No_of_participants__c
							from Provider_Meeting__c where Id=: selectedMeetingId];
		
		if(providerMeeting.Number_of_Remaining_Spots__c == 0){
			errorMessage = 'You have reached the limit of allowed number of participants for this meeting. Please contact your regional office if you need to register more participants.'; 	
		}
		List<Provider_Meeting_Participant__c> listParticipant = [select Id, GSA_Renewal_Participant__r.Name, Scheduled_Start_Time__c, 
    							Provider_Meeting__c, GSA_Renewal_Participant__c,
    							Provider_Meeting__r.Meeting_Address__c from Provider_Meeting_Participant__c
    							where Provider_Meeting__c =: selectedMeetingId
    							and Participation_Status__c= 'Registered'];
    	
        Set<Id> setContactId = new Set<Id>();
        
        for(Provider_Meeting_Participant__c participant : listParticipant){
        	if(!setContactId.contains(participant.GSA_Renewal_Participant__c)){
        		setContactId.add(participant.GSA_Renewal_Participant__c);
        	}
        }
        
        List<Contact_Role__c> listContactRoles = [select Id, Contact__c, Contact__r.Name from Contact_Role__c where
        									Contact__r.AccountId =: accountId and Current_Formula__c = true];
        
        listContacts = new List<SelectOption>();        
        listContacts.add(new SelectOption('--Select--', '--Select--'));
        
        for(Contact_Role__c contactRole : listContactRoles){
        	if(!setContactId.contains(contactRole.Contact__c)){
        		listContacts.add(new SelectOption(contactRole.Contact__c, contactRole.Contact__r.Name));
        		setContactId.add(contactRole.Contact__c);
        	}
        }
		return null;
	}
}