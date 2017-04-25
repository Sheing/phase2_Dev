public class EEC_RestraintReportAttachment {
	 @InvocableMethod
	 public static void createAndInsertAttachment(list<string> Recordids) {
	 	string Reportid;
    	for(string Rec : Recordids){
    	   Reportid = Rec;
    	}
         list<Restraint_Report__c> RRlist = new list <Restraint_Report__c> ([select id,name from Restraint_Report__c where id = : Reportid]);
         for(Restraint_Report__c RR : RRlist){
        PageReference pagePdf = page.EEC_RestraintReportPDF;
        pagePdf.getParameters().put('Id', (string)RR.id);
        //pagePdf.getParameters().put('accountid', account.Id);
        //pagePdf.getParameters().put('member', account.Id);
        system.debug('MMMMMM'+Reportid);
        //System.debug('------> pagePdf: ' + pagePdf.getContent());
        
        Blob pdfPageBlob = pagePdf.getContentAsPDF();
             
        Attachment a = new Attachment();
        a.Body = pdfPageBlob;
        a.ParentID = Reportid;
        a.Name = 'RestraintReportSubmitted.pdf';
        a.Description = 'Report Submitted';
        //insert a;
        insert a;
        system.debug('MMMMMMM'+a);
    }
	 }  
}