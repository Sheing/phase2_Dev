public with sharing class ProcessingStepObjMapping implements ProcessingStep {
    public ProcessingStepObjMapping() {}

    private static String FIELD_MAPPING = 'FIELD_MAPPING';
    private static String INSTANCE_MAPPING = 'INSTANCE_MAPPING';

  
  /*
      Configuration Object has the following shape:
      
      {
          instanceName: {
              type: 'SomeSobjectTypeString',
              mappings: [
                  {
                      destination: 'SomeFieldName',
                      formComponentUUID: 'UUIDOfSomeFormComponent',
                      instanceName: 'SomeInstanceName',
                      type: FIELD_MAPPING | INSTANCE_MAPPING 
                  
                  },
                  {
                  
                  
                  },
              ]
          },
          
          instanceName2: {
          
          }
      
      
      }
  
  */
    public Map<String, SObject> processFieldMappings(List<Response__c> responses, Map<String, MetaConfig> configs) {
        Map<String, SObject> resultingObjects = new Map<String, SObject>();
        Map<String, Response__c> responseByUUID = new Map<String, Response__c>();
        
        for(Response__c resp : responses) {
            responseByUUID.put(resp.Form_Component_UUID__c, resp);
        }
        
        // For each instance we need to create
        for (String key : configs.keySet()) {
            System.debug('---> Starting Field Mapping for Instance ' + key);
            
            MetaConfig instanceConfig = configs.get(key);
            Type t = Type.forName(instanceConfig.type);
            SObject objInstance = (SObject) t.newInstance();
            
            // For each mapping
            for (MetaConfigMapping configMapping : instanceConfig.mappings) {
                
                // For each FIELD_MAPPING configuration; set objInstance's destination field
                // to the responses value for the mapped UUID.
                if(configMapping.type.equalsIgnoreCase(FIELD_MAPPING) && configMapping.formComponentUUID != NULL) { 
                    objInstance.put(configMapping.destination, responseByUUID.get(configMapping.formComponentUUID).Value__c); 
                }
            }
            
            System.debug('---> Finished Field Mapping for Instance ' + key);
            System.debug(objInstance);
            resultingObjects.put(key, objInstance);    
        }
            
        insert resultingObjects.values(); 
        
        System.debug('Inserted objects with field mappings');
        
        return resultingObjects;
    }
    public List<SObject> processInstanceMappings(Map<String, SObject> instances, Map<String, MetaConfig> configs) {
        List<SObject> resultingObjects = new List<SObject>();
        
        // For each instance we need to create
        for (String key : configs.keySet()) {
            System.debug('---> Starting Instance Mapping for Instance ' + key);
            MetaConfig instanceConfig = configs.get(key);
            Type t = Type.forName(instanceConfig.type);
            SObject objInstance = (SObject) t.newInstance();
            
            // For each mapping
            for (MetaConfigMapping configMapping : instanceConfig.mappings) {
                
                // For each INSTANCE_MAPPING configuration; set objInstance's destination ref field
                // to the ID of the instance
                if(configMapping.type.equalsIgnoreCase(INSTANCE_MAPPING) && configMapping.instanceName != NULL) {
                    objInstance.put(configMapping.destination, instances.get(configMapping.instanceName).Id);
                }
            }
        
            System.debug('---> Starting Instance Mapping for Instance ' + key);
            
            resultingObjects.add(objInstance);    
        }
            
        insert resultingObjects;
        
        return resultingObjects;
    }

    public ProcessingStepResult__c process(Intake__c intake, Map<String, List<Response__c>> intakeResponseMap, String config) {
        // Config is a Map of Instance Name => Configuration
        Map<String, MetaConfig> configs = (Map<String, MetaConfig>) JSON.deserialize(config, Map<String, MetaConfig>.class);
        ProcessingStepResult__c result = new ProcessingStepResult__c(Intake__c = intake.Id);
        
        try { 
            Map<String, SObject> mappedObjects = this.processFieldMappings(intakeResponseMap.get(intake.Id), configs);
            List<SObject> instanceMapped = this.processInstanceMappings(mappedObjects, configs);
            result.Result__c = 'Success';
        }
        catch (Exception e) {
            result.Result__c = 'Failure';
            result.ErrorMessage__c = e.getMessage();
        }
        
        return result;
    }
    
    private class MetaConfig {
        public String type { get; set; }
        public List<MetaConfigMapping> mappings { get; set; }
    }
    
    private class MetaConfigMapping {
        public String destination { get; set; }
        public String type { get; set; }
        public String formComponentUUID { get; set; }
        public String instanceName { get; set; }
    }
}