//Author: Latha Davuluri
public with sharing class EEC_ProcessLegacyCaseData {
	
	//Method to Process Legacy Cases : LEAD-4375
	public static void processLegacyCases(Historical_Cases_Staging__c cs){
	   try{
		    Id LegacyRecordTypeId = [Select Id From RecordType Where sobjectType='Case' and name like 'Legacy Case%'].Id;
			Id ProgramId = [Select Id,Name, Provider_No__c From Account Where Provider_No__c = :cs.Program_ID__c].Id;
			List<Contact> contactId = [Select Id,Name From Contact Where EEC_Legacy_Contact_ID__c = :cs.Reporter_ID__c limit 1];
			List<User> caseOwner = [Select Id,Name From User Where Historic_Licensor_No__c = :cs.Case_Owner__c and isActive = true limit 1];
			List<Investigation__c> InvestigationList = [Select Id From Investigation__c Where Legacy_IntakeID__c = :cs.Intake_ID__c limit 1];
			string reporterSummary = '';
			string defaultDate = '1/1/2016';
			date legacyDateCheckPoint = date.parse(defaultDate);
			//Duplicate Algorithm : Intake ID + ProgramId is considered as duplicate
			
			string dupRule1 = cs.Duplicate_Rule_1__c;
	
			List<Case> processedCase = [Select Id From Case Where Duplicate_Rule_1__c = :dupRule1 limit 1];
			
			system.debug('processedCase*******'+processedCase);
			//check for duplicates and insert only if no duplicates found
			if (processedCase.size() <= 0){
				Case lc = new Case();
				 
				lc.RecordTypeId = LegacyRecordTypeId;
				lc.AccountId = ProgramId;
				lc.Date_Closed__c = cs.Date_Closed__c;
				lc.ClosedOnCreate__c = lc.Date_Closed__c != null ? true : false;
				lc.Date_Event_Occured__c = cs.Date_Event_Occurred__c;
				lc.DCF_File_Submission_Date__c = cs.DCF_File_Submission_Date__c;
				lc.DCF_Filer__c = cs.DCF_File_Submitter__c;
				lc.Description = cs.Additional_Description__c;
				lc.Filed_with_DCF__c = cs.Filed_with_DCF__c;
				if (InvestigationList.size()>0)
				    lc.Investigation__c = InvestigationList[0].Id;
				lc.status = 'Closed';
				lc.Nature_of_complaint__c = cs.Nature_of_complaint__c + ':' + cs.Nature_of_complaint_Description__c;				
				lc.Origin = cs.Intake_Method__c;
				lc.Intake_Category__c = cs.Nature_of_complaint_Description__c;
				lc.Priority = cs.Nature_of_complaint_Description__c;
				lc.Relationship_to_provider__c = cs.Reporter_Relationship_To_Provider__c;
				if (!string.isBlank(cs.Summary_Type_of_case__c)){
					if (cs.Summary_Type_of_case__c == 'C'){
					   lc.Subject = 'C - Complaint';
					   lc.Legacy_Case_Type__c = 'C - Complaint';
					}
					else{
						lc.Subject = 'I - Incident';
						lc.Legacy_Case_Type__c = 'I - Incident';
					}
				}
				else{
				    lc.Subject = cs.Intake_ID__c;
				}
				
				//Case Owner
				if(caseOwner.size()>0){
					lc.OwnerId = caseOwner[0].id;
				}
				else{
					lc.Legacy_Case_Owner__c = cs.Case_Owner__c + ':-' + (cs.Case_Owner_Name__c != null ? cs.Case_Owner_Name__c : 'not provided');
				}

				lc.Legacy_Case_Id__c = cs.Intake_ID__c;
				lc.Legacy_Case_Opened_Date__c = cs.Date_Opened__c;
   		        lc.Legacy_Complaint_Disposition__c = cs.Complaint_Disposition__c + ' | Legacy Case Status: ' + (cs.Status__c != null ? cs.Status__c : 'not provided');
	
				
				/*
				if (ContactId.size() >0){
				   lc.ContactId = ContactId[0].Id;
				}
				else{
					//Legacy Contact
					if (cs.Reporter_Anonymous__c == 'Y' && cs.Reporter_Data_Entry__c > = legacyDateCheckPoint){
						Contact legacyContact = new Contact();
						legacyContact.firstName = cs.Reporter_First_Name__c;
						legacyContact.lastName = cs.Reporter_Last_Name__c;
						legacyContact.Phone = cs.Reporter_Work_Phone__c;
						legacyContact.AccountId = ProgramId;
						legacyContact.MailingStreet = cs.Reporter_Street__c;
						legacyContact.mailingCity = cs.Reporter_City__c;
						legacyContact.MailingState = cs.Reporter_State__c;
						legacyContact.MailingPostalCode = cs.Reporter_ZipCode__c;	
						
						insert legacyContact;
						
						lc.ContactId = legacyContact.Id;					
					}
				}
				*/
				reporterSummary = 'Reporter Information: \n Name: '+ (cs.Reporter_First_Name__c != null ? cs.Reporter_First_Name__c : '') + ' ' + (cs.Reporter_Last_Name__c != null ? cs.Reporter_Last_Name__c : 'not provided') +'.';
				reporterSummary += '\n Data Entry Date: ';
				if (cs.Reporter_Data_Entry__c != null){
				    reporterSummary += cs.Reporter_Data_Entry__c;
			    } 
				else{
				   reporterSummary += 'not provided'; 
				}
				reporterSummary += '.';
				reporterSummary += '\n Reporter Id: ' + (cs.Reporter_ID__c != null ? cs.Reporter_ID__c : 'not provided') + '.';
				reporterSummary += '\n Address: ' + (cs.Reporter_Street__c != null ? cs.Reporter_Street__c : 'not provided.') + ', ' + (cs.Reporter_City__c != null ? cs.Reporter_City__c : '') + ', ' + (cs.Reporter_State__c != null ? cs.Reporter_State__c : '') + ' ' + (cs.Reporter_ZipCode__c != null ? cs.Reporter_ZipCode__c : '') + '.';
				reporterSummary += '\n Home phone: ' + (cs.Reporter_Home_Phone__c != null ? cs.Reporter_Home_Phone__c : 'not provided') + '.';
				reporterSummary += '\n Work phone: ' + (cs.Reporter_Work_Phone__c != null ? cs.Reporter_Work_Phone__c : 'not provided') + '.';
				
				lc.Legacy_Reporter_Summary__c = reporterSummary;
		
				
				lc.Duplicate_Rule_1__c = cs.Duplicate_Rule_1__c;

	            // create Case;            
			    insert lc;
				//create caseAllegation
				createCaseAllegation(lc,cs);			
			}
			else{
				//create caseAllegation
				createCaseAllegation(processedCase[0],cs);				
			}
			cs.Case_Processed__c = true;
		}
		catch(Exception e){			
			if (e.getMessage().contains('List has no rows for assignment to SObject')){
			    cs.ErrorText__c = 'Provider not found in LEAD';
			}
			else{
				system.debug('******** Error occured creating Legacy Case, Allegation and Case Allegation *******'+ e.getMessage());
				cs.ErrorText__c = e.getMessage();
			}
		}
		
	}
	
	
	
	private static void createCaseAllegation(Case c,Historical_Cases_Staging__c cs){
			List<Allegation__c> a = [Select Id From Allegation__c Where name = :cs.Allegation_Code__c limit 1];			
			if (a.size() > 0){
				//check if Case Allegation already exists on the Case - so no duplicates are created
				List<Cases_Allegations__c> caseAllegationFound = [Select Id From Cases_Allegations__c Where Case__c = :c.Id and Allegation__c = :a[0].Id];
				if (caseAllegationFound.size() <= 0){
					Cases_Allegations__c ca = new Cases_Allegations__c();
					ca.Case__c = c.Id;
					ca.Allegation__c = a[0].Id;
		            ca.Comments__c = 'Legacy Description -'+cs.Allegation_Description__c;
					insert ca;
				}
			}
	}
	
	public static void processLegacyUnlicensdProviders(Historical_Unlicen_Providers_Staging__c ps){	
		try{
			string providerCity = '%' + ps.Unlicensed_City__c + '%';
		    Id UnlicensedProvId = [Select Id From RecordType Where sobjectType='Account' and name = 'Unlicensed Provider'].Id;
		    List<User> Licensor = [Select Id,Name From User Where Historic_Licensor_No__c = :ps.Unlicensed_Licensor__c limit 1];
			Id LEADUserId = [Select Id, Name From User Where Name = 'LEAD System_Batch_User'].Id;
			List<City__c> city = [Select Id,Name From City__c Where Name like :providerCity];
			
			
			Account a = new Account();
			a.RecordTypeId = UnlicensedProvId;
			a.Name = ps.Unlicensed_Name__c;
			a.Provider_Address_1__c = ps.Unlicensed_Address1__c;
			if (city.size() > 0){
			    a.Provider_City__c = city[0].Id;
			}
			a.State__c = 'MA';
			a.Provider_Zip_Code__c = ps.Unlicensed_ZipCode__c;
			a.Phone = ps.Unlicensed_Phone__c;
			a.Provider_No__c = ps.Unlicensed_ID__c;
			
			if (Licensor.size() > 0){
			    a.OwnerId = Licensor[0].Id;
			}
			else{
			    a.OwnerId = LEADUserId;
			    a.Description = 'Legacy Provider:- Licensor Id :' + ps.Unlicensed_Licensor__c + ' | Licensor Name :' + ps.Unlicensed_Licensor_Name__c;
			}
			
			insert a;
			
			ps.Provider_Processed__c = true;
			
		}
		catch(Exception e){
			if (e.getMessage().contains('List has no rows for assignment to SObject')){
			    ps.ErrorText__c = 'Provider not found in LEAD';
			}
			else{
				system.debug('******** Error occured creating Unlicensed Provider *******'+ e.getMessage());	
				ps.ErrorText__c = e.getMessage();
			}
		}
		
	}
	
	public static void processLegacyIntakeNotes(Historical_Intake_Notes_Staging__c ns){
		try{
			//Duplicate Algorithm : Intake ID + ProgramId is considered as duplicate
			string dupRule1 = ns.Duplicate_Rule_1__c;		
	
			List<Case> processedCase = [Select Id, Intake_Notes__c From Case Where Duplicate_Rule_1__c = :dupRule1 and recordType.Name = 'Legacy Case' limit 1];
			
			if (processedCase.size() > 0){				
				if (string.isBlank(processedCase[0].Intake_Notes__c)){
				    processedCase[0].Intake_Notes__c = 'Notes Date: ' + ns.Notes_Date__c;
				}
				else{
				  processedCase[0].Intake_Notes__c += '\n Notes Date: ' + ns.Notes_Date__c;
				}
				processedCase[0].Intake_Notes__c +=  '| Submitted By: ' + ns.Notes_CreatedBy__c;
				processedCase[0].Intake_Notes__c += ' | Notes: ' + ns.Notes__c;
				
				update processedCase[0];
				
				ns.Notes_Processed__c = true;
			}			
		}
		catch(Exception e){
			system.debug('******** Error occured updating Intake Notes on Case*******'+ e.getMessage());			
			ns.ErrorText__c = e.getMessage();
		}
		
	}
	
}