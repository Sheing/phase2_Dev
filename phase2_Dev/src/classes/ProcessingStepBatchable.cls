global class ProcessingStepBatchable implements Database.Batchable<sObject>, Database.Stateful {
  private final String mBaseQuery = 'Select Id, Name, Status__c, FormVersion__c, FormVersion__r.Name, FormVersion__r.Status__c, FormVersion__r.Form__c, FormVersion__r.Form__r.Name From Intake__c';
  
  public Boolean isFinalRun = false;
  public Integer counter;
  public String currentCronJobName { get; set; }
  public String queryLimit { get; set; }
  public Set<Id> mIntakeList { get; set; }
  public List<ProcessingStepResult__c> mStepResults { get; set; }
  
  global ProcessingStepBatchable() {
    this.queryLimit = '10';
  }

  global ProcessingStepBatchable(Integer counter) {
    this();
    this.counter = counter;
  }

  global ProcessingStepBatchable(Integer counter, Set<Id> intakeList) {
    this(counter);
    this.mIntakeList = intakeList;
  }  
  
  global Database.QueryLocator start(Database.BatchableContext context) {
    Database.QueryLocator results;

    try {
      System.debug('----> [ProcessingStepBatchable][Start] mIntakeList: ' + mIntakeList);
      String query = this.mBaseQuery;

      query += ' WHERE Id IN :mIntakeList';
      
      if (String.isNotBlank(this.queryLimit)) {
        query += ' Limit ' + this.queryLimit;
      }
      System.debug('----> [ProcessingStepBatchable][Start] query: ' + query);
      results = Database.getQueryLocator(query);
      System.debug('----> [ProcessingStepBatchable][Start] results.iterator(): ' + results.iterator());
      // Check if the query returned no value or is null.  
      if (results == null || (results != null && !results.Iterator().hasNext())) {
        System.debug('----> [ProcessingStepBatchable][Start] Query Result does not have any records. Setting this to be the final run...');
        // If no results have been found from the query using ALL request ID's then inform the batch this is the final run.
        // The reason for this is that the query uses ALL of the ID's provided. If one is not found of what may be left then
        //   we no longer need to continue the process. It is possible for all of the ID's to not work.
        isFinalRun = true;      
      }
    } catch(Exception e) {
      System.debug('----> [ProcessingStepBatchable][Start] Error querying for ProcessingStepBatchable: ' + e.getMessage());
      this.isFinalRun = true;
      BatchableUtil.abortSelf(currentCronJobName, true);
      results = Database.getQueryLocator('');
    }
    return results;
  }

  global void execute(Database.BatchableContext context, List<Intake__c> scope) {
    System.debug('----> [ProcessingStepBatchable][Execute] Start...');

    try {
      Set<Id> consumedIntakeList = new Set<Id>();
      Set<Id> formVersionIdList = new Set<Id>();

      List<FormVersion__c> formVersions;

      List<Response__c> responses = [Select Id, Name, Value__c, Intake__c, FormComponent__c From Response__c Where Intake__c IN :mIntakeList];
      Map<String, List<Response__c>> intakeResponsesMap = new Map<String, List<Response__c>>();

      // Intake to responses lists
      for (String Id : mIntakeList) {
        if (!intakeResponsesMap.containsKey(id)) {
          intakeResponsesMap.put(id, new List<Response__c>());
        }

        for (Response__c tempResp : responses) {
          if (id.equalsIgnoreCase(tempResp.Intake__c)) {
            intakeResponsesMap.get(id).add(tempResp);
          }
        }
      }

      System.debug('----> [ProcessingStepBatchable][Execute] Scope: ' + scope);

      // Loop through the scope results.
      for (Intake__c mIntake : scope) {
        formVersionIdList.add(mIntake.FormVersion__c);
        consumedIntakeList.add(mIntake.Id);
      }

      BatchableUtil.processSteps(scope, 'Post', intakeResponsesMap, formVersionIdList);

      // Refresh the intake list by removing all the consumed ID's from the list.
      Set<Id> finalIntakeIdList = new Set<Id>();
      for (Id intakeId : mIntakeList) {
        if (!consumedIntakeList.contains(intakeId)) {
          finalIntakeIdList.add(intakeId);
        }
      }
      // Set the unused ids to the intake list.
      mIntakeList = finalIntakeIdList;
    } catch (Exception e) { 
      System.debug('----> [ProcessingStepBatchable][Execute] Error in Execute for ProcessingStepBatchable: ' + e.getMessage());
      System.debug('----> Error: ' + e.getMessage());
      System.debug(e.getStackTraceString());
      isFinalRun = true;
      BatchableUtil.abortSelf(currentCronJobName, true);
    }
    System.debug('----> [ProcessingStepBatchable][Execute] End...');
  }
  
  global void finish(Database.BatchableContext context) {
    System.debug('----> [ProcessingStepBatchable][Finish] Start...');
    // Get the ID of the AsyncApexJob representing this batch job
    // from Database.BatchableContext.
    // Query the AsyncApexJob object to retrieve the current job's information.
    AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                      TotalJobItems, CreatedBy.Email
                      FROM AsyncApexJob WHERE Id =
                      :context.getJobId()];

    try {
      if (isFinalRun) {
        System.debug('----> [ProcessingStepBatchable][Finish] Final run detected. Discontinuing process...');
        
        if (mStepResults != null && mStepResults.size() > 0) {
          insert mStepResults;
        }
      } else {
        counter++;
        // Generate a new batach name.
        String newBatchName = BatchableUtil.generateBatchableName('Intake', counter, UserInfo.getUserId());
        // Create a new schedulable with the current information.
        ProcessingStepSchedulable bulkSchedule = new ProcessingStepSchedulable();
        // Add the new batch name to the new version of the schedulable.
        bulkSchedule.batchableName = newBatchName;
        bulkSchedule.mIntakeList = mIntakeList;
        // Prep the cron to run 60 Seconds from now.
        Datetime sysTime = System.now().addSeconds(120);
        String cronTiming = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        // Schedule the cron under the new batch name to run.
        System.schedule(newBatchName, cronTiming, bulkSchedule);
      }
      // Abort the current batch once complete.
      BatchableUtil.abortSelf(currentCronJobName, false);
    } catch(Exception e) {
      System.debug('----> [ProcessingStepBatchable][Finish] Error in OnFinish for IntakeBatchable: ' + e.getMessage());
      System.debug(e.getStackTraceString());
      BatchableUtil.abortSelf(currentCronJobName, a);
    }
    System.debug('----> [ProcessingStepBatchable][Finish] End...');
  }
}