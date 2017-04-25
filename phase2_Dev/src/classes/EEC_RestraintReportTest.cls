@IsTest public class EEC_RestraintReportTest {
    @isTest static void testEEC_RestraintReportTest () {
        City__c c = EEC_TestUtil.mockCity();
        Account a = EEC_TestUtil.mockProvider(c);
        Contact con = EEC_TestUtil.mockDirectorContact(a);
        
        ApexPages.currentPage().getParameters().put('accountId',a.Id);
        
        Restraint_Report__c restraintReport = new Restraint_Report__c();
        restraintReport.Provider__c = a.Id;
        insert restraintReport;
        
         test.startTest();
         EEC_RestraintReport p1 = new EEC_RestraintReport();
         p1.contact = con;
         p1.getRestraintReport(string.valueOf(a.id));
         p1.getRestraintReportByID(restraintReport.id);
         test.stopTest();
    }
    
    @isTest  static  void save() {
        City__c c = EEC_TestUtil.mockCity();
        Account a = EEC_TestUtil.mockProvider(c);
        ApexPages.currentPage().getParameters().put('accountId',a.Id);
        ApexPages.currentPage().getParameters().put('member',a.Id);
        test.startTest();
        EEC_RestraintReport p1 = new EEC_RestraintReport();
        User user = [SELECT ContactId FROM User WHERE Id =: userinfo.getuserid()];
        p1.restraintAccountID = a.Id;
        p1.Contact_Submitted_By = userInfo.getUserName();
        p1.CreatedById = userInfo.getUserId();
        p1.Provider = a.Name;
        p1.Submitted_Date = date.today();
        p1.Total_Injured = 10;        
        p1.getRestraintReport(string.valueOf('0011100000vwa1WAAQ'));
        p1.getRestraintReportByID(string.valueOf('0011100000vwa1WAAQ'));
        p1.save();
        p1.returnProvider();
        test.stopTest();
    }
}