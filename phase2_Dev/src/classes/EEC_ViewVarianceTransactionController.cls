public without sharing class EEC_ViewVarianceTransactionController implements EEC_AssistantInterface{
  public Id ltId { get; set; }
  public Licensing_Transaction__c licenseTransation { get; set; }
  public String licenseRecordTypeName { get; set; }
  public String licenseRecordTypeLabel { get; set; }
  public String memberId { get; set; }
  
  public EEC_ViewVarianceTransactionController() {
    ltId = ApexPages.currentPage().getParameters().get('ltID');
    memberId = ApexPages.currentPage().getParameters().get('member');
    getLicenseTrans();
  }

  public void getLicenseTrans() {
    List<Licensing_Transaction__c> ltList = [Select Provider__r.Name, RecordType.DeveloperName, RecordType.Name, Name,
    										Status__c,Last_Reached_Step__c,
    										Submission_Date__c,Submitter__r.FirstName,
    										Submitter__r.LastName,Source__c,Date_Closed__c,
											Reason_Closed_Cancelled__c,
											Assigned_To__r.FirstName,Assigned_To__r.LastName,
											Assigned_To__r.Phone,Assigned_To__r.Email,
											Transaction_Special_Requests_Comments__c,    										
											(Select Id,Associated_Regulation__c,Associated_Regulation__r.Name,Associated_Regulation__r.Regulation_Number__c,
											Associated_Regulation__r.Article__c,Provider_Alternative_Method_to_Comply__c,
											Provider_Understanding_of_Regulation__c From Variance_on_Regulations__r)											
											 From Licensing_Transaction__c where Id = :ltId];

    if (ltList != null && ltList.size() > 0) {
      licenseTransation = ltList.get(0);
      licenseRecordTypeName = licenseTransation.RecordType.DeveloperName;
      licenseRecordTypeLabel = licenseTransation.RecordType.Name;
    }
    else{
      ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Provide a valid Licensing Transaction Id');
      ApexPages.addMessage(msg);
      return;
    }
  }
  
  public List<SelectOption> getItems() {
    List<SelectOption> options = new List<SelectOption> ();
    options.add(new SelectOption('True', 'Yes'));
    options.add(new SelectOption('False', 'No'));
    return options;
  }
  
  public List<SelectOption> getPickItems() {
    List<SelectOption> options = new List<SelectOption> ();
    options.add(new SelectOption('Yes', 'Yes'));
    options.add(new SelectOption('No', 'No'));
    return options;
  }
  
  public Pagereference CancelTransaction() {
    licenseTransation.Status__c = 'Cancelled';
    licenseTransation.Reason_Closed_Cancelled__c = 'Cancelled by portal user';

	licenseTransation = EEC_ContactRoleUtil.updateLicensingTransaction(licenseTransation);
	
    PageReference pPage = page.EEC_PortalProviderPage;
    if (memberId != null)
    pPage.getParameters().put('member', EEC_Util.encryptGetParam(memberId));
    return pPage;
  }

  public Pagereference backInstruction() {
    PageReference pPage = page.EEC_PortalProviderPage;
    if (memberId != null)
    pPage.getParameters().put('member', EEC_Util.encryptGetParam(memberId));
    return pPage;
  }

  public Pagereference editInstruction() {
    PageReference pPage = EEC_Util.lastStepMap.get(licenseTransation.Last_Reached_Step__c);
    pPage.getParameters().put('ltId', licenseTransation.Id);
    pPage.getParameters().put('accountId', memberId);
    return pPage;
  }

  /**
   * getCtrlInstance
   * 
   * This function will return an instance of this controller with interface reference.
   * @author Darkis
   * @return EEC_ViewTransactionController
   */
  public EEC_ViewVarianceTransactionController getCtrlInstance() {
    return this;
  }

  /*-----Interface Methods-----*/
  public void updateAssistantWrapperList(List<EEC_AssistantListCtrl.AssistantInfoWrap> providerAssistantWrappers) {
    
   }

  public Licensing_Transaction__c getBaseLicenseTransaction() {
    return licenseTransation;
  }

  public String getBaseLicenseRecordTypeName() {
    return licenseRecordTypeName;
  }
 }