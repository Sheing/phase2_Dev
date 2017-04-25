public with sharing class ProcessingStepValue implements ProcessingStep{
  public ProcessingStepValue() {}

  public ProcessingStepResult__c process(Intake__c intake, Map<String, List<Response__c>> intakeResponseMap, String jsonConfig) {
    ProcessingStepResult__c result = new ProcessingStepResult__c(Intake__c = intake.Id);

    try {
      Map<String, MetaConfig> configs = (Map<String, MetaConfig>) JSON.deserialize(jsonConfig, Map<String, MetaConfig>.class);
      List<Response__c> responseListToInsert = new List<Response__c>();
      // Loop through the configs returned from the parsed Json.
      for (String key : configs.keySet()) {
        Response__c tempResp = new Response__c();
        // Get the config based on the current key.
        MetaConfig config = configs.get(key);
        // Set the intake id and form component id to the new response.
        tempResp.Intake__c = intake.Id;
        tempResp.FormComponent__c = key;
        // If the type is value then simply insert the value as the response value.
        if (config.type != null && config.type.equalsIgnoreCase('value')) {
          tempResp.Value__c = config.value;
        } else if (config.type != null && config.type.equalsIgnoreCase('expression')) {
          // TODO: Grab the value based on the expression.
        }        
        // Once completed then add the obj to the upsert list.
        responseListToInsert.add(tempResp);
      }
      // Upsert the list into the DB.
      if (responseListToInsert != null && responseListToInsert.size() > 0) {
        insert responseListToInsert;
      }
      result.Result__c = 'Success';
    } catch (Exception e) {
      result.Result__c = 'Failure';
      result.ErrorMessage__c = e.getMessage();
    }
    return result;
  }

  private class MetaConfig {
    public String type { get; set; }
    public String value { get; set; }
  }
}