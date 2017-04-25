@IsTest 
global with sharing class EEC_MyProfileControllerTest {
    @IsTest    
    global static void testEEC_MyProfileController() {
        //RecordType r = [select Id from RecordType where DeveloperName='FCC' and sobjecttype='Account'];
        Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        Contact con = EEC_TestUtil.mockDirectorContact(accnt);
        Test.starttest(); 
        futuretestProcess(con.id);  
        test.stoptest();
    }
    
    @future
    public static void futuretestProcess(String conID){
        EEC_MyProfileController p1 = new EEC_MyProfileController();
        p1.getStates();
        p1.save();       
    }
}