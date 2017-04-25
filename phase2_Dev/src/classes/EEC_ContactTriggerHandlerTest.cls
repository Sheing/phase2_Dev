@isTest
public class EEC_ContactTriggerHandlerTest {
    
    static testMethod void testContactUpdate(){
        Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        Contact c = EEC_TestUtil.mockDirectorContact(acc);
        c.FirstName = 'New Name';
		update c;
    }
    
    

}