/**
 * EEC_AssistantListCtrl
 *
 * @author Darkis
 * @description A view model controller for all view logic retaining to the Assistant Information for a given Transaction.
 * @created 3 Feb 2016
*/
public class EEC_AssistantListCtrl {

  public EEC_AssistantInterface aif { get; set; }
  public Account mAccount { get; set; }
  public Boolean mPopulateUsingAssistant { get; set; }

  private List<FCC_Provider_Assistants__c> providerAssistants { get; set; }
  private List<AssistantInfoWrap> providerAssistantWrappers { get; set; }
  private Licensing_Transaction__c mNewestTransaction { get; set; }

  public EEC_AssistantListCtrl() {
    System.debug('----> EEC_AssistantListCtrl Enter');
  }

  /**
   * getAssistantsList
   *
   * @description This function will gather the assistants for the view based on the current transaction provider.
   * @author Darkis 
   * @created 27 Jan 2016
   * @return List<FCC_Provider_Assistants__c> 
   */
  public List<AssistantInfoWrap> getAssistantsList() {
    if(mPopulateUsingAssistant == null)
        mPopulateUsingAssistant = false;
    // If the provider assistants already have been populated then simply return them.
    if (providerAssistantWrappers != null && providerAssistantWrappers.size() > 0) {
      // Update the upper class list.
      if (aif != null) {
        aif.updateAssistantWrapperList(providerAssistantWrappers);
      }
      return providerAssistantWrappers;
    } else {
      providerAssistantWrappers = new List<AssistantInfoWrap> ();
      // Fetch the provider assistants for the current provider.
      // If the Assistant Interface is present then use the shared transaction object.
      if (aif != null && aif.getBaseLicenseTransaction() != null) {
        populateAssistantsListWithTransaction();
        // Update the upper class list.
        aif.updateAssistantWrapperList(providerAssistantWrappers);
      } else if (mPopulateUsingAssistant) {
        populateAssistantsListUsingAssistant();
      } else {
        populateAssistantsList();
      }
    }
    System.debug('----> providerAssistantWrappers: ' + providerAssistantWrappers);
    // Return to the page.
    return providerAssistantWrappers;
  }

  private void populateAssistantsListWithTransaction() {
    try {
      List<FCC_Provider_Assistants__c> providerAssistants = 
          [SELECT Id, Name, FCC_Assistant__r.Name, FCC_Assistant__r.License_Status__c, 
           FCC_Assistant__r.Current_License_Number__c, 
           FCC_Assistant__r.Renewal_Date__c, 
           FCC_Assistant__r.License_Type__c, 
           Start_Date__c, FCC_Assistant__r.Certified_As__c, 
           End_Date__c, isCopied__c 
           From FCC_Provider_Assistants__c 
           Where FCC_Provider__c = :aif.getBaseLicenseTransaction().Provider__c 
           AND Licensing_Transaction__c = :aif.getBaseLicenseTransaction().Id 
           ORDER BY Start_Date__c DESC NULLS FIRST];
      // If the license type is Renewal or Upgrade we need to copy over the lastest new transactions items. 
      if ((aif.getBaseLicenseRecordTypeName()).equalsIgnoreCase('FCC_Renewal') 
          || (aif.getBaseLicenseRecordTypeName()).equalsIgnoreCase('FCC_License_Upgrade')) {
        Boolean assistantsAlreadyTransferred = false;
        // Loop through the existing items and see if one has already been copied for the transaction.
        for (FCC_Provider_Assistants__c assistant : providerAssistants) {
          if (assistant.isCopied__c) {
            assistantsAlreadyTransferred = true;
            break;
          }
        }
        // If none have been transfered.
        if (!assistantsAlreadyTransferred) {
          List<FCC_Provider_Assistants__c> latestNewTransAssistantsList = [SELECT Id, Name, FCC_Assistant__r.Name, 
                                                                           FCC_Assistant__r.License_Status__c, 
                                                                           FCC_Assistant__r.Current_License_Number__c, 
                                                                           FCC_Assistant__r.Renewal_Date__c, 
                                                                           FCC_Assistant__r.License_Type__c, 
                                                                           FCC_Assistant__r.Certified_As__c,
                                                                           Start_Date__c, End_Date__c 
                                                                           From FCC_Provider_Assistants__c 
                                                                           Where FCC_Provider__c = :aif.getBaseLicenseTransaction().Provider__c 
                                                                           AND Current__c = true 
                                                                           ORDER BY Start_Date__c DESC NULLS FIRST];
          for (FCC_Provider_Assistants__c assistant : latestNewTransAssistantsList) {
            assistant.isCopied__c = true;
            providerAssistantWrappers.add(new AssistantInfoWrap(assistant, false));
          }
        }
      }
      // Place the ones specific to the transaction in this wrapper.  
      for (FCC_Provider_Assistants__c providerAssistant : providerAssistants) {
        providerAssistantWrappers.add(new AssistantInfoWrap(providerAssistant, false));
      }
    } catch(DMLException e) {
      System.debug('-----> Error with getAssistantsList => populateAssistantsListWithTransaction: ' + e.getMessage());
    }
  }

