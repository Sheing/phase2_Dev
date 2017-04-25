@isTest
public class EEC_ContactControllerTest {
    
  public static testMethod void EEC_ContactControllerTest() {
      Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
      Contact c = EEC_TestUtil.mockDirectorContact(acc);
      c.MailingStreet = 'Test';
      c.MailingCity = 'California';
      c.MailingState = 'CA';
      c.MailingCountry = 'USA';
      c.MailingPostalCode = '45644';
      
      c.OtherStreet = 'Test';
      c.OtherCity = 'California';
      c.OtherState = 'CA';
      c.OtherCountry = 'USA';
      c.OtherPostalCode = '45644';
      
      update c;
      
      ApexPages.currentPage().getParameters().put('Id',EEC_TestUtil.mockDirectorContact(acc).Id);
      User u = EEC_TestUtil.mockAccountWithUser();
      
      System.runAs(u){
          //Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
          acc.OwnerId = UserInfo.getUserId();
          update acc;
          ApexPages.currentPage().getParameters().put('member',EEC_TestUtil.mockDirectorContact(acc).Id);
          ApexPages.currentPage().getParameters().put('Id',c.Id);
          
          test.startTest();
          EEC_ContactController cc = new EEC_ContactController();
          cc.contact = c;
          cc.acc = acc;
          String caddres = 'address';
          String address = cc.getAddress();          
          String otherAddress = cc.getOtherAddress();
          Boolean isSelf = cc.getIsSelf();
          Boolean isSelfC = cc.getIsSelfContactMode();
          ApexPages.currentPage().getParameters().put('member',EEC_TestUtil.mockDirectorContact(acc).Id);
          Boolean isUmb = cc.getUmbrellaMemberId();
          ApexPages.currentPage().getParameters().put('selfContactMode',EEC_TestUtil.mockDirectorContact(acc).Id);
          Boolean isCCSelf = cc.getIsSelfContactMode();
          test.stoptest();
      }
  }
    
}