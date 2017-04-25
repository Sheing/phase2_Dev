public class EEC_NavigationController {
    //variables
    public String currentPage;
    public String recordTypeName ;
    public String providerRecordTypeName;
    public Boolean initialized { get; set; }
    
    public void setcurrentPage (String s) {
        currentPage = s;
        if (!initialized) {
            initializeThatDependsOnReceivedString();
        }
      }
    
      public String getcurrentPage() {
        return currentPage;
      } 
   
    public void setrecordTypeName (String s) {
        recordTypeName = s;
        if (!initialized) {
            initializeThatDependsOnReceivedString();
        }
      }
    
      public String getrecordTypeName() {
        return recordTypeName;
      } 
     public void setproviderRecordTypeName (String s) {
        providerRecordTypeName = s;
         if (!initialized) {
            initializeThatDependsOnReceivedString();
        }
      }
    
      public String getproviderRecordTypeName() {
        return providerRecordTypeName;
      } 
    public List<NavigationWrapper> listNavigationWrapper{get;set;}
    
    public class NavigationWrapper{
        public string pageName{get;set;}
        public string nextPage{get;set;}
        public string previousPage{get;set;}
        public boolean selected{get;set;}
        public boolean passed{get;set;}
    }
    
    public map<string,list<string>> recordTypeAvailablePageMap = new map<string,list<String>>{'FCC_New_License' => new list<String>{'Instruction',
                                                                                                                                     'Transaction/Provider Info',
                                                                                                                                     'Individuals Regularly on Premise',
                                                                                                                                     'Licensing/Capacity Info',
                                                                                                                                     'Assistant Info',
                                                                                                                                     'Involvement & Professional Experience',
                                                                                                                                     'Background Information',
                                                                                                                                     'Training Information',
                                                                                                                                     'Indoor/Outdoor Space Info',
                                                                                                                                     'Technical Assistance',
                                                                                                                                     'Attachments',
                                                                                                                                     'Review & Submission'},
                                                                                                                       'FCC_License_Upgrade'=>
                                                                                                                               new list<String>{
                                                                                                                                 'Instruction',
                                                                                                                                 'Transaction/Provider Info',
                                                                                                                                 'Individuals Regularly on Premise',
                                                                                                                                 'Licensing/Capacity Info',
                                                                                                                                 'Assistant Info',
                                                                                                                                 'Background Information',
                                                                                                                                 'Training Information',
                                                                                                                                 'Indoor/Outdoor Space Info',
                                                                                                                                 'Technical Assistance',
                                                                                                                                 'Attachments',
                                                                                                                                 'Review & Submission'
                                                                                                                               },
                                                                                                                             'Change_of_Address' => new list<String>{
                                                                                                                                 'Instruction',
                                                                                                                                 'Transaction/Provider Info',
                                                                                                                                 'Individuals Regularly on Premise',
                                                                                                                                 'Indoor/Outdoor Space Info',
                                                                                                                                 'Technical Assistance',
                                                                                                                                 'Review & Submission'
                                                                                                                             },
                                                                                                                             'FCC_Change_Room_Floor_Level'=>new list<String>{
                                                                                                                                 'Instruction',
                                                                                                                                 'Transaction/Provider Info',
                                                                                                                                 'Indoor/Outdoor Space Info',
                                                                                                                                 'Technical Assistance',
                                                                                                                                 'Review & Submission'
                                                                                                                             },
                                                                                                                             'FCC_Change_of_Household' =>new list<String>{
                                                                                                                                 'Instruction',
                                                                                                                                 'Transaction/Provider Info',
                                                                                                                                 'Individuals Regularly on Premise',
                                                                                                                                 'Technical Assistance',
                                                                                                                                 'Review & Submission'
                                                                                                                             },
                                                                                                                             'FCC_Renewal'=> new list<String>{
                                                                                                                                 'Instruction',
                                                                                                                                 'Transaction/Provider Info',
                                                                                                                                 'Individuals Regularly on Premise',
                                                                                                                                 'Licensing/Capacity Info',
                                                                                                                                 'Assistant Info',
                                                                                                                                 'Background Information',
                                                                                                                                 'Training Information',
                                                                                                                                 'Indoor/Outdoor Space Info',
                                                                                                                                 'Technical Assistance',
                                                                                                                                 'Attachments',
                                                                                                                                 'Review & Submission'                     
                                                                                                                             },
                                                                                                                             'FCC_Assistant_License_Upgrade' => new list<String>{
                                                                                                                                 'Instruction',
                                                                                                                                 'Transaction/Provider Info',
                                                                                                                                 'Involvement & Professional Experience',
                                                                                                                                 'Background Information',
                                                                                                                                 'Training Information',
                                                                                                                                 'Review & Submission'
                                                                                                                             },
                                                                                                                             'FCC_Assistant_New_License'=> new list<String>{
                                                                                                                                 'Instruction',
                                                                                                                                 'Transaction/Provider Info',
                                                                                                                                 'Involvement & Professional Experience',
                                                                                                                                 'Daily Routine & Activities',
                                                                                                                                 'Background Information',
                                                                                                                                 'Training Information',
                                                                                                                                 'Review & Submission'
                                                                                                                             },
                                                                                                                             'FCC_Assistant_Renewal'=> new list<String>{
                                                                                                                                 'Instruction',
                                                                                                                                 'Transaction/Provider Info',
                                                                                                                                 'Involvement & Professional Experience',
                                                                                                                                 'Daily Routine & Activities',
                                                                                                                                 'Background Information',
                                                                                                                                 'Training Information',
                                                                                                                                 'Review & Submission'
                                                                                                                               }
                                                                                                                               };
      public map<string,list<string>> GSArecordTypeAvailablePageMap = new map<string,list<String>>{'GSA_New_License' => new list<String>{'Instruction',
                                                                                                                                     'Transaction/Provider Info',
                                                                                                                                     'Ownership and Administrator information',
                                                                                                                                     'Designation of Administrative Responsibility',
                                                                                                                                     'Capacity Information',
                                                                                                                                     'Operation details Information',
                                                                                                                                     'Indoor/Outdoor Space Info',
                                                                                                                                     'Technical Assistance',
                                                                                                                                     'Attachments',
                                                                                                                                     'Review & Submission'},
                                                                                                                    'GSA_Renewal'=>
                                                                                                                     new list<String>{  'Instruction',
                                                                                                                                     'Transaction/Provider Info',
                                                                                                                                     'Ownership and Administrator information',
                                                                                                                                     'Designation of Administrative Responsibility',
                                                                                                                                     'Capacity Information',
                                                                                                                                     'Operation details Information',
                                                                                                                                     'Indoor/Outdoor Space Info',
                                                                                                                                     'Technical Assistance',
                                                                                                                                     'Attachments',
                                                                                                                                     'Review & Submission'}, 
                                                                                                                     'GSA_License_Change'=>
                                                                                                                      new list<String>{  'Instruction',
                                                                                                                                     'Transaction/Provider Info', 
                                                                                                                                     'Capacity Information',                                                                                                                     
                                                                                                                                     'Operation details Information',
                                                                                                                                     'Indoor/Outdoor Space Info',
                                                                                                                                     'Technical Assistance',
                                                                                                                                     'Attachments',
                                                                                                                                     'Review & Submission'},
                                                                                                                      'GSA_Move'=>
                                                                                                                        new list<String>{ 'Instruction',
                                                                                                                                     'Transaction/Provider Info',
                                                                                                                                     'Ownership and Administrator information',
                                                                                                                                     'Designation of Administrative Responsibility',
                                                                                                                                     'Capacity Information',
                                                                                                                                     'Operation details Information',
                                                                                                                                     'Indoor/Outdoor Space Info',
                                                                                                                                     'Technical Assistance',
                                                                                                                                     'Attachments',
                                                                                                                                     'Review & Submission'},
                                                                                                                       'GSA_Change_of_Admin_Authority'=> 
                                                                                                                        new list<String>{ 'Instruction',
                                                                                                                                     'Transaction/Provider Info',
                                                                                                                                     'Ownership and Administrator information',
                                                                                                                                     'Designation of Administrative Responsibility',
                                                                                                                                      'Technical Assistance',
                                                                                                                                     'Attachments',
                                                                                                                                     'Review & Submission'},
                                                                                                                       'Variance_On_Regulation_Request'=>
                                                                                                                        new list<String>{
                                                                                                                                     'Instruction',
                                                                                                                                     'Transaction/Provider Info',
                                                                                                                                      'Technical Assistance',
                                                                                                                                      'Attachments',
                                                                                                                                      'Review & Submission'}};
       public map<string,list<string>> RPrecordTypeAvailablePageMap = new map<string,list<String>>{'Residential_New_License' => new list<String>{'Instruction',
                                                                                                                                     'Transaction/Provider Info',
                                                                                                                                      'Ownership and Administrator information',
                                                                                                                                      'Residential Program Details',
                                                                                                                                      'Technical Assistance',
                                                                                                                                      'Attachments',
                                                                                                                                      'Review & Submission'},
                                                                                                                 'Residential_License_Renewal'=>
                                                                                                                        new list<String>{'Instruction',
                                                                                                                                     'Transaction/Provider Info',
                                                                                                                                      'Ownership and Administrator information',
                                                                                                                                      'Residential Program Details',
                                                                                                                                      'Technical Assistance',
                                                                                                                                      'Attachments',
                                                                                                                                      'Review & Submission'}, 
                                                                                                                 'Residential_Change_in_License'=>
                                                                                                                        new list<String>{'Instruction',
                                                                                                                                     'Transaction/Provider Info',
                                                                                                                                      
                                                                                                                                      'Residential Program Details',
                                                                                                                                      'Technical Assistance',
                                                                                                                                      'Attachments',
                                                                                                                                      'Review & Submission'},
                                                                                                                 'Residential_Move'=>
                                                                                                                        new list<String>{'Instruction',
                                                                                                                                     'Transaction/Provider Info',
                                                                                                                                      'Ownership and Administrator information',
                                                                                                                                      'Residential Program Details',
                                                                                                                                      'Technical Assistance',
                                                                                                                                      'Attachments',
                                                                                                                                      'Review & Submission'},
                                                                                                                 'R_P_Change_of_Admin_Authority'=>
                                                                                                                        new list<String>{'Instruction',
                                                                                                                                     'Transaction/Provider Info',
                                                                                                                                      'Ownership and Administrator information',
                                                                                                                                       'Technical Assistance',
                                                                                                                                      'Attachments',
                                                                                                                                      'Review & Submission'},
                                                                                                                'Placement_New_License'=>
                                                                                                                        new list<String>{'Instruction',
                                                                                                                                     'Transaction/Provider Info',
                                                                                                                                      'Ownership and Administrator information',
                                                                                                                                      'Placement Agency Additional info',
                                                                                                                                       'Technical Assistance',
                                                                                                                                      'Attachments',
                                                                                                                                      'Review & Submission'}, 
                                                                                                                 'Placement_Renewal'=>
                                                                                                                        new list<String>{'Instruction',
                                                                                                                                     'Transaction/Provider Info',
                                                                                                                                      'Ownership and Administrator information',
                                                                                                                                      'Placement Agency Additional info',
                                                                                                                                      'Technical Assistance',
                                                                                                                                      'Attachments',
                                                                                                                                      'Review & Submission'},
                                                                                                                 'Placement_Change_in_License'=>
                                                                                                                        new list<String>{'Instruction',
                                                                                                                                     'Transaction/Provider Info',
                                                                                                                                      'Placement Agency Additional info',
                                                                                                                                      'Technical Assistance',
                                                                                                                                      'Attachments',
                                                                                                                                      'Review & Submission'}, 
                                                                                                                 'Placement_Move'=>
                                                                                                                        new list<String>{'Instruction',
                                                                                                                                     'Transaction/Provider Info',
                                                                                                                                      'Ownership and Administrator information',
                                                                                                                                      'Placement Agency Additional info',
                                                                                                                                      'Technical Assistance',
                                                                                                                                      'Attachments',
                                                                                                                                      'Review & Submission'},
                                                                                                                    'Variance_On_Regulation_Request'=>
                                                                                                                        new list<String>{
                                                                                                                                     'Instruction',
                                                                                                                                       'Transaction/Provider Info',  
                                                                                                                                      'Technical Assistance',
                                                                                                                                      'Attachments',
                                                                                                                                      'Review & Submission'}};
                                                                                                                            
    //Constructor
    public EEC_NavigationController(){
        initialized = false;
    }
    
    private void initializeThatDependsOnReceivedString(){
        listNavigationWrapper = new List<NavigationWrapper>();
        List<string> listSteps;

        if(providerRecordTypeName != null && recordTypeName != null && currentPage != null){
            initialized = true;
            if(providerRecordTypeName == 'Family Child Care' || providerRecordTypeName == 'FCC Assistant'){
               listSteps = recordTypeAvailablePageMap.get(recordTypeName);
            }
            else if(providerRecordTypeName == 'Large Group' || providerRecordTypeName == 'Small Group' || providerRecordTypeName == 'Large and Small Group Umbrella'){
                listSteps = GSArecordTypeAvailablePageMap.get(recordTypeName);
            }
            else if(providerRecordTypeName == 'R&P Umbrella' || providerRecordTypeName == 'Temporary Shelter' || providerRecordTypeName == 'Group Care'
                    || providerRecordTypeName == 'Foster Care Agency' || providerRecordTypeName == 'Adoption Agency'){
                listSteps = RPrecordTypeAvailablePageMap.get(recordTypeName);
            }
            system.debug('recordTypeName: ' + recordTypeName);
            system.debug('listSteps: ' + listSteps);
            boolean IsCurrentPassed = false;
            integer iCurrent = 0;
            if(listSteps != null){
            for(integer iCount = 0; iCount < listSteps.size(); iCount++){
                NavigationWrapper NavigationWrapper = new NavigationWrapper();
                NavigationWrapper.pageName = listSteps[iCount];
                if(listSteps[iCount] != currentPage && IsCurrentPassed == false){
                    NavigationWrapper.selected = false;
                    NavigationWrapper.passed = true;
                    NavigationWrapper.previousPage = '';
                    NavigationWrapper.nextPage = '';
                }
                else if(listSteps[iCount] != currentPage && IsCurrentPassed == true){
                    NavigationWrapper.selected = false;
                    NavigationWrapper.passed = false;
                    NavigationWrapper.previousPage = '';
                    NavigationWrapper.nextPage = '';
                }
                else if(listSteps[iCount] == currentPage){
                    NavigationWrapper.selected = true;
                    NavigationWrapper.passed = false;
                    IsCurrentPassed = true;
                }
                if(!IsCurrentPassed)
                    iCurrent++;
                listNavigationWrapper.add(NavigationWrapper);
            }
            system.debug('listNavigationWrapper: ' + listNavigationWrapper);
            for(integer iCount = 0; iCount < listNavigationWrapper.size(); iCount++){
                //if(iCount == iCurrent - 1 && iCurrent > 0){
                if(iCurrent > 0 && iCount < iCurrent){
                    listNavigationWrapper[iCount].previousPage = listSteps[iCount];
                }
                else if(iCount == iCurrent + 1 && iCurrent < listNavigationWrapper.size() - 1){
                    listNavigationWrapper[iCount].nextPage = listSteps[iCount];
                }
            }
            }
        }
    }
}