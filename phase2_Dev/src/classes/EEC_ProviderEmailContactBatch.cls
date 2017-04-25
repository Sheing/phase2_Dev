global class EEC_ProviderEmailContactBatch implements Database.Batchable<sobject> {
    
    public string query;
    global EEC_ProviderEmailContactBatch() {
      query='Select Id,name,Email,title from contact where email !=\'leadcontact@gmail.com\' and email !=null';
    } 
   global Database.Querylocator start(Database.BatchableContext bc){
    return Database.getQuerylocator(query);
  }
  global Void execute(Database.BatchableContext bc,List<Sobject> scope){
    List<contact> ConList = (List<contact>)scope;
    list<contact> UpdateList = new list<contact>();
    for(Contact C : ConList){
     C.email = 'leadcontact@gmail.com';
     //C.title = '.';
     UpdateList.add(C);
    }
    if(!UpdateList.isempty()) 
   update UpdateList;
  }
  global Void finish(Database.BatchableContext bc){
    }
}