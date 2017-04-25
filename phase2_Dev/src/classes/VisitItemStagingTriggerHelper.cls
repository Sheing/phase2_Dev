public with sharing class VisitItemStagingTriggerHelper {   
    
    public static void bulkInsertStandardVisitItems(List<VisitItemsStaging__c> triggerNew){
      
        List<String> applicableToList = new List<String>();
        for(VisitItemsStaging__c v : triggerNew){
            applicableToList.add(v.ProviderType__c);
        }
        
        //stdVisitItemsMap
        Map<string,Standard_Inspection_Item__c> stdVisitItemsMap = new Map<string,Standard_Inspection_Item__c>();
        List<Standard_Inspection_Item__c> stdVisitItemsList = new List<Standard_Inspection_Item__c>([Select Id,Name, Category__c From Standard_Inspection_Item__c Where applicable_to__c in :applicableToList]);
        for(Standard_Inspection_Item__c sv: stdVisitItemsList){
            stdVisitItemsMap.put(sv.Name, sv);
        }
        
        system.debug('##### applicableToList...'+ applicableToList);
        
        system.debug('##### Std Visit Items Map...'+ stdVisitItemsMap);
    
        Map<Id,Standard_Inspection_Item__c> stdVisitItemsToUpdate = new Map<Id,Standard_Inspection_Item__c>();
        List<Standard_Inspection_Item__c> stdVisitItemsToInsert = new List<Standard_Inspection_Item__c>();
    
        for(VisitItemsStaging__c visitItm : triggerNew){
            Standard_Inspection_Item__c sv = stdVisitItemsMap.get(visitItm.Name);
            
             //system.debug('##### Item Found in Map...'+ sv);
             
            
            Standard_Inspection_Item__c svItm = new Standard_Inspection_Item__c();
                        
            if (sv != null && visitItm.Override__c == false){
                //or(Standard_Inspection_Item__c sv : svList){
                    //Update the Existing Standard Visit Item to flag as Random Item and Set the Random Domain name
                    if (sv.Name.trim() == visitItm.Name.trim() && sv.Category__c.trim() == visitItm.VisitItemDomain__c.trim()){ //&& visitItm.IsRandomItem__c)
                        system.debug('##### In Update...'+ sv);
                        svItm.Id = sv.Id;
                        
                        if (visitItm.IsRandomItem__c){
                            svItm.StdVisitItemRandom__c = visitItm.IsRandomItem__c;
                            svItm.StdVisitItemRandomDomainName__c = visitItm.RandomItemDomain__c;
                        }
                        svItm.StdVisitItemTool__c = visitItm.VisitItemToolAssignment__c;
                        stdVisitItemsToUpdate.put(svItm.Id,svItm);
                    }
                    else if (sv.Name.trim() == visitItm.Name.trim() && sv.Category__c.trim() != visitItm.VisitItemDomain__c.trim()){// && visitItm.IsRandomItem__c == false)
                        
                        system.debug('##### In Update..ELSE....'+ sv);
                        system.debug('##### In Update..ELSE....'+ visitItm);
                        
                        svItm.Name = visitItm.Name.trim();
                        svItm.Description__c = visitItm.Description__c;
                        svItm.Category__c = visitItm.VisitItemDomain__c;
                        svItm.Guidance__c = visitItm.Guidance__c;
                        svItm.StdVisitItemRandom__c = visitItm.IsRandomItem__c;
                        svItm.StdVisitItemRandomDomainName__c = visitItm.RandomItemDomain__c;
                        svItm.StdVisitItemReg__c = visitItm.VisitItemRegulation__c;
                        svItm.StdVisitItemTool__c = visitItm.VisitItemToolAssignment__c;
                        svItm.Applicable_To__c = visitItm.ProviderType__c;
                        stdVisitItemsToInsert.add(svItm);                   
                    }
                //}         
            }
            else{
                system.debug('##### In Insert..ELSE....'+ visitItm);
                svItm.Name = visitItm.Name.trim();
                svItm.Description__c = visitItm.Description__c;
                svItm.Category__c = visitItm.VisitItemDomain__c;
                svItm.Guidance__c = visitItm.Guidance__c;
                svItm.StdVisitItemRandom__c = visitItm.IsRandomItem__c;
                svItm.StdVisitItemRandomDomainName__c = visitItm.RandomItemDomain__c;
                svItm.StdVisitItemReg__c = visitItm.VisitItemRegulation__c;
                svItm.StdVisitItemTool__c = visitItm.VisitItemToolAssignment__c;
                svItm.Applicable_To__c = visitItm.ProviderType__c;
                stdVisitItemsToInsert.add(svItm);
            }
            
        }
        
        if (stdVisitItemsToUpdate.size() > 0) {
            
            system.debug('##### stdVisitItemsToUpdate...'+ stdVisitItemsToUpdate.values());
             update stdVisitItemsToUpdate.values(); 
        } 
          
        if (stdVisitItemsToInsert.size() > 0){
            insert stdVisitItemsToInsert;
         } 
         
        // Call Batch to cleanup VisitItemsStaging 
        string SOQL = 'Select Id from VisitItemsStaging__c';
        Database.executeBatch(new Batch_CleanVisitItemStaging(SOQL),200); 
             
     }
 
}