@isTest
public with sharing class EEC_TestGenerateVisitChecklistExtension {

  @isTest static void testVisitChecklistItemWrapperConstruct() {
    Inspection_Item__c i = new Inspection_Item__c();
    String s = 'test';

    EEC_GeneratePDFBase.VisitChecklistItemWrapper vciwc = new
    EEC_GeneratePDFBase.VisitChecklistItemWrapper(i, s);

    System.assertEquals(vciwc.inspectionItem, i);
    System.assertEquals(vciwc.standardRegulations, s);
  }

  @isTest static void testAugmentStandardInspectionItems() {
    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    Standard_Inspection_Item__c sii1 = EEC_TestUtil.mockStdInspectionItem();
    Regulation__c reg1 = EEC_TestUtil.mockRegulation();
    Regulation__c reg2 = EEC_TestUtil.mockRegulation();
    EEC_TestUtil.mockRegStdInsp(reg1, sii1);
    EEC_TestUtil.mockRegStdInsp(reg2, sii1);
    Inspection_Item__c ii1 = EEC_TestUtil.mockInspectionItem(i, sii1, 'Non-Compliant', false, null);
    Inspection_Item__c ii2 = EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null);
    List<EEC_GeneratePDFBase.VisitChecklistItemWrapper> l = EEC_GeneratePDFBase.augmentStandardInspectionItems(new List<Inspection_Item__c> { ii1, ii2 });

    System.assertEquals(2, l.size());
    System.assertEquals(reg1.Name + ', ' + reg2.Name, l.get(0).standardRegulations);
    System.assertEquals('', l.get(1).standardRegulations);
  } 

  @isTest static void testGetAssessedStandardInspectionItems() {
    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
    List<Inspection_Item__c> iItemsList = new List<Inspection_Item__c>();

    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null));
    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, 'HJelp'));
    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, EEC_TestUtil.mockRegulation(), null, true, null));
    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, stdIi, 'Non-Compliant', false, null));
    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, stdIi, 'Non-Compliant', false, 'Helo'));
    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, stdIi, 'Compliant', true, null));
    upsert iItemsList;
    EEC_GenerateVisitChecklistExtension ext = new EEC_GenerateVisitChecklistExtension(new ApexPages.StandardController(i));

    Test.startTest();
    List<EEC_GeneratePDFBase.VisitChecklistItemWrapper> l = ext.getAssessedStandardInspectionItems();
    System.assertEquals(4, l.size());
    Test.stopTest();
  }

  @isTest static void testGetUnassessedStandardInspectionItems() {
    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
    List<Inspection_Item__c> iItemsList = new List<Inspection_Item__c>();

    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null));
    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, 'HJelp'));
    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, EEC_TestUtil.mockRegulation(), null, true, null));
    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, stdIi, 'Non-Compliant', false, null));
    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, stdIi, 'Non-Compliant', false, 'Helo'));
    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, stdIi, null, false, null));
    upsert iItemsList;
    EEC_GenerateVisitChecklistExtension ext = new EEC_GenerateVisitChecklistExtension(new ApexPages.StandardController(i));

    Test.startTest();
    List<EEC_GeneratePDFBase.VisitChecklistItemWrapper> l = ext.getUnassessedStandardInspectionItems();
    System.assertEquals(1, l.size());
    Test.stopTest();
  }

  @isTest static void testGetAdditionalInspectionItems() {
    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
    List<Inspection_Item__c> iItemsList = new List<Inspection_Item__c>();

    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null));
    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, 'HJelp'));
    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, EEC_TestUtil.mockRegulation(), null, true, null));
    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, stdIi, 'Non-Compliant', false, null));
    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, stdIi, 'Non-Compliant', false, 'Helo'));
    iItemsList.add(EEC_TestUtil.mockInspectionItemWithoutInsert(i, stdIi, null, true, null));
    upsert iItemsList;

    EEC_GenerateVisitChecklistExtension ext = new EEC_GenerateVisitChecklistExtension(new ApexPages.StandardController(i));

    Test.startTest();
    List<EEC_GeneratePDFBase.VisitChecklistItemWrapper> l = ext.getAdditionalInspectionItems();

    System.assertEquals(2, l.size(), 2);
    Test.stopTest();
  }

  @isTest static void testGetHasNonCompliantTrue() {
    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
    EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null);
    EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Compliant', false, null);
    EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Not Applicable', false, null);
    EEC_GenerateVisitChecklistExtension ext = new EEC_GenerateVisitChecklistExtension(new ApexPages.StandardController(i));

    System.assertEquals(true, ext.getHasNonCompliant());
  }
  @isTest static void testGetHasNonCompliantFalse() {
    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
    EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Compliant', false, null);
    EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Not Applicable', false, null);
    EEC_GenerateVisitChecklistExtension ext = new EEC_GenerateVisitChecklistExtension(new ApexPages.StandardController(i));

    System.assertEquals(false, ext.getHasNonCompliant());
  }

  @isTest static void testGetVisitBestPracticesFalse() {
    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    EEC_GenerateVisitChecklistExtension ext = new EEC_GenerateVisitChecklistExtension(new ApexPages.StandardController(i));

    System.assertEquals(0, ext.getVisitBestPractices().size());
  }

  @isTest static void testGetVisitBestPracticesTrue() {
    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    Visit_Best_Practices__c vbp = EEC_TestUtil.mockVisitBestPractice(i, EEC_TestUtil.mockStdBestPractice());
    EEC_GenerateVisitChecklistExtension ext = new EEC_GenerateVisitChecklistExtension(new ApexPages.StandardController(i));

    System.assertEquals(1, ext.getVisitBestPractices().size());
  }

  @isTest static void testGetVisitOutcomesSummary() {
    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
    EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null);
    EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Compliant', false, null);
    EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Not Applicable', false, null);
    EEC_GenerateVisitChecklistExtension ext = new EEC_GenerateVisitChecklistExtension(new ApexPages.StandardController(i));

    System.assertEquals(new Set<String>{null}, ext.getVisitOutcomesSummary());  
  }

  @isTest static void testAvailablities() {
    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
    EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null);
    EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Compliant', false, null);
    EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Not Applicable', false, null);
    EEC_GenerateVisitChecklistExtension ext = new EEC_GenerateVisitChecklistExtension(new ApexPages.StandardController(i));

    System.assert(!ext.getTechnicalAssistanceAvailable()); 
    System.assert(ext.getComplaintAvailable()); 
    System.assert(ext.getNonComplaintAvailable()); 
  }

  @isTest static void testGetTypeOfVisitHeaderTextMonitoring() {
    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    i.Type_of_Visit__c = 'Enhanced Monitoring';
    update i;
    EEC_GenerateVisitChecklistExtension ext = new EEC_GenerateVisitChecklistExtension(new ApexPages.StandardController(i));

    System.assertEquals('', ext.getTypeOfVisitHeaderText());
  }

  @isTest static void testGetTypeOfVisitHeaderTextRenewal() {
    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    i.Type_of_Visit__c = 'Provisional License Renewal';
    update i;
    EEC_GenerateVisitChecklistExtension ext = new EEC_GenerateVisitChecklistExtension(new ApexPages.StandardController(i));

    System.assertEquals('Renewal -', ext.getTypeOfVisitHeaderText());
  }

  @isTest static void testGetTypeOfVisitHeaderTextDefault() {
    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    i.Type_of_Visit__c = 'Follow-up';
    update i;
    EEC_GenerateVisitChecklistExtension ext = new EEC_GenerateVisitChecklistExtension(new ApexPages.StandardController(i));

    System.assertEquals('Follow-up -', ext.getTypeOfVisitHeaderText());
  }
}