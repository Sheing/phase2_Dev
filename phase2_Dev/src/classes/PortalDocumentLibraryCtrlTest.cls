@isTest
public class PortalDocumentLibraryCtrlTest {

  public static testMethod void testPortalDocumentLibraryCtrl() {
    Test.setCurrentPageReference(new PageReference('Page.PortalDocumentLibrary')); 
    System.currentPageReference().getParameters().put('id', '1234');
    System.currentPageReference().getParameters().put('mode', '1');
       
    PortalDocumentLibraryCtrl ctrl = new PortalDocumentLibraryCtrl();
    System.assertEquals('1234', ctrl.docId);
    System.assertEquals('1', ctrl.mode);
  }
   
  public static testMethod void testGetIsModifyMode() {
    Test.setCurrentPageReference(new PageReference('Page.PortalDocumentLibrary'));   
    System.currentPageReference().getParameters().put('mode', '1');
      
    PortalDocumentLibraryCtrl ctrl = new PortalDocumentLibraryCtrl();
    System.assert(ctrl.getIsModifyMode());
        
    System.currentPageReference().getParameters().put('mode', '5');
    ctrl = new PortalDocumentLibraryCtrl();
    System.assert(!ctrl.getIsModifyMode());  
        
    System.currentPageReference().getParameters().put('mode', 'false');
    ctrl = new PortalDocumentLibraryCtrl();
    System.assert(!ctrl.getIsModifyMode());  
  }
}