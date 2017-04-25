public without sharing class EEC_PortalNonCompliancePageController {
 
   public List<Inspection_Item__c> visititems {get;set; }
   public List<Inspection__c> relatedVisits {get; set;}
   public List<Inspection_Item__c> investigationvVisitItems {get;set; } 
   public List<Non_Compliant__c>  noncompitems {get;set; } 
   public Set<String> allVisits = new Set<String>();
   public Set<String> allInvestigationVisits = new Set<String>(); 
   public Set<String> allInvestigation = new Set<String>();
   public List<InspectionListWrapper> iiWrapperList {get;set;}
   public List<ComplainceListWrapper> ncWrapperList {get;set;}
   public Map<Id,InspectionListWrapper> iiMap {get; set;} 
    
   public List<InspectionListWrapper> iiVisitWrapperList {get;set;}
   public List<InspectionListWrapper> iiInvWrapperList {get;set;} 
          
   Public Map<String,List<InspectionListWrapper>> allInvNonComplianceItems {get; set;}
   Private Map<String,Id> allInvIds = new Map<String,Id>();
   Public Map<String,List<InspectionListWrapper>> allVisitNonComplianceItems {get; set;}
   public Integer valcount {get;set; }
   public ID accountid {get; private set;}
   public Id invId {get; private set;}
   public Account provider {get; private set;}
   public String memberId {get;set;}
   public String mode {get;set;} 
   public boolean saveForLater {get; set;}
   private String id { get; set; } 
   private List<boolean> viewTypes = new List<boolean>();
    
    
   EmailTemplate template34 = [SELECT Body, Subject FROM EmailTemplate WHERE DeveloperName = 'X34_Alert_to_licensor_that_corrective_actions_have_been_submitted'];
       
   public EEC_PortalNonCompliancePageController() {  
       memberId = ApexPages.currentPage().getParameters().get('member');
       mode = ApexPages.currentPage().getParameters().get('mode');
       String view = ApexPages.currentPage().getParameters().get('view');
       System.debug('view-->' + view);
       viewTypes.add(True);
       if(String.isNotBlank(view)){
           viewTypes.add(False);
       } 
       if(String.isNotBlank(memberId)){
           accountid = memberId;
           //memberId = EEC_Util.encryptGetParam(EncodingUtil.urlDecode(memberId, 'UTF-8'));
       }
       else{
           List<Account> tempAccount = [SELECT Id 
                                        FROM Account 
                                        WHERE ID in 
                                        (SELECT Accountid 
                                         FROM User WHERE id = :Userinfo.getUserId()) LIMIT 1];
           
           if (tempAccount != null && tempAccount.size() == 1) {
             accountid = tempAccount.get(0).Id;    
           }
       }
       if(String.isBlank(accountid)){
           accountid = ApexPages.currentPage().getParameters().get('accountid');
       }

       if(String.isnotBlank(accountid))
       {
           provider = [SELECT Id, Owner.Email,Name, Provider_Number__c,Owner.Out_of_Office__c,Owner.ManagerId,
                       Provider_Full_Address__c, Last_Issue_Date__c, Renewal_date__c,Owner.Manager.Email,
                       Licensor_Full_Name__c
                       FROM Account WHERE Id = :accountId];
           getitems();
       }                 
   }
   
   public pageReference generatePDF(){
        PageReference pagePdf = ApexPages.currentPage();
        pagePdf.getParameters().put('view','all');
        if(String.isNotBlank(mode)){
            return savePDF();
        }
       else
           return null;
   } 
   
   public pageReference savePDF(){
        PageReference pagePdf = ApexPages.currentPage();
        Blob pdfPageBlob;
        pagePdf.getParameters().put('mode','');
        pdfPageBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pagePdf.getContentAsPDF();
             
        Attachment a = new Attachment();
        a.Body = pdfPageBlob;
        a.ParentID = provider.Id;
        a.Name = 'Program Transaction History - ' + provider.Name + '.pdf';
        insert a;
                 
        return new PageReference('/' + provider.Id);
    } 
    
   public PageReference returnProvider() {
    PageReference pPage = page.EEC_PortalProviderPage;
    if(memberId != null)  
       pPage.getParameters().put('member',EEC_Util.encryptGetParam(memberId));
    return pPage;
  }
    
   public void getitems(){    
         
        iiWrapperList = new List<InspectionListWrapper>();
        Map<Id,Map<String,String>> iregulationMap = new Map<Id,Map<String,String>>();
        Map<String,String> jiMap;
        iiMap = new Map<Id,InspectionListWrapper>();
               
     
        visititems = [SELECT Id,Recordtype.Name,Observations__c,Corrective_Action_EEC_Feedback__c, 
                      Standard_Inspection_Item__c,Associated_regulation__c,
                      Associated_regulation__r.name, Associated_regulation__r.Regulation_Number__c, Inspection_No__c,Inspection_No__r.Visit_Tool_Used__r.Name,Inspection_No__r.RecordType.Name, 
                      Inspection_No__r.Name,Inspection_No__r.Date_Of_Visit__c,Correction_Plan__c,Inspection_No__r.Status__c, 
                      Date_Implemented__c, Inspection_No__r.Investigation__c,Description_of_inspection__c, 
                      Inspection_No__r.Investigation__r.Name, Inspection_No__r.Investigation__r.Closed_Date__c,Inspection_No__r.Investigation__r.Investigation_Status__c
                      FROM Inspection_Item__c 
                      WHERE Inspection_No__r.Provider_No__c = :accountId
                      AND Inspection_Result__c = 'Non-Compliant'
                      AND To_Review_on_Portal__c IN: viewTypes 
                      LIMIT 200];
           //Getting list of all visits that may need staus update once visit items are reviewed. Qamar (LEAD-4678)
           Set<id> relatedVisitIdSet = new Set<Id>();
           for(Inspection_Item__c ii : visititems){
              relatedVisitIdSet.add(ii.Inspection_No__c);
           }
           relatedVisits = [SELECT ID, Status__c FROM Inspection__c WHERE Id IN :relatedVisitIdSet];



           Set<Id> siSet = new Set<Id>(); 
           System.debug('viewTypes-->' + viewTypes);
           System.debug('visititems-->' + visititems);    
           if(visititems != null && visititems.size() > 0){
               
                for(Inspection_Item__c ii : visititems){
                    if(ii.RecordType.Name == 'Standard Visit Item'){
                        siSet.add(ii.Standard_Inspection_Item__c);
                        invId = ii.Inspection_No__r.Investigation__c;
                    }
                }
           
               for(Junction_InspReg__c jir : [SELECT Id,Regulation__c,Standard_Inspection_Item__c,
                                              Regulation__r.name, Regulation__r.Regulation_Number__c 
                                              FROM Junction_InspReg__c 
                                              WHERE Standard_Inspection_Item__c in :siSet]){
                  if(iregulationMap.containsKey(jir.Standard_Inspection_Item__c)){
                     iregulationMap.get(jir.Standard_Inspection_Item__c).put(jir.Regulation__r.Regulation_Number__c+',', jir.Regulation__c);

                  }
                  else{
                     jiMap = new Map<String,String>();
                     jiMap.put(jir.Regulation__r.Regulation_Number__c+',', jir.Regulation__c);
                     iregulationMap.put(jir.Standard_Inspection_Item__c,jiMap);
                
                  }
               }
               Integer rowIndex = 0; 
               System.debug('visititems-->' + visititems);
               iiVisitWrapperList = new List<InspectionListWrapper>();
               investigationvVisitItems = new List<Inspection_Item__c>();
               for(Inspection_Item__c ii : visititems){ 
                   if(!allVisits.contains(ii.Inspection_No__r.Name) && ii.Inspection_No__r.Investigation__c == null)
                       iiVisitWrapperList.add(new InspectionListWrapper(rowIndex,ii,iregulationMap));
                   if(ii.Inspection_No__r.Investigation__c != null){
                       investigationvVisitItems.add(ii);
                       allInvestigationVisits.add(ii.Inspection_No__r.Investigation__r.Name);
                   }
                   allVisits.add(ii.Inspection_No__r.Name); 
                   iiWrapperList.add(new InspectionListWrapper(rowIndex,ii,iregulationMap));  
                   iiMap.put(ii.Id, new InspectionListWrapper(rowIndex,ii,iregulationMap));
                   rowIndex = rowIndex + 1;
               }
           }
                                              
             
        ncWrapperList = new List<ComplainceListWrapper>();
        iiInvWrapperList = new List<InspectionListWrapper>();
        Integer rowIndex = 0; 
        noncompitems = [SELECT Id,Name,Recordtype.Name,Observations__c,Investigation__c,
                        Corrective_Action_EEC_Feedback__c,Investigation__r.Investigation_Type__c,
                        Investigation__r.name,Correction_Plan__c,Date_Implemented__c,
                        Investigation__r.Closed_Date__c, Investigation__r.Investigation_Status__c 
                        FROM Non_Compliant__c 
                        WHERE Investigation__r.Provider_No__c = :accountId 
                        AND To_Review_on_Portal__c IN: viewTypes LIMIT 200 ];
       
           Set<Id> ncSet = new Set<Id>();
           if(noncompitems != null && noncompitems.size() > 0){
                
               for(Non_Compliant__c nc : noncompitems){
                    ncSet.add(nc.id);
                    invId = nc.Investigation__r.Id;
               }
               Map<String,String> ncMap; 
               Map<Id,Map<String,Id>> ncregulationMap = new Map<Id,Map<String,String>>();
               
               for(Non_Compliant_Item_Regulation__c ncr : [SELECT Id,Non_Compliant_Item__c,
                                                           Regulation__c,Regulation__r.name, Regulation__r.Regulation_Number__c 
                                                           FROM Non_Compliant_Item_Regulation__c 
                                                           WHERE Non_Compliant_Item__c in :ncSet]){
                  if(ncregulationMap.containsKey(ncr.Non_Compliant_Item__c)){
                     ncregulationMap.get(ncr.Non_Compliant_Item__c).put(ncr.Regulation__r.Regulation_Number__c+',', ncr.Regulation__c);

                  }
                  else{
                     ncMap = new Map<String,String>();
                     ncMap.put(ncr.Regulation__r.Regulation_Number__c+',', ncr.Regulation__c);
                     ncregulationMap.put(ncr.Non_Compliant_Item__c,ncMap);
                
                  }
               }
               for(Non_Compliant__c nc : noncompitems){  
                   if(!allInvestigation.contains(nc.Investigation__r.name))
                       iiInvWrapperList.add(new InspectionListWrapper(rowIndex,nc,ncregulationMap));
                   allInvestigation.add(nc.Investigation__r.name);
                   
                   iiWrapperList.add(new InspectionListWrapper(rowIndex,nc,ncregulationMap));
                   iiMap.put(nc.Id, new InspectionListWrapper(rowIndex,nc,ncregulationMap));                   
                   rowIndex = rowIndex + 1;
               }
       }
       System.debug('iiWrapperList-->' + iiWrapperList);
       System.debug('iiVisitWrapperList-->' + iiVisitWrapperList);
       if(investigationvVisitItems != null && investigationvVisitItems.size() > 0){
               for(Inspection_Item__c ii : investigationvVisitItems){
                   if(!allInvestigation.contains(ii.Inspection_No__r.Investigation__r.Name))
                       iiInvWrapperList.add(new InspectionListWrapper(rowIndex,ii,iregulationMap));
                   allInvestigation.add(ii.Inspection_No__r.Investigation__r.Name);

                   rowIndex = rowIndex + 1; 
               }
       }
       allInvNonComplianceItems = new Map<String, List<InspectionListWrapper>>();
       allVisitNonComplianceItems = new Map<String, List<InspectionListWrapper>>();
       for(String name : allInvestigation){
           Id invId;
           List<InspectionListWrapper> wrapperList = new List<InspectionListWrapper>();
           for(InspectionListWrapper ilw : iiWrapperList){
               if(ilw.name == name || ilw.inspItem.Inspection_No__r.Investigation__r.Name == name){
                    wrapperList.add(ilw);
               }
               invId = ilw.inspItem.Inspection_No__r.Investigation__c; 
           }
           allInvNonComplianceItems.put(name,wrapperList);
           allInvIds.put(name, invId);
       }
       System.debug('allInvNonComplianceItems-->' + allInvNonComplianceItems);
       System.debug('allVisits-->' + allVisits);
       for(String name : allVisits){
           List<InspectionListWrapper> wrapperList = new List<InspectionListWrapper>();
           for(InspectionListWrapper ilw : iiWrapperList){
               if(ilw.visitname == name){
                    wrapperList.add(ilw);
               }
           }
           allVisitNonComplianceItems.put(name,wrapperList);
       }
        System.debug('allVisitNonComplianceItems-->' + allVisitNonComplianceItems);
       if((visititems == null && visititems.size() == 0) && (noncompitems == null && noncompitems.size() == 0)){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Current, there is no non-compliance that requires your feedback.'));           
       }
  }

  public class InspectionListWrapper{
       
    public Id Id {get;set;}
    public String visitname {get;set;}
    public Integer rowIndex { get; set; }
    public String Type {get; private set;}
    public Map<String,String> regulationMap {get; set;}
    public String dateofvisit {get;set;}
    public String closedDate {get;set;}  
    public String implementdate {get;set;}
    public String observations {get;set;}
    public String correctionPlan {get;set;}
    public Inspection_Item__c inspItem {get;set;}
    public String name {get;set;}  
    public String InvestType {get; private set;}
    public Non_Compliant__c compItem {get;set;}
    public String ncFeedback {get; set;}  
    public String viFeedback {get; set;}
    public String invId {get;set;}
    public String inspDescription {get; set;}
    public String inspStatus {get; set;}
    public String inspToolUser {get; set;}
    public String inspType {get; set;}
    public String invStatus {get; set;}  
    
    public InspectionListWrapper (Integer rowIndex, Inspection_Item__c insp,Map<Id, Map<String,String>> iRegMap) {
         System.debug('********ID-- ' + insp.Id);
         this.Id = insp.Id;
         this.rowIndex = rowIndex;
         this.Type = insp.RecordType.Name;
         this.regulationMap = null;
         if(this.Type == 'Standard Visit Item' && insp.Standard_Inspection_Item__c != null){
              this.regulationMap = iRegMap.get(insp.Standard_Inspection_Item__c);
         }
         else{
              this.regulationMap = new Map<String,String>();
              if(insp.Associated_regulation__c != null){
                this.regulationMap.put(insp.Associated_regulation__r.Regulation_Number__c,insp.Associated_regulation__c);
              }
            }
            System.debug('********regulationMap-- '+this.regulationMap);
            this.visitname = insp.Inspection_No__r.Name;
            this.name = insp.Inspection_No__r.Investigation__r.Name;
            this.invId = insp.Inspection_No__r.Investigation__c;
            this.implementdate = insp.Date_Implemented__c != null ? insp.Date_Implemented__c.format() : String.valueOf(insp.Date_Implemented__c);
            this.dateofvisit = insp.Inspection_No__r.Date_Of_Visit__c != null ? insp.Inspection_No__r.Date_Of_Visit__c.format() : String.valueOf(insp.Inspection_No__r.Date_Of_Visit__c);
            this.closedDate = insp.Inspection_No__r.Investigation__r.Closed_Date__c != null ? insp.Inspection_No__r.Investigation__r.Closed_Date__c .format() : String.valueOf(insp.Inspection_No__r.Investigation__r.Closed_Date__c);
            this.observations = insp.observations__c;
            this.correctionPlan = insp.correction_plan__c;
            this.inspItem = insp;
            this.viFeedback = insp.Corrective_Action_EEC_Feedback__c;
            this.inspDescription = insp.Description_of_inspection__c;
            this.inspStatus = insp.Inspection_No__r.Status__c;
            this.inspToolUser = insp.Inspection_No__r.Visit_Tool_Used__r.Name;
            this.inspType = insp.Inspection_No__r.RecordType.Name;
            this.invStatus = insp.Inspection_No__r.Investigation__r.Investigation_Status__c;
      }
       
      public InspectionListWrapper (Integer rowIndex, Non_Compliant__c ncomp,Map<Id, Map<String,String>> nRegMap) {
         this.Id = ncomp.Id;
         this.rowIndex = rowIndex;
         this.Type = ncomp.RecordType.Name;
         this.InvestType = ncomp.Investigation__r.Investigation_Type__c;
         this.regulationMap = null;
         if(ncomp.Name != null){
              this.regulationMap = nRegMap.get(ncomp.id);
         }
            System.debug('********Non Complaince regulationMap-- '+this.regulationMap);
            this.name = ncomp.Investigation__r.name;
            this.implementdate = ncomp.Date_Implemented__c != null ? ncomp.Date_Implemented__c.format() : String.valueOf(ncomp.Date_Implemented__c);
            this.observations = ncomp.observations__c;
            this.closedDate = ncomp.Investigation__r.Closed_Date__c != null ? ncomp.Investigation__r.Closed_Date__c.format() : String.valueOf(ncomp.Investigation__r.Closed_Date__c);
            this.correctionPlan = ncomp.correction_plan__c;
            this.compItem = ncomp;
            this.ncFeedback = ncomp.Corrective_Action_EEC_Feedback__c;
            this.invStatus = ncomp.Investigation__r.Investigation_Status__c;
            this.invId = ncomp.Investigation__c;
        }
    }
    public class ComplainceListWrapper{
       
    public Id Id {get;set;}
    public String name {get;set;}
    public Integer rowIndex { get; set;}
    public String Type {get; private set;}
    public String InvestType {get; private set;}
    public Map<String,String> regulationMap {get; set;}
    public String   implementdate {get;set;}
    public String observations {get;set;}
    public String correctionPlan {get;set;}
    public Non_Compliant__c compItem {get;set;}
    
    
    public ComplainceListWrapper(Integer rowIndex, Non_Compliant__c ncomp,Map<Id, Map<String,String>> nRegMap) {
         this.Id = ncomp.Id;
         this.rowIndex = rowIndex;
         this.Type = ncomp.RecordType.Name;
         this.InvestType = ncomp.Investigation__r.Investigation_Type__c;
         this.regulationMap = null;
         if(ncomp.Name != null){
              this.regulationMap = nRegMap.get(ncomp.id);
         }
            System.debug('********Non Complaince regulationMap-- '+this.regulationMap);
            this.name = ncomp.Investigation__r.name;
            this.implementdate = ncomp.Date_Implemented__c != null ? ncomp.Date_Implemented__c.format() : String.valueOf(ncomp.Date_Implemented__c);
            this.observations = ncomp.observations__c;
            this.correctionPlan = ncomp.correction_plan__c;
            this.compItem = ncomp;
        }
    }
    
    private void saveInspectionItems(){
    List<Inspection_Item__c> updateiiList = new List<Inspection_Item__c>();
    List<Non_Compliant__c>   updatencList = new List<Non_Compliant__c>();
    //numberItemsNonSelected = 0;
    Integer iiCount = 0;
    Integer ncCount = 0;
    if(iiWrapperList != null){
      Inspection_Item__c iItem;
      for(InspectionListWrapper ilw : iiWrapperList){
          if(ilw.inspItem != null){ 
              iItem = new Inspection_Item__c();
              iItem.Id = ilw.Id;
              iItem.Correction_Plan_Status__c ='Provider Submitted, EEC to Review';
              iItem.correction_plan__c = ilw.correctionPlan;
              iItem.Date_Implemented__c = (!String.isBlank(ilw.implementdate) ? Date.parse(ilw.implementdate) : null);

              if((ilw.ncFeedback != null || ilw.viFeedback != null) && ilw.correctionPlan == '')
                  iItem.Save_for_Later__c = true;
              else if(!String.isBlank(ilw.correctionPlan) && !String.isBlank(ilw.implementdate) && !saveForlater)
                  iItem.Save_for_Later__c = false;
              else if(!String.isBlank(ilw.correctionPlan) || !String.isBlank(ilw.implementdate)){
                  iItem.Save_for_Later__c = true;
              }
                  
              if(String.isNotBlank(iItem.correction_plan__c)){
                iiCount ++;
              }
              //if(iItem.Date_Implemented__c != null && iItem.Correction_Plan__c != '')
              updateiiList.add(iItem);
          }
          else if(ilw.compItem != null){
              Non_Compliant__c cItem ;
              cItem = new Non_Compliant__c();
              cItem.Id = ilw.Id;
              cItem.Correction_Plan_Status__c ='Provider Submitted, EEC to Review';
              cItem.correction_plan__c = ilw.correctionPlan;
              cItem.Date_Implemented__c = (!String.isBlank(ilw.implementdate) ? Date.parse(ilw.implementdate) : null);

              if((ilw.ncFeedback != null || ilw.viFeedback != null) && ilw.correctionPlan == '')
                  iItem.Save_for_Later__c = true;
              else if(!String.isBlank(ilw.correctionPlan) && !String.isBlank(ilw.implementdate) && !saveForlater)
                  cItem.Save_for_Later__c = false;
              else if(!String.isBlank(ilw.correctionPlan) || !String.isBlank(ilw.implementdate))
                  cItem.Save_for_Later__c = true;
              
              if(String.isNotBlank(cItem.correction_plan__c)){
                ncCount ++;
              }
              //if(cItem.Date_Implemented__c != null && cItem.Correction_Plan__c != '')
              updatencList.add(cItem);
          }
        }
     }
      if(updatencList.size() > 0){
          update updatencList;
      }
        
      if(updateiiList.size() > 0){
          update updateiiList;
          System.debug('---------> relatedVisitsList: ' + relatedVisits);
          for(Inspection__c visit : relatedVisits){
            if(visit.Status__c != 'Report Sent to Provider, Awaiting feedback'){
              System.debug('-------> Visits: ' + visit);
            } else {
              List<Inspection_Item__c> iiList = [SELECT ID, Inspection_Result__c, To_Review_on_Portal__c, Date_Implemented__c
                                            FROM Inspection_Item__c 
                                            WHERE Inspection_No__c = :visit.Id AND Inspection_Result__c = 'Non-Compliant'
                                              AND To_Review_on_Portal__c = true];
              Integer ncToReviewOnPortal = 0;
              Integer ncDateImplementedNull = 0;
              for(Inspection_Item__c ii : iiList){
                if(ii.To_Review_on_Portal__c = true){
                  ncToReviewOnPortal++;
                }
                if(ii.Date_Implemented__c == null){
                  ncDateImplementedNull++;
                }
              }
              if(ncToReviewOnPortal == 0 && ncDateImplementedNull == 0){
                visit.Status__c = 'Feedback received, to review';
                Update visit;
              }
            }
            
          }
      }
      
      Set<String> totalInvs = allInvestigation;  
      Set<String> totalVisits = allVisits;  
      System.debug('allInvestigationVisits--->' + allInvestigationVisits);  
      System.debug('allInvestigation--->' + allInvestigation);   
      Map<String,Id> cloneAllInvIds = allInvIds;
      getitems();
      List<Investigation__c> invUpdates = new List<Investigation__c>();  
      Boolean emailSent = false;  
      for(String name : totalInvs){
          System.debug('totalInvs--->' + totalInvs);
          if(allInvNonComplianceItems.get(name).isEmpty()){
              if(cloneAllInvIds.get(name) != null){
                  Investigation__c inv = new Investigation__c();
                  inv.Id = cloneAllInvIds.get(name);
                  inv.Corrective_Actions_Submitted_Date__c = System.Today();
                  invUpdates.add(inv);
              }
              sendEmail(); 
              emailSent = true;
          }
      }
      for(String name : totalVisits){
        System.debug('totalVisits--->' + totalVisits);
        System.debug('allVisitNonComplianceItems--->' + allVisitNonComplianceItems);
        if(allVisitNonComplianceItems.get(name).isEmpty() && !emailSent){
            sendEmail();
        }
      }
      if(invUpdates.size() > 0)
          update invUpdates;
    }
    
    public PageReference ReturnToProvider(){
        saveForLater = true;
        saveInspectionItems();
        return returnProvider();
    }  
  
    public PageReference Save(){
        saveForLater = false;
        saveInspectionItems();
        if(memberId != null)  
        ApexPages.currentPage().getParameters().put('member',memberId);
        PageReference page = ApexPages.currentPage();
        page.setRedirect(true);
        return page;
    }
  
    public PageReference Cancel(){
        return null;
    }
  
    private void sendEmail(){
        
        EEC_EmailUtil email = new EEC_EmailUtil();   
        OrgWideEmailAddress owa = [SELECT id, Address FROM OrgWideEmailAddress WHERE DisplayName  = 'EEC LEAD Alert'];  
        email.toAddresses = new List<String>();
        email.toAddresses.add(provider.Owner.Email);
        if(provider.Owner.Out_Of_Office__c && provider.Owner.ManagerId != null)
            email.toAddresses.add(provider.Owner.Manager.Email);
        email.saveAsActivity = false;
        email.orgWideEmailId = owa.Id; 
        email.plainTextBody = template34.Body.replace('{!Inspection__c.Provider_No__c}', provider.Name);
        email.subject = template34.Subject;  
        email.whatId = provider.Id;
        email.sendEmail();
        
    }
  
}