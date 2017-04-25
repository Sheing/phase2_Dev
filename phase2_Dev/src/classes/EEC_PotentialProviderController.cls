public with sharing class EEC_PotentialProviderController {	
	public string contactFirstName{get;set;}
	public string contactLastName{get;set;}
	public string parentLeadId{get;set;}
	public Lead lead {get;set;}
	
    public EEC_PotentialProviderController(ApexPages.StandardController std){
    	parentLeadId = std.getId();
    	lead = [select Id, Company from Lead where id =: parentLeadId];
    }
     
    public PageReference doSave(){
    	RecordType rt = [select Id from RecordType where Name = 'Potential Provider (Additional Participant)' and SobjectType = 'Lead' limit 1];
    	
    	Lead potentialProvider = new Lead();
    	potentialProvider.RecordTypeId = rt.Id;
    	potentialProvider.FirstName = contactFirstName;
    	potentialProvider.LastName = contactLastName;
    	potentialProvider.Parent_GSA_Potential_Provider__c = parentLeadId;
    	potentialProvider.Company = lead.Company;

    	insert potentialProvider;
    	
    	List<Provider_Meeting_Participant__c> listMeetingParticipant = new List<Provider_Meeting_Participant__c>();
    	
    	for(Provider_Meeting_Participant__c participant: [select Id, Provider_Meeting__c,
		    	Participation_Status__c, GSA_Renewal_Participant__c from Provider_Meeting_Participant__c where 
		    	Potential_Provider__c =: parentLeadId]){
    		Provider_Meeting_Participant__c newParticipant = new Provider_Meeting_Participant__c();
    		newParticipant.Provider_Meeting__c = participant.Provider_Meeting__c;
    		newParticipant.Potential_Provider__c = potentialProvider.Id;
    		newParticipant.Participation_Status__c = participant.Participation_Status__c;
    		listMeetingParticipant.add(newParticipant);
    	}
    	
    	if(listMeetingParticipant.size() > 0)
    		insert listMeetingParticipant;
    	
    	PageReference pg = new PageReference('/' + potentialProvider.Id);
    	return pg;
    } 
    
    public PageReference doCancel(){
    	PageReference pg = new PageReference('/' + parentLeadId);
    	return pg; 
    }
}