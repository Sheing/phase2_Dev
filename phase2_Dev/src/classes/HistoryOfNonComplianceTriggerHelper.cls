public with sharing class HistoryOfNonComplianceTriggerHelper {
	//Created by LD - LEAD-2226
    public static void bulkVisitInsert(List<HistoryOfNonCompliance__c> triggerNew){
    	
    	Set<string> ProgramIds = new Set<string>();
    	Set<string> ProgramIdInteraction = new Set<string>();
    	Set<string> CitationIds = new Set<string>();
    	List<string> citationList = new List<string>();
    	integer prevPId = 0;
    	integer currPId = 0;
    	
    	for (HistoryOfNonCompliance__c nc : triggerNew) {
    		
    		currPId = integer.valueof(nc.name.trim());
    		
    		if(currPId != prevPId){
    		   ProgramIds.add(nc.name.trim()); 
    		   ProgramIdInteraction.add(nc.name.trim() + '|' + nc.Interaction__c.trim()); 
    		   prevPId = currPId;
    		   currPId = 0;
    		} 
    		
    		if (nc.citation__c != null){
	    		citationList = nc.citation__c.split(';');
	    		for(string cs: citationList){
	    			CitationIds.add(cs);
	    		}
    		}
    				
    	}
    	
    	List<Inspection__c> VisitsToInsert = new List<Inspection__c>();
    	List<Inspection_Item__c> VisitItemsToInsert = new List<Inspection_Item__c>();
    	
    	List<Regulation__c> RegulationList = [Select Id, Name, Applicable_To__c From Regulation__c Where Name in :CitationIds];
    	Map<string,Regulation__c> RegulationMap = new Map<string,Regulation__c>();
    	for(Regulation__c rg: RegulationList){
    		RegulationMap.put(rg.Name,rg);
    	}
    	
    	system.debug('****Regulation Map:'+RegulationMap);
    	
    	Map<Id,Account> AccountMap = new Map<Id,Account>([Select Id,Name, Provider_No__c,RecordTypeId From Account Where Provider_No__c in :ProgramIds]);
    	Map<string,Account> ProgramIdMap = new Map<string,Account>();
    	for(Account a: AccountMap.values()){
    		ProgramIdMap.put(a.Provider_No__c,a);
    	}
    	
        string prevVisit = null;
        string newVisit = null;
        integer interactionYear = 0;
        string ncStr = null;
        Id LegacySystemImport = [Select id,Name from RecordType where sObjectType = 'Inspection__c' and Name like 'Legacy System Import%'].Id;
        Id NonStandardItm = [Select id,Name from RecordType where sObjectType = 'Inspection_Item__c' and Name like 'Non Standard%'].Id;
        
    	for (HistoryOfNonCompliance__c nc : triggerNew) {
    		
    		newVisit = nc.Name.trim() + '|' + nc.Interaction__c.trim();
    		
    		if (nc.InteractionDate__c != null){
	    	    interactionYear = nc.InteractionDate__c.Year();
	    	 }
	    		       		
    		if(newVisit != prevVisit){
    		
	    		Account acc = ProgramIdMap.get(nc.Name);	
	    		
	    		if(acc != null){
			
	    		   prevVisit = null;	
	    			
	    		   Inspection__c visiTT = new Inspection__c();
	    		  
	    		   visiTT.RecordTypeId = LegacySystemImport;
	    		   visiTT.Provider_No__c = acc.Id;
	    		   visiTT.Legacy_System_Interaction__c = nc.Interaction__c;
	    		   visiTT.Date_of_Visit__c = nc.InteractionDate__c;
	    		   visiTT.Type_of_Visit__c = 'Legacy System Import';
	    		   visiTT.Status__c = 'Closed';
	    		   
	    		   system.debug('YEAR*********:'+nc.InteractionDate__c.Year());
	    		   
	    		   if (interactionYear == 2015 || interactionYear == 2014){
		              ProgramIds.add(acc.Id);
			        }
	    		   
	    		   VisitsToInsert.add(visiTT);
	    		   
	    		   prevVisit = nc.Name.trim() + '|' + nc.Interaction__c.trim();
	    		   interactionYear = 0;    		   
    		
	    	      } 
    		  }
    		  newVisit = null; 	      
    	      
          }
          
          if(VisitsToInsert.size() > 0){
          	insert VisitsToInsert;
          	
          }
         
          if(VisitsToInsert.size() > 0){
          	string prgId = null;
          	DateTime dtGMT = null;
          	DateTime current = system.now();
          	Date currDate = system.today();
			Time currTime = current.time();
			DateTime local;
            List<string> regList = new List<string>();
          	Map<Id,Inspection__c> VisitMap = new Map<Id,Inspection__c>([Select Id,Name,Provider_No__c,Provider_Type__c,Legacy_System_Interaction__c From Inspection__c Where Id in :VisitsToInsert]);
          
          	system.debug('****VistMap****:'+ VisitMap);
          	List<HistoryOfNonCompliance__c> nonComplianceList = [Select Id,Name, Interaction__c,Observations__c,InteractionDate__c,Citation__c  From HistoryOfNonCompliance__c];
          	if (VisitMap != null){
          	for(Inspection__c v : VisitMap.values()){
          		
          		Account programIdVal = AccountMap.get(v.Provider_No__c);
       
          		if (programIdVal != null){
              	    if (nonComplianceList.size() > 0){
	          	     	for (HistoryOfNonCompliance__c ncl : nonComplianceList){
	          	     		prgId = string.valueOf(programIdVal.Provider_No__c);
	          	     	     if(ncl.Name.trim() == prgId && (ncl.InteractionDate__c.Year() == 2014 || ncl.InteractionDate__c.Year() == 2015) && ncl.Interaction__c.trim() == v.Legacy_System_Interaction__c.trim()){
			          	     	 Inspection_Item__c visitItm = new Inspection_Item__c();
				    		     
				    		     visitItm.Inspection_No__c = v.Id;
				    		     visitItm.RecordTypeId = NonStandardItm;
					    	     visitItm.Category_additional__c = 'Legacy System Non Compliance';
					    	     visitItm.Additional_Inspection_Item_Name__c = ncl.Observations__c.substring(0,37) + '...';
					    	     visitItm.Observations__c = ncl.Observations__c;
					    	     visitItm.Inspection_Result__c ='Non-Compliant';
					    	     
					    	     if(ncl.InteractionDate__c != null){
					    	     	dtGMT = ncl.InteractionDate__c;
					    	     	currDate = dtGMT.dateGmt();
                                    local = datetime.newinstance(currDate,currTime); 
				    	            visitItm.Assessed_Date__c = local;
					    	     }
					    	     
					    	     system.debug('****Citation ****:'+ncl.Citation__c);
					    	     
					    	     regList = ncl.citation__c.split(';');
					    		 if(regList.size() > 1){
						    		 for (string cs: regList){
						    		 	 Regulation__c rgFound = regulationMap.get(cs);
						    	         
						    	          if (rgFound != null){
						    	     	
						    	             system.debug('****rgFound***:'+rgFound);
						    	             system.debug('****Provider_Type__c***:'+v.Provider_Type__c);
						    	     	
						    	     	     if (rgFound.Applicable_To__c.contains(v.Provider_Type__c)){
						    	     	     	 Inspection_Item__c visitItmClone = visitItm.clone();	
						    	     		     system.debug('****Applicable_To***:'+rgFound.Applicable_To__c.contains(v.Provider_Type__c));				  
						    		             visitItmClone.Associated_regulation__c = rgFound.Id;
						    		             VisitItemsToInsert.add(visitItmClone); 
						    	     	      }
						    		      } 
						    		   }//end for citation
					    		   }
					    		   else if(regList.size() <= 1){
						     	       Regulation__c rgFound2 = regulationMap.get(ncl.Citation__c);
							    	   if(rgFound2 != null){
							    	     	
							              system.debug('****rgFound***:'+rgFound2);
							    	      system.debug('****Provider_Type__c***:'+v.Provider_Type__c);
							    	     	
							    	   	  if (rgFound2.Applicable_To__c.contains(v.Provider_Type__c)){	
							    	    	 system.debug('****Applicable_To***:'+rgFound2.Applicable_To__c.contains(v.Provider_Type__c));				  
							    		     visitItm.Associated_regulation__c = rgFound2.Id;
							    	       }
							            }
							            VisitItemsToInsert.add(visitItm); 
					    		   }
	          	     	     }
	          	     	     prgId = null; 
	          	     	  } //end for
	          	        }// end if  
	       		     }	 
	    	     }//end for
          	  }//end if
          }
          if(VisitItemsToInsert.size() > 0){
          	system.debug('VisitItems to Insert****:'+VisitItemsToInsert);
          	insert VisitItemsToInsert;
          }
    
    string SOQL = 'Select Id from HistoryOfNonCompliance__c';
    Database.executeBatch(new Batch_CleanHistoryofNonCompliance(SOQL),200);       
          
    }

}