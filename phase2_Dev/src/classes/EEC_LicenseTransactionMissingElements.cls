public with sharing class EEC_LicenseTransactionMissingElements {

    public Licensing_Transaction__c lt;
    public Boolean reload {get; set;}

    public EEC_LicenseTransactionMissingElements(ApexPages.StandardController sc) {
        this.reload = false;
        this.lt = (Licensing_Transaction__c)sc.getRecord();
        Long timeSinceLastUpdate;
        lt = [SELECT Id, Provider__c, Status__c
                    , MissingElementsUpdateNoDisplay__c, lastModifiedDate
                FROM Licensing_Transaction__c 
                WHERE Id = :lt.Id];
        if(lt.MissingElementsUpdateNoDisplay__c <> null ){
            timeSinceLastUpdate = Datetime.now().getTime() - lt.MissingElementsUpdateNoDisplay__c.getTime();
        }
        Boolean transactionUpdated = timeSinceLastUpdate > 5000 //This is to break page refresh loop
                                    || lt.MissingElementsUpdateNoDisplay__c == null
                                    || lt.lastModifiedDate.getTime() - lt.MissingElementsUpdateNoDisplay__c.getTime() > 5000;
        if(lt.Status__c != 'To Submit' && !lt.Status__c.contains('closed') && transactionUpdated){
            reload = true;
            lt.MissingElementsUpdateNoDisplay__c = Datetime.now();
        }
        
    }

    public void updateMissingElements(){
        if(reload){
            update lt;
        }
    }
}