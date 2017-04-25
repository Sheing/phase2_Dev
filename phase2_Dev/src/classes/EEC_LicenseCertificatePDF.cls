public class EEC_LicenseCertificatePDF {

     public Licensing_Transaction__c ld;
    
     public EEC_LicenseCertificatePDF(ApexPages.StandardController std){
        Id id = std.getId();
        ld = [SELECT Id,Name, Provider__c FROM Licensing_Transaction__c WHERE Id = :id]; 
   	 }
     
     public PageReference savePDF(){
     	
     	Account acc = [Select Id,name, RecordTypeId From Account Where Id=:ld.Provider__c];
     	Map<Id,RecordType> accountRTMap = new Map<Id,RecordType>([Select id,Name from RecordType where sObjectType = 'Account' and isActive = true]);
        string rtName = null;
        PageReference pagePdf;
        
        if (acc != null){
            rtName = accountRTMap.get(acc.RecordTypeId).Name;
        }
        
        if(rtName == 'Family Child Care'){
            pagePdf = pdfPageReference();
        }
        else if (rtName == 'FCC Assistant'){
        	pagePdf = pdfFCCAssistant();
        }
        else {
            pagePdf = pdfGSACertificatePDF();
        } 
        pagePdf.getParameters().put('id', ld.id); 
        
        
        Attachment a = new Attachment();
        a.Body = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pagePdf.getContentAsPdf();
        a.ParentID = ld.ID;
        a.Name = 'License Certificate-' + ld.Name + '.pdf';
        
        insert a;
                 
        return new PageReference('/' + ld.Id);
    }
    
    public PageReference pdfPageReference(){
        return Page.EEC_LicenseCertificatePDF;
    } 
    
    public PageReference pdfFCCAssistant(){
        return Page.EEC_FCCAssistantLicenseCertPDF;
    }
    
    public PageReference pdfGSACertificatePDF(){
        return Page.EEC_GSARPLicenseCertificatePDF;
    } 
}