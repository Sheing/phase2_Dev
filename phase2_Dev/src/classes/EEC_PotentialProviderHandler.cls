public class EEC_PotentialProviderHandler {
    public static void doAfterUpdate(List<Lead> listLead){    	
    	Map<Id, Id> mapParentLead = new Map<Id, Id>();
    	for(Lead lead : listLead){
    		mapParentLead.put(lead.Id, lead.ConvertedAccountId);
    	}
    	
        List<Lead> listChildLeads = [select Id,FirstName,LastName,Parent_GSA_Potential_Provider__c from Lead where Parent_GSA_Potential_Provider__c in : listLead];
        
        Map<Id, Id> mapChildAccount = new Map<Id, Id>();
        
        for(Lead childLead : listChildLeads){
        	mapChildAccount.put(childLead.Id, mapParentLead.get(childLead.Parent_GSA_Potential_Provider__c));
        }
        
        List<Contact> listContact = new List<Contact>();        
        List<Contact_Role__c> listContactRole = new List<Contact_Role__c>();
        for(Lead lead : listChildLeads){
            Contact contact = new Contact();
            contact.FirstName = lead.FirstName;
            contact.LastName = lead.LastName;
            contact.AccountId = mapChildAccount.get(lead.Id);
            listContact.add(contact);
        }
        
        if(listContact.size() > 0){
            insert listContact;
        }
        
        for(Contact contact : listContact){
            Contact_Role__c contactRole = new Contact_Role__c();
            contactRole.Role__c = 'Other Contact';
            contactRole.Start_Date__c = date.today();
            contactRole.Provider__c = contact.AccountId;
            contactRole.Contact__c = contact.Id;
            listContactRole.add(contactRole);
        }
        
        if(listContactRole.size() > 0){
            insert listContactRole;
        }
    }
}