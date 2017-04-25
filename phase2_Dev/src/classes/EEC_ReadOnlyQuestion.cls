public class EEC_ReadOnlyQuestion extends EEC_Question { 

	public String fieldName { get; set; }

	public override String getQuestionType() {
		return 'readonly';
	}

	public EEC_ReadOnlyQuestion(String fieldName, String label) {
		this.label = label;
		this.fieldName = fieldName;
	}

}