  private void populateAssistantsList() {
    try {
      List<FCC_Provider_Assistants__c> providerAssistants = [Select Id, Name, 
                                                             FCC_Assistant__r.Name,
                                                             FCC_Assistant__r.License_Status__c, 
                                                             FCC_Assistant__r.Current_License_Number__c,
                                                             FCC_Assistant__r.Renewal_Date__c,
                                                             FCC_Assistant__r.License_Type__c,
                                                             Start_Date__c, End_Date__c,
                                                             isCopied__c, FCC_Provider__r.Name,
                                                             FCC_Provider__r.Provider_Full_Address__c,
                                                             FCC_Provider__r.Licensor_s_Manager_Email__c,
                                                             FCC_Assistant__r.Provider_Full_Address__c,
                                                             FCC_Assistant__r.Licensor_s_Manager_Email__c,
                                                             FCC_Assistant__r.Licensor_Email__c,
                                                             FCC_Assistant__r.Certified_As__c
                                                             From FCC_Provider_Assistants__c
                                                             Where FCC_Provider__c = :mAccount.Id
                                                             AND Current__c = true ORDER BY Start_Date__c DESC NULLS FIRST];
      // Place the ones specific to the transaction in this wrapper.  
      for (FCC_Provider_Assistants__c providerAssistant : providerAssistants) {
        providerAssistantWrappers.add(new AssistantInfoWrap(providerAssistant, false));
      }
    } catch(DMLException e) {
      System.debug('-----> Error with getAssistantsList: ' + e.getMessage());
    }
  }

  private void populateAssistantsListUsingAssistant() {
    try {
      List<FCC_Provider_Assistants__c> providerAssistants = [Select Id, Name, FCC_Assistant__r.Name,
                                                             FCC_Assistant__r.License_Status__c, 
                                                             FCC_Assistant__r.Current_License_Number__c,
                                                             FCC_Assistant__r.Renewal_Date__c,
                                                             FCC_Assistant__r.License_Type__c,
                                                             Start_Date__c, End_Date__c, isCopied__c,
                                                             FCC_Provider__r.Name,
                                                             FCC_Provider__r.Provider_Full_Address__c,
                                                             FCC_Provider__r.Licensor_s_Manager_Email__c,
                                                             FCC_Assistant__r.Provider_Full_Address__c,
                                                             FCC_Assistant__r.Licensor_s_Manager_Email__c,
                                                             FCC_Assistant__r.Licensor_Email__c,
                                                             FCC_Assistant__r.Certified_As__c
                                                             From FCC_Provider_Assistants__c
                                                             Where FCC_Assistant__c = :mAccount.Id 
                                                             AND Current__c = true ORDER BY Start_Date__c DESC NULLS FIRST];
      // Place the ones specific to the transaction in this wrapper.  
      for (FCC_Provider_Assistants__c providerAssistant : providerAssistants) {
        providerAssistantWrappers.add(new AssistantInfoWrap(providerAssistant, false));
      }
    } catch(DMLException e) {
      System.debug('-----> Error with getAssistantsList: ' + e.getMessage());
    }
  }

