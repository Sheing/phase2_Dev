public  class EEC_SendEmailProvider {
    @InvocableMethod 
    public static void sendEmail(list<string> templateAndRecordID){
    	string recordid;
    	string tempid;
    	for(string tempRec : templateAndRecordID){
    	   Recordid = tempRec.substringAfter('|');
    	   tempid = tempRec.substringbefore('|');
    	   system.debug('MMMM'+Recordid+tempid);
    	}
     EmailTemplate template47a = [SELECT Body,brandtemplateid,Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'X47a_Transaction_Electronic_Submission_Confirmation_New_App_Renewal_Upgrade'];
     EmailTemplate template92a = [SELECT Body,brandtemplateid,Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'X92a_FCC_Assistant_Transaction_submission_confirmation_NewLicense_Renewal_Upgra'];
     BrandTemplate bt = [SELECT Id,Value FROM BrandTemplate WHERE Id =: template47a.brandtemplateid LIMIT 1];	
     
     set<id> ltset = new set<id>();
     
     list<Licensing_Transaction__c> lList = [select id,name,Status__c,Source__c,RecordType.Name,Assigned_User_Email__c,Submission_Confirmation_Sent__c,
                                             Provider__c,Assigned_To__c,Associated_Fee__c,Provider__r.Region_Address__c,Provider__r.recordtype.name,
                                             Assigned_To_Phone__c,Provider__r.Region_Fax__c,Provider__r.Region_Phone__c,Provider__r.Electronic_Communication__c,
                                             Provider__r.Region_Email__c,Submitter__c,Submitter__r.ContactId,Submitter__r.id,Submitter_Email_Address__c from Licensing_Transaction__c where id =: recordid];
      list<OrgWideEmailAddress> orgList = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'EEC LEAD Alert'];
      for(Licensing_Transaction__c ltran: lList){
       ltset.add(ltran.Submitter__r.ContactId);
      }
      List<Contact> c = [select id, Email from Contact where Id IN: ltset];	
      if(c.size() >0){
         system.debug('MMMM'+c[0].id);
      
	      for(Licensing_Transaction__c lt: lList){
	      EEC_EmailUtil email = new EEC_EmailUtil();
	      email.saveAsActivity = false;
	      string fee = string.valueof(lt.Associated_Fee__c);
	     
	          
		  PageReference pdf = Page.EEC_EmailRegionPDF;
	      pdf.getParameters().put('id',(String)lt.id);
		  pdf.setRedirect(true);
		  Blob b = pdf.getcontent();
	          
		  Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
		  efa.setFileName('RegionInfo.pdf');
		  efa.setBody(b);
		  system.debug('MMMMM'+efa);
		  email.FileAttachments = new list<Messaging.EmailFileAttachment>();
	      email.FileAttachments.add(efa);
		  email.targetObjectId = c[0].Id;
		   email.orgWideEmailId = orglist[0].id;
	      email.toAddresses = new List<String>();
	      //email.toAddresses.add(lt.Submitter_Email_Address__c);
	      email.whatid=lt.id;
	      if(tempid == '47a'){
	      email.templateid= template47a.id;   
		  string htmlBody = template47a.HtmlValue;
	      htmlBody = htmlBody.replace('{!Licensing_Transaction__c.Provider__c}', lt.Provider__c)
	                    .replace('{!Licensing_Transaction__c.RecordType}', lt.recordtype.name)
	                    .replace('{!Licensing_Transaction__c.Associated_Fee__c}',fee)
	                    .replace('{!Account.Region_Address__c}', lt.Provider__r.Region_Address__c)
	                    .replace('{!Licensing_Transaction__c.Assigned_To__c}', lt.Assigned_To__c)
	                    .replace('{!Licensing_Transaction__c.Assigned_To_Phone__c}', lt.Assigned_To_Phone__c)
	                    .replace('{!Licensing_Transaction__c.Assigned_User_Email__c}', lt.Assigned_User_Email__c)
	                    .replace('{!Account.Region_Phone__c}', lt.Provider__r.Region_Phone__c);
	            //system.debug('MMMM'+email.htmlBody);
	            //email.targetObjectId= c.id; 
	            
	      //email.htmlBody = htmlBody;
	      email.subject = template47a.Subject;
	      }else if(tempid == '92a'){
	      email.templateid= template92a.id;
	      email.subject = template92a.Subject;
	      string htmlBody = template92a.HtmlValue;
	      htmlBody = htmlBody.replace('{!Licensing_Transaction__c.Provider__c}', lt.Provider__c)
	                    .replace('{!Licensing_Transaction__c.RecordType}', lt.recordtype.name)
	                    .replace('{!Licensing_Transaction__c.Associated_Fee__c}',fee)
	                    .replace('{!Account.Region_Address__c}', lt.Provider__r.Region_Address__c)
	                    .replace('{!Licensing_Transaction__c.Assigned_To__c}', lt.Assigned_To__c)
	                    .replace('{!Licensing_Transaction__c.Assigned_To_Phone__c}', lt.Assigned_To_Phone__c)
	                    .replace('{!Licensing_Transaction__c.Assigned_User_Email__c}', lt.Assigned_User_Email__c)
	                    .replace('{!Account.Region_Phone__c}', lt.Provider__r.Region_Phone__c);
	      }
	      System.debug('MMMMM'+email.toAddresses);
	      email.sendEmail();
	     }
    }
    
   }
}