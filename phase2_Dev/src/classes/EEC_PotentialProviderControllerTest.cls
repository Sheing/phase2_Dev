@IsTest
public class EEC_PotentialProviderControllerTest {
    static testMethod void testEEC_PotentialProvider() {    	
    	Lead mLead = new Lead(FirstName = 'TestF', LastName = 'TestL', Status = 'Registered',
                       Company = 'Test Provider', Street_Address_1__c = '1st Street',
                       City__c = EEC_TestUtil.mockCity().Id, State__c = 'MA', Zip_code__c = '01803', 
                       Region__c = EEC_TestUtil.mockRegion().Id, 
                       PPM_Participation_Region__c = EEC_TestUtil.mockRegion().Id,
                       PPM_Language__c = 'test');
                       
        RecordType rt = [select Id from RecordType where Name = 'Potential Provider GSA' and SobjectType = 'Lead' limit 1];
    	
        mLead.RecordTypeId = rt.Id;
        insert mLead;
        
        Provider_Meeting__c providerMeeting = new Provider_Meeting__c(
                       Meeting_Region__c = EEC_TestUtil.mockRegion().Id, 
                       Meeting_Status__c ='Open for registration',
                       Meeting_Type__c = 'PPM (GSA)',
                       No_of_seats_available__c = 3,
                       Scheduled_Start__c = system.now() + 5,
                       Scheduled_End__c = system.now() + 7);
                       
    	insert providerMeeting;
    	
    	Provider_Meeting_Participant__c meetingParticipant = new Provider_Meeting_Participant__c(
    	Provider_Meeting__c = providerMeeting.Id,
    	Potential_Provider__c = mLead.Id,
    	Participation_Status__c = 'Registered'    	
    	);
    	
    	insert meetingParticipant;
    	
    	ApexPages.StandardController sc = new ApexPages.StandardController(mLead);
    	
    	test.startTest();
    	EEC_PotentialProviderController potentialProvider = new EEC_PotentialProviderController(sc);
    	potentialProvider.doCancel();
    	potentialProvider.contactFirstName = 'Test';
    	potentialProvider.contactLastName = 'Contact';
    	potentialProvider.doSave();
    	test.stopTest();
    }
    
    static testMethod void testEEC_PotentialProviderConvert() {    	
    	Lead mLead = new Lead(FirstName = 'TestF', LastName = 'TestL', Status = 'Registered',
                       Company = 'Test Provider', Street_Address_1__c = '1st Street',
                       City__c = EEC_TestUtil.mockCity().Id, State__c = 'MA', Zip_code__c = '01803', 
                       Region__c = EEC_TestUtil.mockRegion().Id, 
                       PPM_Participation_Region__c = EEC_TestUtil.mockRegion().Id,
                       PPM_Language__c = 'test');
                       
        RecordType rt = [select Id from RecordType where Name = 'Potential Provider GSA' and SobjectType = 'Lead' limit 1];
    	
        mLead.RecordTypeId = rt.Id;
        insert mLead;
        
        Provider_Meeting__c providerMeeting = new Provider_Meeting__c(
                       Meeting_Region__c = EEC_TestUtil.mockRegion().Id, 
                       Meeting_Status__c ='Open for registration',
                       Meeting_Type__c = 'PPM (GSA)',
                       No_of_seats_available__c = 3,
                       Scheduled_Start__c = system.now() + 5,
                       Scheduled_End__c = system.now() + 7);
                       
    	insert providerMeeting;
    	
    	Provider_Meeting_Participant__c meetingParticipant = new Provider_Meeting_Participant__c(
    	Provider_Meeting__c = providerMeeting.Id,
    	Potential_Provider__c = mLead.Id,
    	Participation_Status__c = 'Registered'    	
    	);
    	
    	insert meetingParticipant;
    	
    	ApexPages.StandardController sc = new ApexPages.StandardController(mLead);
    	
    	test.startTest();
    	EEC_PotentialProviderController potentialProvider = new EEC_PotentialProviderController(sc);
    	potentialProvider.doCancel();
    	potentialProvider.contactFirstName = 'Test';
    	potentialProvider.contactLastName = 'Contact';
    	potentialProvider.doSave();
    	
    	Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId(mLead.id);
		
		LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
		lc.setConvertedStatus(convertStatus.MasterLabel);
		
		Database.LeadConvertResult lcr = Database.convertLead(lc);
		
    	test.stopTest();
    }
}