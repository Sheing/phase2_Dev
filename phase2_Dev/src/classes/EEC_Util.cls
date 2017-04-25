/**
 * EEC_Util
 * 
 * This class is a place meant for all generic functions that will be shared accross the application.
 * @author Darkis
 * @testClass EEC_TestUtil
 */ 
public class EEC_Util {
    
  private static final Blob cryptoKey = Blob.valueOf('HZxE4kqHZg5RQbQA');

   public static Map<String, PageReference> lastStepMap = new Map<String, PageReference> {
      'Daily Routine and Activities' => Page.EEC_TechnicalAssistance,
      'Instructions' => Page.EEC_TransactionInstructions,
      'Transaction / Provider Information' => Page.EEC_TransactionProvider,
      'Residential Program Details' => Page.EEC_TransactionProvider,
      'Placement Agency Additional Information' => Page.EEC_TransactionProvider,
      'Corporation and Administrator Info' => Page.EEC_TransactionProvider,
      'Household Members' => Page.EEC_HouseHoldMembers,
      'Licensing Status and Capacity' => Page.EEC_LicenseStatusCapacityInfo,
      'Assistant Information' => Page.EEC_Transaction_AssistantInfo,
      'EEC Involvement Experience & Professional Exp.' => Page.EEC_InvolvementExperience,
      'Background Information' => Page.EEC_BackgroundInformation,
      'Training Information' => Page.EEC_TrainingInformation,
      'Indoor / Outdoor space information' => Page.EEC_IndoorSpacePage,
      'Daily Routine Activities / Technical Assistance' => Page.EEC_TechnicalAssistance,
      'Attachments' => Page.EEC_LicensingAttachment,
      'Review Summary and Submission' => Page.EEC_ReviewSummarySubmission,
      'Daily Routine & Activities' => Page.EEC_Transaction_DailyRandA,
      'Assistant Review Summary and Submission' => Page.EEC_ReviewSummarySubmissionAssistant,
      'Designation of Admin Responsilibity' =>Page.EEC_DesignationOfAdministrative,
      'Operation Details' =>Page.EEC_OperationDetailInfo,
      'Capacity Information' =>Page.eec_capacityinformation,
      'Capacity Info' =>Page.EEC_TransactionProvider,
      'Licensee Information page' =>Page.EEC_OwnershipAdministratorInfo,
      'Techincal Assistance Info' =>Page.EEC_TechnicalAssistance,
      'Residential Program Details' =>Page.EEC_TransactionProvider,
      'Placement Agency Additional Information' =>Page.EEC_TransactionProvider,
      'Residential Program Detail'=>Page.EEC_ResidentialProgramDetail,
      'Indoor / Outdoor space info'=>Page.eec_indoorspacegsapage,
      'Placement Agency Additional Info'=>Page.EEC_PlacementAgency
  };
          //FCC and FCC_Assistant map
  public static Map<String, PageReference> lastFCCStepMap = new Map<String, PageReference> {
      'Instruction' => Page.EEC_transactioninstructions,
      'Transaction/Provider Info' => Page.EEC_transactionprovider,
      'Individuals Regularly on Premise' => Page.EEC_householdmembers,
      'Licensing/Capacity Info' => Page.EEC_licensestatuscapacityinfo,
      'Involvement & Professional Experience' => Page.EEC_AssistantInvolvementExperience,
      'Background Information' => Page.EEC_BackgroundInformation,
      'Training Information' => Page.EEC_TrainingInformation,
      'Indoor/Outdoor Space Info' => Page.eec_indoorspacepage,
      'Technical Assistance' => Page.EEC_TechnicalAssistance,
      'Attachments' => Page.EEC_licensetransactionattachments,
      'Review & Submission' => Page.EEC_ReviewSummarySubmission,
      'Daily Routine & Activities' => Page.EEC_Transaction_DailyRandA
      
  };
     //GSA  map
   public static Map<String, PageReference> lastGSAStepMap = new Map<String, PageReference> {
      'Instruction' => Page.EEC_transactioninstructions,
      'Transaction/Provider Info' => Page.EEC_transactionprovider,
      'Ownership and Administrator information' => Page.EEC_ownershipadministratorinfo,
      'Designation of Administrative Responsibility' => Page.EEC_designationofadministrative,
      'Capacity Information' => Page.EEC_capacityinformation,
      'Operation details Information' => Page.EEC_operationdetailinfo,
      'Indoor/Outdoor Space Info' => Page.EEC_indoorspacegsapage,
      'Technical Assistance' => Page.eec_technicalassistance,
      'Attachments' => Page.EEC_licensingattachment,
      'Review & Submission' => Page.EEC_gsareviewsummary
  };
         //RP  map
   public static Map<String, PageReference> lastRPStepMap = new Map<String, PageReference> {
      'Instruction' => Page.EEC_transactioninstructions,
      'Transaction/Provider Info' => Page.EEC_transactionprovider,
      'Ownership and Administrator information' => Page.EEC_ownershipadministratorinfo,
      'Residential Program Details' => Page.EEC_ResidentialProgramDetail,
      'Technical Assistance' => Page.EEC_TechnicalAssistance,
      'Attachments' => Page.EEC_licensingattachment,
      'Review & Submission' => Page.EEC_rp_reviewsummary,
      'Placement Agency Additional info' => Page.EEC_PlacementAgency
  };
  
