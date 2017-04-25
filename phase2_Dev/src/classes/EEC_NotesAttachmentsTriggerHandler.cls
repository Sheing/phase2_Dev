public class EEC_NotesAttachmentsTriggerHandler {
    
    private List<Attachment> newAttList = new List<Attachment>();
    private List<Note> newNoteList = new List<Note>();
    public EEC_NotesAttachmentsTriggerHandler(List<Attachment> newAttachment){
        newAttList = newAttachment; 
    }
    public EEC_NotesAttachmentsTriggerHandler(List<Note> newNotes){
        newNoteList = newNotes; 
    }
    
    public void checkNoteStatus(){
        for (Note nt : newNoteList) {
            if(nt.IsPrivate){
               nt.addError('You cannot create a private Note. Please uncheck the "Private" checkbox before saving');
            }
    	}
    }
    public void checkAttachmentStatus(){
        for (Attachment nt : newAttList) {
            if(nt.IsPrivate){
               nt.addError('You cannot create a private Attachment. Please uncheck the "Private" checkbox before saving');
            }
    	}
    }
}