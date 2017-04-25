public class EEC_AssistantInfoStepCtrl extends EEC_BaseTransactionStep implements EEC_AssistantInterface {
  public string previousPageName{get;set;}
  
  private List<EEC_AssistantListCtrl.AssistantInfoWrap> providerAssistantWrappers { get; set; }

  /**
   * Constructor
   *
   * @description The constructor for the class.
   * @author Darkis
   * @created 26 Jan 2016
   * @return EEC_AssistantInfoStepCtrl 
   */
  public EEC_AssistantInfoStepCtrl() {
    super();
    // Set defaults.
  }
  
  /**
   * getCtrlInstance
   * 
   * This function will return an instance of this controller with interface reference.
   * @author Darkis
   * @return EEC_AssistantInfoStepCtrl
   */
  public EEC_AssistantInfoStepCtrl getCtrlInstance() {
    return this;
  }

  /**
   * AssistantInfoSave
   *
   * @description A one stop location for all traversal paths for Assistant Information.
   * @authour Darkis
   * @created 26 Jan 2016
   * @param saveType Integer The save type attempted.
   * @return PageReference 
   */
  public PageReference AssistantInfoSave() {
    PageReference pPage;
    Integer saveType = Integer.valueOf(ApexPages.currentPage().getParameters().get('saveType'));
    List<FCC_Provider_Assistants__c> assistantsToUpsert = new List<FCC_Provider_Assistants__c> ();

    System.debug('----> providerAssistantWrappers: ' + providerAssistantWrappers);
    if (providerAssistantWrappers != null && providerAssistantWrappers.size() > 0) {
      for (EEC_AssistantListCtrl.AssistantInfoWrap wrapper : providerAssistantWrappers) {
        assistantsToUpsert.add(wrapper.providerAssistant);
      }
      System.debug('----> assistantsToUpsert: ' + assistantsToUpsert);
      upsert assistantsToUpsert;
    }

    if (saveType == SAVE_AND_NEXT) {
      // Change the last step.
      licenseTransaction.Last_Reached_Step__c = (LicenseRecordTypeName == 'FCC_New_License' ? 'EEC Involvement Experience & Professional Exp.' : 'Background Information');
      // Setup the page.
      pPage = (LicenseRecordTypeName == 'FCC_New_License' ? Page.EEC_InvolvementExperience : Page.EEC_BackgroundInformation);
      pPage.getParameters().put('ltId', licenseTransaction.Id);
    } else if (saveType == SAVE_AND_PREVIOUS) {
      // Change the last step.
      licenseTransaction.Last_Reached_Step__c = 'Assistant Information';
      // Setup the page.
      if(string.IsNotBlank(previousPageName)){
    	if(provider.RecordType.Name == 'Family Child Care' || provider.RecordType.Name == 'FCC Assistant'){
            pPage = EEC_Util.lastFCCStepMap.get(previousPageName);
            system.debug('previousPageName: ' + previousPageName);
        }
        else if(provider.RecordType.Name == 'Large Group' || provider.RecordType.Name == 'Small Group' || provider.RecordType.Name == 'Large and Small Group Umbrella' ){
            pPage = EEC_Util.lastGSAStepMap.get(previousPageName);
        }
        else if(provider.RecordType.Name == 'R&P Umbrella' || provider.RecordType.Name == 'Temporary Shelter' || provider.RecordType.Name == 'Group Care'
                || provider.RecordType.Name == 'Foster Care Agency' || provider.RecordType.Name == 'Adoption Agency'){
        	pPage = EEC_Util.lastRPStepMap.get(previousPageName);
        }
      }
      else{
  		pPage = Page.EEC_LicenseStatusCapacityInfo;
      }
      pPage.getParameters().put('ltId', licenseTransaction.Id);
    } else if (saveType == SAVE_AND_RETURN) {
      // Change the last step.
      licenseTransaction.Last_Reached_Step__c = 'Assistant Information';
      // Setup the page.
      pPage = page.EEC_PortalProviderPage;
    }
    update licenseTransaction;

    if (pPage != null) {
      EEC_Util.addMemberIDPageParameter(memberId, pPage, false);
      pPage.setRedirect(true);
    }
    return pPage;
  }

  /*-----Interface Methods-----*/
  public void updateAssistantWrapperList(List<EEC_AssistantListCtrl.AssistantInfoWrap> providerAssistantWrappers) {
    System.debug('----> providerAssistantWrappers: ' + providerAssistantWrappers);
    System.debug('----> this.providerAssistantWrappers: ' + this.providerAssistantWrappers);
    this.providerAssistantWrappers = providerAssistantWrappers;
    System.debug('----> this.providerAssistantWrappers: ' + this.providerAssistantWrappers);
  }

  public Licensing_Transaction__c getBaseLicenseTransaction() {
    return licenseTransaction;
  }

  public String getBaseLicenseRecordTypeName() {
    return LicenseRecordTypeName;
  }
}