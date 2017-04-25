/**
 * 
 * EEC_GenerateLoginHistoryTest
 * 
 * This class contains all unit tests relating to the EEC_GenerateLoginHistoryExtension class
 * and the EEC_GenerateLoginHistoryPDF page
 * 
 * @author Nettles
 * 
 */

@isTest
private class EEC_GenerateLoginHistoryTest {
    static testMethod void testEEC_GenerateLoginHistoryExtension() {
        Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        Contact c = EEC_TestUtil.mockDirectorContact(acc);
        c.FirstName = 'New Name';
        c.Department = 'Department';
        c.Description = 'Description';
		update c;
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        EEC_GenerateLoginHistoryExtension ext = new EEC_GenerateLoginHistoryExtension(sc);
        ext.getLoginHistory();
        
        Test.stopTest(); 
    }
    
    static testMethod void testEEC_GenerateLoginHistoryPDF() {
        
        Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        Contact c = EEC_TestUtil.mockDirectorContact(acc);
        c.FirstName = 'New Name';
        c.Department = 'Department';
        c.Description = 'Description';
		update c;
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        EEC_GenerateLoginHistory ext = new EEC_GenerateLoginHistory(sc);
        PageReference pageRef = ext.savePDF();

        Test.stopTest(); 
        
        // Make sure we created one attachment for the contact
        List<Attachment> att = [SELECT Id, Name FROM Attachment WHERE parent.id = :c.id];
		System.assertEquals(1, att.size());
        
    }
}