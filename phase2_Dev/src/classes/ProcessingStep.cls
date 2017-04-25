public interface ProcessingStep {  
  ProcessingStepResult__c process(Intake__c intake, Map<String, List<Response__c>> intakeResponseMap, String config);  
}