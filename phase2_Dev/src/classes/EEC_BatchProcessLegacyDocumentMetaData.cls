global class EEC_BatchProcessLegacyDocumentMetaData implements Database.Batchable<sObject> {

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([SELECT Id, ProgramId__c, IntakeId__c, InteractionId__c, FileName__c
																			, MetaDataFileName__c, DocumentDate__c
																		FROM HistoricalDocumentStaging__c
																		WHERE isProcessed__c = false]);
	}

	global void execute(Database.BatchableContext BC, List<HistoricalDocumentStaging__c> scope) {
		for(HistoricalDocumentStaging__c hds : scope){
			processHistoricalDocument(hds);
		}
		update scope;
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}

	private void processHistoricalDocument(HistoricalDocumentStaging__c hds){
		S3_File__c s3File = new S3_File__c();
		String provId = '';
		String caseId = '';
		String visitId = '';
		String invId = '';
		try{
			provId = (String)[SELECT ID FROM Account WHERE Provider_No__c = :hds.ProgramId__c limit 1].Id;
			caseId = (String)[SELECT Id FROM Case WHERE Legacy_Case_Id__c = :hds.IntakeId__c limit 1].id;
			visitId = (String)[SELECT Id FROM Inspection__c WHERE Legacy_System_Interaction__c = :hds.InteractionId__c limit 1].id;
			invId = (String)[SELECT Id FROM Investigation__c 
											WHERE isLegacyInvestigation__c = true 
												AND Legacy_IntakeID__c = :hds.IntakeId__c limit 1].id;
		} catch(Exception e){
			System.debug('-------> Id Error: ' + e.getMessage());
		}
		if(provId == ''){
			hds.ErrorMessage__c = 'Provider not found.';
			return;
		} 
		try{
			//Start processing documents other than visit/inv reports
			if(!hds.Filename__c.contains('ReportImage')){
				if(caseId == ''){
					hds.ErrorMessage__c = 'No legacy case found with Intake Id provided.';
					return;
				} else {
					s3File.LegacyRecordId__c = caseId;
				}
			}
			//End processing documents other than visit/inv reports

			//Start processing Visit coverLetters
			if(hds.Filename__c.contains('coverletter')){
				if(visitId == ''){
					hds.ErrorMessage__c = 'No legacy visit found with Interaction Id provided.';
					return;
				} else {
					s3File.LegacyRecordId__c = visitId;
				}
			}
			//End processing Visit coverLetters

			//Start processing investigation reports
			if(hds.Filename__c.contains('invreport')){
				if(String.isBlank(hds.InteractionId__c) && invId == ''){
					hds.ErrorMessage__c = 'No legacy investigation found with Intake Id provided.';
					return;
				} else if(String.isNotBlank(hds.InteractionId__c) && visitId == ''){
					hds.ErrorMessage__c = 'No legacy visit found with Interaction Id provided.';
					return;
				} else {
					s3File.LegacyRecordId__c = String.isBlank(hds.InteractionId__c) && invId != '' ? invId : visitId;
				}

			}
			//End processing investigation reports

			s3File.Bucket__c = 'eec-lead-legacydocs';
			s3File.Filename__c = hds.FileName__c;
			hds.isProcessed__c = true;
			if(String.isNotBlank(s3File.LegacyRecordId__c)){
				insert s3File;
			}

		} catch(Exception e){
			System.debug('--------> Error Message: ' + e.getMessage());
			hds.ErrorMessage__c = e.getMessage();
		}
		
	}
	
}