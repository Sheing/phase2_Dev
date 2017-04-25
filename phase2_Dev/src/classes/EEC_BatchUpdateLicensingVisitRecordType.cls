global class EEC_BatchUpdateLicensingVisitRecordType implements Database.Batchable<sObject> {
	
	String query;
	
	global EEC_BatchUpdateLicensingVisitRecordType() {
		query = 'Select Id, Announced__c, Provider_Type__c from Inspection__c where RecordType.Name = \'Licensing Visits\' limit 100';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<Inspection__c> scope) {
		List<Inspection__c> toBeUpdated = new List<Inspection__c>();
		List<RecordType> licensingVisitRecordTypes = [SELECT Description, DeveloperName, Id, IsActive, Name, SobjectType
																							FROM RecordType
																							WHERE SobjectType = 'Inspection__c'];
		String fccVisitRecordType = '';
		String gsaVisitRecordType = '';
		String placementVisitRecordType = '';
		String residentialVisitRecordType = '';

		for (RecordType rt : licensingVisitRecordTypes){
			if (rt.Name.contains('FCC')){
				fccVisitRecordType = rt.Id;
			} else if (rt.Name.contains('GSA')){
				gsaVisitRecordType = rt.Id;
			} else if (rt.Name.contains('Residential')){
				residentialVisitRecordType = rt.Id;
			} else if (rt.Name.contains('Placement')){
				placementVisitRecordType = rt.Id;
			}
		}
		System.debug('----FCC RT: ' + fccVisitRecordType + ' - GSA RT: ' + gsaVisitRecordType + ' - Residential RT: ' + residentialVisitRecordType + ' - Placement RT: ' + placementVisitRecordType);
		for (Inspection__c i : scope){
			System.debug('-----> VisitToBeUpdate before: ' + i);
			if (i.Provider_Type__c == 'Family Child Care'){
				i.RecordTypeID = fccVisitRecordType;
			} else if (i.Provider_Type__c == 'Large Group' || i.Provider_Type__c == 'Small Group'){
				i.RecordTypeID = gsaVisitRecordType;
			} else if (i.Provider_Type__c == 'Group Care' || i.Provider_Type__c == 'Temporary Shelter'){
				i.RecordTypeID = residentialVisitRecordType;
			} else if (i.Provider_Type__c == 'Foster Care Agency' || i.Provider_Type__c == 'Adoption Agency'){
				i.RecordTypeID = placementVisitRecordType;
			} 
			if(i.Announced__c){
				i.Announcement_Type__c = 'Announced';
			} else {
				i.Announcement_Type__c = 'Unannounced';
			}
			System.debug('-----> VisitToBeUpdate: ' + i);
			toBeUpdated.add(i);
		}

		Update toBeUpdated;
	}
	
	global void finish(Database.BatchableContext BC) {
		Integer remainingVisits = [Select Count() from Inspection__c where RecordType.Name = 'Licensing Visits'];
		if(remainingVisits != null && remainingVisits > 0){
			EEC_BatchUpdateLicensingVisitRecordType visitBatch = new EEC_BatchUpdateLicensingVisitRecordType();
			String cronId = System.scheduleBatch(visitBatch, 'updateVisitRecordType', 1);
			System.debug(cronId);
		}
	}
}