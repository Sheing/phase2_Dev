public with sharing class EEC_LegacyDocuments {
	private final sObject mysObject;
    public Id id {get; set;}
    public Map<Id, String> attachmentsMapUrls {get; set;}
    public List<FileMap__c> attachmentsMapList {get; set;}
    public List<S3_File__c> attachments {get; set;}
    public String generateFileId {get; set;}

    public EEC_LegacyDocuments(ApexPages.StandardController stdController) {
        generateFileId = '';
        try {
            // Create a new map with the urls.
            id = stdController.getId();
            System.debug('-----> Id: ' + id);
            // Get all the attachments.
            attachments = new List<S3_File__c> ();
            attachments = [Select Id, Bucket__c, Filename__c, CreatedDate From S3_File__c Where LegacyRecordId__c =: Id];
            System.debug('----> All Files: ' + attachments);
        } catch(Exception e) {
          System.debug('----> Error: ' + e.getMessage());
        }
    }

    public String genetateS3Link() {
        String filename = '';
        S3_File__c file = [Select Id, Filename__c, Bucket__c From S3_File__c Where id = :generateFileId];
        filename += file.Filename__c;
        String bucket = 'eec-lead-legacy';
        AWSKeys creds = new AWSKeys('eec');
        System.debug('-------> creds: ' + creds);
        // Special URL.
        String signedUrl = 'https://s3-us-gov-west-1.amazonaws.com';
        String filePath = '/' + bucket + '/' + filename;
        // Set the expiry on the url.  
        // TODO: Config the time in seconds desired.
        Datetime expireDatetime = System.now().addMinutes(15);
        String expires = String.valueOf(expireDatetime.getTime() / 1000);
        // Create the signature.
        String canonicalString = 'GET\n\n\n' + expires + '\n' + filePath;
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalString),blob.valueof(creds.secret_encrypted)); 
        System.debug('--------> MAC: ' + mac);
        String signature = EncodingUtil.base64Encode(mac); 
        // Patch together the signed url.
        signedUrl += filePath + '?AWSAccessKeyId=' + creds.key + '&Expires=' + expires + '&Signature=' + EncodingUtil.urlEncode(signature, 'UTF-8');
        // Return the url to the user.
        return signedUrl;
        //return EEC_S3ComponentCtrl.generateTempS3Url('eec-lead-integration', filename);
    }

}