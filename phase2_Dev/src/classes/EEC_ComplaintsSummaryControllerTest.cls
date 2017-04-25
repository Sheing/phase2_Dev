@isTest
public class EEC_ComplaintsSummaryControllerTest {
 
    @isTest
    static void testQuestions() {
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        EEC_ComplaintsSummaryController cic = new EEC_ComplaintsSummaryController(); 
        
        System.assertEquals(cic.getComplaintFilling(),  EEC_QuestionService.complaintFilling); 
        System.assertEquals(cic.getComplaintShared(),  EEC_QuestionService.complaintSharedProvider); 
        System.assertEquals(cic.getComplaintOther(),  EEC_QuestionService.complaintInformationOtherQuestions); 
        System.assertEquals(cic.getComplaintQuestions(),  EEC_QuestionService.complaintInfoDescrQuestions); 
        System.assertEquals(cic.getInvolvedQuestions().size(),  EEC_QuestionService.complaintInfoInvolvedQuestions().size());
        System.assertEquals(cic.getProviderInformationQuestions(), EEC_QuestionService.complaintSummaryProvider);
        
        EEC_Question question = new EEC_EmptyQuestion();
        question.getQuestionType();
        
    } 
     
    @isTest
    static void testmet(){} 
    @isTest
    static void testGetReporterQuestions() {
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        EEC_ComplaintsSummaryController cic = new EEC_ComplaintsSummaryController(); 
        List<EEC_Question> reporterQuestions = cic.getReporterQuestions();
        
        List<EEC_Question> questions = EEC_QuestionService.complaintReporterInfoQuestion;
        questions.addAll(EEC_QuestionService.complaintReporterAddressQuestion);
        questions.addAll(EEC_QuestionService.complaintReporterContactQuestion);
        cic.backPage();
        cic.submit();
        System.assertEquals(reporterQuestions.size(), questions.size());
        
        EEC_Question question = new EEC_SimpleQuestion('Name', 'First and Last Name');
        question.getConditions();
        question.getQuestionType();
        question.getFirstCondition();
        question.getSecondCondition();
        question.addLessThenCondition('test','test');
        question.getIsRequired();
        question.getHideOnLicensingType();
    }

}