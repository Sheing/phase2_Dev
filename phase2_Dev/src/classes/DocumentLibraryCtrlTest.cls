@isTest
public class DocumentLibraryCtrlTest {
  @testSetup static void setup() {
    EEC_TestUtil.mockAWSKeys();      
  }  
    
  public static testMethod void testDocumentLibraryCtrl() {
    Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
    Contact con = EEC_TestUtil.mockDirectorContact(acc);
    User u = EEC_TestUtil.mockPortalUser(con);
      
    System.runAs(u) {      
      Document__c mockDoc = new Document__c(Provider__c = acc.Id);
      insert mockDoc;
        
      DocumentLibraryCtrl ctrl = new DocumentLibraryCtrl();
      
      Test.setCurrentPageReference(new PageReference('Page.DocumentLibraryCtrl')); 
      System.currentPageReference().getParameters().put('id', mockDoc.Id);
      System.currentPageReference().getParameters().put('mode', '1');  
      ctrl = new DocumentLibraryCtrl();
    }
  }
    
  public static testMethod void testMarkDocumentAsOutOfDate() {  
    Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
    Contact con = EEC_TestUtil.mockDirectorContact(acc);
    User u = EEC_TestUtil.mockPortalUser(con);
      
    System.runAs(u) {      
      Document__c mockDoc = new Document__c(Provider__c = acc.Id);
      insert mockDoc;
      
      Test.setCurrentPageReference(new PageReference('Page.DocumentLibraryCtrl')); 
      System.currentPageReference().getParameters().put('documentId', mockDoc.Id);
      DocumentLibraryCtrl ctrl = new DocumentLibraryCtrl();      
      ctrl.markDocumentAsOutOfDate();
    }
  }
    
  public static testMethod void testGenerateMultiplePolicySignature() {
    Test.startTest();
    Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
    Contact con = EEC_TestUtil.mockDirectorContact(acc);
    User u = EEC_TestUtil.mockPortalUser(con);
    
    System.runAs(u) {  
      DocumentLibraryCtrl ctrl = new DocumentLibraryCtrl();        
      // Test method.
      String exampleJson = '[{"filename": "testName", "type": "image/png"}]'; 
        
      List<Map<String,String>> result = DocumentLibraryCtrl.generateMultiplePolicySignature('eec', 'authenticated-read', exampleJson);
      System.assertNotEquals(0, result.size());
      System.assertNotEquals(null, result.get(0).get('policy'));  
      System.assertNotEquals(null, result.get(0).get('signature'));
    }
  }
    
  public static testMethod void testSave() {
    Test.startTest();
    Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
    Contact con = EEC_TestUtil.mockDirectorContact(acc);
    User u = EEC_TestUtil.mockPortalUser(con);
    
    System.runAs(u) {  
      DocumentLibraryCtrl ctrl = new DocumentLibraryCtrl();        
              
      String attachmentsJson = '{"Filename__c": "TestFile", "Prefix__c": "12345", "Content_Type__c": "image/png", "Acl__c": "authenticated-read", "Bucket__c": "test"}';
      String documentJson = '{"Name":"nfnfgn","Notes__c":"fnffgnf"}';
        
      ctrl.s3FileJson = attachmentsJson;
      ctrl.documentJson = documentJson;
      ctrl.save();
        
      List<Document__c> docList = [Select Id From Document__c];  
      System.assert(docList.size() > 0);
        
      Document__c doc = [Select Id, Notes__c From Document__c];
      doc.Notes__c = 'abcde';
      ctrl.activeDocument = doc;
      ctrl.s3FileJson = '';
      ctrl.documentJson = '';
      ctrl.save();
        
      doc = [Select Id, Notes__c From Document__c Where Id = :doc.Id];  
      System.assertEquals('abcde', doc.Notes__c);
    }
  }
    
  public static testMethod void testDeleteAttachment() {
    Test.startTest();
    Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
    Contact con = EEC_TestUtil.mockDirectorContact(acc);
    User u = EEC_TestUtil.mockPortalUser(con);
    
    System.runAs(u) {          
      Document__c doc = new Document__c(
        //Name = 'TestDoc',
        //Original_File_Name__c = 'test.txt',
        Notes__c = 'This is a test Document',
        Provider__c = acc.Id
      );
      insert doc;
        
      S3_File__c file = new S3_File__c(
        Filename__c = 'testFile',
        Content_Type__c = 'image/png',
        Bucket__c = 'test',
        Acl__c = 'authenticated-read',
        Prefix__c = UserInfo.getUserId(),
        Document__c = doc.Id
      ); 
      insert file;  
          
      Test.setCurrentPageReference(new PageReference('Page.DocumentLibraryCtrl')); 
      System.currentPageReference().getParameters().put('documentId', doc.Id);
      DocumentLibraryCtrl ctrl = new DocumentLibraryCtrl();      
      ctrl.deleteDocument();  
    }
  }
    
  public static testMethod void testGenerateLink() {
    
    Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
    Contact con = EEC_TestUtil.mockDirectorContact(acc);
    User u = EEC_TestUtil.mockPortalUser(con);
    
    Test.startTest();
    System.runAs(u) {          
      Document__c doc = new Document__c(
        //Name = 'TestDoc',
        //Original_File_Name__c = 'test.txt',
        Notes__c = 'This is a test Document',
        Provider__c = acc.Id
      );
      insert doc;
        
      S3_File__c file = new S3_File__c(
        Filename__c = 'testFile',
        Content_Type__c = 'image/png',
        Bucket__c = 'test',
        Acl__c = 'authenticated-read',
        Prefix__c = UserInfo.getUserId(),
        Document__c = doc.Id
      ); 
      insert file;  
          
      Test.setCurrentPageReference(new PageReference('Page.DocumentLibraryCtrl')); 
      System.currentPageReference().getParameters().put('documentId', doc.Id);
      DocumentLibraryCtrl ctrl = new DocumentLibraryCtrl();    
      ctrl.origFile = file.Filename__c;
      String s3Link = ctrl.generateS3Link();
    }
    Test.stopTest();
  }
    
  public static testMethod void testOutofDateDoc() {    
    Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
    Contact con = EEC_TestUtil.mockDirectorContact(acc);
    User u = EEC_TestUtil.mockPortalUser(con);
    
    Test.startTest();
    System.runAs(u) {     
      Document__c doc = new Document__c(
        
        //Original_File_Name__c = 'test.txt',
        Notes__c = 'This is a test Document',
        Provider__c = acc.Id
        //Out_of_Date__c = System.Now().Date()
      );
      insert doc;
        
      S3_File__c file = new S3_File__c(
        Filename__c = 'testFile',
        Content_Type__c = 'image/png',
        Bucket__c = 'test',
        Acl__c = 'authenticated-read',
        Prefix__c = UserInfo.getUserId(),
        Document__c = doc.Id
      ); 
      insert file;  
          
      Test.setCurrentPageReference(new PageReference('Page.DocumentLibraryCtrl')); 
      System.currentPageReference().getParameters().put('documentId', doc.Id);
      DocumentLibraryCtrl ctrl = new DocumentLibraryCtrl();    
      ctrl.retrieveDocumentsForUser();
        
      //Make sure that our list of docs does not include the one that was marked out of date
      //So it should be zero
      System.assertEquals(0, ctrl.documentsList.size());
    }
    Test.stopTest();
  }
}