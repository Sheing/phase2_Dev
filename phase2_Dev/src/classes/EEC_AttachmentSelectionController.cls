public with sharing class EEC_AttachmentSelectionController{
    public LEAD_Configuration__c leadConfiguration {get;set;}
    public Document__c document{get;set;}
	public List<s3Wrapper> listS3File{get;set;}
    public String generateFileId {get; set;}
    public string accessKey{get;set;}
    public string attachmentJSON{get;set;}
	public string documentName{get;set;}
	public string documentNotes{get;set;}
	public Transaction_Document__c transactionDocument {get; set;}
	public Licensing_Transaction__c licenseTransaction {get; set;}
	public Contact contact {get; set;}

    private string accountId{get;set;}
    private string transactionId{get;set;}
    private string varianceId{get;set;}
    private string transactiondocId{get;set;}
    private string attachmentType{get;set;}
    
    private AWS_Config__c aws{get;set;}
    private AWSKeys credentials{get;set;}
    private string bucket{get;set;}
	
	public class s3Wrapper{
		public S3_File__c s3File{get;set;}
		public string fileUrl{get;set;}	
	}
	
    public EEC_AttachmentSelectionController(){
    	string documentId = ApexPages.currentPage().getParameters().get('id');
    	transactionId = ApexPages.currentPage().getParameters().get('transactionId');
    	varianceId = ApexPages.currentPage().getParameters().get('varianceid');
    	transactiondocId = ApexPages.currentPage().getParameters().get('transactiondocId');
    	attachmentType = ApexPages.currentPage().getParameters().get('type');
    	
	    User loggedUser = [select Id, Name, contactId from User where Id = :UserInfo.getUserId()];
	    
	    string providerRecordType = '';
	    
	    if(loggedUser.contactId != null){
	    	contact = [select Id, Account.Id, Account.RecordType.Name from Contact where Id =: loggedUser.contactId];    	
	    	providerRecordType = contact.Account.RecordType.Name;
	    	accountId = contact.Account.Id;

			//System.Debug('TransctionDocID=' + transactiondocId);
			
			//Changed for Lead 5169
			if(string.isNotBlank(transactiondocId))
			{
				transactionDocument = [SELECT Status__c,Document_Level__c FROM Transaction_Document__c WHERE ID= :transactiondocId];
			}
			
			//System.debug('transactionDocument' + transactionDocument);
			if(string.isNotBlank(transactionId))
			{
				licenseTransaction = [Select Id, Provider__c, 
	    			RecordType.Name, RecordType.DeveloperName,
	    			RecordTypeId,
	    			Provider__r.RecordType.Name,
	    			Provider__r.RecordType.DeveloperName,
	    			Transaction_Configuration__c,
			    	Provider__r.Umbrella_Members__c, Status__c
	             	From Licensing_Transaction__c where Id = :transactionId];
			}
			
	    }
	    else{
	    	if(string.isNotBlank(transactionId)){
				//Changed for Lead 5169
		    	licenseTransaction = [Select Id, Provider__c, 
	    			RecordType.Name, RecordType.DeveloperName,
	    			RecordTypeId,
	    			Provider__r.RecordType.Name,
	    			Provider__r.RecordType.DeveloperName,
	    			Transaction_Configuration__c,
			    	Provider__r.Umbrella_Members__c, Status__c
	             	From Licensing_Transaction__c where Id = :transactionId];
	             	
	            accountId = licenseTransaction.Provider__c;
	            
	            Account account = [select Id, RecordType.Name from Account where Id =: accountId];
	            
	            providerRecordType = account.RecordType.Name;

				
	    	}
	    }
	    
    	leadConfiguration = [Select Id, Attachment_Selection_Page_Intro__c from LEAD_Configuration__c where 
    												Name = :providerRecordType];

		aws = AWS_Config__c.getInstance();
        bucket = aws.S3_Bucket_Name__c;
        string signedUrl = aws.S3_Endpoint_Url__c;
        
        credentials = new AWSKeys('eec');
                
        accessKey = credentials.key;

		listS3File = new List<s3Wrapper>();
    	if(string.isNotBlank(documentId)){
			document = [select Id, Document_Name__c, Document_Type__c, Document_Type__r.Name,
				Approved_for_Future_Usage__c,Provider__c,
				Document_Type__r.Description__c, Attachment_Status__c, Notes__c,Valid_From__c,Valid_To__c from 
				Document__c where Id =: documentId limit 1];
			
			if(string.isBlank(document.Document_Name__c))	
				documentName = document.Document_Type__r.Name;
			else
				documentName = document.Document_Name__c;
			
			documentNotes = document.Notes__c;
			
			List<S3_File__c> listFiles = [select Id, Filename__c, Bucket__c, CreatedDate, Prefix__c,Content_Type__c,
							Acl__c from S3_File__c 
						where Document__c =: documentId];
			
			string fileName = '';
	        for(S3_File__c s3File : listFiles){
	        	s3Wrapper s3Wrapper = new s3Wrapper();
	        	fileName = '';
	        	if (!String.isBlank(s3File.Prefix__c)) {
			    	filename += s3File.Prefix__c + '/';
			    }
			    filename += s3File.Filename__c;
			    
	        	s3Wrapper.fileUrl = EEC_S3ComponentCtrl.generateTempS3Url(s3File.Bucket__c,EncodingUtil.urlEncode(filename, 'UTF-8'));
	        	s3Wrapper.s3File = s3File;
	        	listS3File.add(s3Wrapper);
	        }
	        
	        attachmentJSON = JSON.serialize(listS3File);
    	}
    	else{
    		document = new Document__c();
    		documentName = '';
    		documentNotes = '';
    		attachmentJSON = '[]';
    	}
    }
	
	public void doCreateDocument(){
		if(document.Id == null){
			document.Provider__c = accountId;
			insert document;
		}	
	}
	
    public PageReference doBack(){
    	PageReference pageReference = Page.EEC_PortalLandingPage_2;
    	pageReference.setRedirect(true);
    	return pageReference;
    }
    
    /**
	* generateMultiplePolicySignature
	* 
	* This function will call the S3ComponentCtrl to generate multiple or single policy and signature combos for specified files to upload to S3.
	* @author Darkis
	* @param String bucket The name of the bucket to save to.
	* @param String acl The permission level of the file. Typically this would be 'authenticated-read' for our purposes. 
	* @param String fileJson A JSON string of all the files to be uploaded from the Angular Controller.
	*/
    @RemoteAction
    public static List<Map<String, String>> generateMultiplePolicySignature(String bucket, String acl, String fileJson) {
        List<Map<String, String>> returnJson = new List<Map<String, String>> ();
        List<EEC_S3ComponentCtrl.FileTypeJsonWrapper> fileTypeWrapperList = (List<EEC_S3ComponentCtrl.FileTypeJsonWrapper>) JSON.deserialize(fileJson, List<EEC_S3ComponentCtrl.FileTypeJsonWrapper>.class);
        // Loop through the files given and get all the necessary policy/sig combos.
        for (EEC_S3ComponentCtrl.FileTypeJsonWrapper wrapper : fileTypeWrapperList) {
            returnJson.add(EEC_S3ComponentCtrl.generatePolicySignature(bucket, acl, wrapper.filename, wrapper.type, null));
        }
        return returnJson;
    }
    
    public void doSave(){    	
    	String attachmentbody = ApexPages.currentPage().getParameters().get('attachmentbody');
    	String attachmentdeletebody = ApexPages.currentPage().getParameters().get('attachmentdeletebody');

    	List<S3_File__c> s3FilesList;
    	List<S3_File__c> s3FilesDeleteList;
    	if (!String.isBlank(attachmentbody)) {
    		s3FilesList = (List<S3_File__c>) JSON.deserialize(attachmentbody, List<S3_File__c>.class);
    	}
    	else{
    		s3FilesList = new List<S3_File__c>();
    	}
    	if(!string.isBlank(attachmentdeletebody)){
    		s3FilesDeleteList = (List<S3_File__c>) JSON.deserialize(attachmentdeletebody, List<S3_File__c>.class);
    	}
    	else{
    		s3FilesDeleteList = new List<S3_File__c>();
    	}
    	
    	if(document.Valid_From__c == null){
    		document.Valid_From__c = datetime.now();
    		if(string.isNotBlank(varianceId) && attachmentType == 'V'){
    			Variance_on_Regulation__c variance = [select Id, Associated_Regulation__r.Regulation_Number__c from
    			Variance_on_Regulation__c where Id =: varianceId];
    			
    			documentName = 'Variance  -  ' + variance.Associated_Regulation__r.Regulation_Number__c + ' - ' + documentName;
    		}
    		else if(attachmentType == 'A'){
    			documentName = 'Attach  -  ' + documentName;
    		}
    		if(documentName.length() > 100)
    			documentName.subString(0,100);
    			
    		document.Document_Name__c = documentName;
    		document.Notes__c = documentNotes;
    		
    		upsert document;
    		
			//Changed for Lead 5169
    		transactionDocument = new Transaction_Document__c();
    		 	
    		if(string.isNotBlank(transactionId)){
				transactionDocument.Licensing_Transaction__c = transactionId;
			}
    		
    		transactionDocument.Document__c = document.Id;
    		
    		if(string.isNotBlank(transactiondocId)){
    			transactionDocument.Id = transactiondocId;
    		}
    		else{
    			if(string.isNotBlank(transactionId)){
    				transactionDocument.Licensing_Transaction__c = transactionId;
    			}
    		}
    		if(attachmentType == 'A'){
    			transactionDocument.Mode__c = 'Additional';
    		}
    		else if(string.isNotBlank(varianceId) && attachmentType == 'V'){
    			transactionDocument.Variance_on_Regulation__c = varianceId;
    			transactionDocument.Mode__c = 'Variance';
    		}
    		else if(attachmentType == 'I'){
    			transactionDocument.Mode__c = 'Individual';
    		}
    		else if(attachmentType == 'R'){
    			transactionDocument.Mode__c = 'Required';
    		}
    		else if(attachmentType == 'O'){
    			transactionDocument.Mode__c = 'Optional';
    		}
    		if(string.isNotBlank(transactionId)){
	    		transactionDocument.Status__c = 'To Submit';
	    		transactionDocument.Last_Status_Date__c = date.today();
	    		upsert transactionDocument;
    		}
    		if(s3FilesList != null && s3FilesList.size() > 0){
	    		for(S3_File__c s3File : s3FilesList){
	    			s3File.Document__c = document.Id;
	    		}
	    		if(s3FilesList.size() > 0)
	    			upsert s3FilesList;
	    	}
    		
    		if(s3FilesDeleteList != null && s3FilesDeleteList.size() > 0){
    			List<S3_File__c> listDeleteS3 = new List<S3_File__c>();
    			for(S3_File__c s3File : s3FilesDeleteList){
    				if(s3File.Id != null)
    					listDeleteS3.add(s3File);
    			}
    			if(listDeleteS3.size() > 0)
    				delete listDeleteS3;
    		}    		
		}
    	else{
    		if(documentName != document.Document_Name__c || documentNotes != document.Notes__c 
    		 || s3FilesList.size() != listS3File.size() || s3FilesDeleteList.size() > 0){
    		 	document.Valid_To__c = datetime.now();
	    		document.Approved_for_Future_Usage__c = false;
	    		upsert document;
	    		
	    		Document__c newDocument = new Document__c();
	    		if(string.isNotBlank(varianceId)){
	    			Variance_on_Regulation__c variance = [select Id, Associated_Regulation__r.Regulation_Number__c from
	    			Variance_on_Regulation__c where Id =: varianceId];
	    			
	    			documentName = 'Variance  -  ' + variance.Associated_Regulation__r.Regulation_Number__c + ' - ' + documentName;
	    		}
	    		else if(string.isNotBlank(transactionId)){
	    			documentName = 'Attach  -  ' + documentName;
	    		}
	    		if(documentName.length() > 100)
    				documentName.subString(0,100);
    				
    			document.Document_Name__c = documentName;
	    		newDocument.Notes__c = documentNotes;
	    		newDocument.Valid_From__c = datetime.now();
	    		newDocument.Document_Type__c = document.Document_Type__c;
	    		newDocument.Provider__c = document.Provider__c;
	    		
	    		insert newDocument;
	    		
	    		if(s3FilesList != null){
	    			List<S3_File__c> listNewS3 = new List<S3_File__c>();
		    		for(S3_File__c s3File : s3FilesList){
		    			if(s3File.Id == null){
		    				s3File.Document__c = newDocument.Id;
			    			listNewS3.add(s3File);
		    			}
		    			else{
			    			S3_File__c newS3 = s3File.clone(false, false, false, false);
			    			newS3.Document__c = newDocument.Id;
			    			listNewS3.add(newS3);
		    			}
		    		}
		    		if(listNewS3.size() > 0)
		    			insert listNewS3;
		    	}
	    		else{
	    			List<S3_File__c> listNewS3 = new List<S3_File__c>();
	    			for(s3Wrapper s3File : listS3File){
		    			S3_File__c newS3 = s3File.s3File.clone(false, false, false, false);
		    			newS3.Document__c = newDocument.Id;
		    			listNewS3.add(newS3);
		    		}
		    		if(listNewS3.size() > 0)
		    			insert listNewS3;
		    	}
		    	
		    	if(string.isNotBlank(transactionId)){
			    	Transaction_Document__c transactionDocument = new Transaction_Document__c();
		    		transactionDocument.Document__c = newDocument.Id;
		    		if(string.isNotBlank(transactiondocId)){
		    			transactionDocument.Id = transactiondocId;
		    		}
		    		else{
	    				transactionDocument.Licensing_Transaction__c = transactionId;
		    		}
		    		if(string.isNotBlank(varianceId)){
		    			transactionDocument.Variance_on_Regulation__c = varianceId;
		    		}
		    		if(attachmentType == 'A'){
		    			transactionDocument.Mode__c = 'Additional';
		    		}
		    		else if(string.isNotBlank(varianceId) && attachmentType == 'V'){
		    			transactionDocument.Variance_on_Regulation__c = varianceId;
		    			transactionDocument.Mode__c = 'Variance';
		    		}
		    		else if(attachmentType == 'I'){
		    			transactionDocument.Mode__c = 'Individual';
		    		}
		    		else if(attachmentType == 'R'){
		    			transactionDocument.Mode__c = 'Required';
		    		}
		    		else if(attachmentType == 'O'){
		    			transactionDocument.Mode__c = 'Optional';
		    		}
		    		transactionDocument.Last_Status_Date__c = date.today();
		    		transactionDocument.Status__c = 'To Submit';
		    		upsert transactionDocument;
		    	}
    		}
    	}
    }
}