@isTest
public class EEC_UserTriggerHandlerTest {
    
  static testMethod void testUpdateInactiveAccount() {
    Profile p = [SELECT ID FROM Profile Where Name = 'System Administrator' LIMIT 1];
    Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
    Contact con = EEC_TestUtil.mockDirectorContact(acc);
    User runAsUser = new User(
      Email = 'test@test.com',
      LastName = 'Admin',
      FirstName = 'System',
      Username = EEC_TestUtil.generateRandomString(26) + '@test.com',
      Alias = 'sysad',
      TimeZoneSidKey = 'GMT',
      LocaleSidKey = 'en_US',
      EmailEncodingKey = 'ISO-8859-1',
      ProfileID = p.Id,
      region__c = EEC_TestUtil.mockRegion().Id,
      LanguageLocaleKey = 'en_US'
    );
    insert runAsUser; 
      
    User u1 = EEC_TestUtil.mockUser();
    acc.Owner = u1;
    update acc;
    
    List<User> users = new List<User>{
      u1,
      EEC_TestUtil.mockUser(),
      EEC_TestUtil.mockUser(),
      EEC_TestUtil.mockUser()
    };
        
    System.runAs(runAsUser) {      
      for (User u : users) {
        u.IsPortalEnabled = true; 
        u.isActive = true;          
      }
      update users;
    }
  }
  @future 
    static void createUserRoles(){
        test.starttest();
    
        Contact contact = [select Id, Name from Contact limit 1];
        
        User runAsUser = [select Id, Name from User where email= 'test@test.com'];
        
        List<User> users = new List<User>{       
            EEC_TestUtil.mockPortalUserwithRole(contact,'none')    
        };
                    
        System.runAs(runAsUser) {      
            for (User u : users) {    
                u.IsPortalEnabled = true; 
                u.isActive = true;          
            }
            update users;
        }
        test.stoptest();
    }
    
  static testMethod void testCreateTasks() {
    User u = EEC_TestUtil.mockUser();
    Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
    Account acc2 = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());      
      
    EEC_UserTriggerHandler.createTasks(new Map<Id,Id>{acc.Id => u.Id, acc2.Id => u.Id});
  }
}