  public Static Map<String, String> recordTypeMap = new Map<String, String> {
    'Apply for a New License' => 'FCC_New_License',
    'Apply for License Renewal' => 'FCC_Renewal',
    'Apply for an License Upgrade' => 'FCC_License_Upgrade',
    'Apply for a Change of Address' => 'Change_of_Address',
    'Notify Change of Room usage' => 'FCC_Change_Room_Floor_Level',
    'Notify Change in Household / Individuals Regularly on the Premises' => 'FCC_Change_of_Household',
    'Request Re-issuance of License Certificate' => 'Re_issuance_of_License_Cert',
    'Re-Activate License' => 'FCC_Re_Active',
    'De-Activate License' => 'FCC_Inactivate',
    'Close Prior Expiration' => 'Close_Prior_Expiration'
  };

  public Static Map<String, String> assistantRecordTypeMap = new Map<String, String> {
    'Apply for an License Upgrade' => 'FCC_Assistant_License_Upgrade',
    'Apply for a New License' => 'FCC_Assistant_New_License',
    'Apply for Renewal' => 'FCC_Assistant_Renewal',
    'Request Re-issuance of License Certificate' => 'Re_issuance_of_License_Cert',
    'Re-Activate License' => 'FCC_Re_Active',
    'De-Activate License' => 'FCC_Inactivate'
  };

  public static String encryptGetParam(String param) {
    return EncodingUtil.urlEncode(EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES128', EEC_Util.cryptoKey, Blob.valueOf(param))),'UTF-8');     
  }
    
  public static String decryptGetParam(String param) {
    Blob paramBlob = EncodingUtil.base64Decode(param);
    return Crypto.decryptWithManagedIV('AES128', EEC_Util.cryptoKey, paramBlob).toString();
  }

  /**
  * addMemberIDPageParameter
  *
  * @description This function will encrypt an account Id if necessary and attach it to the given PageReference.
  * @author Darkis
  * @created 26 Jan 2016
  * @param accountId The account ID that may need to be encrytped. 
  * @param pPage PageReference The desired destination. 
  * @param encrypt Boolean A flag to tell the function to encrypt the param or not. 
  * @return PageReference 
  */
  public static PageReference addMemberIDPageParameter(String accountId, PageReference pPage, Boolean encrypt) {
    if (String.isNotBlank(accountId)) {
      pPage.getParameters().put('member', (encrypt ? EEC_Util.encryptGetParam(accountId) : accountId));
    }
    return pPage;
  }
  /**
   * Change the lookup for city into select option
   * @author Bemnet  
   * 
   */
  
  public static EEC_PaginatedSelectList allCityList(){
    EEC_PaginatedSelectList allCityList = new EEC_PaginatedSelectList();
        for (City__c c :[select id, Name, State__c from City__c where isdeleted = false order by Name]) {
          allCityList.add(new SelectOption(c.id, c.name + ' (' + c.State__c + ')'));
        }
        return allCityList;
  }
  public static EEC_PaginatedSelectList maCityList(){
      EEC_PaginatedSelectList maCityList = new EEC_PaginatedSelectList();
    for (City__c c :[select id, Name, State__c from City__c where State__c = 'MA' AND isdeleted = false order by Name]) {
       maCityList.add(new SelectOption(c.id, c.name + ' (' + c.State__c + ')'));
    }
    return maCityList;
  } 
  
  //Email notification when a Batch job processes
  public static void batchEmailSuccess(Database.BatchableContext apexJob, string apexJobName){
        
        string messageBody;
        string messageSubject;
        messageSubject = 'Apex Batch Job '+ apexJobName + ' is Complete';
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                     TotalJobItems, CreatedBy.Email
                                     from AsyncApexJob where Id =:apexJob.getJobId()];
            
        messageBody ='<html><body><h2>The batch apex job '+ apexJobName +' processed successfully.</h2><br/><br/>';
        messageBody = messageBody + 'Job Id:- '+ a.Id +'<br/>';
        messageBody = messageBody + 'No of Errors:- '+ a.NumberOfErrors +'<br/>';
        messageBody = messageBody + 'Job Items Processed:- '+ a.JobItemsProcessed + '<br/>';
        messageBody = messageBody + 'Total Job Items:- '+ a.TotalJobItems + '<br/></body></html>';
              
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
        String[] toAddresses = new String[]{a.CreatedBy.Email};

      
            if (toAddresses.size() > 0){
              mail.setToAddresses(toAddresses);
            }
        mail.setSubject(messageSubject);
        mail.setHtmlBody(messageBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});    
     } 
     public static void batchEmailFailure(Database.BatchableContext apexJob, String apexJobName, string errorMessage){
        
        String messageBody = '';
        String messageSubject = '';
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                     TotalJobItems, CreatedBy.Email
                                     from AsyncApexJob where Id =:apexJob.getJobId()];
        messageSubject = 'Apex Batch Job '+ apexJobName + ' failed';

            
        messageBody ='<html><body><h2>The batch apex job '+ apexJobName +' failed. Here is the error message;</h2><br/><br/>';
        messageBody = messageBody + '\t' + errorMessage +'<br/>';
              
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
        String[] toAddresses = new String[]{a.CreatedBy.Email};

      
            if (toAddresses.size() > 0){
              mail.setToAddresses(toAddresses);
            }
        mail.setSubject(messageSubject);
        mail.setHtmlBody(messageBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});    
     }  
     
    @InvocableMethod(label='Quick Exit' description='Doesn\'t do anything, just a short cut to exit a Process Flow')
    public static void QuickExit() {  }    
}