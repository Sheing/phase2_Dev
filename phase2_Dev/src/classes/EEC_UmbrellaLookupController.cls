public without sharing class EEC_UmbrellaLookupController {
    
  public String umbrellaName { get; set; }
  public String cityName{get;set;}
  public String errorMessage { get; set; }
  public String umbrellaId {get; set;}
  public List<Account> queryResults { get; set; }
  public  String licenseTransationId {get;set;} 
  public Licensing_Transaction__c licensingTransaction{get;set;}
  public boolean isNewUmbrella{get;set;}
  
  public EEC_UmbrellaLookupController() {
  	isNewUmbrella = false;
    licenseTransationId  = ApexPages.currentPage().getParameters().get('licenseTransationId');
    queryResults = new List<Account>();
    licensingTransaction = [select Id, Name,
    New_Umbrella_Name__c,
New_Umbrella_Business_Name__c,
NewUmbrella_Place_of_Incorporation__c,
NewUmbrella_Date_of_Incorporation__c,
NewUmbrella_Street_Address_1__c,
NewUmbrella_Street_Address_2__c,
NewUmbrella_State__c,
NewUmbrella_City__c,
NewUmbrella_Zip_Code__c,
NewUmbrella_Phone__c,
NewUmbrella_Alternate_Phone__c,
NewUmbrella_Fax__c,
NewUmbrella_Email__c,
NewUmbrella_Director_First_Name__c,
NewUmbrella_Director_Last_Name__c,
NewUmbrella_Director_Title__c,
NewUmbrella_Director_Phone__c,
NewUmbrella_Director_Email__c from Licensing_Transaction__c where Id=: licenseTransationId];
 }
    
  public PageReference query() {
  	try{
		queryResults = new List<Account>();
      	errorMessage = '';
        
        if (String.isBlank(umbrellaName) && String.isBlank(cityName)) {
        	errorMessage = 'Enter at least one criteria before you start your search';
            return null;
		}
        if (!String.isBlank(umbrellaName)) {
	       umbrellaName = '%'+umbrellaName+'%';
        }
        if (!String.isBlank(cityName)) {
           cityName = '%'+cityName+'%';
        }
        queryResults = [select Id, Name, Provider_Address_1__c, Provider_city_text__c, Provider_Zip_Code__c , State__c
              				from Account where RecordType.Name = 'Umbrella' and (Name like : umbrellaName or Provider_City__r.Name like : cityName)];
        if (queryResults.size() == 0) {
            errorMessage = 'Based on these criteria, no Umbrella were found. Please review your search criteria.';
        }
	} catch(Exception e) {
    	System.debug('Error: ' + e.getMessage());
        errorMessage = 'An error has occured attempting to get your results. Please try again.';
    }
    return null;
  }
  
  public PageReference addUmbrella(){
  	try{  		
        licensingTransaction = EEC_ContactRoleUtil.updateLicensingTransaction(licensingTransaction);
  	}
  	 catch(Exception e) {
    	System.debug('Error: ' + e.getMessage());
        errorMessage = 'An error has occured attempting to save new umbrella. Please try again later.';
    }
    return null;
  }
}