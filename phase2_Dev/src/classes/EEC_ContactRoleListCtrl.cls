/**
 * EEC_ContactRoleListCtrl
 *
 * @author Nirdesh Bhatt
 * @description A view model controller for all view logic retaining to the ContactRole Information for a given Transaction.
 * @created 23 Jan 2017
*/ 
public  class EEC_ContactRoleListCtrl {
	
  public EEC_ContactRoleInterface vif { get; set; } 
  public Account mAccount { get; set; } 
 // public Regulation__c mRegulation {get; set;}
  public string programRecordType  { get; set; } 
  
 // public Boolean mPopulateUsingAssistant { get; set; }

  private List<Contact_Role__c> varianceRegs { get; set; }
  private List<ContactRoleInfoWrap> ContactRoleInfoWrappers { get; set; }
  private Licensing_Transaction__c mNewestTransaction { get; set; }

  public EEC_ContactRoleListCtrl() {
    system.debug('----> EEC_ContactRoleListCtrl Enter');
  }


  /**
   * getContactRoleList
   *
   * @description This function will gather the Contact for the view based on the current transaction.
   * @author Nirdesh Bhatt
   * @created 23 Jan 2017
   * @return List<Contact_Role__c> 
   */
  public List<ContactRoleInfoWrap> getContactList() {
  //  if(mPopulateUsingAssistant == null)
 //       mPopulateUsingAssistant = false;
    // If the provider assistants already have been populated then simply return them.
    if (ContactRoleInfoWrappers != null && ContactRoleInfoWrappers.size() > 0) {
      // Update the upper class list.
      if (vif != null) {
     //   vif.updateContactRoleWrapperList(ContactRoleInfoWrappers);
      }   
      return ContactRoleInfoWrappers; 
    } else {
      ContactRoleInfoWrappers = new List<ContactRoleInfoWrap> ();
      // Fetch the provider assistants for the current provider.
      // If the Assistant Interface is present then use the shared transaction object.
      if (vif != null && vif.getBaseLicenseTransaction() != null) {
        populateContactRoleListWithTransaction();
        // Update the upper class list.
     //   vif.updateContactRoleWrapperList(ContactRoleInfoWrappers);
      } 
      else {
        populateContactRoleList();
      }
    }
    system.debug('----> ContactRoleInfoWrappers: ' + ContactRoleInfoWrappers);
    // Return to the page.
    return ContactRoleInfoWrappers;
  }

  private void populateContactRoleListWithTransaction() {
    try {
      List<Contact_Role__c> varianceRegs = 
          [SELECT Contact__r.FirstName,contact__r.LastName,contact__r.MailingStreet,contact__r.MailingCity,contact__r.MailingPostalCode,contact__r.MailingState,contact__r.Phone,contact__r.Email,Start_Date__c,End_Date__c
           From Contact_Role__c 
           Where Provider__c = :vif.getBaseLicenseTransaction().Provider__c 
         //  AND Source_Transaction__c = :vif.getBaseLicenseTransaction().Id 
           ];
      // If the license type is NOT New License or Change of Admin Authority we need to copy over the lastest new transactions items. 
      system.debug('#########recordtype##########'+ vif.getBaseLicenseRecordTypeName());
      system.debug('#########recordtype##########'+ varianceRegs);
      if ((vif.getBaseLicenseRecordTypeName().toLowerCase().contains('new_license') == false) && (vif.getBaseLicenseRecordTypeName().toLowerCase().contains('change_of_admin') == false)){
	        Boolean variancesAlreadyTransferred = false;
	        // Loop through the existing items and see if one has already been copied for the transaction.
	      /*
	        for (Variance_on_Regulation__c variance : varianceRegs) {
	          if (variance.isCopied__c) {
	            variancesAlreadyTransferred = true;
	            break;
	          }
	        }
	        */
	        // If none have been transfered.
	        if (!variancesAlreadyTransferred) {
	          List<Contact_Role__c> latestNewTransVariancesList = [SELECT Contact__r.FirstName,contact__r.LastName,contact__r.MailingStreet,contact__r.MailingCity,contact__r.MailingPostalCode,contact__r.MailingState,contact__r.Phone,contact__r.Email,Start_Date__c,End_Date__c
           														   From Contact_Role__c ]; 
	                                                                          // ORDER BY Start_Date__c DESC NULLS FIRST];
	         /*
	          for (Contact_Role__c contactrole : latestNewTransVariancesList) {
	            variance.isCopied__c = true;
	            varianceInfoWrappers.add(new VarianceInfoWrap(variance, false));
	          }*/
	        }
	      }
	      
	      
	      // Place the ones specific to the transaction in this wrapper.  
	      for (Contact_Role__c contactroleReg : varianceRegs) {
	        ContactRoleInfoWrappers.add(new ContactRoleInfoWrap(contactroleReg, false));
	      }
        } catch(DMLException e) {
            system.debug('-----> Error with getVariancesList => populateContactRoleListWithTransaction: ' + e.getMessage());
        }
  }

