/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@istest
public class EEC_Batch_InvestigationConclusionTest {
//class testmethod
    static testmethod void  batchinvestigation(){
        //create account
        Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC');
        // create contact
        Contact contact = EEC_TestUtil.mockDirectorContact(accnt); 
        //create case
        Case cases = EEC_TestUtil.mockCase(accnt, contact );  
        //adding case to list
        List<Case> caselist = new List<Case>();
        caselist.add(cases);
        Database.BatchableContext BC;
        
    test.startTest();        
        // calling batch class and its method
            EEC_Batch_InvestigationConclusion batchinvest = new EEC_Batch_InvestigationConclusion();
            batchinvest.execute(BC, caselist);
            batchinvest.start(BC);
            batchinvest.finish(BC);    
    test.stopTest();
    }
}