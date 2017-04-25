public class UserManagementCtrl {

  public Contact contact { get; set; }
  public User user { get; set; }
  public List<UM_PageReferenceParamsWrapper> pageRefParams { get; set; }

  public UserManagementCtrl() {
    user = [Select Id, ContactId, FirstName, LastName, Title, Email, Phone, MobilePhone, City, Country, PostalCode, Street, Department, Fax From User Where Id = :UserInfo.getUserId()];

    if (String.isNotBlank(user.ContactId)) {
      contact = [Select Id, Title, Salutation, FirstName, LastName, MobilePhone, Email, MailingCity, MailingState, MailingCountry, MailingPostalCode, MailingStreet, OtherCity, OtherState, OtherCountry, OtherPostalCode, OtherStreet, Phone, HomePhone, Fax, Department, Extension__c From Contact Where Id = :user.ContactId];

      if (String.isBlank(contact.Email)) {
        contact.Email = user.Email;
      }
    }
  }

  public PageReference save() {
    try {
      // If the contact exists then update it. 
      if (contact != null) {
        update contact;
        // Update the user.
        user.Title = contact.title;
        user.FirstName = contact.firstName;
        user.LastName = contact.lastName;
        user.City = contact.MailingCity;
        user.State = contact.MailingState;
        user.Country = contact.MailingCountry;
        user.PostalCode = contact.MailingPostalCode;
        user.Street = contact.MailingStreet;
        user.Phone = contact.phone;
        user.Department = contact.department;
        user.Fax = contact.fax;
        user.MobilePhone = contact.MobilePhone;
        user.Extension = contact.Extension__c;

        if (contact.email != null && user.Email != contact.Email) {
          user.Email = contact.email;
        }
      }
      update user;
    } catch(Exception e) {
      System.debug('----> Error updating Contact/User: ' + e.getMessage());
    }
    // Check to see if the redirect page is set.
    if (pageRefParams != null && pageRefParams.size() > 0) {
      System.debug('----> pageRefParams: ' + pageRefParams);
      String pageToRedirect = '';
      Integer counter = 0;

      for (UM_PageReferenceParamsWrapper paramWrapper : pageRefParams) {
        if (paramWrapper.key == 'page') {
          pageToRedirect = paramWrapper.value;
          pageRefParams.remove(counter);
          break;
        }
        counter++;
      }

      PageReference pPage = new PageReference('/apex/' + pageToRedirect);
      // If we have page params to attach then loop through them and attach them to the page.
      if (pageRefParams != null && pageRefParams.size() > 0) {
        for (UM_PageReferenceParamsWrapper paramWrapper : pageRefParams) {
          pPage.getParameters().put(paramWrapper.key, paramWrapper.value);
        }
      }
      // Redirect the user to force a loss of state. 
      pPage.setRedirect(true);
      return pPage;
    }
    return null;
  }
}