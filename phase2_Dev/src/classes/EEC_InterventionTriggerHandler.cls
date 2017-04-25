public class EEC_InterventionTriggerHandler {
    
    List<Intervention__c> newIntList;
    Map<Id, Intervention__c> oldCaseMap;
    Map<Id, User> userList;

    public EEC_InterventionTriggerHandler(List<Intervention__c> newList, Map<Id, Intervention__c> oldList){
        this.newIntList = newList;
        this.oldCaseMap = oldList;
        
        userList = new Map<Id, User>([
            SELECT ManagerId, UserRoleId, Email, Name, DelegatedApproverId, Out_of_Office__c 
            FROM User
            WHERE UserType = 'Standard'
        ]);
    }
    
    public void sendInterventionSubmittedOutOfOffice(){
        for(Intervention__c inv : newIntList){
            Intervention__c oldI = oldCaseMap.get(inv.Id);
            Investigation__c invest = [SELECT Id,Name,Assigned_To__r.Out_of_Office__c,Provider_No__r.Name,Assigned_To__r.ManagerId,Provider_Name__c
                                       FROM Investigation__c WHERE Id =: inv.Investigation__c];
            User leader = userList.get(invest.Assigned_To__c);

            String invRtName = [SELECT recordType.Name FROM Intervention__c WHERE id =: inv.Id].RecordType.Name;
            if(inv.Status__c == 'Submitted' && oldI.Status__c != 'Submitted' 
               && invRtName == 'Internal Investigation'
               && leader != null && leader.Out_of_Office__c){
                   
                List<OrgWideEmailAddress> orgList = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'EEC LEAD Alert'];
                EmailTemplate template41 = [SELECT Body, Subject FROM EmailTemplate WHERE DeveloperName = 'X41_An_Internal_Investigation_Has_Been_Submitted'];
                   
                EEC_EmailUtil email = new EEC_EmailUtil(); 
                email.plainTextBody = template41.Body
                    .replace('{!Investigation__c.Name}', invest.Name)
                    .replace('{!Account.Name}', invest.Provider_Name__c);
                email.subject = 'Alert to Investigation Leader that internal investigation has been submitted';
                email.toAddresses = new List<String>();
                
                if(leader.ManagerId != null){
                    User manager = userList.get(leader.ManagerId);
                    email.toAddresses.add(manager.Email);
                    
                    if(manager.ManagerId != null && manager.Out_of_office__c){
                        User managersManager = userList.get(manager.ManagerId);
                        email.toAddresses.add(managersManager.Email); 
                    }
                }
                                    
                email.whatId = inv.Id;
            	email.saveAsActivity = false; 

                if(orgList.size() > 0)
                	email.orgWideEmailId = orgList.get(0).Id;
                
                email.sendEmail();
            }
        }
    }
}