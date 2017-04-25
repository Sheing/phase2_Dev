trigger EEC_AttachmentsTrigger on Attachment (before insert, before update) {

    EEC_NotesAttachmentsTriggerHandler nahandler = new EEC_NotesAttachmentsTriggerHandler(Trigger.New);
    
    nahandler.checkAttachmentStatus();
}