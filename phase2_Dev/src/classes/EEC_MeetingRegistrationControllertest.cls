@istest
public class EEC_MeetingRegistrationControllertest {
    static testmethod void MeetingRegistration() { 
        Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('Small Group', null);
        
        Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'Small_Group');
        accnt.Config_Record__c = config2.Id;
        update accnt;
        
        Contact contact = EEC_TestUtil.mockContact(accnt, 'Test', 'LastName', '');
        
        Contact_Role__c contactRole = EEC_TestUtil.mockContactRole('Partner', contact.Id, accnt.Id);
        contactRole = EEC_TestUtil.mockContactRole('Administrative Designee', contact.Id, accnt.Id);
        contactRole = EEC_TestUtil.mockContactRole('Program Director / Administrative Head', contact.Id, accnt.Id);
        contactRole = EEC_TestUtil.mockContactRole('Board Chair', contact.Id, accnt.Id); 
        contactRole = EEC_TestUtil.mockContactRole('Owner', contact.Id, accnt.Id);
        
        User portaluser = EEC_TestUtil.mockPortalUser (contact);
        
        Provider_Meeting__c  providermeeting  = EEC_TestUtil.mockGsaProviderMeeting();
        
        System.runAs(portaluser){
            test.startTest();
            EEC_MeetingRegistrationController mp = new EEC_MeetingRegistrationController();            
            mp.selectedContact = contact.Id;
            mp.selectedMeetingId = providermeeting.Id;
            mp.doRegistration(); 
            Provider_Meeting_Participant__c providermeetingparticipant =[Select ID From Provider_Meeting_Participant__c Limit 1];
            mp.selectedParticipantId = providermeetingparticipant.Id;
            mp.doViewMeetingDetail();
            mp.doCancelRegistration();            
            mp.doBack();
            test.stopTest();
            
        }
        
    }   
    
}