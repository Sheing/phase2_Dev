public with sharing class EEC_LEADAdminToolsController {
	
	//Load FCC DL Tools
        public void loadFCCDLTools() {
            Database.executeBatch(new EEC_Batch_LoadFCCDLTools(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Loading FCC Differential Licensing Tools...Please wait... !!!'));
         } 
         
          //Load GSA DL Tools
        public void loadGSADLTools() {
            Database.executeBatch(new EEC_Batch_LoadGSADLTools(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Loading GSA DL Tool...Please wait... !!!'));
         }   
         
         //Load Residential DL Tools
        public void loadResidentialDLTools() {
            Database.executeBatch(new EEC_Batch_LoadResidentialTools(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Loading Residential DL Tools...Please wait... !!!'));
         }  
         
          //Load Residential DL Tools
        public void loadPlacementDLTools() {
            Database.executeBatch(new EEC_Batch_LoadPlacementTools(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Loading Placement DL Tools...Please wait... !!!'));
         } 
}