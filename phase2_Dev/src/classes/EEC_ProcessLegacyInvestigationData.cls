public with sharing class EEC_ProcessLegacyInvestigationData {
	
	//LEAD-4961
	public static void processLegacyInvestigations(Historical_Investigation_Staging__c Ins){
	   
	    try{
			   string dupRule1 = Ins.Duplicate_Rule__c;
			   string Intakeid = Ins.Intake_Id__c;
			   string Relatedto = Ins.Related_to_51A__c;
			   if(Ins.Related_to_51A__c == null){
			    Relatedto = 'False';
			   }
			    
			   List<Investigation__c> Inv = [Select Id,Legacy_IntakeID__c,Due_Date__c,Number_of_Days_to_Receive_Response__c,Related_to_51A__c,Related_To_Complaint_Case__c,
			                                 Cover_Letter_Narrative__c,Agencies_Involved__c,Legacy_Investigation_Number__c  From Investigation__c Where Legacy_IntakeID__c =: Intakeid limit 1];
			   
			   if(Inv.size() > 0){
			     Inv[0].Due_Date__c = Ins.Due_Date__c;
			     Inv[0].Number_of_Days_to_Receive_Response__c = Ins.Corrective_Action_Due_Days__c;
			     if(Inv[0].Related_to_51A__c == false ){
			     Inv[0].Related_to_51A__c = boolean.valueof(Relatedto);
			     }
			     Inv[0].Related_To_Complaint_Case__c = true;
			     //Inv[0].Duplicate_Rule__c = Ins.Duplicate_Rule__c;
			     Inv[0].Cover_Letter_Narrative__c = 'Cover Letter fields from Legacy Systems: \n From:' + Ins.Cover_Letter_Custom_From_Name__c + ',' + Ins.Cover_Letter_Custom_From_Title__c + ', \n cc:'+ Ins.Cover_Letter_Custom_CC_List__c
			                                         + '|'+Ins.Cover_Letter_Custom_To_Name__c + ': \n '+ Ins.Cover_Letter_Custom_Text__c;
			     Inv[0].Legacy_Investigation_Number__c = Ins.Investigation_Number__c;
			     Inv[0].Agencies_Involved__c = Ins.Agencies_Involved__c;
			     system.debug('Investigation Being Updated'+Inv[0].id+Inv[0].Legacy_IntakeID__c+Ins.id);
			     
			     update Inv[0];
			     
			     Ins.Investigation_Processed__c= true;
	     }else{
	          Ins.Error_Text__c = 'Intake ID not found in LEAD';
	     }
	  } 
	  catch(Exception e){
	      system.debug('******** Error occured updating Investigation*******'+ e.getMessage());			
		   Ins.Error_Text__c = e.getMessage();
	  }
	}
	
	public static void processLegacyStaff(Historical_Staff_Staging__c SS){
		
		try{
			//Duplicate Algorithm : Intake ID + ProgramId is considered as duplicate
			string dupRule = Ss.Duplicate_Rule__c;
			boolean licensorExists = false;		
	        
	        List<User> Licensor = [Select Id,Name From User Where Historic_Licensor_No__c = :Ss.Licensor_Number__c limit 1];
	        Id LEADUserId = [Select Id, Name From User Where Name = 'LEAD System_Batch_User'].Id;
			
			List<Investigation__c> processedInvestigation = [Select Id, Duplicate_Rule__c,Assigned_To__c,Backup__c,Assigned_Date__c,Legacy_Staff_Info__c From Investigation__c Where Duplicate_Rule__c = :dupRule limit 1];
			
			if (processedInvestigation.size() > 0){
				system.debug('MMMMM'+processedInvestigation.size()+processedInvestigation[0].Assigned_To__c);
				  if(Ss.Active__c == '1' && processedInvestigation[0].Assigned_To__c == null && Ss.Role__c == 'Lead'){
				  	if (Licensor.size() > 0){
				  	    processedInvestigation[0].Assigned_To__c = Licensor[0].id;
				  	    licensorExists = true;
				  	 }
				   }
				   else if(Ss.Active__c == '1' && processedInvestigation[0].Backup__c == null && Ss.Role__c == 'Assist'){
				  	 if (Licensor.size() > 0){ 
				       processedInvestigation[0].Backup__c = Licensor[0].id;
				       licensorExists = true;
				  	  }
				   }
				   
				   if (!licensorExists){
				      processedInvestigation[0].Assigned_Date__c = Ss.Date_Assigned__c;
				      if(string.isBlank(processedInvestigation[0].Legacy_Staff_Info__c)){
				          processedInvestigation[0].Legacy_Staff_Info__c = 'Investigation Staff Info: \n Staff Id:' +(Ss.Licensor_Number__c != null? Ss.Licensor_Number__c :'Not Provided')+ '\n Name :' + (Ss.Licensor_Name__c != null? Ss.Licensor_Name__c:'Not Provided') + '\n Date Assigned :';
				      }
				      else{
				      	 processedInvestigation[0].Legacy_Staff_Info__c += '\n\n Staff Id:' +(Ss.Licensor_Number__c != null? Ss.Licensor_Number__c :'Not Provided')+ '\n Name :' + (Ss.Licensor_Name__c != null? Ss.Licensor_Name__c:'Not Provided') + '\n Date Assigned :';
				      }                                                  
				      if (Ss.Date_Assigned__c != null){
					      processedInvestigation[0].Legacy_Staff_Info__c += Ss.Date_Assigned__c+'\n Role : '+(Ss.Role__c != null? Ss.Role__c:'Not Provided');
				       } 
					    else{
					      processedInvestigation[0].Legacy_Staff_Info__c += 'not provided'+'\n Role : '+(Ss.Role__c != null? Ss.Role__c:'Not Provided'); 
					    }
				      processedInvestigation[0].Legacy_Staff_Info__c += (Ss.Active__c != '1'? ' And is not active' : '');
			      }
			      system.debug('Investigation Being Updated'+processedInvestigation[0].id+'..Staff id'+LEADUserId+'..'+Ss.id+dupRule);
				  update processedInvestigation[0];
				  Ss.Staff_Processed__c = true;
			}			  	
			else{
			  Ss.Error_Text__c = 'Matching record \' '+Ss.Intake_Id__c+'|'+ Ss.Program_Id__c+'\' '+ 'not found in LEAD';
			}
		}
		catch(Exception e){
			system.debug('******** Error occured Updating Staff on Investigation*******'+ e.getMessage());			
			Ss.Error_Text__c = e.getMessage();
		}
	
	}
	
	public static void processLegacyIntervention(Historical_Intervention_Staging__c Is){
	  
		try{
			//Duplicate Algorithm : Intake ID + ProgramId is considered as duplicate
			string dupRule = Is.Duplicate_Rule__c;
			string InterventionType	= Is.Intervention_Code__c;
			if(Is.Intervention_Code__c == 'Documentation Review'){
			 InterventionType = 'Document Review';
			}	
	
			List<Investigation__c> processedInvestigation = [Select Id, Duplicate_Rule__c From Investigation__c Where Duplicate_Rule__c = :dupRule limit 1];
			
			if (processedInvestigation.size() > 0){	
				if (!string.isBlank(Is.Intervention_Type__c)){			
					Intervention__c intvn = new Intervention__c();
					intvn.Investigation__c = processedInvestigation[0].Id;
					intvn.Intervention_Type__c = [select id,name from Intervention_Type__c where name =: InterventionType].id;
					intvn.RecordTypeId = [Select Id from RecordType where sObjectType='Intervention__c' and name like 'Other Intervention'].Id;
					intvn.Date_Completed__c = Is.Date_Completed__c;
					intvn.Status__c = 'Done';
					intvn.Additional_Description__c = 'This is a Legacy Intervention with Intervention Type '+ Is.Intervention_Type__c;
					
					insert intvn;
					Is.Intervention_Processed__c = true;
				}
			}
			else{
			    Is.Error_Text__c = 'Matching record \' '+Is.Intake_Id__c+'|'+ Is.Program_Id__c+'\' '+ 'not found in LEAD';
			}			
		}
		catch(Exception e){
			system.debug('******** Error occured Creating Intervention on Investigation*******'+ e.getMessage());			
			Is.Error_Text__c = e.getMessage();
		}
		
	
	}
	
	public static void processLegacyFollow(Historical_Follow_Staging__c Hf){
	
	try{
			//Duplicate Algorithm : Intake ID + ProgramId is considered as duplicate
			string dupRule = Hf.Duplicate_Rule__c;		
	
			List<Investigation__c> processedInvestigation = [Select Id, Duplicate_Rule__c,Legacy_IntakeID__c From Investigation__c Where Duplicate_Rule__c = :dupRule limit 1];
			List<User> Licensor = [Select Id,Name From User Where Historic_Licensor_No__c = :Hf.Licensor__c limit 1];
			Id LEADUserId = [Select Id, Name From User Where Name = 'LEAD System_Batch_User'].Id;
			
			if (processedInvestigation.size() > 0){	
				Task Tsk = new Task();
				Tsk.WhatId = processedInvestigation[0].id;
				Tsk.RecordTypeId = [Select Id from RecordType where sObjectType='Task' and name like 'Investigation Follow-Up Actions'].Id;
				tsk.Status = 'Completed';
                tsk.Priority = 'Normal';
                tsk.ActivityDate = Hf.Due_Date__c;
                tsk.Subject = 'Legacy Investigation Follow-Up Action';
                tsk.Description = (Hf.Description__c != null?Hf.Description__c:'') + '\n'+'Additional Data :\n' +'Refer To Legal date :';
                if (Hf.Refer_to_Legal_Date__c != null){
				    tsk.Description += Hf.Refer_to_Legal_Date__c+'\n Legal Issue Date :';
			    } 
				else{
				   tsk.Description += 'not provided'+'\n Legal Issue Date :'; 
				}
				if (Hf.Legal_Issue_Date__c != null){
				    tsk.Description += Hf.Legal_Issue_Date__c+'\n Modification Date :';
			    } 
				else{
				   tsk.Description += 'not provided'+'\n Modification Date :'; 
				}
				if (Hf.Modification_Date__c != null){
				    tsk.Description += Hf.Modification_Date__c+'\n Follow Up Code :';
			    } 
				else{
				   tsk.Description += 'not provided'+'\n Follow Up Code :'; 
				}
                tsk.Description += (Hf.FollowUp_Code__c != null?Hf.FollowUp_Code__c:'Not Provided') + '\n Follow Up Id : '+(Hf.FollowUp_Id__c != null?Hf.FollowUp_Id__c:'Not Provided') +'\n Completed Date :';
                if (Hf.Completed_Date__c != null){
				    tsk.Description += Hf.Completed_Date__c;
			    } 
				else{
				   tsk.Description += 'not provided'; 
				}
                
                if (Licensor.size() > 0){
			     tsk.Ownerid = Licensor[0].Id;
			    }
			       else{
			     tsk.OwnerId = LEADUserId;
			     tsk.Description += '\n'+'Legacy Follow:- Licensor Id :' + Hf.Licensor__c + '\n Licensor Name :' + Hf.Licensor_Name__c;
			    }
                 system.debug('Investigation Being Updated'+processedInvestigation[0].id+processedInvestigation[0].Legacy_IntakeID__c+Hf.id+dupRule);
                insert tsk;
                Hf.Follow_Processed__c = true;
			}else{
			    Hf.Error_Text__c = 'Matching record \' '+Hf.Intake_Id__c+'|'+ Hf.Program_Id__c+'\' '+ 'not found in LEAD';
			}			
		}
		catch(Exception e){
			system.debug('******** Error occured Creating FollowUp on Investigation*******'+ e.getMessage());			
			Hf.Error_Text__c = e.getMessage();
		}
		
	}
    
}