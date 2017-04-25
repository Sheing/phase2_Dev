trigger EEC_PotentialProvider on Lead (after update) {
    List<Lead> listLeads = new List<Lead>();
    for(Lead lead : trigger.new){
    	if(lead.Status == 'Converted' && Trigger.oldMap.get(lead.Id).Status != 'Converted' && lead.ConvertedAccountId != null){
            listLeads.add(lead);
        }
    }
    
    if(listLeads.size() > 0){
        EEC_PotentialProviderHandler.doAfterUpdate(listLeads);
    }
}