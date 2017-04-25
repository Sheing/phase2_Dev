//Author: Latha Davuluri
public with sharing class EEC_ProcessLegacyVisitData {
    
    //Method to Process LM 2010/FCC Mobile Visits - LEAD-4231 & LEAD-4298
    public static void processLegacyVisits(EEC_HistoricalVisitStaging__c vs){
        
        Id LegacyRecordTypeId = [Select Id From RecordType Where sobjectType='Inspection__c' and name like 'Legacy System%'].Id;
        Id ProgramId = [Select Id,Name, Provider_No__c From Account Where Provider_No__c = :vs.EEC_ProgramId__c].Id;
        Id licensorId = [Select Id From User Where Historic_Licensor_No__c = :vs.EEC_VisitingLicensorId1__c limit 1].Id;
        List<Inspection__c> visitsToCreate = new List<Inspection__c>();
        
        //Duplicate Algorithm : Visit Date + ProgramId + VisitReason is considered as duplicate
        
        string dupRule1 = vs.EEC_DuplicateRule1__c;

        List<EEC_HistoricalVisitStaging__c> processedVisit = [Select Id From EEC_HistoricalVisitStaging__c Where EEC_DuplicateRule1__c = :dupRule1 and EEC_Visit_Processed__c = true];
        
        system.debug('processedVisit*******'+processedVisit);
        //check for duplicates and insert only if no duplicates found
        if (processedVisit.size() <= 0){
            Inspection__c lmv = new Inspection__c();
            
            lmv.RecordTypeId = LegacyRecordTypeId;
            lmv.Provider_No__c = ProgramId;
            lmv.Type_of_Visit__c = vs.EEC_LeadReasonOfVisit__c;
            lmv.Comments__c = vs.EEC_Comment__c;
            lmv.Status__c = 'Closed';
            lmv.Date_of_Visit__c = vs.EEC_VisitDate__c;
            lmv.EEC_Legacy_Compliance_Code_Desc__c = vs.EEC_ComplianceCodeDesc__c;
            lmv.Legacy_FCC_LM_Mobile_Visit__c = vs.EEC_FCC_Mobile_Visit__c;
            if(licensorId != null)
                lmv.Inspector_del__c = licensorId;
            
            visitsToCreate.add(lmv);
            
            if(visitsToCreate.size() > 0){
                insert visitsToCreate;
            }
        }
        
    }
        
    //Method to Process FCC Mobile VisitItems - LEAD-4298
    public static void processLegacyVisitItems(EEC_HistoricalVisitItemStaging__c vis){
        
        boolean createVisitItem = true;
        
      /*  //ONLY Bring in the Non-Compliance VisitItems on FCC Mobile Detail Extract    
        if (!String.isBlank(vis.EEC_ComplianceStatusDesc__c) && vis.EEC_ComplianceStatusDesc__c.equalsIgnoreCase('Non-compliance')){ 
            createVisitItem = true;
        }
        */
       try{
       //Create Visit Item only if it is Non-Compliance
       if (createVisitItem){
        
        List<Inspection_Item__c> visitItemsToCreate = new List<Inspection_Item__c>();
        List<EEC_HistoricalVisitSubItemStaging__c> subItemsToUpdate = new List<EEC_HistoricalVisitSubItemStaging__c>();
        List<Inspection__c> visitsToUpdate = new List<Inspection__c>();
        Id NonStandardItm = [Select id,Name from RecordType where sObjectType = 'Inspection_Item__c' and Name like 'Non Standard%'].Id;
        List<string> regList = new List<string>();
        Set<string> citationIds = new Set<string>();
        Set<string> legacyCitationIds = new Set<string>();
        List<string> citationList = new List<string>();
        List<EEC_HistoricalVisitSubItemStaging__c> visitSubItems = [Select Id, EEC_Display_Text_SubItemVal__c, EEC_Visit_SubItem_Processed__c From EEC_HistoricalVisitSubItemStaging__c Where EEC_HeaderVisitItem__c = :vis.EEC_HeaderVisitItem__c And EEC_Visit_SubItem_Processed__c = false];
            
        if (vis.EEC_RegGroupItem__c != null){
            citationList = vis.EEC_RegGroupItem__c.split(';');
             for(string cs: citationList){
             	string regSwap = getRegulationSwap(cs.trim());
             	regSwap = regSwap.trim();
                citationIds.add(regSwap);
                string rgName = regSwap +'_20031010';
                legacyCitationIds.add(rgName);              	
	          }      
        }
        
        List<Regulation__c> RegulationList = [Select Id, Name, Applicable_To__c From Regulation__c Where Name in :citationIds];
        Map<string,Regulation__c> RegulationMap = new Map<string,Regulation__c>();
        for(Regulation__c rg: RegulationList){
		   RegulationMap.put(rg.Name,rg);
		}
		
		List<Regulation__c> legacyRegulationList = [Select Id, Name, Applicable_To__c From Regulation__c Where Name in :legacyCitationIds];
	    Map<string,Regulation__c> legacyRegulationMap = new Map<string,Regulation__c>();
	    for(Regulation__c rg: legacyRegulationList){
	           legacyRegulationMap.put(rg.Name,rg);
	    }		
		
        string headerVisit = vis.EEC_HeaderVisit__c;
        string subItemText = '';

        Inspection__c legacyVisit = [Select Id,Provider_No__c,Provider_Type__c,Date_of_Visit__c, Status__c From Inspection__c Where Legacy_FCC_LM_Mobile_Visit__c = :headerVisit limit 1];
        
        //check for duplicates and insert only if no duplicates found
        if (legacyVisit != null){
            
            Inspection_Item__c visitItm = new Inspection_Item__c();
                                 
             visitItm.Inspection_No__c = legacyVisit.Id;
             visitItm.RecordTypeId = NonStandardItm;
             visitItm.Additional_Inspection_Item_Name__c = vis.EEC_RegGroupItemDesc__c;
             if (!String.isBlank(vis.EEC_ComplianceStatusDesc__c)){ 
                 if (vis.EEC_ComplianceStatusDesc__c.equalsIgnoreCase('Compliance'))
                     visitItm.Inspection_Result__c = 'Compliant';
                 else if (vis.EEC_ComplianceStatusDesc__c.equalsIgnoreCase('Non-compliance'))
                     visitItm.Inspection_Result__c = 'Non-Compliant';
                 else if (vis.EEC_ComplianceStatusDesc__c.equalsIgnoreCase('Discussion'))
                     visitItm.Inspection_Result__c = 'Discussion';
                 else 
                    visitItm.Inspection_Result__c = vis.EEC_ComplianceStatusDesc__c;                
             }
             visitItm.Category_additional__c = 'Legacy System '+ vis.EEC_ComplianceStatusDesc__c;
             
             //Append all the SubItems info 
             if (visitSubItems.size() > 0){
                for (EEC_HistoricalVisitSubItemStaging__c sis :  visitSubItems){                    
                    subItemText = subItemText + sis.EEC_Display_Text_SubItemVal__c + ';';
                    sis.EEC_Visit_SubItem_Processed__c = true;
                    subItemsToUpdate.add(sis);
                }
             }
             
             visitItm.Observations__c = vis.EEC_Comment__c;
             if (!string.isBlank(vis.EEC_Comment__c)) {
                visitItm.Observations__c = vis.EEC_Comment__c + '; ' + subItemText;
             }
             else if (!string.isBlank(subItemText)) {
                visitItm.Observations__c = subItemText;
             }
             else{
                visitItm.Observations__c = 'No Observations added.'; // Added this text in order to avoid Validation errors 
             }
             visitItm.Assessed_Date__c = legacyVisit.Date_of_Visit__c + 1;
             
               //Citation Info to include
             if (!string.isBlank(vis.EEC_RegGroupItem__c ))
                 regList = vis.EEC_RegGroupItem__c.split(';');
            
             //Regulations/Citations to add on the visit Items  
              if (regList.size() > 1){                
                //system.debug('****Regulation Map***'+regulationMap);               
                 integer counter = 1;
                
                 for (string cs: regList){
                    //system.debug('***1 ***:'+ cs);                    
                    if (!string.isBlank(cs))
                        cs = cs.trim();
                        
                    string regSwap = getRegulationSwap(cs);
                     
                     Regulation__c rgFound = regulationMap.get(regSwap);
                     string legacyRegStr = regSwap +'_20031010';
                     // Legacy regulation 
		             Regulation__c legacyReg = legacyRegulationMap.get(legacyRegStr);
 
                     if (counter == regList.size()){    
                        if (legacyReg != null){	            	
				            if (legacyReg.Applicable_To__c.contains(legacyVisit.Provider_Type__c)){
                               // system.debug('****Applicable_To***:'+rgFound.Applicable_To__c.contains(legacyVisit.Provider_Type__c));                
                                    visitItm.Associated_regulation__c = legacyReg.Id;                             
                             }	               	                                                    
                        }
                        else{
                          /* if (rgFound != null){
 		                    	if (rgFound.Applicable_To__c.contains(legacyVisit.Provider_Type__c)){
                               		// system.debug('****Applicable_To***:'+rgFound.Applicable_To__c.contains(legacyVisit.Provider_Type__c));                
                                    visitItm.Associated_regulation__c = rgFound.Id;                             
                            	}
                           }
                           */
                        }
                        visitItemsToCreate.add(visitItm); 
                     }
                     else{                      
	                        Inspection_Item__c visitItmClone = visitItm.clone();    
	                        if (legacyReg != null){	            	
					                visitItmClone.Associated_regulation__c = legacyReg.Id;                   	   
			                }
			                else{
	                        	if (rgFound != null){
		                            //system.debug('****rgFound***:'+rgFound);
		                            //system.debug('****Provider_Type__c***:'+legacyVisit.Provider_Type__c);
		                            //system.debug('****Applicable_To***:'+rgFound.Applicable_To__c.contains(legacyVisit.Provider_Type__c));                
		                            visitItmClone.Associated_regulation__c = rgFound.Id;        
	                        	}
			                }
                        visitItemsToCreate.add(visitItmClone);              
                     }                                         
                     counter = counter + 1;
                     
                   }//end for citation
               }
               else if(regList.size() <= 1){                 
                     string cs = vis.EEC_RegGroupItem__c;
                     
                     if (!string.isBlank(cs))
                        cs = cs.trim();
                        
                     string regSwap = getRegulationSwap(cs);   
   
                   Regulation__c rgFound2 = regulationMap.get(regSwap);
                   string legacyRegStr = regSwap +'_20031010';
                   Regulation__c legacyReg = legacyRegulationMap.get(legacyRegStr);
                   
                   if (legacyReg != null){
	                    if (legacyReg.Applicable_To__c.contains(legacyVisit.Provider_Type__c)){    
	                        visitItm.Associated_regulation__c = legacyReg.Id;
	                    }
		            }   
                   else{
	                   if(rgFound2 != null){                       
	                      if (rgFound2.Applicable_To__c.contains(legacyVisit.Provider_Type__c)){    
	                          visitItm.Associated_regulation__c = rgFound2.Id;
	                       }               
	                    }
                    }
                    visitItemsToCreate.add(visitItm);               
               }
               
             legacyVisit.Status__c = 'Closed';           
             if(visitItemsToCreate.size() > 0){
                 insert visitItemsToCreate;
              }
            
             if (subItemsToUpdate.size() >0){
                 update subItemsToUpdate;
             }           
            update legacyVisit;
        }
       } //Create Non-Compliance Visit Item
        vis.EEC_ErrorText__c = '';
        vis.EEC_VisitItem_Processed__c = true; 
       }
        catch(exception ex){
    		string errText = ex.getMessage();
    		if (errText.contains('List has no rows for assignment to SObject')){
    	        vis.EEC_ErrorText__c = 'Visit Not Found in LEAD';
    		}
    		else{
    			vis.EEC_ErrorText__c = ex.getMessage();
    		}    		
        }      
    }
    
    //Method to Process EECRs NonCompliance Visits - LEAD-4299
    public static void processLegacyNonComplianceVisits(EEC_HistoryOfNonComplianceStaging__c ncs){
        try{
        system.debug('*******Provider******'+ncs.ProgramId__c);
        
        Id LegacyRecordTypeId = [Select Id From RecordType Where sobjectType='Inspection__c' and name like 'Legacy System%'].Id;
        Id ProgramId = [Select Id,Name, Provider_No__c From Account Where Provider_No__c = :ncs.ProgramId__c].Id;
        List<User> licensorId = [Select Id From User Where Historic_Licensor_No__c = :ncs.LicensorOfInteraction__c limit 1];
        List<Inspection__c> visitsToCreate = new List<Inspection__c>();
        
        //Duplicate Algorithm : ProgramId + InteractionId + InteractionTypeDesc is considered as duplicate
        
        string dupRule1 = ncs.DuplicateRule1__c;

        List<Inspection__c> processedVisit = [Select Id,Legacy_FCC_LM_Mobile_Visit__c From Inspection__c Where Legacy_FCC_LM_Mobile_Visit__c = :dupRule1];
        
        system.debug('processedVisit*******'+processedVisit);
        //check for duplicates and insert only if no duplicates found
        if (processedVisit.size() <= 0){
            Inspection__c ncVisit = new Inspection__c();
                            
            ncVisit.RecordTypeId = LegacyRecordTypeId;
            if(ProgramId != null)
               ncVisit.Provider_No__c = ProgramId;
            ncVisit.Type_of_Visit__c = ncs.InteractionTypeDesc__c;
            ncVisit.Legacy_System_Interaction__c = ncs.InteractionId__c;
            ncVisit.Status__c = 'Closed';
            ncVisit.Date_of_Visit__c = ncs.InteractionDate__c;
            ncVisit.Legacy_FCC_LM_Mobile_Visit__c = ncs.DuplicateRule1__c;
            if(licensorId.size() > 0)
                ncVisit.Inspector_del__c = licensorId[0].Id;
            
            visitsToCreate.add(ncVisit);
            
            if(visitsToCreate.size() > 0){
                insert visitsToCreate;
            }
        }
         ncs.Visit_Processed__c = true;
        }
        catch(exception ex){
    		string errText = ex.getMessage();
    		if (errText.contains('List has no rows for assignment to SObject')){
    	        ncs.ErrorText__c = 'Provider Not Found in LEAD';
    		}
    		else{
    			ncs.ErrorText__c = ex.getMessage();
    		}
    		
        }
           
    }
  //Method to create investigations for EECRS non-compliances where InvestigationType is not null - Qamar
    public static void processLegacyInvestigations(EEC_HistoryOfNonComplianceStaging__c ncs){
        
        try{
        system.debug('*******Provider******'+ncs.ProgramId__c);
        
        //Id LegacyRecordTypeId = [Select Id From RecordType Where sobjectType='Inspection__c' and name like 'Legacy System%'].Id;
        Account p = [Select Id, AccountRecord_Type_Hidden__c, Name, Provider_No__c From Account Where Provider_No__c = :ncs.ProgramId__c];
        Id programId = p.Id;
        String programRecordType = p.AccountRecord_Type_Hidden__c;
        List<User> licensorId = [Select Id From User Where Historic_Licensor_No__c = :ncs.LicensorOfInteraction__c limit 1];
        List<Investigation__c> investigationsToCreate = new List<Investigation__c>();
        
        //Duplicate Algorithm : ProgramId + InteractionId + InteractionTypeDesc is considered as duplicate
        
        string dupRule1 = ncs.DuplicateRule1__c;

        List<Investigation__c> processedInvestigation = [Select Id,Legacy_FCC_LM_Mobile_Investigation__c From Investigation__c Where Legacy_FCC_LM_Mobile_Investigation__c = :dupRule1];
        
        system.debug('processedInvestigation*******'+processedInvestigation);
        //check for duplicates and insert only if no duplicates found
        if(processedInvestigation.size() <= 0){
            Investigation__c ncInv = new Investigation__c();

            if(programId != null && programRecordType != 'FCC Assistant'){
                ncInv.Provider_No__c = ProgramId;
            }
            ncInv.Investigation_Type__c = ncs.InvestigationType__c;
            ncInv.Assigned_Date__c = ncs.InteractionDate__c;
            ncInv.Legacy_System_Interaction__c = ncs.InteractionId__c;
            ncInv.Investigation_Status__c = 'Closed (Legacy Investigation)';
            ncInv.Legacy_FCC_LM_Mobile_Investigation__c = ncs.DuplicateRule1__c;
            ncInv.isLegacyInvestigation__c = true;
            ncInv.Legacy_System_Interaction__c = ncs.InteractionId__c;
            ncInv.Legacy_IntakeID__c = ncs.IntakeID__c;
            ncInv.Closed_Date__c = ncs.InvestigationClosedDate__c;
            if(licensorId.size() > 0){
                ncInv.Assigned_To__c = licensorId[0].Id;
            }
            investigationsToCreate.add(ncInv);
            
            if(investigationsToCreate.size() > 0){
                insert investigationsToCreate;
            }
        }
          ncs.Visit_Processed__c = true;
        }
        catch(exception ex){
        		string errText = ex.getMessage();
        		if (errText.contains('List has no rows for assignment to SObject')){
        	        ncs.ErrorText__c = 'Provider Not Found in LEAD';
        		}
        		else{
        			ncs.ErrorText__c = ex.getMessage();
        		}        		
            }          
    }

    //Method to process ECCRS Investigation Additional Non-compliance Items - Qamar
    public static void processLegacyInvestigationAddionalNonComplianceItems(EEC_HistoryOfNonComplianceStaging__c ncs){
	    try{
	        List<Non_Compliant__c> nonComplianceItemsToCreate = new List<Non_Compliant__c>();
	        List<string> regList = new List<string>();
	        Set<string> citationIds = new Set<string>();
	        Set<string> legacyCitationIds = new Set<string>();
	        List<string> citationList = new List<string>();
	        	        
	        List<Non_Compliant_Item_Regulation__c> ncItemRegItemsToInsert = new List<Non_Compliant_Item_Regulation__c>();
	
	        if (ncs.Citation__c != null){
	            citationList = ncs.Citation__c.split(';');
	            for(string cs: citationList){
	            	string regSwap = getRegulationSwap(cs.trim());
             	    regSwap = regSwap.trim();
	                citationIds.add(regSwap);
	                string rgName = regSwap +'_20031010';
                    legacyCitationIds.add(rgName);              	
	            }            
	        }
	       
		    List<Regulation__c> RegulationList = [Select Id, Name, Applicable_To__c From Regulation__c Where Name in :citationIds];
		    Map<string,Regulation__c> RegulationMap = new Map<string,Regulation__c>();
		    for(Regulation__c rg: RegulationList){
		           RegulationMap.put(rg.Name,rg);
		    }
		    
		    List<Regulation__c> legacyRegulationList = [Select Id, Name, Applicable_To__c From Regulation__c Where Name in :legacyCitationIds];
		    Map<string,Regulation__c> legacyRegulationMap = new Map<string,Regulation__c>();
		    for(Regulation__c rg: legacyRegulationList){
		           legacyRegulationMap.put(rg.Name,rg);
		    }		    
	            
	        //Look for the matching Visit
	        string matchRule = ncs.DuplicateRule1__c;
	        List<Investigation__c> processedInvestigation = [Select Id,Legacy_FCC_LM_Mobile_Investigation__c From Investigation__c Where Legacy_FCC_LM_Mobile_Investigation__c = :matchRule];
	        
	        system.debug('---------> processedInvestigation: ' + processedInvestigation);
	        Non_Compliant__c nonCompliantItem = new Non_Compliant__c();
	        //Matching investigation found - Insert the non-compliant items on the investigation found
	        if(processedInvestigation.size() > 0){
	            system.debug('Regulation Map ---'+RegulationMap);
	            nonCompliantItem.Investigation__c = processedInvestigation[0].Id;
	            nonCompliantItem.Require_Portal_Feedback__c = false;
	            nonCompliantItem.To_Review_on_Portal__c = false;
	            nonCompliantItem.Observations__c = ncs.Observations__c;
	            nonCompliantItem.Correction_Plan__c = ncs.CorrectionPlan__c;
	            nonCompliantItem.Correction_Plan_Status__c = 'Legacy Non-compliance';
	        
		        system.debug('***nonCompliantItem***'+nonCompliantItem);
		        insert nonCompliantItem;
		        //Non_Compliant_Item_Regulation__c items to create
		        for(String cs : citationIds){
		        	
		        	string regSwap = getRegulationSwap(cs.trim());
                    
                    boolean regFound = false;
                    string legacyRegStr = regSwap +'_20031010';
		            Regulation__c legacyReg = legacyRegulationMap.get(legacyRegStr);            	            

		            if(legacyReg != null){
		            	regFound = true;
                        Non_Compliant_Item_Regulation__c ncItemReg = new Non_Compliant_Item_Regulation__c();		            	
			            ncItemReg.Non_Compliant_Item__c = nonCompliantItem.Id;
			            ncItemReg.Regulation__c = legacyReg.id;
			            ncItemRegItemsToInsert.add(ncItemReg);
		            }
		            else{
		            	 Regulation__c reg = RegulationMap.get(regSwap);   
		                 if(reg != null){
		                 	regFound = true;
	                        Non_Compliant_Item_Regulation__c ncItemReg = new Non_Compliant_Item_Regulation__c();		            	
				            ncItemReg.Non_Compliant_Item__c = nonCompliantItem.Id;
				            ncItemReg.Regulation__c = reg.id;
				            ncItemRegItemsToInsert.add(ncItemReg);
		                  }
		            }
		            		    
		            if(!regFound){
		             //No Match found then it could be a uniqueCitation where Only some legacy citations are in the format of Allegation:Citation and this format doesn't exist in LEAD  
	               	  if(string.isBlank(nonCompliantItem.Legacy_Regulation__c)){
	               	     nonCompliantItem.Legacy_Regulation__c = regSwap.replace('_20031010','');
	               	  }
	               	  else{
	               	  	 nonCompliantItem.Legacy_Regulation__c =  nonCompliantItem.Legacy_Regulation__c + ';' + regSwap.replace('_20031010','');
	               	  }
	               	  update nonCompliantItem;
		            } 
		            upsert ncItemRegItemsToInsert;			        
		        }//end for

	        ncs.VisitItem_Processed__c = true;	
	
	        } 
	        ncs.ErrorText2__c ='';
		    ncs.ErrorTextLong2__c ='';     
	    }
        catch(exception ex){
        	system.debug('****ERROR********'+ex.getMessage());
        	ncs.ErrorText2__c = ex.getMessage();
        	ncs.ErrorTextLong2__c =ex.getMessage(); 
        }
    }
    
    //Method to Process EECRs NonCompliance Visits - LEAD-4299
    public static void processLegacyNonComplianceVisitItems(EEC_HistoryOfNonComplianceStaging__c ncs){
        try{
	        List<Inspection_Item__c> visitItemsToCreate = new List<Inspection_Item__c>();
	        Id NonStandardItm = [Select id,Name from RecordType where sObjectType = 'Inspection_Item__c' and Name like 'Non Standard%'].Id;
	        List<string> regList = new List<string>();
	        Set<string> citationIds = new Set<string>();
	        Set<string> legacyCitationIds = new Set<string>();
	        List<string> citationList = new List<string>();
	            
	        if (ncs.Citation__c != null){
                citationList = ncs.Citation__c.split(';');
                for(string cs: citationList){
                	string regSwap = getRegulationSwap(cs.trim());
             	    regSwap = regSwap.trim();
	                citationIds.add(regSwap);
	                string rgName = regSwap +'_20031010';
                    legacyCitationIds.add(rgName);              	
	            }     
	        }
	        
	        List<Regulation__c> RegulationList = [Select Id, Name, Applicable_To__c From Regulation__c Where Name in :citationIds];
	        Map<string,Regulation__c> RegulationMap = new Map<string,Regulation__c>();
	        for(Regulation__c rg: RegulationList){
		        RegulationMap.put(rg.Name,rg);
		    }
		    
		    List<Regulation__c> legacyRegulationList = [Select Id, Name, Applicable_To__c From Regulation__c Where Name in :legacyCitationIds];
		    Map<string,Regulation__c> legacyRegulationMap = new Map<string,Regulation__c>();
		    for(Regulation__c rg: legacyRegulationList){
		           legacyRegulationMap.put(rg.Name,rg);
		    }		            
	        //Look for the matching Visit
	        string matchRule = ncs.DuplicateRule1__c;	
	        List<Inspection__c> processedVisit = [Select Id,Legacy_FCC_LM_Mobile_Visit__c,Provider_Type__c,Date_of_Visit__c From Inspection__c Where Legacy_FCC_LM_Mobile_Visit__c = :matchRule limit 1];	        
	        
	        //system.debug('processedVisit*******'+processedVisit);
	        
	        //Matching Visit Found - Insert the VisitItems on the Visit Found
	        if (processedVisit.size() > 0){
	            system.debug('Regulation Map ---'+RegulationMap);
	            Inspection_Item__c visitItm = new Inspection_Item__c();
	            visitItm.Inspection_No__c = processedVisit[0].Id;
	            visitItm.RecordTypeId = NonStandardItm;
	            visitItm.Category_additional__c = 'Legacy System Non Compliance';
	            Integer itemNameUpperLimit = ncs.Observations__c.length() > 37 ? 37 : ncs.Observations__c.length();
	            visitItm.Additional_Inspection_Item_Name__c = ncs.Observations__c.substring(0,itemNameUpperLimit) + '...';
	            visitItm.Observations__c = ncs.Observations__c;
	            visitItm.Inspection_Result__c ='Non-Compliant';
	            visitItm.Correction_Plan__c = ncs.CorrectionPlan__c;
	            visitItm.Assessed_Date__c = processedVisit[0].Date_of_Visit__c + 1;
	            visitItm.Correction_Plan_Status__c = 'Legacy Non-compliance';
	             
	               //Citation Info to include
	             if (!string.isBlank(ncs.Citation__c))
	                 regList = ncs.Citation__c.split(';');
	                 
	             //Regulations/Citations to add on the visit Items
	             if (regList.size() > 1){
	                
	                system.debug('****Regulation Map***'+regulationMap);
	                
	                 integer counter = 1;
	                
	                 for (string cs: regList){	
	                 	
	                 	 string regSwap = getRegulationSwap(cs.trim());                    
	                     
	                     Regulation__c rgFound = regulationMap.get(regSwap);
	                     string legacyRegStr = regSwap +'_20031010';
	                     // Legacy regulation 
			             Regulation__c legacyReg = legacyRegulationMap.get(legacyRegStr);
	                     
	                     if (counter == regList.size()){    
	                        if (legacyReg != null){	            	
					               if (legacyReg.Applicable_To__c.contains(processedVisit[0].Provider_Type__c)){
	                                  visitItm.Associated_regulation__c = legacyReg.Id;                             
	                               }                 	   
			                 }
	                        else{
		                        if (rgFound != null){
		                            if (rgFound.Applicable_To__c.contains(processedVisit[0].Provider_Type__c)){
		                                visitItm.Associated_regulation__c = rgFound.Id;                             
		                            }
		                        }
	                        }

	                        visitItemsToCreate.add(visitItm); 
	                     }
	                     else{                      
	                        Inspection_Item__c visitItmClone = visitItm.clone();    
	                        if (legacyReg != null){	            	
					            visitItmClone.Associated_regulation__c = legacyReg.Id;                  	   
			                }
	                        else{		                    
			                    if (rgFound != null){
	                               visitItmClone.Associated_regulation__c = rgFound.Id;        
	                            }
	                        }
	                        visitItemsToCreate.add(visitItmClone);              
	                     }	                                         
	                     counter = counter + 1;	                     
	                   }//end for citation
	               }
	               else if(regList.size() <= 1){	                  
	                 string cs = ncs.Citation__c;
	   
	                   string regSwap = getRegulationSwap(cs.trim());
	                   
	                   Regulation__c rgFound2 = regulationMap.get(regSwap);
	                   string legacyRegStr = regSwap +'_20031010';
	                   // Legacy regulation 
			             Regulation__c legacyReg2 = legacyRegulationMap.get(legacyRegStr);
			             
	                   if(legacyReg2 != null){
	                      if (legacyReg2.Applicable_To__c.contains(processedVisit[0].Provider_Type__c)){  
	                          visitItm.Associated_regulation__c = legacyReg2.Id;
	                       }             
	                    }
	                    else{		                   
	                       if(rgFound2 != null){
	                          if (rgFound2.Applicable_To__c.contains(processedVisit[0].Provider_Type__c)){  
		                         //system.debug('****Applicable_To***:'+rgFound2.Applicable_To__c.contains(processedVisit[0].Provider_Type__c));                
		                         visitItm.Associated_regulation__c = rgFound2.Id;
	                          }               
	                       }
	                    }
	                    visitItemsToCreate.add(visitItm);               
	               }	        
	            //system.debug('##### VisitItems ####'+ visitItemsToCreate);	            
	            processedVisit[0].Status__c = 'Closed';  	            
	            update processedVisit[0];	            
	        }
	        if (visitItemsToCreate.size() > 0){
	            insert visitItemsToCreate;
	        }
	         ncs.VisitItem_Processed__c = true;
	         ncs.ErrorText2__c = '';
        }
         catch(exception ex){
        	system.debug('****ERROR********'+ex.getMessage());
        	ncs.ErrorText2__c = ex.getMessage();
        }               
    }    
    
    //Special condition on one of the regulations
    private static string getRegulationSwap(string reg){
    	/*
    	- 7.07(02)(a) -> 7.07(02) 
		- 7.07(02)(b) -> 7.07(02) 
		- 7.07(07)(g) -> 7.07(07)(h) 
		- 7.05(15) -> 7.04(15) 
		- 7.05(16) -> 7.04(16) 
		- 7.079(10)(p) -> 7.07(10)(p) 
		- 7.07(15)(6) ->7.07(15)(b) 
		- 7.11(5)9c) -> 7.11(05)(c) 
		- 8.1 -> 7.10(05) 
		- 8.04(03) ->7.09(08) 
    	*/
    	
    	Map<string,string> regSwapMap = new Map<string,string>();
    	regSwapMap.put('7.07(02)(a)','7.07(02)');
    	regSwapMap.put('7.07(2)(a)','7.07(02)');
    	regSwapMap.put('7.07(02)(b)','7.07(02)');
    	regSwapMap.put('7.07(2)(b)','7.07(02)');
    	regSwapMap.put('7.07(07)(g)','7.07(07)(h)');
    	regSwapMap.put('7.05(15)','7.04(15)');
    	regSwapMap.put('7.05(16)','7.04(16)');
    	regSwapMap.put('7.079(10)(p)', '7.07(10)(p)');
    	regSwapMap.put('7.07(15)(6)','7.07(15)(b)');
    	regSwapMap.put('7.07(15)(06)','7.07(15)(b)');
    	regSwapMap.put('7.11(5)9c','7.11(05)(c)');
    	regSwapMap.put('7.11(05)9c','7.11(05)(c)');
    	regSwapMap.put('8.1','7.10(05)');
    	regSwapMap.put('8.04(03)','7.09(08)');
    	
    	string regSwapVal = regSwapMap.get(reg);
    	
    	if(!string.isBlank(regSwapVal))
    	    return regSwapVal.trim();
    	    
      return reg.trim();
    }
}