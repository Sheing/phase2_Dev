public class PortalDocumentLibraryCtrl {
    
  public String docId { get; set; }
  public String mode { get; set; }
    
  public final Set<Integer> MODIFY_MODES = new Set<Integer>{1,2};
    
  public PortalDocumentLibraryCtrl() {
    this.docId = ApexPages.currentPage().getParameters().get('id');  
    this.mode = ApexPages.currentPage().getParameters().get('mode');  
  }
    
  public Boolean getIsModifyMode() {  
    Integer mode;
      
    try {
      mode = Integer.valueOf(this.mode);
    } catch (Exception e) {
      return false;  
    }      
    return MODIFY_MODES.contains(mode) ? true : false;
  }
}