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
@isTest
private class EEC_TestLicensingTransactionTrigger {

    static testMethod void testLicensingTransactionTrigger() {
        EEC_TestUtil.mockLeadConfig('Family Child Care', null);
        Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.MockCity());
        RecordType r = [select Id from RecordType where DeveloperName='FCC_Change_of_Household' and sobjecttype='Licensing_Transaction__c'];
        Licensing_Transaction__c lic = new Licensing_Transaction__c(RecordTypeId=r.Id,Status__c='Submitted', Provider__c=accnt.Id,Submitter__c=Userinfo.getUserId());
        lic.Assigned_User_Email__c = 'test@email.com';
        insert lic;
        EEC_TestUtil.mockHouseHold(lic, accnt);
        
    }
    
    //      Licensing_Transaction__c ltResult = [Select Missing_Elements_For_Licensor_2__c From Licensing_Transaction__c where id= :lic.id];
    //    system.assertEquals(ltResult.Missing_Elements_For_Licensor_2__c, 'Status Incorrect - License Expiration Date not filled -License Issue Date not filled - License Requested not filled - License Type not filled - Exp. / Training Not Reviewed - Licensee CORI Missing - SORI Missing - Licensee DCF Missing - Other Info Not Reviewed - Conditions Not Finalized - Need Manager Approval');
  
   static testMethod void testMissingElementsForLicensor() {
    
        Lead_Configuration__c ld = new Lead_Configuration__c();
        ld.name = 'FCC Assistant';
        ld.New_License_Fee__c = 75;
        ld.License_Renewal_Fee__c = 25;
        ld.License_Upgrade_Fee__c = 25;
        ld.RecordTypeId = [select Id from RecordType where Name='Per Provider Type' and sobjecttype='Lead_Configuration__c'].Id;
        insert ld;
    
   
        Account a = new Account();
        a.Name = 'Test FCC Assistant';
        a.RecordTypeId = [select Id from RecordType where SobjectType = 'Account' and Name = 'FCC Assistant'].id;
        a.License_Status__c = 'Not Licensed';
        a.License_Type__c = 'Regular Assistant';
        a.Preferred_Language__c = 'English';
        a.Provider_Address_1__c = '1212';
        a.Provider_Email__c = 'test@test.com';
        a.State__c = 'MA';
        a.Provider_City__c = EEC_TestUtil.mockCity().Id;
        a.Provider_Zip_Code__c = '90270';
        a.Config_Record__c = ld.id;
        insert a;
        RecordType r = [select Id from RecordType where Name='FCC Assistant New License' and sobjecttype='Licensing_Transaction__c'];
        Licensing_Transaction__c FCCAssistlic = new Licensing_Transaction__c(RecordTypeId=r.Id,Status__c='Submitted', Provider__c=a.Id,Submitter__c=Userinfo.getUserId());
        FCCAssistlic.Caring_For_Children_Not_Related__c = '2';
        FCCAssistlic.Caring_for_other_peoples_children_Hr_Wk__c = 2;
        FCCAssistlic.Caring_for_other_peoples_children_Month__c = 2;
        FCCAssistlic.Caring_for_other_peoples_children_Years__c = 2;
        FCCAssistlic.Caring_for_your_own_children_Hrs_Week__c = 2;
        FCCAssistlic.Caring_for_your_own_children_Months__c = 2;
        FCCAssistlic.Caring_for_other_peoples_children_Years__c = 2;
        FCCAssistlic.Caring_for_your_own_children_Years__c = 2;
        FCCAssistlic.Other_Children_Kindergarten_Hrs_Week__c = 2;
        FCCAssistlic.Other_Children_Kindergarten_Months__c =2;         
        FCCAssistlic.Other_Children_Kindergarten_Years__c = 2;
        FCCAssistlic.Charged_or_Arrested_for_Crime__c = 'No';
        FCCAssistlic.Dealings_with_Child_Prot_Child_Welfar__c = 'No';
        FCCAssistlic.Abused_or_neglected_a_child__c = 'No';
        FCCAssistlic.Use_of_Alcoholic_Bev_Narcotics_Drugs__c ='No';
        FCCAssistlic.Restraining_Order_Issued__c ='No';
        FCCAssistlic.Registering_as_Sex_Offender__c ='No';
        FCCAssistlic.Took_Medication_Administration_Training__c ='No';
        FCCAssistlic.Took_Transportation_Training__c ='No';
        FCCAssistlic.Took_SIDS_Training__c = 'No';
        FCCAssistlic.Took_USDA_Nutrition_Training__c ='No';
        FCCAssistlic.Took_FCC_Orientation_Module_1__c = 'No';
        FCCAssistlic.CPR_Certified__c ='No';
        FCCAssistlic.First_Aid_Certified__c ='No';
        FCCAssistlic.Taken_Intro_to_EEC_in_Mass_Orientation__c = 'No';
        FCCAssistlic.Daily_Routine_and_Activities__c ='Test Routines';
        FCCAssistlic.Medical_Emergency_Steps__c = 'Test Medical Emergency steps';
        FCCAssistlic.Steps_for_Guiding_Child_Behavior__c = 'Test steps for guiding child behavior';
        
        test.startTest();
        insert FCCAssistlic; 
       
        update FCCAssistlic;
        test.stopTest();
       
       Licensing_Transaction__c ltResult = [Select Missing_Elements_For_Licensor_2__c From Licensing_Transaction__c where id= :FCCAssistlic.id];
        
       if(ltResult != null){
           
        // Boolean result=ltResult.Missing_Elements_For_Licensor_2__c.contains('Status Incorrect - License Expiration Date not filled -License Issue Date not filled - License Requested not filled - License Type not filled - Exp. / Training Not Reviewed - Licensee CORI Missing - SORI Missing - Licensee DCF Missing - Other Info Not Reviewed - Conditions Not Finalized - Need Manager Approval');
         system.assertEquals(ltResult.Missing_Elements_For_Licensor_2__c != null,true); 
       }

      



  
    }
   /*static testMethod void testLTRenewal() {
        EEC_TestUtil.mockLeadConfig('Family Child Care', null);
        Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.MockCity());
        RecordType r = [select Id from RecordType where DeveloperName='FCC_Renewal' and sobjecttype='Licensing_Transaction__c'];
        Licensing_Transaction__c lic = new Licensing_Transaction__c(RecordTypeId=r.Id,Status__c='Submitted', Provider__c=accnt.Id,Submitter__c=Userinfo.getUserId());
        insert lic;
        EEC_TestUtil.mockHouseHold(lic, accnt);
        
    }
    
    static testMethod void testLTChangeOfHousehold() {
        Account accnt = EEC_TestUtil.loadLicenseTransaction();
        RecordType r = [select Id from RecordType where DeveloperName='FCC_Change_of_Household' and sobjecttype='Licensing_Transaction__c'];
        Licensing_Transaction__c lic = new Licensing_Transaction__c(RecordTypeId=r.Id,Status__c='Submitted', Provider__c=accnt.Id,Submitter__c=Userinfo.getUserId());
        insert lic;
        EEC_TestUtil.mockHouseHold(lic, accnt);
        
    }*/
    
}