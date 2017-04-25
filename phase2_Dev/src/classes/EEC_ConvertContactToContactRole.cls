//Author: Latha Davuluri
// Class used in EEC_Batch_ConvertContactToContactRole
// Story: LEAD-4721

public with sharing class EEC_ConvertContactToContactRole {
   
   //Method for Data conversion of Role on Contact to ContactRole - LEAD-4721
	public static void convertContactToContactRole(Contact c){
		
		boolean isGSA = false;
		boolean isRP = false;
		boolean isUmbrella = false;
		
		List<Contact_Role__c>  contactRolesToCreate = new List<Contact_Role__c>();
		
		Account a = [Select Id, Is_GSA__c, Is_R_P__c, RecordType.Name From Account Where id = :c.AccountId];
		
		if(a != null){
			if (a.Is_GSA__c)
			   isGSA = true;
			   
			if (a.Is_R_P__c)
			   isRP = true;
			   
			if(a.RecordType.Name == 'Umbrella')
			   isUmbrella = true;
		}
		
		//Data conversion of Role on Contact to ContactRole
		if (isGSA || isRP || isUmbrella){
			
			Contact_Role__c cr = new Contact_Role__c();
			cr.Contact__c = c.Id;
			cr.Provider__c = c.AccountId;
			
			//Role Mappings on Contact Role
			if (c.Role__c != null){
				if (c.Role__c.containsIgnoreCase('Designee'))
				    cr.Role__c = 'Administrative Designee';
			    else if (c.Role__c.containsIgnoreCase('Director') && isUmbrella) 
				    cr.Role__c = 'Executive Director';
				else if (c.Role__c.containsIgnoreCase('Director') && !isUmbrella) 
				    cr.Role__c = 'Program Director / Administrative Head';
				else if (c.Role__c.containsIgnoreCase('Main Contact') && !isUmbrella) 
				    cr.Role__c = 'Main Contact';
				else
				    cr.Role__c = c.Role__c;
			}
			else{
				cr.Role__c = 'Other Contact'; 
			}
			    
			contactRolesToCreate.add(cr);
			system.debug('**** ContactRole being Inserted ***'+ cr);
		}
		
		if(contactRolesToCreate.size() > 0){
			   insert contactRolesToCreate;
			   c.Role__c = null;
		}
	
     }
}