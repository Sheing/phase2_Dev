public class EEC_LookupController {

  public String sObjectName { get; set; }
  public string recordTypeName {get; set;}
  public String queryStr { get; set; }
  public string lookupName {get; set;}
  public String errorMessage { get; set; }
  public List<SObject> queryResults { get; set; }
  public List<String> fieldNamesForObject { get; set; }
  public Map<String, Map<String, String>> fileNamesForObjectFormatted { get; set; }
  public Map<String, Map<String, Map<String, String>>> sObjectFieldUtilMap { get; set; }
  public string searchMessage {get;set;}
  public boolean isSOSLQuery {get;set;}

  private EEC_Lookup_Params__c lookupConfig { get; set; }
  private List<String> dateSObjectFields { get; set; }

  public EEC_LookupController() {
    sObjectName = ApexPages.currentPage().getParameters().get('sobject');
    recordTypeName = ApexPages.currentPage().getParameters().get('rtype');
    lookupName = sObjectName.replace('__c', '');
    
    system.debug('****sObjectName*****'+sObjectName);
    
    system.debug('**********LicenseRecordTypeName*********'+recordTypeName);
    
    if (sObjectName.contains('Assistant')){
    	searchMessage = 'Please search by Assistant Name OR Certificate Number OR City';
    }
    else if (sObjectName.contains('Regulation')){
    	searchMessage = 'Please search by Regulation or Article';
    }
    else{
    	searchMessage = 'Please search by Name';
    }
    queryResults = new List<SObject>();
    dateSObjectFields = new List<String>();
    fileNamesForObjectFormatted = new Map<String, Map<String, String>> ();
    sObjectFieldUtilMap = new Map<String, Map<String, Map<String, String>>> ();

    //lookupConfig = EEC_Lookup_Params__c.getValues(sObjectName);
     lookupConfig = EEC_Lookup_Params__c.getInstance(sObjectName);
    System.debug('----> Lookup Config: ' + lookupConfig);
    // Create a formatted name list of the query fields to show on the page.
    if (lookupConfig != null && String.isNotBlank(lookupConfig.Query_Fields__c)) {
      fieldNamesForObject = lookupConfig.Query_Fields__c.split(',');
      List<String> fieldNameCustomLabels = (String.isNotBlank(lookupConfig.Query_Field_Labels__c) ? lookupConfig.Query_Field_Labels__c.split(',') : new List<String> ());
		
      //String name : fieldNamesForObject
      for (Integer i = 0; i < fieldNamesForObject.size(); i++) {
        String name = fieldNamesForObject.get(i);
        String formattedDefaultName = name;

        formattedDefaultName = formattedDefaultName.replaceAll('_c', '');
        formattedDefaultName = formattedDefaultName.replaceAll('_', ' ');
        formattedDefaultName = formattedDefaultName.replaceAll('r\\.', '');

        if (name.containsIgnoreCase('Date')) {
          dateSObjectFields.add(name);
        }
		
        String customLabel = ((fieldNameCustomLabels.size() > 0 && i <= fieldNameCustomLabels.size() - 1) ? fieldNameCustomLabels.get(i) : 'null');
        fileNamesForObjectFormatted.put(name, new Map<String, String> { 'Default' => formattedDefaultName, 'Custom' => customLabel });
      }
    }
    system.debug('fileNamesForObjectFormatted: ' + fileNamesForObjectFormatted);
  }

  /**
   * query
   *
   * @description This function will query the Sforce objects using the passed in params. 
   * @author Darkis
   * @created ?
   * @modified 27 Jan 2016
   * @return PageReference 
   */
  public PageReference query() {
    try {
      errorMessage = '';
      queryResults = new List<SObject> ();

      if (String.isBlank(queryStr)) {
        errorMessage = 'You cannot have an empty search. Please enter your query into the search text field.';
        return null;
      }

      String likeQueryCommand = '(';
      // Ensure that the like conditions and like conditional operator are present. 
      if (lookupConfig != null && String.isNotBlank(lookupConfig.Like_Conditions__c) && String.isNotBlank(lookupConfig.Like_Conditional_Operator__c)) {
        List<String> likeFields = lookupConfig.Like_Conditions__c.split(',');
        // Loop through conditional and create a query command. 
        for (Integer i = 0; i < likeFields.size(); i++) {
          likeQueryCommand += likeFields[i] + ' Like \'%' + queryStr + '%\' ';
          // If we are not on the last entry then add the conditional operator.
          // TODO: Make this allow multiple types of operators rather than just one. 
          if ((i + 1) != likeFields.size()) {
            likeQueryCommand += lookupConfig.Like_Conditional_Operator__c + ' ';
          }
        }
      }
      
      //Mod by Latha on 1/20/17
      //SOQL search results
      if (!lookupConfig.isSOSL__c){
	      // Begin building the query.
	      String query = 'Select ' + (lookupConfig != null && String.isNotBlank(lookupConfig.Query_Fields__c) ? (lookupConfig.Query_Fields__c) : '');
	      query += ' From ' + sObjectName;
	      query += ' Where ' + likeQueryCommand + ')';
	      if (lookupConfig != null && String.isNotBlank(lookupConfig.Where_Conditions__c)) {
	        query += ' AND ' + lookupConfig.Where_Conditions__c;
	      }
	      if (sObjectName.contains('Regulation')){
	      	query += ' AND Active__c = true';
	      }
	      query += (lookupConfig != null && String.isNotBlank(lookupConfig.Order_Conditions__c) ? (' ORDER BY ' + lookupConfig.Order_Conditions__c) : '');
	      query += ' LIMIT 10000';
	      System.debug('----> Query: ' + query);
	      queryResults = Database.query(query);
      }
      //SOSL query search results
	  else {	  	
        if(queryStr.length() > 1){
           string searchStr1 = '*'+queryStr+'*';
		   string searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING  ' + sObjectName + '(' + lookupConfig.Query_Fields__c + ' ';
		   if (sObjectName.contains('Regulation')){
			   //GSA
			   if(recordTypeName.contains('GSA')){
			      searchQuery+= 'Where Applicable_To__c IN (\'Large Group\',\'Small Group\') and Active__c = true)';
			   }
			   //FCC 
			   else if (recordTypeName.contains('FCC') || recordTypeName.contains('Change_of_Address')) {
			     searchQuery+= 'Where Applicable_To__c IN (\'Family Child Care\') and Active__c = true)';
			   }
			   //R&P
			   else if (recordTypeName.contains('Placement') || recordTypeName.contains('Residential') || recordTypeName.contains('R_P')) {
			     searchQuery+= 'Where Applicable_To__c IN (\'Foster Care Agency\',\'Adoption Agency\') and Active__c = true)';
			   }
			   else {
			   	  searchQuery+= ' WHERE Active__c = true)';
			   }
		    }
		   else {
				//searchQuery+= ' WHERE Active__c = true)';
			}
		   searchQuery += ' LIMIT 2000';
		   system.debug('searchQuery---->>>'+searchQuery);
		   List<List <SObject>> searchList = search.query(searchQuery);
		   queryResults = ((List<SObject>)searchList[0]);
	 	 }
	  }
       
      system.debug('*****queryResults *****'+queryResults);
      // Loop through the result set.
      for (sObject obj : queryResults) {
        // Get the objects schema.
        Schema.DescribeSObjectResult r = (Schema.getGlobalDescribe().get(sObjectName)).getDescribe();
        // Loop througbh the field names of the object presented in the configuration.
        for (String fieldName : fieldNamesForObject) {
          Schema.DescribeFieldResult f;
          String type = 'UNKNOWN';
          // Check if the fieldname is in the mapping.
          if (r.fields.getMap().get(fieldName) != null) {
            f = r.fields.getMap().get(fieldName).getDescribe();
            type = (f != null ? String.valueOf(f.getType()) : 'UNKNOWN');
          }
          // If the object key already exists then simply add to the map otherwise create it new. 
          // When adding to the map add the primiative data type for the field. If no type is available due to it being a relation then say 'UNKNOWN'.
          if (sObjectFieldUtilMap.containsKey(obj.Id)) {
            (sObjectFieldUtilMap.get(obj.Id)).put(fieldName, new Map<String,String>{'Data_Type' => type});
          } else {
            sObjectFieldUtilMap.put(obj.Id, 
              new Map<String, Map<String,String>>{
                fieldName => new Map<String,String>{'Data_Type' => type}
              }
            );
          }
        }
        // If there are date sObject fields then loop through them.
        if (dateSObjectFields != null && dateSObjectFields.size() > 0) {
          for (String dateFieldName : dateSObjectFields) {
            // Attempt to convery the sObjects date field into a Date Object.
            Date tempDatetime = (Date) obj.get(dateFieldName);
            // Place into the util map the formatted date if applicable or a null string. 
            sObjectFieldUtilMap.get(obj.Id).get(dateFieldName).put('Formatted_Date', (tempDatetime != null ? tempDatetime.format() : 'null'));
          }
        }
      }
	  system.debug('sObjectFieldUtilMap: ' + sObjectFieldUtilMap);
      if (queryResults.size() == 0) {
        errorMessage = 'No results found.';
      }
    } catch(Exception e) {
      
      System.debug('Error: ' + e.getMessage());
      errorMessage = 'An error has occured attempting to get your results. Please try again later.';
    }
    return null;
  }
}