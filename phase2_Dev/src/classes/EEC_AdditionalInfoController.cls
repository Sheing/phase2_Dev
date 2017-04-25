public with sharing class EEC_AdditionalInfoController {

  private ApexPages.StandardController controller {get; set;}
  private Licensing_Transaction__c lt;

  public List<Additional_Information__c> otherLicensesHeld {get; set;}
  public List<Additional_Information__c> otherLicenseApps {get; set;}
  public List<Additional_Information__c> adminCriminalAction {get; set;}
  public List<Additional_Information__c> fedStateInvestigation {get; set;}

  public Boolean renderOtherLicenses {get; set;}
  public Boolean renderOtherApps {get; set;}
  public Boolean renderActions {get; set;}
  public Boolean renderInvestigations {get; set;}

    public EEC_AdditionalInfoController(ApexPages.StandardController controller) {
      this.controller = controller;
      this.lt = (Licensing_Transaction__c)controller.getRecord();

      List<Additional_Information__c> allAddInfoList = [SELECT Id, Name, RecordType.DeveloperName
                            , Name_of_Licensee__c, State_Country_Issuing_the_License__c, Type_of_License__c
                            , License_Number__c, Name_of_Applicant__c, Phone_No_of_Licensing_Authority__c
                            , State_Country_of_Applicant__c, Name_of_Licensing_Authority__c, Address_of_Licensing_authority__c 
                            , Address_of_court__c, Caption__c, Disposition__c, Docket_Number__c
                            , Name_Admin_civil_criminal_action__c, Name_of_court_or_administrative_body__c
                            , Name_of_Person_Agency_Investigated__c, Nature_of_Investigation__c
                            , State_and_or_Federal_Agency__c, Status_of_Application__c, Nature_of_Proceedings__c   
                            FROM Additional_Information__c 
                            WHERE Licensing_Transaction__c = :lt.Id];

      otherLicensesHeld = new List<Additional_Information__c>();
      otherLicenseApps = new List<Additional_Information__c>();
      adminCriminalAction = new List<Additional_Information__c>();
      fedStateInvestigation = new List<Additional_Information__c>();

      for(Additional_Information__c aInfo : allAddInfoList){
        System.debug('************* aInfo: ' + aInfo.RecordType.DeveloperName);
        if(aInfo.RecordType.DeveloperName == 'Other_Licenses_Held'){
          otherLicensesHeld.add(aInfo);
        } else if(aInfo.RecordType.DeveloperName == 'Other_License_Applications'){
          otherLicenseApps.add(aInfo);
        } else if(aInfo.RecordType.DeveloperName == 'Admin_civil_criminal_action_detail'){
          adminCriminalAction.add(aInfo);
        } else if(aInfo.RecordType.DeveloperName == 'State_federal_investigation_detail'){
          fedStateInvestigation.add(aInfo);
        }
      }

      renderOtherLicenses = !otherLicensesHeld.isEmpty();
      renderOtherApps = !otherLicenseApps.isEmpty();
      renderActions = !adminCriminalAction.isEmpty();
      renderInvestigations = !fedStateInvestigation.isEmpty();

    }
}