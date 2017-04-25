public abstract with sharing class EEC_GenerateInvestigationPDFBase {    

    private Investigation__c inv;

    public EEC_GenerateInvestigationPDFBase(ApexPages.StandardController ctr){
        inv = [
            SELECT Provider_No__c,Name, Provider_No__r.Name,
            (SELECT CaseNumber, CreatedDate FROM Cases__r),
            (SELECT ID FROM Inspections__r), 
            (SELECT ID FROM Non_Compliant_Item__r)
            FROM Investigation__c 
            WHERE Id = :ctr.getId()
        ]; 
    } 
    
    public class InvestigationVisitChecklistItemWrapper {
        public Inspection_Item__c inspectionItem { get; set; }
        public String standardRegulations { get; set; }
        public Non_Compliant__c nonCompliantItem { get; set; }
        
        public InvestigationVisitChecklistItemWrapper(Inspection_Item__c inspItem, Non_Compliant__c nc, String regs) {
            this.inspectionItem = inspItem;
            this.standardRegulations = regs;
            this.nonCompliantItem = nc;
        }
    } 
    
    private static Map<ID, Standard_Inspection_Item__c> standardInspectionItems = new Map<ID, Standard_Inspection_Item__c>([
            SELECT Id, (SELECT Regulation__r.Name, Regulation__r.Regulation_Number__c FROM Junction_InspRegs__r) 
            FROM Standard_Inspection_Item__c]);
    
    public Contact getDirectorContact() {
        Account acc = [select id,RecordTypeId,RecordType.Name from Account where id=:inv.Provider_No__c];
    if(acc.RecordType.Name == 'FCC Assistant'){
       List<Contact> acrs = [
            SELECT Salutation, FirstName, LastName 
            FROM Contact 
            WHERE AccountID = :inv.Provider_No__c AND Role__c = 'Director' 
            ORDER BY CreatedDate DESC 
            LIMIT 1
        ];
        
        if(acrs.size() > 0) {
            return acrs.get(0);
        }
        else{
          List<Contact> acrs1 = [
            SELECT Salutation, FirstName, Contact.LastName 
            FROM Contact 
            WHERE AccountID = :inv.Provider_No__c AND Role__c like 'Main Contact%' 
            ORDER BY CreatedDate DESC 
            LIMIT 1];
            if(acrs1.size() > 0) {
              return acrs1.get(0);
            }
        }
    }else{
       List<Contact_Role__c> acrs = [
            SELECT Contact__c FROM Contact_Role__c 
            WHERE Provider__c = :inv.Provider_No__c AND Role__c = 'Executive Director' AND Current_Formula__c =true
            ORDER BY CreatedDate DESC 
            LIMIT 1
        ];
        if(acrs.size()>0){
        List<Contact> acrs1 = [SELECT Salutation, FirstName, Contact.LastName 
                FROM Contact 
                WHERE ID =: acrs[0].Contact__c
                ORDER BY CreatedDate DESC 
                LIMIT 1];
                
        if(acrs1.size() > 0) {
            return acrs1.get(0);
        }
        else{
          List<Contact_Role__c> conRList = [
            SELECT Contact__c FROM Contact_Role__c  
            WHERE Provider__c = :inv.Provider_No__c AND Role__c like 'Main Contact%' 
            ORDER BY CreatedDate DESC 
            LIMIT 1];
            
             List<Contact> contactList = [SELECT Salutation, FirstName, Contact.LastName 
                FROM Contact 
                WHERE ID =: conRList[0].Contact__c
                ORDER BY CreatedDate DESC 
                LIMIT 1];
                
                if(contactList.size() > 0) {
                  return contactList.get(0);
                }
            }
        }
    }
        
        return null;
    }
    
 
    public Datetime getOldestCaseDate(){
        Datetime d = null;
         
        for(Case c : inv.Cases__r){  
            if(d == null){
                d = c.CreatedDate;
            }
        
            if(d > c.CreatedDate){
                d = c.CreatedDate;
            }
        
        } 
        
        return d;
    }
 
    public String getCaseNumbers(){
        String ret = '';
         
        for(Case c : inv.Cases__r){
            System.debug(c);
        
            if(ret != ''){
                ret += ', ';
            }
            
            ret += c.CaseNumber;
        } 
        
        return ret;
    }
    
       public string getProviderName(){
        String ret = '';
        
        if(inv.Provider_No__r.Name.indexOf(',') > -1){
        	String[] rets = inv.Provider_No__r.Name.split(',');
            ret = rets[1] + ' ' + rets[0];
        }
        else 
            ret = inv.Provider_No__r.Name;
        
        return ret;
    }
    
    public String getInvestigationNumber(){
        String ret = '';
        
        String[] rets = inv.Name.split('#');
        if(rets.size() > 0)
        	ret = rets[1];
        
        return ret;
    }
    
    
    public List<InvestigationVisitChecklistItemWrapper> getOustandingComplianceIssues(){
        List<InvestigationVisitChecklistItemWrapper> items = new List<InvestigationVisitChecklistItemWrapper>();
        
        items.addAll(getInspecitonItems());
        items.addAll(getNonCompliantItems());
        
        return items;
    }
    
    public List<InvestigationVisitChecklistItemWrapper> getInspecitonItems(){ 
        List<InvestigationVisitChecklistItemWrapper> items = new List<InvestigationVisitChecklistItemWrapper>();
        Set<ID> inspIds = new Set<ID>(); 
        
        for(Inspection__c i : inv.Inspections__r){
            inspIds.add(i.Id);
        }
        
        List<Inspection__c> is = [
            SELECT (SELECT 
                Standard_Inspection_Item__c, 
                Associated_regulation__r.Name, 
                Associated_regulation__r.Regulation_Number__c, 
                Inspection_Item_Name__c, Date_Implemented__c, 
                Additional_Inspection_Item_Name__c, ID,
                Observations__c, Correction_Plan__c 
                FROM Inspection_Items__r
                WHERE Inspection_Result__c = 'Non-Compliant')
            FROM Inspection__c
            WHERE ID IN :inspIds
        ];
         
        
        for(Inspection__c i : is) {
            for(Inspection_Item__c row : i.Inspection_Items__r ){ 
                String regs = '';
                
                if(row.Standard_Inspection_Item__c != null){
                    Standard_Inspection_Item__c sii = standardInspectionItems.get(row.Standard_Inspection_Item__c); 
                        
                    for(Junction_InspReg__c jir : sii.Junction_InspRegs__r){
                        if(regs != ''){
                            regs += ', ';
                        }
                    
                        regs += jir.Regulation__r.Regulation_Number__c;
                    }
                }
                
                items.add(new InvestigationVisitChecklistItemWrapper(row, null, regs));
            } 
        }
        
        return items;
    }
    
    public List<InvestigationVisitChecklistItemWrapper> getNonCompliantItems(){ 
        List<InvestigationVisitChecklistItemWrapper> items = new List<InvestigationVisitChecklistItemWrapper>();
        Set<ID> ncIds = new Set<ID>();
        
        for(Non_Compliant__c nc : inv.Non_Compliant_Item__r){
            ncIds.add(nc.Id);
        }
        
        List<Non_Compliant__c> ncItems = [
            SELECT Observations__c, Date_Implemented__c, Correction_Plan__c,
            (SELECT Id, Regulation__r.Name, Regulation__r.Regulation_Number__c  FROM Non_Compliant_Item_Regulations__r)
            FROM Non_Compliant__c
            WHERE ID in :ncIds
        ];
         
        for(Non_Compliant__c item : ncItems) {
            String ret = '';
            
            for(Non_Compliant_Item_Regulation__c itemRegs : item.Non_Compliant_Item_Regulations__r){
                if(ret != ''){
                    ret += ', ';
                }
                
                ret += itemRegs.Regulation__r.Regulation_Number__c;
            }
            items.add(new InvestigationVisitChecklistItemWrapper(null, item, ret));
        }
        
        return items;
    }
}