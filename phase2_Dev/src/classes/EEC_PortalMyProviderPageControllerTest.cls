@isTest
public class EEC_PortalMyProviderPageControllerTest {
    
  public static testMethod void testEEC_PortalMyProviderPageController() {
    ID accountid;
    Account a = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
    accountid=a.id;
    
    Test.setCurrentPage(new PageReference('Page.EEC_PortalProviderPage'));
    System.currentPageReference().getParameters().put('accountid',accountid);
    System.currentPageReference().getParameters().put('member',EEC_Util.encryptGetParam(accountid));
    System.currentPageReference().getParameters().put('licTransId',accountid);  
      
    EEC_PortalMyProviderPageController prov = new EEC_PortalMyProviderPageController();
    prov = new EEC_PortalMyProviderPageController();
    prov.subInc();
    prov.resReport();
    prov.getSortDirection();
    prov.setSortDirection('DESC');
    
    prov.trxIntro();
    prov.noncomp();
    prov.getContact();
    prov.getUser();
    prov.getAccount();
    prov.getContactlist();
    prov.getProviderslist();
    prov.getLicenselist();    
    prov.getIsEdit();
    prov.investigationPage();
    prov.home();
    prov.cancel();
    prov.save();
    prov.edit();
    prov.getUmbrellaFCCSystem();
    prov.getFCCSystemName();
    prov.getFCCSystemExists();  
    prov.editInstruction(); 
    prov.getIsAssistant();
    prov.getEncryptedAccountId();
    prov.createSecureTransactionMap();
    prov.subInc();
    prov.resReport();  
    	prov.getAttachmentId();
      prov.condition_none = 'Test';
      prov.memberIds = 'Test';
      prov.Attachmentid = 'Test';
      prov.listsize = 10;
      prov.errorMsg = '';
      prov.secureMemberMap = null;

     a = [SELECT RecordType.Name FROM Account WHERE Id = :a.Id]; 
     System.debug('Record type --> ' + a.RecordType.Name);
     System.debug('Account id  -->' + accountid);
  }  
}