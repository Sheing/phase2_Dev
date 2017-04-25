@isTest
public class EEC_VisitAttachmentsExtensiontest {
    static testMethod void testVisitAttachments(){
        
    Inspection__c inspec = EEC_TestUtil.loadInspectionSetup();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(inspec);
        ApexPages.currentPage().getParameters().put('Id',inspec.id);
        
        EEC_VisitAttachmentsExtension er = new EEC_VisitAttachmentsExtension (sc); 
                   er.getCtrlInstance();
           
    }  
}