  private void populateContactRoleList() {
    try {
      List<Contact_Role__c> ContactRoleRegs = [SELECT Contact__r.FirstName,contact__r.LastName,contact__r.MailingStreet,contact__r.MailingCity,contact__r.MailingPostalCode,contact__r.MailingState,contact__r.Phone,contact__r.Email,Start_Date__c,End_Date__c
          									   From Contact_Role__c 
                                                            /// Where Provider__c = :mAccount.Id
                                                             //AND Current__c = true ORDER BY Start_Date__c DESC NULLS FIRST
                                                             ];
      // Place the ones specific to the transaction in this wrapper.  
      for (Contact_Role__c ContactRoleReg : ContactRoleRegs) {
        ContactRoleInfoWrappers.add(new ContactRoleInfoWrap(ContactRoleReg, false));
      }
    } catch(DMLException e) {
      System.debug('-----> Error with getContactRoleList: ' + e.getMessage());
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
  public Boolean getContactRoleListCount() {
    system.debug('----> List count Enter');
    if (ContactRoleInfoWrappers != null) {
      return(ContactRoleInfoWrappers.size() > 0 ? true : false);
    } else {
      // IF the Interface is provided then proceed.
      if (vif != null && vif.getBaseLicenseTransaction() != null) {
        //Licensing_Transaction__c tempTrans = getNewestTransaction();
        //System.debug('----> tempTrans: ' + tempTrans);
        
        if ([SELECT Count() FROM Contact_Role__c 
             WHERE Provider__c = :vif.getBaseLicenseTransaction().Provider__c 
            // AND Source_Transaction__c = :vif.getBaseLicenseTransaction().Id
             ] > 0) 
             {
          return true;
        } else if ([SELECT Count() FROM Contact_Role__c 
                    WHERE Provider__c = :vif.getBaseLicenseTransaction().Provider__c 
                   // AND current__c = true
                    ] > 0) {
          return true;
        }
      } else {
        if ([SELECT Count() FROM Contact_Role__c WHERE Provider__c = :mAccount.Id 
      //  AND Current__c = true
        ] > 0) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * removeAddedVariance
   *
   * @description This function will remove from the wrapper list the passed in object id. This is only intended for newly added objects.
   * @author Latha Davuluri
   * @created 19 Jan 2017
   */
  public void removeAddedContactRole() {
    String wrapperId = ApexPages.currentPage().getParameters().get('wrapperId');
    system.debug('----> wrapperId: ' + wrapperId);
    system.debug('----> ContactRoleInfoWrappers: ' + ContactRoleInfoWrappers);
    Integer wrapperIndex;

    for (Integer i = 0; i < ContactRoleInfoWrappers.size(); i++) {
      ContactRoleInfoWrap varianceWrap = ContactRoleInfoWrappers.get(i);

      if (wrapperId.equalsIgnoreCase(String.valueOf(varianceWrap.wrapperId))) {
        wrapperIndex = i;
        break;
      }
    }

    if (wrapperIndex != null) {
      try {
        ContactRoleInfoWrappers.remove(wrapperIndex);
      } catch(Exception e) {
        system.debug('----> Could not remove index from Variance varianceInfoWrappers: ' + e.getMessage());
      }
    }
  }
  

  /**
   * addVariancesToList
   *
   * @description This function will add the new variance from the popup to the list.
   * @author Latha Davuluri
   * @created 18 Jan 2017
   * @return PageReference 
   */
  public PageReference addContactRoleToList() {
    String contactId = ApexPages.currentPage().getParameters().get('contactId');
    // This will retrieve the assistant information needed for the view. Sadly we have no way of attaching this to the object directly without inserting.
      	Contact contactInfo = [Select Id, Name  From Contact Where Id = :contactId LIMIT 1];
    // TODO: Ensure that the assistant has an VIF before attempting to use it. 
    // Create the new wrapper. 
    Contact_Role__c tempVarianceReg = new Contact_Role__c(	Contact__c = contactId);

    if (vif != null && vif.getBaseLicenseTransaction() != null) {
      tempVarianceReg.Provider__c = vif.getBaseLicenseTransaction().Provider__c;
     // tempVarianceReg.Source_Transaction__c = vif.getBaseLicenseTransaction().Id; 
    } else {
      tempVarianceReg.Provider__c = mAccount.Id;
    }
    
  
    
    system.debug('*****tempVarianceReg*****'+tempVarianceReg);
    ContactRoleInfoWrap newContactRoleWrapper = new ContactRoleInfoWrap(tempVarianceReg, true, contactInfo);
    newContactRoleWrapper.varianceReg.recalculateFormulas();

    Integer counter = 0;
    if (ContactRoleInfoWrappers != null && ContactRoleInfoWrappers.size() > 0) {
      // Determine the new wrapper ID to set for this new entry.
      for (ContactRoleInfoWrap wrapper : ContactRoleInfoWrappers) {
        if (wrapper.isNew) {
          counter++;
        }
      }
    }
    newContactRoleWrapper.wrapperId = counter + 1;

    if (ContactRoleInfoWrappers == null) {
      ContactRoleInfoWrappers = new List<ContactRoleInfoWrap> ();
    }
    ContactRoleInfoWrappers.add(newContactRoleWrapper);
    system.debug('----> ContactRoleInfoWrappers: ' + ContactRoleInfoWrappers);
    return null;
  }


  /**
   * getNewestTransaction
   *
   * @description This function will get the newest transaction based on criteia to copy over any exisiting variances for upgrades. 
   * @author Latha Davuluri
   * @created 18 Jan 2017
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
      Where Provider__c = :vif.getBaseLicenseTransaction().Provider__c
      AND Status__c IN('Submitted', 'To Submit', 'Under Review')
      ORDER BY LastModifiedDate DESC LIMIT 1
      ];
      mNewestTransaction = (tempTrans != null && tempTrans.size() == 1 ? tempTrans.get(0) : null);
    }
    system.debug('----> mNewestTransaction: ' + mNewestTransaction);
    return mNewestTransaction;
  }

  /**
   * VarianceInfoWrap
   *
   * @description This wrapper class will allow us to know which variances have just been added vs pre-populated.
   * @author Latha Davuluri
   * @created 18 Jan 2017
   */
  public class ContactRoleInfoWrap implements Comparable {

    public Contact_Role__c varianceReg { get; set; }
    public Contact regInfo { get; set; }
    public Boolean isNew { get; set; }
    public Integer wrapperId { get; set; }

    public ContactRoleInfoWrap(Contact_Role__c ContactRoleReg, Boolean isNew) {
      this.varianceReg = ContactRoleReg;
      this.isNew = isNew;
    }

    public ContactRoleInfoWrap(Contact_Role__c ContactRoleReg, Boolean isNew, Contact regInfo) {
      this.varianceReg = varianceReg;
      this.isNew = isNew;
      this.regInfo = regInfo;
    }

    // Compare opportunities based on the opportunity amount.
    public Integer compareTo(Object compareTo) {
      // Cast argument to OpportunityWrapper
      ContactRoleInfoWrap compareToObj = (ContactRoleInfoWrap) compareTo;

      // The return value of 0 indicates that both elements are equal.
      Integer returnValue = 0;
      /*
      if (varianceReg.Associated_Regulation__r.Name == compareToObj.varianceReg.Associated_Regulation__r.Name) {
        return 0;
      } else if (varianceReg.Associated_Regulation__r.Name == null && compareToObj.varianceReg.Associated_Regulation__r.Name != null) {
        returnValue = 1;
      } else if (varianceReg.Associated_Regulation__r.Name != null && compareToObj.varianceReg.Associated_Regulation__r.Name == null) {
        returnValue = - 1;
      } */
      return returnValue;  
    } 
    
  }
}