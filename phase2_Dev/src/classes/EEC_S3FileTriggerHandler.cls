public with sharing class EEC_S3FileTriggerHandler {
    public static void doAfterInsert(List<S3_File__c> listS3File){
    	updateAttachmentStatus(listS3File);	
    }
    
    public static void doAfterUpdate(List<S3_File__c> listS3File){
    	updateAttachmentStatus(listS3File);
    }
    
    public static void doAfterUnDelete(List<S3_File__c> listS3File){
    	updateAttachmentStatus(listS3File);
    }
    
    public static void doAfterDelete(List<S3_File__c> listS3File){
    	updateAttachmentStatus(listS3File);
    }
    
    private static void updateAttachmentStatus(List<S3_File__c> listS3File){
    	

		Set<Id> setDocumentIds = new Set<Id>();
    	for(S3_File__c s3File : listS3File){
    		if(s3File.Document__c != null){
    			setDocumentIds.add(s3File.Document__c);
    		}
    	}
    	
		

    	Map<Id,AggregateResult> mapS3Files = new Map<id,AggregateResult>
    	([select Document__c Id, count(Id) from S3_File__c where
    									Document__c in : setDocumentIds group by Document__c]);
    									
    	List<Document__c> listDocuments = [select Id, Attachment_Status__c from Document__c where Id in : setDocumentIds];
    	
    	for(Document__c document : listDocuments){
    		AggregateResult aggregate = mapS3Files.get(document.Id);

			if(aggregate != null)
			{
				integer fileCount = (integer)aggregate.get('expr0');
				if(fileCount > 0){
					document.Attachment_Status__c = 'Attachment(s) Available';
				}
				else{
					document.Attachment_Status__c = 'No Attachment';
				}
			}
			else
			{
				document.Attachment_Status__c = 'No Attachment';
			}
    		
    	}
    	update listDocuments;
    }
}