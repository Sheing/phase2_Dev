trigger EEC_NotesTrigger on Note (before insert, before update) {
	EEC_NotesAttachmentsTriggerHandler nahandler = new EEC_NotesAttachmentsTriggerHandler(Trigger.New);
    
    nahandler.checkNoteStatus();
}