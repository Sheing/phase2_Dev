public with sharing class BatchTestUtil {
  public BatchTestUtil() {
    
  }

  public static FormVersion__c loadData() {
    Form__c testForm = new Form__c(Name = 'Test Form',UUID__c = '123');
    insert testForm;

    FormVersion__c testFormVersion = new FormVersion__c(Form__c = testForm.Id, Status__c='Draft', UUID__c = '1234');
    insert testFormVersion;

    Component__c c1 = new Component__c(Name = 'TestComponent', DeveloperName__c = 'test');
    insert c1;

    FormComponent__c fc1 = new FormComponent__c(Component__c = c1.Id, FormVersion__c = testFormVersion.Id, Order__c = 0, UUID__c = '123456');
    FormComponent__c fc2 = new FormComponent__c(Component__c = c1.Id, FormVersion__c = testFormVersion.Id, Order__c = 1, UUID__c = '1234567');
    List<FormComponent__c> fcList = new List<FormComponent__c>{fc1, fc2};
    insert fcList;

    ProcessingStepType__c pst1 = new ProcessingStepType__c(Type__c = 'Pre', ClassName__c = 'ProcessingStepValue');
    insert pst1;

    ProcessingStepType__c pst2 = new ProcessingStepType__c(Type__c = 'Post', ClassName__c = 'ProcessingStepObjMapping');
    insert pst2;

    ProcessingStep__c psPre1 = new ProcessingStep__c(Type__c = pst1.Id, Order__c = 0, FormVersion__c = testFormVersion.Id, Config__c = '{"' + fc1.Id + '":{"type":"value","value":"New"}, "' + fc2.Id + '":{"type":"value","value":"Web"}}');
    insert psPre1;

    ProcessingStep__c psPost1 = new ProcessingStep__c(Type__c = pst2.Id, Order__c = 0, FormVersion__c = testFormVersion.Id, Config__c = '{"case1": {"type": "Case","mappings": [{"destination":"Status","formComponentId": "' + fc1.Id + '"},{"destination": "Origin", "formComponentId": "' + fc2.Id + '" }]}}');
    insert psPost1;

    return testFormVersion;
  }
}