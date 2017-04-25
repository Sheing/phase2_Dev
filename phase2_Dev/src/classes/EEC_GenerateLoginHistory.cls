public with sharing class EEC_GenerateLoginHistory {

     public Contact con;
    
     public EEC_GenerateLoginHistory(ApexPages.StandardController std){
        Id id = std.getId();
        con = [SELECT Id,Name FROM Contact WHERE Id = :id]; 
    }
    
     public PageReference savePDF(){
        PageReference pagePdf = pdfPageReference();
        pagePdf.getParameters().put('id', con.id); 
             
        
        Attachment a = new Attachment();
        a.Body = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pagePdf.getContentAsPdf();
        a.ParentID = con.ID;
        a.Name = 'Portal Login History-' + con.Name + '.pdf';
        
        insert a;
                 
        return new PageReference('/' + con.Id);
    }
    
     public PageReference pdfPageReference(){
        return Page.EEC_GenerateLoginHistoryPDF;
    } 
}