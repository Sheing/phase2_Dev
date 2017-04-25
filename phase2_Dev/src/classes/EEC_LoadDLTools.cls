//Author: Latha Davuluri
public with sharing class EEC_LoadDLTools {
	
	public static void loadFCCDLTools(VisitItemsStaging__c visitItm){
		List<String> applicableToList = new List<String>(); 
        
        applicableToList.add(visitItm.ProviderType__c);

        //stdVisitItemsMap
        Map<string,Standard_Inspection_Item__c> stdVisitItemsMap = new Map<string,Standard_Inspection_Item__c>();
        List<Standard_Inspection_Item__c> stdVisitItemsList = new List<Standard_Inspection_Item__c>([Select Id,Name, Category__c From Standard_Inspection_Item__c Where applicable_to__c in :applicableToList]);
        for(Standard_Inspection_Item__c sv: stdVisitItemsList){
            stdVisitItemsMap.put(sv.Name, sv);
        }
        
        system.debug('##### applicableToList...'+ applicableToList);
        
        system.debug('##### Std Visit Items Map...'+ stdVisitItemsMap);
    
        List<Standard_Inspection_Item__c> stdVisitItemsToInsert = new List<Standard_Inspection_Item__c>();
        List<Standard_Inspection_Item__c> stdVisitItemsToUpdate = new List<Standard_Inspection_Item__c>();
        
        if (!string.isBlank(visitItm.Name)){
            Standard_Inspection_Item__c sv = stdVisitItemsMap.get(visitItm.Name.trim());
            system.debug('*** sv***'+ sv);
            system.debug('****visitItm.Override__c *****'+visitItm.Override__c);
           // system.debug('*****3'+sv.Category__c);
            system.debug('***4'+ visitItm.VisitItemDomain__c);
            
             if (sv != null && !visitItm.Override__c && sv.Category__c == visitItm.VisitItemDomain__c){
                system.debug('##### Visit Item Found in Map...'+ sv);
                sv.Description__c = visitItm.Description__c;
                sv.Guidance__c = visitItm.Guidance__c; 
                createOrUpdateJuncObjects(sv.Id,visitItm,false);
                stdVisitItemsToUpdate.add(sv);
             }
             else{
             	system.debug('##### Visit Item NOT Found in Map...');
             	Standard_Inspection_Item__c svItm = new Standard_Inspection_Item__c();
             	 
             	svItm.Name = visitItm.Name.trim();
                svItm.Description__c = visitItm.Description__c;
                svItm.Category__c = visitItm.VisitItemDomain__c;
                svItm.Guidance__c = visitItm.Guidance__c;
                svItm.Applicable_To__c = visitItm.ProviderType__c;
                stdVisitItemsToInsert.add(svItm);
             }
   
	    }
	    	    
	    if (stdVisitItemsToInsert.size() > 0){
            insert stdVisitItemsToInsert;          
            createOrUpdateJuncObjects(stdVisitItemsToInsert[0].Id,visitItm,true);
         } 
         
         if(stdVisitItemsToUpdate.size()>0){
         	update stdVisitItemsToUpdate;
         }
	}
	
	private static void createOrUpdateJuncObjects(Id stdVisitItemId,VisitItemsStaging__c visitItm, boolean createRegs){
		//Regulations Map
		Map<string,Id> regMap = new Map<string,Id>();
	    // Tools Map 
		Map<string,Id> vistToolsMap = new Map<string,Id>();
		List<String> stdVisitItmRegList;  
		Id regId;
		Id visitToolId;
		 /** Code to insert into ToolAssignments and ToolRegulations objects */
             List<Junction_InspReg__c> visitItmRegsToCreate = new List<Junction_InspReg__c>();
			 List<Junction_ChklInsp__c> toolVisitItemsToCreate = new List<Junction_ChklInsp__c>();
		
			  
			 List<Regulation__c> regList = new List<Regulation__c>([Select Id,Name From Regulation__c]);
			 for(Regulation__c rg : regList){
			  	  regMap.put(rg.Name,rg.Id);
			   }
			   
			 List<Standard_Checklist_Reference__c> vistToolsList = new List<Standard_Checklist_Reference__c>([Select Id,Name From Standard_Checklist_Reference__c Where Active__c = true]);
			 for(Standard_Checklist_Reference__c chkRef : vistToolsList){
			  	 vistToolsMap.put(chkRef.Name, chkRef.Id);
			  }
				   				  	  
		  	  //Insert into Visit Items Regulation ONLY if createRegs = true
		  	  if (createRegs){
			  	  if (!string.isBlank(visitItm.VisitItemRegulation__c)){	
			  	  	 
			  	  	 stdVisitItmRegList = visitItm.VisitItemRegulation__c.split(';');		  	  	 		  	  	
			  	  	 
			  	  	 for(string vistItmReg : stdVisitItmRegList){
			  	  	    
			  	  	    regId = regMap.get(vistItmReg.trim());
			  	  	 	
			  	  	 	if(regId != null){
			  	  	 		
			  	  	 		Junction_InspReg__c vItmReg = new Junction_InspReg__c();
			  	  	 		
				  	  	 	vItmReg.Standard_Inspection_Item__c = stdVisitItemId;
					        vItmReg.Regulation__c = regId;
					        visitItmRegsToCreate.add(vItmReg);	
			  	  	 	  }  		  	  	      	  	 	 	  	 	
			  	  	   } // for loop for Regs List
			  	    }
		  	  }
				  	     
	  	     //Insert into Tool Assignments		  	     
	  	     if (!string.isBlank(visitItm.VisitItemToolAssignment__c)){
	  	  	   
	  	  	    visitToolId = vistToolsMap.get(visitItm.VisitItemToolAssignment__c.trim());
	  	  	 	
	  	  	 	if(visitToolId != null){
	  	  	 		
	  	  	 		Junction_ChklInsp__c toolVisitItem = new Junction_ChklInsp__c();
	  	  	 		
		  	  	 	toolVisitItem.Standard_Checklist_Reference__c = visitToolId; 	
		  	  	 	toolVisitItem.Standard_Inspection_Item__c = stdVisitItemId;
		  	  	 	toolVisitItem.Random_Item__c = visitItm.IsRandomItem__c;
		  	  	 	if(toolVisitItem.Random_Item__c){
		  	  	 	   toolVisitItem.Random_Item_Domain__c = visitItm.RandomItemDomain__c;
		  	  	 	}
		  	  	 	toolVisitItemsToCreate.add(toolVisitItem);
	  	  	 	}	
	  	     }
			  	 	  		  	 
			  
			 if (visitItmRegsToCreate.size() > 0) {
			  	 insert visitItmRegsToCreate; 
			   }
			  
			 if (toolVisitItemsToCreate.size() > 0){
			  	insert toolVisitItemsToCreate;
			  } 
            
            /**ends here **/
	}

}