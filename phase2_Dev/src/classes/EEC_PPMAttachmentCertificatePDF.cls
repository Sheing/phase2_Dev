public with sharing class EEC_PPMAttachmentCertificatePDF {
     public Provider_Meeting__c providerMeeting{get;set;}
     public string meetingType{get;set;}
     
     public EEC_PPMAttachmentCertificatePDF(ApexPages.StandardController std){
        Id id = std.getId();
        providerMeeting = [SELECT Id,Name, Meeting_Type__c,Meeting_Region__c,Scheduled_Start__c, (select Id, Potential_Provider_Name__c, Meeting_Type__c, Meeting_Region__c, Scheduled_Start_Time__c, Contact_Name__c, Participation_Status__c from Provider_Meeting_Participants__r where Participation_Status__c='Attended') FROM Provider_Meeting__c WHERE Id = :id];
        
        if(providerMeeting.Meeting_Type__c == 'PPM (FCC)'){
        	meetingType = 'Family Child Care Potential Provider Meeting';
        }
        else if(providerMeeting.Meeting_Type__c == 'PPM (GSA)'){
        	meetingType = 'Group and School Age Potential Provider Meeting';
        }
        else if(providerMeeting.Meeting_Type__c == 'Renewal (GSA)'){
        	meetingType = 'Group and School Age Renewal Meeting';
        } 
    }
    
     public PageReference savePDF(){
        PageReference pagePdf = pdfPageReference();
        pagePdf.getParameters().put('id', providerMeeting.id); 
             
        
        Attachment a = new Attachment();
        a.Body = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pagePdf.getContentAsPdf();
        a.ParentID = providerMeeting.ID;
        a.Name = 'Attendance Certificate-' + providerMeeting.Name + '.pdf';
        
        insert a;
                 
        return new PageReference('/' + providerMeeting.Id);
    }
    
     public PageReference pdfPageReference(){
        return Page.EEC_PPMAttendanceGenerateCertificatePDF;
    } 
}