public class EEC_VarianceInfoStepCtrl extends EEC_BaseTransactionStep implements EEC_VarianceInterface {

  private List<EEC_VarianceListCtrl.VarianceInfoWrap> varianceInfoWrappers { get; set; }

  /**
   * Constructor
   *
   * @description The constructor for the class.
   * @author Latha Davuluri
   * @created 18 Jan 2017
   * @return EEC_VarianceInfoStepCtrl 
   */
  public EEC_VarianceInfoStepCtrl() {
    super();
    // Set defaults.
  }
  
  /**
   * getCtrlInstance
   * 
   * This function will return an instance of this controller with interface reference.
   * @author Latha Davuluri
   * @return EEC_VarianceInfoStepCtrl
   */
  public EEC_VarianceInfoStepCtrl getCtrlInstance() {
    return this;
  }

  /**
   * VarianceInfoSave
   *
   * @description A one stop location for all traversal paths for Variance Information.
   * @authour Latha Davuluri
   * @param saveType Integer The save type attempted.
   * @return PageReference 
   */
  public PageReference VarianceInfoSave() {
    PageReference pPage;
    Integer saveType = Integer.valueOf(ApexPages.currentPage().getParameters().get('saveType'));
    List<Variance_on_Regulation__c> variancesToUpsert = new List<Variance_on_Regulation__c> ();

    System.debug('----> varianceInfoWrappers: ' + varianceInfoWrappers);
    if (varianceInfoWrappers != null && varianceInfoWrappers.size() > 0) {
      for (EEC_VarianceListCtrl.VarianceInfoWrap wrapper : varianceInfoWrappers) {
        variancesToUpsert.add(wrapper.varianceReg);
      }
      System.debug('----> variancesToUpsert: ' + variancesToUpsert);
      upsert variancesToUpsert;
    }

    if (saveType == SAVE_AND_NEXT) {
      // Change the last step.
      licenseTransaction.Last_Reached_Step__c = 'Attachments';
      // Setup the page.
      pPage.getParameters().put('ltId', licenseTransaction.Id);
    } else if (saveType == SAVE_AND_PREVIOUS) {
      // Change the last step.
      licenseTransaction.Last_Reached_Step__c = 'Technical Assistance';
      // Setup the page.
      pPage = Page.EEC_LicenseStatusCapacityInfo;
      pPage.getParameters().put('ltId', licenseTransaction.Id);
    } else if (saveType == SAVE_AND_RETURN) {
      // Change the last step.
      licenseTransaction.Last_Reached_Step__c = 'Technical Assistance';
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
  public void updateVarianceWrapperList(List<EEC_VarianceListCtrl.VarianceInfoWrap> varianceInfoWrappers) {
    System.debug('----> varianceInfoWrappers: ' + varianceInfoWrappers);
    System.debug('----> this.varianceInfoWrappers: ' + this.varianceInfoWrappers);
    this.varianceInfoWrappers = varianceInfoWrappers;
    System.debug('----> this.varianceInfoWrappers: ' + this.varianceInfoWrappers);
  }

  public Licensing_Transaction__c getBaseLicenseTransaction() {
    return licenseTransaction;
  }

  public String getBaseLicenseRecordTypeName() {
    return LicenseRecordTypeName;
  }
}