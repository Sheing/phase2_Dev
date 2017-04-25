public without sharing class EEC_ContactRoleUtil{

    public static list<Contact> insertContact(list<Contact> contactListtoInsert){
        insert contactListtoInsert;
        return contactListtoInsert;
    }
    
    public static list<Contact> updateContact(list<Contact> contactListtoUpdate){
        update contactListtoUpdate;
        return contactListtoUpdate;
    }
    public static list<Contact_Role__c> upsertContactRole(list<Contact_Role__c> listContactRole){
        upsert listContactRole;
        return listContactRole;
    }
    public static void deleteContactRole(list<Contact_Role__c> listContactRole){
        delete listContactRole;
    }
    public static void  upsertTransactionDocument(List<Transaction_Document__c>  listdocs){
        upsert listdocs;
    }

    public static void deleteTransactionDocument(Transaction_Document__c tdocument){
        delete tdocument;
    }
    
    public static void deleteTransactionDocuments(List<Transaction_Document__c> listdocument){
        delete listdocument;
    }
    
    public static Licensing_Transaction__c updateLicensingTransaction(Licensing_Transaction__c licenseTransaction){
        update licenseTransaction;
        return licenseTransaction;
    }
}