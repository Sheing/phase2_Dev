public with sharing class EEC_RegulationViewController {
    public List<Regulation__c> childregs{get;set;}
    public Regulation__c regulation {get;set;}
    public string regId {get;set;}
    //public ID insId {get;set;}
    public EEC_RegulationViewController(){       
       regId = ApexPages.currentPage().getParameters().get('id');
       system.debug('***reg***'+regId);
       //insId = ApexPages.currentPage().getParameters().get('inId');
       if(String.isNotBlank(regId) && regId.contains('.') == false){
   	     Id reggId = Id.valueOf(regId);
         regulation = [select Id,Name,Regulation_Number__c,Parent_Regulation__r.Name,Parent_Regulation__r.Regulation_Number__c,Applicable_To__c,article__c from Regulation__c where Id = :reggId];
         if (regulation != null ){ 
         	regId = regulation.Id;
         	getchildregs(regId);
         }
       }
       else if(String.isNotBlank(regId) && regId.contains('.') == true){
         regulation = [select Id,Regulation_Number__c,Name,Parent_Regulation__r.Name,Parent_Regulation__r.Regulation_Number__c,Applicable_To__c,article__c from Regulation__c where Name = :regId];
         if (regulation != null ){ 
         	regId = regulation.Id;
         	getchildregs(regId);
         }
       }
    }
    
    public void getchildregs(Id regId){    
       childregs = [select id,Name,Regulation_Number__c,Article__c from Regulation__c where Parent_Regulation__c = :regId
       				and Active__c = true];
    }
}