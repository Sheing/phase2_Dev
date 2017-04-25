public with sharing class AWS_TestQamarToBeDeleted {
	public Blob file { get; set; }
	public String fileName { get; set; }
	public String contentType { get; set; }
	public String bucketname { get; set; }
	public String host { get; set; }
	public String key { get; set; }
	public String secret { get; set; }
	public String endPointUrl {get; set;}

	public AWS_TestQamarToBeDeleted() {
		bucketname = 'eec-lead-integration';
		key = 'AKIALWS6G36DVULUZVHA';
		secret = '/GrQwTZdRrTGVJOOh9E6zlw0CiipMNNcYinJdkL+';
		host = 's3-us-gov-west-1.amazonaws.com';
		//fileName = 'sample.png';
		

	}

	public pageReference upload() {
		Map<String, String> policySigMap = EEC_S3ComponentCtrl.generatePolicySignature(bucketname, 'authenticated-read', fileName, contentType, '');
		System.debug('------> PolicySigMap: ' + policySigMap);
		fileName = fileName.replace(' ', '_');
		fileName = '12345678/' + fileName;
		System.debug('-----> FileName: ' + fileName);
		System.debug('-----> File: ' + file);
		endPointUrl = 'https://' + host + '/' + bucketname + '/' + fileName;
		//endPointUrl = EncodingUtil.urlEncode(endPointUrl, 'UTF-8');
		try {
			
			String now = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');

			HttpRequest req = new HttpRequest();
			req.setMethod('PUT');
			req.setEndpoint(endPointUrl);
			req.setHeader('key', fileName);
			req.setHeader('AWSAccessKeyId', key);
			req.setHeader('x-amz-server-side-encryption', 'AES256');
			req.setHeader('filename', fileName);
			//req.setHeader('Host', bucketname + '.' + host);
			//req.setHeader('Content-Length', String.valueOf(file.length()));
			//req.setHeader('Content-Encoding', 'UTF-8');
			req.setHeader('Content-Type', contentType);
			//req.setHeader('Connection', 'keep-alive');
			//req.setHeader('Date', now);
			req.setHeader('acl', 'authenticated-read');
			req.setHeader('policy', policySigMap.get('policy'));
			req.setHeader('signature', policySigMap.get('signature'));
			req.setBodyAsBlob(file);

			/*String stringToSign = 'POST\n\n' + contentType + '\n' + now + '\n' +
			    '/' + bucketname + '/' + '123456789' + '/' + fileName;

			String encodedStringToSign = EncodingUtil.urlEncode(stringToSign, 'UTF-8');
			Blob mac = Crypto.generateMac('HMACSHA1', Blob.valueOf(stringToSign), Blob.valueOf(secret));
			String signed = EncodingUtil.base64Encode(mac);
			String authHeader = 'AWS' + ' ' + key + ':' + signed;
			req.setHeader('Authorization', authHeader);
			String decoded = EncodingUtil.urlDecode(encodedStringToSign , 'UTF-8');*/

			Http http = new Http();
			HTTPResponse res = http.send(req);
			System.debug('RESPONSE STRING: ' + res.toString());
			System.debug('RESPONSE STATUS: ' + res.getStatus());
			System.debug('STATUS_CODE: ' + res.getStatusCode());

		} catch(Exception e) {
			System.debug('EXCEPTION: ' + e);

		}

    return null;
	}
}