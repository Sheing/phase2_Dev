/**
 * EEC_GenerateNonCompPDFControllerTest
 * 
 * This class contains all the unit tests relating to the EEC_GenerateNonCompPDFController class.
 * @author Darkis
 * 
 */

@isTest
private class EEC_GenerateNonCompPDFControllerTest {

    static testMethod void testEEC_GenerateNonCompPDFController() {
        // Setup basic defaults.
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        // Call constructor.
        new EEC_GenerateNonCompPDFController(sc);
    }
    
    static testMethod void testGeneratePDF() {
        // Setup basic defaults.
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        
        Inspection__c i = [SELECT Id,Statement_of_non_compliance__c FROM Inspection__c LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        EEC_GenerateNonCompPDFController controller = new EEC_GenerateNonCompPDFController(sc);        
        // Call the controller method.
        controller.GeneratePDF();   
        
        List<Attachment> attachments = [SELECT Name FROM Attachment WHERE ParentID = :i.Id]; 
        
        //controller.createAndInsertAttachment(insp); 
    }
}