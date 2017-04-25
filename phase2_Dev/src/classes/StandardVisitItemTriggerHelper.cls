public with sharing class StandardVisitItemTriggerHelper {
	
	public static void bulkInsertStandardVisitItems(List<Standard_Inspection_Item__c> triggerNew){
		
		 //Regulations Map
		  Map<string,Id> regMap = new Map<string,Id>();
		 // Tools Map 
		  Map<string,Id> vistToolsMap = new Map<string,Id>();
		  List<String> stdVisitItmRegList;
		  Id regId;
		  Id visitToolId;
		  
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
		   
		  for(Standard_Inspection_Item__c stdItm : triggerNew) {
		  	  
		  	  //Insert into Visit Items Regulation
		  	  if (stdItm.StdVisitItemReg__c != null && stdItm.StdVisitItemReg__c != ''){	
		  	  	 
		  	  	 stdVisitItmRegList = stdItm.StdVisitItemReg__c.split(';');		  	  	 		  	  	
		  	  	 
		  	  	 for(string vistItmReg : stdVisitItmRegList){
		  	  	    
		  	  	    regId = regMap.get(vistItmReg.trim());
		  	  	 	
		  	  	 	if(regId != null){
		  	  	 		
		  	  	 		Junction_InspReg__c vItmReg = new Junction_InspReg__c();
		  	  	 		
			  	  	 	vItmReg.Standard_Inspection_Item__c = stdItm.Id;
				        vItmReg.Regulation__c = regId;
				        visitItmRegsToCreate.add(vItmReg);	
		  	  	 	  }  	
		  	  	      	  	 	 	  	 	
		  	  	    } // for loop for Regs List
		  	     }
		  	     
		  	     //Insert into Tool Assignments		  	     
		  	     if (stdItm.StdVisitItemTool__c != null && stdItm.StdVisitItemTool__c != ''){
		  	  	   
		  	  	    visitToolId = vistToolsMap.get(stdItm.StdVisitItemTool__c);
		  	  	 	
		  	  	 	if(visitToolId != null){
		  	  	 		
		  	  	 		Junction_ChklInsp__c toolVisitItem = new Junction_ChklInsp__c();
		  	  	 		
			  	  	 	toolVisitItem.Standard_Checklist_Reference__c = visitToolId; 	
			  	  	 	toolVisitItem.Standard_Inspection_Item__c = stdItm.Id;
			  	  	 	toolVisitItem.Random_Item__c = stdItm.StdVisitItemRandom__c;
			  	  	 	if(toolVisitItem.Random_Item__c){
			  	  	 	   toolVisitItem.Random_Item_Domain__c = stdItm.StdVisitItemRandomDomainName__c;
			  	  	 	}
			  	  	 	toolVisitItemsToCreate.add(toolVisitItem);
		  	  	 	}	
		  	     }
		  	 	  		  	 
		  }
		  
		  if (visitItmRegsToCreate.size() > 0) {
		  	 insert visitItmRegsToCreate; 
		   }
		  
		  if (toolVisitItemsToCreate.size() > 0){
		  	insert toolVisitItemsToCreate;
		  } 
	
	 }
	 
	 
	 //Update StandardVisitItems
	 public static void bulkUpdateStandardVisitItems(Map<Id, Standard_Inspection_Item__c> triggerNewMap){
		 
		 system.debug('######### triggerNewMap....'+ triggerNewMap);
		  
		
		  Id visitToolId;
		  Id stdVisitItmId;
		 // Tools Map 
		  Map<string,Id> vistToolsMap = new Map<string,Id>();

		  List<Standard_Checklist_Reference__c> vistToolsList = new List<Standard_Checklist_Reference__c>([Select Id,Name From Standard_Checklist_Reference__c Where Active__c = true]);
		  for(Standard_Checklist_Reference__c chkRef : vistToolsList){
		  	 vistToolsMap.put(chkRef.Name, chkRef.Id);
		  }

         Set<Id> stdVisitIds = new Set<Id>();
         for(Standard_Inspection_Item__c s: triggerNewMap.values()){
         	stdVisitIds.add(s.Id);
         }

		  //ToolVisitItemsMap
		  List<Junction_ChklInsp__c> toolVisitItemsList = new List<Junction_ChklInsp__c>([Select Id,Name, Standard_Inspection_Item__c, Standard_Checklist_Reference__r.name From Junction_ChklInsp__c Where Standard_Inspection_Item__c in :stdVisitIds]);
		  Map<string,Id> toolVisitItemsMap = new Map<string,Id>();
		  for(Junction_ChklInsp__c jc: toolVisitItemsList){
		  	toolVisitItemsMap.put(jc.Standard_Checklist_Reference__r.name,jc.Standard_Inspection_Item__c);
		  }
		  
		  system.debug('**** ToolVisitItemsMap...'+toolVisitItemsMap);
		  
		  system.debug('######### vistToolsMap....'+ vistToolsMap);
		  
		  List<Junction_ChklInsp__c> toolVisitItemsToCreate = new List<Junction_ChklInsp__c>();
		   
		  for(Standard_Inspection_Item__c stdItm : triggerNewMap.values()) {	
		  	
		  	system.debug('######### in For Loop--- StandardItm---:'+ stdItm);	  	  
		  	     
		  	     //Insert into Tool Assignments		  	     
		  	     if (stdItm.StdVisitItemTool__c != null && stdItm.StdVisitItemTool__c != ''){
		  	     	
		  	     	system.debug('######### In IF Condition'+ stdItm.StdVisitItemTool__c +'----'+stdItm.Name);
		  	  	   
		  	  	    //Get the Tool Id
		  	  	    visitToolId = vistToolsMap.get(stdItm.StdVisitItemTool__c);
		  	  	    
		  	  	    //Get the Std Visit Item Id
		  	  	    stdVisitItmId = toolVisitItemsMap.get(stdItm.StdVisitItemTool__c);
		  	  	    
		  	  	    system.debug('######### visitToolId....'+ visitToolId);
		  	  	    system.debug('######### stdVisitItmId....'+ stdVisitItmId);
		  	  	 	
		  	  	 	if(visitToolId != null && stdVisitItmId == null){
		  	  	 		
		  	  	 		Junction_ChklInsp__c toolVisitItem = new Junction_ChklInsp__c();
		  	  	 		
			  	  	 	toolVisitItem.Standard_Checklist_Reference__c = visitToolId; 	
			  	  	 	toolVisitItem.Standard_Inspection_Item__c = stdItm.Id;
			  	  	 	toolVisitItem.Random_Item__c = stdItm.StdVisitItemRandom__c;
			  	  	 	if(toolVisitItem.Random_Item__c){
			  	  	 	   toolVisitItem.Random_Item_Domain__c = stdItm.StdVisitItemRandomDomainName__c;
			  	  	 	}
			  	  	 	
			  	  	   system.debug('######### toolVisitItem....'+ toolVisitItem);
			  	  	 	toolVisitItemsToCreate.add(toolVisitItem);
		  	  	 	}	
		  	     }
		  	 	  		  	 
		  }
		  
		  if (toolVisitItemsToCreate.size() > 0){
		  	  system.debug('######### toolVisitItemsToCreate....'+ toolVisitItemsToCreate);
		  	
		  	insert toolVisitItemsToCreate;
		  } 
		  
		 
	
	 }
	 
	 
	 

}