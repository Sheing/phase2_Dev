public class EEC_AssistantUpdateListCtrl implements EEC_AssistantInterface {

  public Account account { get; set; }
  public String errorMessage { get; set; }

  private List<EEC_AssistantListCtrl.AssistantInfoWrap> providerAssistantWrappers { get; set; }

  public EEC_AssistantUpdateListCtrl() {
    try {
      String accountId = EEC_Util.decryptGetParam(EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('param'), 'UTF-8'));
      List<Account> accountList = [Select Id From Account Where Id = :accountId];

      if (accountList != null && accountList.size() == 1) {
        account = accountList.get(0);
      }
    } catch(Exception e) {
      System.debug('----> Error getting account for Page: ' + e.getMessage());
      errorMessage = 'Unable to retrieve list of Assistants. Please try again later.';
    }
  }

  /**
   * Save
   *
   * @description This function will be used to save a new transaction with all then edited information.
   * @author Darkis
   * @created 8 Feb 2016
   */
  public PageReference Save() {
    List<FCC_Provider_Assistants__c> assistantsToUpsert = new List<FCC_Provider_Assistants__c> ();
    Savepoint sp = Database.setSavepoint();

    try {
      Licensing_Transaction__c newUpdateAssistantTransaction = new Licensing_Transaction__c
      (
       Provider__c = account.Id,
       Status__c = 'Closed (Processed)',
       Submission_Date__c = Date.today(),
       Submitter__c = UserInfo.getUserId(),
       Source__c = 'Provider Portal',
       Date_Closed__c = Date.today(),
       Reason_Closed_Cancelled__c = 'Processed'
      );
      newUpdateAssistantTransaction.RecordTypeId = EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.FCC_Provider_Assistant_Update').Id;
      System.debug('----> New Transaction: ' + newUpdateAssistantTransaction);
      insert newUpdateAssistantTransaction;

      System.debug('----> providerAssistantWrappers: ' + providerAssistantWrappers);
      if (providerAssistantWrappers != null && providerAssistantWrappers.size() > 0) {
        for (EEC_AssistantListCtrl.AssistantInfoWrap wrapper : providerAssistantWrappers) {
          FCC_Provider_Assistants__c tempProvAssist = wrapper.providerAssistant.clone(false, true);
          tempProvAssist.Licensing_Transaction__c = newUpdateAssistantTransaction.Id;
          tempProvAssist.FCC_Provider__c = account.Id;
          assistantsToUpsert.add(tempProvAssist);
        }
        System.debug('----> assistantsToUpsert: ' + assistantsToUpsert);
        insert assistantsToUpsert;
      }
    } catch(Exception e) {
      System.debug('----> Error has occured saving assistants: ' + e.getMessage());
      Database.rollback(sp);
    }
    
    PageReference pPage = Page.EEC_PortalProviderPage;
    pPage.setRedirect(true);
    return pPage;
  }

  /**
   * getCtrlInstance
   * 
   * This function will return an instance of this controller with interface reference.
   * @author Darkis
   * @return EEC_AssistantInfoStepCtrl
   */
  public EEC_AssistantUpdateListCtrl getCtrlInstance() {
    return this;
  }

  /*-----Interface Methods-----*/
  public void updateAssistantWrapperList(List<EEC_AssistantListCtrl.AssistantInfoWrap> providerAssistantWrappers) {
    this.providerAssistantWrappers = providerAssistantWrappers;
  }

  public Licensing_Transaction__c getBaseLicenseTransaction() {
    return null;
  }

  public String getBaseLicenseRecordTypeName() {
    return null;
  }
}