  /**
   * getAssistantsListCount
   *
   * @description This function will determine if the assistant list has more than 0 rows. 
   * @author Darkis
   * @created 27 Jan 2016
   * @return Boolean 
   */
  public Boolean getAssistantsListCount() {
  System.debug('----> List count Enter');
    if (providerAssistantWrappers != null) {
      return(providerAssistantWrappers.size() > 0 ? true : false);
    } else {
      // IF the Interface is provided then proceed.
      if (aif != null && aif.getBaseLicenseTransaction() != null) {
        //Licensing_Transaction__c tempTrans = getNewestTransaction();
        //System.debug('----> tempTrans: ' + tempTrans);
        
        if ([SELECT Count() FROM FCC_Provider_Assistants__c 
             WHERE FCC_Provider__c = :aif.getBaseLicenseTransaction().Provider__c 
             AND Licensing_Transaction__c = :aif.getBaseLicenseTransaction().Id] > 0) {
          return true;
        } else if ([SELECT Count() FROM FCC_Provider_Assistants__c 
                    WHERE FCC_Provider__c = :aif.getBaseLicenseTransaction().Provider__c 
                    AND Current__c = true] > 0) {
          return true;
        }
      } else {
        if ([SELECT Count() FROM FCC_Provider_Assistants__c WHERE FCC_Provider__c = :mAccount.Id AND Current__c = true] > 0) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * removeAddedAssistant
   *
   * @description This function will remove from the wrapper list the passed in object id. This is only intended for newly added objects.
   * @author Darkis
   * @created 27 Jan 2016
   */
  public void removeAddedAssistant() {
    String wrapperId = ApexPages.currentPage().getParameters().get('wrapperId');
    System.debug('----> wrapperId: ' + wrapperId);
    System.debug('----> providerAssistantWrappers: ' + providerAssistantWrappers);
    Integer wrapperIndex;

    for (Integer i = 0; i < providerAssistantWrappers.size(); i++) {
      AssistantInfoWrap assistantWrap = providerAssistantWrappers.get(i);

      if (wrapperId.equalsIgnoreCase(String.valueOf(assistantWrap.wrapperId))) {
        wrapperIndex = i;
        break;
      }
    }

    if (wrapperIndex != null) {
      try {
        providerAssistantWrappers.remove(wrapperIndex);
      } catch(Exception e) {
        System.debug('----> Could not remove index from Assistant providerAssistantWrappers: ' + e.getMessage());
      }
    }
  }

  /**
   * addAssistantToList
   *
   * @description This function will add the new assistant from the popup to the list.
   * @author Darkis
   * @created 27 Jan 2016
   * @return PageReference 
   */
  public PageReference addAssistantToList() {
    String assistantId = ApexPages.currentPage().getParameters().get('accountId');
    // This will retrieve the assistant information needed for the view. Sadly we have no way of attaching this to the object directly without inserting.
    Account assistantInfo = [SELECT Name, License_Status__c, Certified_As__c, 
                             Current_License_Number__c, Renewal_Date__c, 
                             License_Type__c 
                             FROM Account WHERE Id = :assistantId LIMIT 1];
    // TODO: Ensure that the assistant has an AIF before attempting to use it. 
    // Create the new wrapper. 
    FCC_Provider_Assistants__c tempProvAssist = new FCC_Provider_Assistants__c(FCC_Assistant__c = assistantId);

    if (aif != null && aif.getBaseLicenseTransaction() != null) {
      tempProvAssist.FCC_Provider__c = aif.getBaseLicenseTransaction().Provider__c;
      tempProvAssist.Licensing_Transaction__c = aif.getBaseLicenseTransaction().Id;
    } else {
      tempProvAssist.FCC_Provider__c = mAccount.Id;
    }

    AssistantInfoWrap newAssistantWrapper = new AssistantInfoWrap
    (tempProvAssist, true, assistantInfo);
    newAssistantWrapper.providerAssistant.recalculateFormulas();

    Integer counter = 0;
    if (providerAssistantWrappers != null && providerAssistantWrappers.size() > 0) {
      // Determine the new wrapper ID to set for this new entry.
      for (AssistantInfoWrap wrapper : providerAssistantWrappers) {
        if (wrapper.isNew) {
          counter++;
        }
      }
    }
    newAssistantWrapper.wrapperId = counter + 1;

    if (providerAssistantWrappers == null) {
      providerAssistantWrappers = new List<AssistantInfoWrap> ();
    }
    providerAssistantWrappers.add(newAssistantWrapper);
    System.debug('----> providerAssistantWrappers: ' + providerAssistantWrappers);
    return null;
  }

  /**
   * getNewestTransaction
   *
   * @description This function will get the newest transaction based on criteia to copy over any exisiting assitants for upgrades and renewals. 
   * @author Darkis
   * @created 27 Jan 2016
   * @return Licensing_Transaction__c 
   */
  public Licensing_Transaction__c getNewestTransaction() {
    if (mNewestTransaction != null) {
      return mNewestTransaction;
    } else {
      List<Licensing_Transaction__c> tempTrans =
      [
      Select
      Id, Name, RecordType.DeveloperName, Provider__c, Status__c, LastModifiedDate
      From Licensing_Transaction__c
      Where Provider__c = : aif.getBaseLicenseTransaction().Provider__c
      AND Status__c IN('Submitted', 'To Submit', 'Under Review')
      ORDER BY LastModifiedDate DESC LIMIT 1
      ];
      mNewestTransaction = (tempTrans != null && tempTrans.size() == 1 ? tempTrans.get(0) : null);
    }
    System.debug('----> mNewestTransaction: ' + mNewestTransaction);
    return mNewestTransaction;
  }

  /**
   * AssistantInfoWrap
   *
   * @description This wrapper class will allow us to know which providers have just been added vs pre-populated.
   * @author Darkis
   * @created 27 Jan 2016
   */
  public class AssistantInfoWrap implements Comparable {

    public FCC_Provider_Assistants__c providerAssistant { get; set; }
    public Account assistantInformation { get; set; }
    public Boolean isNew { get; set; }
    public Integer wrapperId { get; set; }

    public AssistantInfoWrap(FCC_Provider_Assistants__c providerAssistant, Boolean isNew) {
      this.providerAssistant = providerAssistant;
      this.isNew = isNew;
    }

    public AssistantInfoWrap(FCC_Provider_Assistants__c providerAssistant, Boolean isNew, Account assistantInformation) {
      this.providerAssistant = providerAssistant;
      this.isNew = isNew;
      this.assistantInformation = assistantInformation;
    }

    // Compare opportunities based on the opportunity amount.
    public Integer compareTo(Object compareTo) {
      // Cast argument to OpportunityWrapper
      AssistantInfoWrap compareToObj = (AssistantInfoWrap) compareTo;

      // The return value of 0 indicates that both elements are equal.
      Integer returnValue = 0;
      if (providerAssistant.Start_Date__c == null && compareToObj.providerAssistant.Start_Date__c == null) {
        return 0;
      } else if (providerAssistant.Start_Date__c == null && compareToObj.providerAssistant.Start_Date__c != null) {
        returnValue = 1;
      } else if (providerAssistant.Start_Date__c != null && compareToObj.providerAssistant.Start_Date__c == null) {
        returnValue = - 1;
      } else if (providerAssistant.Start_Date__c > compareToObj.providerAssistant.Start_Date__c) {
        // Set return value to a positive value.
        returnValue = 1;
      } else if (providerAssistant.Start_Date__c < compareToObj.providerAssistant.Start_Date__c) {
        // Set return value to a negative value.
        returnValue = - 1;
      }
      return returnValue;
    }
  }
}