trigger updateStartDate on Licensing_Transaction__c ( before update ) {

Set<id> setOfParentId = new Set<Id>();
 for(Licensing_Transaction__c pt : trigger.new){
 
 
 
 if( pt.Status__c == 'Closed (License Issued / Updated)' ||  pt.Status__c == 'Closed (Processed)' ||  pt.Status__c == 'Closed (EEC Application Incomplete / Denied)'){
  
   setOfParentId.add(pt.id);
   
   }
 }
 
 
 List<Conditions_and_Limitations__c> listChild = new List<Conditions_and_Limitations__c>([Select id,Start_Date__c,Source_Transaction__c from  Conditions_and_Limitations__c where Source_Transaction__c =: setOfParentId]);
 List<Conditions_and_Limitations__c> updatedlistChild = new List<Conditions_and_Limitations__c>();
 
 for(Licensing_Transaction__c pt : trigger.new){
  for( Conditions_and_Limitations__c ch : listChild){
  
  if(listChild.size() > 0 ) { 
  
    if(  pt.To_Process_Flag__c = true && ch.Start_Date__c != null && pt.License_Issue_Date__c != null){
  
     ch.Start_Date__c = pt.License_Issue_Date__c ;
   }
   
   }
   
   updatedlistChild.add(ch);
  }
 }
 
  
 if(updatedlistChild.size() > 0) {
 
  Update updatedlistChild;
  
  }
}