global class ProcessingStepSchedulable implements Schedulable {
  public Integer runCount { get; set; }
  public Set<Id> mIntakeList { get; set; }
  public String batchableName { get; set; }

  global ProcessingStepSchedulable() {
    this.runCount = (runCount != null && runCount > 0 ? runCount + 1 : 1);
  }

  global ProcessingStepSchedulable(Set<Id> intakeList) {
    this();
    this.mIntakeList = intakeList;
  }
 
  global void execute(SchedulableContext sc) {
    System.debug('---> mIntakeList: ' + mIntakeList);
    ProcessingStepBatchable batch = new ProcessingStepBatchable(runCount, mIntakeList);

    if (String.isNotBlank(this.batchableName)) {
      batch.currentCronJobName = this.batchableName;
    }

    Database.executebatch(batch);
  }
}