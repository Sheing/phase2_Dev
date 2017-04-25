public with sharing class EEC_AttachDocumentController {

  public String iiId { get; set; }
  public String filename { get; set; }
  public String attachmentMessage { get; set; }
  public String newAttachmentId { get; set; }

  public EEC_AttachDocumentController() {
    iiId = ApexPages.currentPage().getParameters().get('iiId');
    filename = ApexPages.currentPage().getParameters().get('filename');
    attachmentMessage = '';
    newAttachmentId = '';
  }

  public Attachment attachment {
    get {
      if (attachment == null)
      attachment = new Attachment();
      return attachment;
    }
    set;
  }

  public PageReference upload() {
    if (attachment != null && attachment.name != null) {
      if (!String.isBlank(filename)) {
        attachment.name = filename + '_' + attachment.name;
      }

      attachment.OwnerId = UserInfo.getUserId();
      attachment.ParentId = iiId; // the record the file is attached to
      attachment.IsPrivate = true;
      attachmentMessage = attachmentMessage + attachment.name + ', ';
      System.debug('----> Attachment: ' + attachment);
      try {
        insert attachment;
        newAttachmentId = attachment.Id;
      } catch(DMLException e) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error uploading attachment'));
        return null;
      } finally {
        attachment = new Attachment();
      }

      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Attachment uploaded successfully'));
      return null;
    }
    else {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select a file to be uploaded'));
    }

    return null;
  }
}