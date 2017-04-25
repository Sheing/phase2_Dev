global class EEC_ScheduleBatchInvestigationConclusion implements Schedulable {
   global void execute(SchedulableContext sc) {
      database.executeBatch(new EEC_Batch_InvestigationConclusion());
   }
}