public with sharing class EEC_LicenseTransactionTriggerHandler {
    public static boolean alreadyRan = false;
    public static boolean alreadyRanME = false;
    public static boolean isTransactionSubmitted = false;
    public static string fee;
    public static Boolean flag=false;
    public static List<Licensing_Transaction__c> newList;
    public static Map<Id,Licensing_Transaction__c> oldLT = new Map<Id,Licensing_Transaction__c>();
    public static Map<Id,Licensing_Transaction__c> newMap;
    public static Map<Id,Household_Member__c> hhMAP;
    public static Map<Id,Account> providerMap;
    public static Map<String,ID> strHHMap;
    public static Set<Id> transactionsWithVisit = new Set<Id>();
    
    list<string> emailids=new list<string>();
    //Map<Id,ID> providerLTMap;
    public static Map<Id,Set<String>> ltHHMap;
    public EEC_LicenseTransactionTriggerHandler(List<Licensing_Transaction__c> newLTList, Map<Id,Licensing_Transaction__c> oldMap){
        newList = newLTList;
        oldLT = oldMap;
        Set<Id> transactionSet = new Set<Id>();
        for(Licensing_Transaction__c lt : newList){
            transactionSet.add(lt.Id);
            System.debug(lt.id);
        }
        try{
            AggregateResult[] gr = [select Licensing_Transaction__c, Count(id) visitCount from Inspection__c where Licensing_Transaction__c IN :transactionSet group by Licensing_Transaction__c];
            for(AggregateResult ar : gr){
                Id ltId = (ID)ar.get('Licensing_Transaction__c');
                transactionsWithVisit.add(ltId);
                System.debug('***********TransactionWithVisit' + transactionsWithVisit);
            } 
        } catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    
    
    public void licenseMapVisit(){
        Set<Id> providerSet = new Set<Id>();
        Map<Id,Id> licenseProviderMap = new Map<Id,Id>();
        List<RecordType> transRecordTypeList = [select id,name,SobjectType from RecordType where name like '%Renewal%' AND SobjectType = 'Licensing_Transaction__c'];
        Set<Id> transRecordTypeNames = new Set<Id>();
        for(RecordType rec : transRecordTypeList){
            transRecordTypeNames.add(rec.Id);
        }
        for(Licensing_Transaction__c lt : newList){
            if(transRecordTypeNames.contains(lt.RecordTypeId)){
                providerSet.add(lt.Provider__c);
                licenseProviderMap.put(lt.id,lt.Provider__c);
            }
        }
        Date dateOfVisitFilter = Date.today().addDays(-120);
        List<Inspection__c> visitList = [select id,name,Provider_No__c,Licensing_Transaction__c ,Type_of_Visit__c,Status__c ,Date_of_Visit__c,Estimated_Deadline__c from Inspection__c where Provider_No__c IN:providerSet AND Licensing_Transaction__c =:Null AND Type_of_Visit__c like '%Renewal%' AND Status__c !='Cancelled'];  
        List<Inspection__c> updateVisitList = new List<Inspection__c>(); 
        
        
        for(ID licenseID : licenseProviderMap.keyset()){
            for(Inspection__c visit : visitList){
                Inspection__c vist2 = visit;
                if(licenseProviderMap.get(licenseID) == vist2.Provider_No__c && ((visit.Date_of_Visit__c!=null && visit.Date_of_Visit__c >= dateOfVisitFilter) || (visit.Date_of_Visit__c==null && visit.Estimated_Deadline__c >= dateOfVisitFilter) )){
                    
                    vist2.Licensing_Transaction__c = licenseID;
                    updateVisitList.add(vist2);
                }
            }
        }
        
        if(!updateVisitList.isEmpty()){
            update updateVisitList;
        }
    }
    
    public static boolean checkRecursive(){
        if(!alreadyRan){
            system.debug('MMMMM'+alreadyran);
            alreadyRan=true;
            return false;
        }else{
            system.debug('MMMMM'+alreadyran);
            return true;
        }
    }
    public static boolean checkRecursiveME(){
        if(!alreadyRanME){
            system.debug('MMMMM'+alreadyranME);
            alreadyRanME=true;
            return false;
        }else{
            system.debug('MMMMM'+alreadyranME);
            return true;
        }
    }
    public static void bulkAfter(){
        Set<Id> accountSet = new Set<Id>();
        Map<Id,Licensing_Transaction__c> newLTMap = new Map<Id,Licensing_Transaction__c>();
        newMap = new Map<Id,Licensing_Transaction__c>();
        ltHHMap = new Map<Id,Set<String>>();
        strHHMap = new Map<String, Id>();
        //providerLTMap = new Map<Id,Id>();
        
        Map<Id,LEAD_Configuration__c> leadConfigMap = new Map<Id,LEAD_Configuration__c>([Select Id,Name,FCC_Renewal_Significant_Delay__c,New_License_Fee__c,License_Renewal_Fee__c From LEAD_Configuration__c]);
        
        Map<string,LEAD_Configuration__c> providerFeeMap = new Map<string,LEAD_Configuration__c>();
        
        for(Lead_Configuration__c cf: leadConfigMap.values()){
           providerFeeMap.put(cf.Name,cf);
        }
        
        for(Licensing_Transaction__c lt : newList){
            System.debug('*********** -- '+lt.Status__c);
            if(String.isNotBlank(lt.Status__c) && lt.Status__c == 'Submitted' && lt.RecordType.DeveloperName != 'FCC_Change_of_Name'){
                accountSet.add(lt.provider__c);
                newLTMap.put(lt.Id,lt);
            }
            
            lt.Transaction_Configuration__c = providerFeeMap.get(Schema.SObjectType.Licensing_Transaction__c.getRecordTypeInfosById().get(lt.recordtypeid).getname()).Id;
            
        }
        if(newLTMap != null && newLTMap.size() > 0){
            providerMap = new Map<Id,Account>([select Id, RecordType.DeveloperName from Account where Id in :accountSet]);
            newMap = new Map<Id,Licensing_Transaction__c>([select Id,RecordType.DeveloperName,RecordType.Name, Status__c, No_Visit_Needed__c,Provider__r.Region__c,Assigned_To__r.Region__c,Provider__r.Region__r.Name,
                                                           Provider__c,(select Id,BRC_Required__c,First_Name__c,Last_Name__c,Date_of_Birth__c,Age_At_Submission__c,BRC_Consent_Status__c from Household_Member__r where Age_At_Submission__c >= 15) 
                                                           from Licensing_Transaction__c where Id in :newLTMap.KeySet()]);
            hhMAP = new Map<Id,Household_Member__c>([SELECT Id,First_Name__c,Last_Name__c,Date_of_Birth__c,
                                                     Provider__c,BRC_Consent_Status__c,
                                                     Age_At_Submission__c FROM Household_Member__c 
                                                     WHERE Provider__c = :accountSet 
                                                     AND  Licensing_Transactions__c not in :newLTMap.KeySet()]);
            
            if(hhMAP != null){                                     
                for(Household_Member__c hh : hhMAP.Values()){
                    if(ltHHMap.containsKey(hh.Provider__c)){
                        ltHHMap.get(hh.Provider__c).add(hh.First_Name__c+'-'+hh.Last_Name__c+'-'+hh.Date_of_Birth__c);
                    }
                    else{
                        ltHHMap.put(hh.Provider__c,new Set<String>{hh.First_Name__c+'-'+hh.Last_Name__c+'-'+hh.Date_of_Birth__c});
                    }
                    strHHMap.put(hh.First_Name__c+'-'+hh.Last_Name__c+'-'+hh.Date_of_Birth__c,hh.Id);
                }
            }
            
            /*if(providerLTMap != null && providerLTMap.size() > 0){
                for(Household_Member__c hm :[select Id,Name,First_Name__c,First_Name__c,First_Name__c,BRC_Required__c,Licensing_Transactions__c from Household_Member__c where Licensing_Transactions__c in :providerLTMap.Values() and BRC_Required__c = true]){
                    if(ltHHMap.containsKey(hm.Licensing_Transactions__c)){
                        ltHHMap.get(hm.Licensing_Transactions__c).add(hm.First_Name__c+'-'+hm.Last_Name__c+'-'+hm.Date_of_Birth__c);
                    }
                    else{
                        ltHHMap.put(hm.Licensing_Transactions__c,new Set<String>{hm.First_Name__c+'-'+hm.Last_Name__c+'-'+hm.Date_of_Birth__c});
                    }
                }
            }*/
           
        }
        
    }

    public static void updateOnChangeOfRegion(){
        if(newMap != null && newMap.size() > 0){
           for(Licensing_Transaction__c lt : newMap.values()){ 
                if(lt.RecordType.DeveloperName == 'Change_of_Address' 
                    && lt.Provider__r.Region__c != oldLT.get(lt.Id).Provider__r.Region__c 
                    && lt.Assigned_To__r.Region__c != lt.Provider__r.Region__r.Name){
                   lt.Licensor_Re_assignment_Needed_for_Region__c = true;    
                }
           }     
        }
    }
    
    public static void createConditionFccUpto8(List<Licensing_Transaction__c> newList2){
        Map<Id,Licensing_Transaction__c> newLTMap2 = new Map<Id,Licensing_Transaction__c>();
        for(Licensing_Transaction__c lt : newList2){
            System.debug('*********** -- '+lt.Status__c);
            if(String.isNotBlank(lt.Status__c) && lt.Status__c != 'To submit' 
                    && !lt.Status__c.contains('Cancelled') && !lt.Status__c.contains('Closed')  
                    && lt.RecordType.DeveloperName != 'FCC_Change_of_Name'){
                newLTMap2.put(lt.Id,lt);
            }
        }
        Map<Id,Licensing_Transaction__c> newMap2 = new Map<Id,Licensing_Transaction__c>([select Id,RecordType.DeveloperName, Status__c, No_Visit_Needed__c, X2_School_Age_Condition_Created__c, License_Requested__c,
                                                           Provider__c,(select Id,BRC_Required__c,First_Name__c,Last_Name__c,Date_of_Birth__c,Age_At_Submission__c,BRC_Consent_Status__c from Household_Member__r where Age_At_Submission__c >= 15) 
                                                           from Licensing_Transaction__c where Id in :newLTMap2.KeySet()]);
        if(newMap2 != null && newMap2.size() > 0){
            for(Licensing_Transaction__c lt : newMap2.values()){
                if(lt.Status__c != 'To submit' && !lt.Status__c.contains('Cancelled') && !lt.Status__c.contains('Closed') 
                        && lt.X2_School_Age_Condition_Created__c == false 
                        && String.isNotBlank(lt.License_Requested__c) 
                        && lt.License_Requested__c == 'Up to 8 Children; 2 School Aged'){
                    Integer existingCond = [SELECT COUNT() FROM Conditions_and_Limitations__c 
                                            WHERE Condition_Name__r.Name = 'Up to 8 Children; 2 School Aged' 
                                                AND Source_Transaction__c = :lt.Id];
                    if(existingCond < 1){
                        Conditions_and_Limitations__c cnl = new Conditions_and_Limitations__c();
                        cnl.Source_Transaction__c = lt.id;
                        cnl.Provider__c = lt.Provider__c;
                        cnl.Condition_Name__c = [SELECT Id FROM Condition__c 
                                                WHERE Name = 'Family Child Care for 8 Children (formely FCCP)'].Id;
                        Insert cnl;
                    }
                }
            }
        }
    }
    
    public void updateHouseHoldMembers(){
        if(newMap != null && newMap.size() > 0){
            Account provider;
            Id tLTId;
            Set<String> tLTSet;
            List<Household_Member__c> hmList = new List<Household_Member__c>();
            String tStr = '';
            Boolean isBRCSet = false;
            System.debug('TriggerLicenseDebugNewMapValue' + ltHHMap);
            List<Household_Member__c> hMAP = [SELECT Id,First_Name__c,Last_Name__c,Date_of_Birth__c, Provider__c,BRC_Consent_Status__c,Age_At_Submission__c 
                                              FROM Household_Member__c WHERE Licensing_Transactions__c in : newMap.KeySet()];
            for(Licensing_Transaction__c lt : newMap.values()){
                provider = providerMap.get(lt.Provider__c);
                if(provider.RecordType.DeveloperName == 'FCC' && lt.Status__c == 'Submitted'){
                    if((lt.RecordType.DeveloperName == 'FCC_New_License' || lt.RecordType.DeveloperName == 'FCC_Renewal')){
                        if(hMAP != null && hMAP.size() > 0){
                            for(Household_Member__c hm : hMAP){
                                if(hM.Age_At_Submission__c >= 15)
                                hm.BRC_Required__c = true;
                                hmList.add(hm);
                            }
                        }
                    }
                    else if(lt.RecordType.DeveloperName == 'FCC_License_Upgrade' || lt.RecordType.DeveloperName == 'Change_of_Address'|| lt.RecordType.DeveloperName == 'FCC_Change_of_Household'){
                        Household_Member__c phm;
                        if(ltHHMap != null && ltHHMap.size() > 0){
                            tLTSet = ltHHMap.get(lt.Provider__c);
                        }
                        for(Household_Member__c hm : hMAP){
                            isBRCSet = false;
                            if(tLTSet != null && tLTSet.size() > 0){
                                tStr = hm.First_Name__c+'-'+hm.Last_Name__c+'-'+hm.Date_of_Birth__c;
                                Id hhId = strHHMap.get(tStr);
                                if(String.isNotBlank(hhId)){
                                    phm = hhMAP.get(hhId);
                                }
                                if(tLTSet.contains(tStr) && phm != null && (phm.Age_At_Submission__c < 15 || (String.isNotBlank(phm.BRC_Consent_Status__c) && phm.BRC_Consent_Status__c == 'Completed'))){
                                    hm.BRC_Required__c = false;
                                    isBRCSet = true;
                                    hmList.add(hm);
                                }
                            }
                            if(!isBRCSet){
                                if(hm.Age_At_Submission__c >= 15 ){
                                    hm.BRC_Required__c = true;
                                    hmList.add(hm);
                                }
                            }
                        }
                    }
                }
            }
            if(hmList != null && hmList.size() > 0){
                update hmList;
            }
        }
    }
    
    public static void checkTransactionStatus(List<Licensing_Transaction__c> LTNewList){
        for(Licensing_Transaction__c lt: LTNewList){
            if (isTransactionSubmitted == false){
                if (lt.Status__c != 'To Submit'){
                    isTransactionSubmitted = true;
                }
            }
            if (isTransactionSubmitted == true){
                if (lt.Status__c != 'Under Review' && lt.Status__c != 'Submitted' && lt.Status__c != 'Pending Manager Approval' && lt.Status__c != 'Approved By Manager'){
                    isTransactionSubmitted = false;
                }
            }
        }
    }
    
    /** Method to check 'Missing Elements for Licensor **/
    public static void checkMissingElementsForLicensor(List<Licensing_Transaction__c> LTNewList){
        /* Start of Initialization... */
        string missingElementsForLicensor = '';
        string missingElementsForFinalizing = '';
    
        string LicensingRTName = null;
        //date currDate = date.today();
        //date accRenewalDate = date.today();
        User u = null; 
        
        Set<Id> LTIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        for(Licensing_Transaction__c lt: LTNewList){
            //if(isTransactionSubmitted){
                accountIds.add(lt.provider__c);
                LTIds.add(lt.id);
            //}
        }
                
        /* End of Initialization */
        
        //if (isTransactionSubmitted){
            Map<Id,Account> accountMap = new Map<Id,Account>([Select Id,Name, Renewal_date__c, License_Type__c, Total_License_Capacity__c,
            Public_Approval__c, Allow_New_Application_as_Provider__c, Allow_Renewal_as_Assistant__c, Config_Record__c, Record_Type_Name__c, Is_R_P__c From Account Where Id in :accountIds]);
            
            Map<Id,User> userMap = new Map<Id,User>([Select Id, Name, Need_Supervisor_Approval__c From User Where IsActive = true]);
            
            Map<Id,LEAD_Configuration__c> leadConfigMap = new Map<Id,LEAD_Configuration__c>([Select Id,Name,FCC_Renewal_Significant_Delay__c,New_License_Fee__c,License_Renewal_Fee__c From LEAD_Configuration__c]);
            
            List<Transaction_Process_Step__c> listProcessStep = [select Id, Associated_Transaction_Field__c, Transaction_Type__c,
            Type__c, (Select Id, Active__c,
            Associated_Transaction_Field__c, Associated_Transaction_Step__c, Rule_Ranking__c, Standard_Process_Rule__c,
            Standard_Process_Rule__r.API_Name_of_field_to_be_Tested__c,
            Standard_Process_Rule__r.Description__c,
            Standard_Process_Rule__r.Message_If_Field_False__c from 
            Step_Process_Rules__r where Active__c = true order by Rule_Ranking__c asc) from Transaction_Process_Step__c];
            
            Map<Id, List<Transaction_Process_Step__c>> mapProcessStep = new Map<Id, List<Transaction_Process_Step__c>>();
            
            for(Transaction_Process_Step__c processStep : listProcessStep){
                List<Transaction_Process_Step__c> listSteps;
                if(mapProcessStep.get(processStep.Transaction_Type__c) == null){
                    listSteps = new List<Transaction_Process_Step__c>();
                }
                else{
                    listSteps = mapProcessStep.get(processStep.Transaction_Type__c);
                }
                listSteps.add(processStep);
                mapProcessStep.put(processStep.Transaction_Type__c, listSteps);
            }

            Map<string,LEAD_Configuration__c> providerFeeMap = new Map<string,LEAD_Configuration__c>();
            
            for(Lead_Configuration__c cf: leadConfigMap.values()){
                //if(cf.New_License_Fee__c !=null){
               providerFeeMap.put(cf.Name,cf);
                //}
            }
            
            /*List<Conditions_and_Limitations__c> otherConditionsAssistantList = [Select Id, current__c, Source_Transaction__c 
                                                                                From Conditions_and_Limitations__c 
                                                                                Where Source_Transaction__c = :LTIds 
                                                                                AND current__c = true];
                                                                                
            Map<Id,Conditions_and_Limitations__c> otherConditionsAssistantMap = new Map<Id,Conditions_and_Limitations__c>();
            for(Conditions_and_Limitations__c cl: otherConditionsAssistantList){
                otherConditionsAssistantMap.put(cl.Source_Transaction__c,cl);
            }*/
    		
    		List<Transaction_Fee_Schedule__c> listFeeSchedule = [select Id, Waived_if_Informed_Before_Nb_of_Days__c,Current__c,
    		Effect_Date__c, Expiration_Date__c, Fee_Amount__c, Number_of_Placements_Higher_Limit__c, Number_of_Placements_Lower_Limit__c,
    		Only_On_Capacity_Increase__c, Provider_Type__c, Related_Transaction_Type__c, Requested_Capacity_Higher_Limit__c,
    		Requested_Capacity_Lower_Limit__c, Requested_License__c, Type_of_License__c, Waived_if_State_Funded_Public_Company__c
    		from Transaction_Fee_Schedule__c];
    		
    		Map<Id, List<Transaction_Fee_Schedule__c>> mapFeeSchedule = new Map<Id, List<Transaction_Fee_Schedule__c>>();
    		
    		for(Transaction_Fee_Schedule__c feeSchedule : listFeeSchedule){
    			List<Transaction_Fee_Schedule__c> listFees;
    			if(mapFeeSchedule.get(feeSchedule.Related_Transaction_Type__c) == null){
    				listFees = new List<Transaction_Fee_Schedule__c>();
    			}	
    			else{
    				listFees = mapFeeSchedule.get(feeSchedule.Related_Transaction_Type__c);
    			}
    			listFees.add(feeSchedule);
    			mapFeeSchedule.put(feeSchedule.Related_Transaction_Type__c, listFees);
    		}
    		
    		
            for(Licensing_Transaction__c lt: LTNewList){
                LicensingRTName = Schema.SObjectType.Licensing_Transaction__c.getRecordTypeInfosById().get(lt.recordtypeid).getname();
                boolean is_R_and_P = false;
                Account acc = accountMap.get(lt.Provider__c);
                LEAD_Configuration__c leadConfig = leadConfigMap.get(acc.Config_Record__c);
                is_R_and_P = acc.Is_R_P__c;
                
                if (lt.Assigned_To__c != null){
                    u = userMap.get(lt.Assigned_To__c);
                }
                
                boolean isFeesSet = false;
                if(lt.Status__c == 'Submitted' && lt.Associated_Fee__c == null && lt.Transaction_Configuration__c != null){
                	List<Transaction_Fee_Schedule__c> listFees = mapFeeSchedule.get(lt.Transaction_Configuration__c);
                	if(listFees != null && listFees.size() > 0){
                		for(Transaction_Fee_Schedule__c transactionFees : listFees){
                            system.debug('1: ' + (transactionFees.Current__c == true && (transactionFees.Requested_Capacity_Lower_Limit__c <= lt.Total_License_Capacity_Requested__c || transactionFees.Requested_Capacity_Lower_Limit__c == null)));
                            system.debug('2: ' + (transactionFees.Requested_Capacity_Higher_Limit__c >= lt.Total_License_Capacity_Requested__c || transactionFees.Requested_Capacity_Higher_Limit__c == null));
                            system.debug('3: ' + (transactionFees.Provider_Type__c == acc.Record_Type_Name__c || string.isEmpty(transactionFees.Provider_Type__c)));
                            system.debug('4: ' + (transactionFees.Type_of_License__c == acc.License_Type__c || string.isEmpty(transactionFees.Type_of_License__c)));
                            system.debug('5: ' + (transactionFees.Requested_License__c == lt.License_Requested__c || string.isEmpty(transactionFees.Requested_License__c)));
                            system.debug('6: ' + (transactionFees.Number_of_Placements_Lower_Limit__c <= lt.Number_of_Adoptive_Placements__c || transactionFees.Number_of_Placements_Lower_Limit__c == null));
                            system.debug('7: ' + (transactionFees.Number_of_Placements_Higher_Limit__c >= lt.Number_of_Adoptive_Placements__c || transactionFees.Number_of_Placements_Higher_Limit__c == null));
                            system.debug('8: ' + (transactionFees.Only_On_Capacity_Increase__c == false || (transactionFees.Only_On_Capacity_Increase__c == true && (acc.Total_License_Capacity__c == null || lt.Total_License_Capacity_Requested__c >= acc.Total_License_Capacity__c))));
                            system.debug('9: ' + (transactionFees.Waived_if_Informed_Before_Nb_of_Days__c == null || (lt.Moving_Date__c <= date.TODAY().addDays(integer.valueof(transactionFees.Waived_if_Informed_Before_Nb_of_Days__c)))));
                            system.debug('10: ' + (transactionFees.Waived_if_State_Funded_Public_Company__c == false || (transactionFees.Waived_if_State_Funded_Public_Company__c == true && acc.Public_Approval__c == false)));
                            
                			if(transactionFees.Current__c == true && (transactionFees.Requested_Capacity_Lower_Limit__c <= lt.Total_License_Capacity_Requested__c || transactionFees.Requested_Capacity_Lower_Limit__c == null)
                			&&(transactionFees.Requested_Capacity_Higher_Limit__c >= lt.Total_License_Capacity_Requested__c || transactionFees.Requested_Capacity_Higher_Limit__c == null)
                			&&(transactionFees.Provider_Type__c == acc.Record_Type_Name__c || string.isEmpty(transactionFees.Provider_Type__c))
                			&&(transactionFees.Type_of_License__c == acc.License_Type__c || string.isEmpty(transactionFees.Type_of_License__c))
                			&&(transactionFees.Requested_License__c == lt.License_Requested__c || string.isEmpty(transactionFees.Requested_License__c))
                			&&(transactionFees.Number_of_Placements_Lower_Limit__c <= lt.Number_of_Adoptive_Placements__c || transactionFees.Number_of_Placements_Lower_Limit__c == null)
                			&&(transactionFees.Number_of_Placements_Higher_Limit__c >= lt.Number_of_Adoptive_Placements__c || transactionFees.Number_of_Placements_Higher_Limit__c == null)
                			&&(transactionFees.Only_On_Capacity_Increase__c == false || (transactionFees.Only_On_Capacity_Increase__c == true && (acc.Total_License_Capacity__c == null || lt.Total_License_Capacity_Requested__c >= acc.Total_License_Capacity__c)))
                			&&(transactionFees.Waived_if_Informed_Before_Nb_of_Days__c == null || (lt.Moving_Date__c <= date.TODAY().addDays(integer.valueof(transactionFees.Waived_if_Informed_Before_Nb_of_Days__c))))
                			&&(transactionFees.Waived_if_State_Funded_Public_Company__c == false || (transactionFees.Waived_if_State_Funded_Public_Company__c == true && acc.Public_Approval__c == false))
                			){
                				system.debug('transactionFees: ' + transactionFees.Id);
                				lt.Associated_Fee__c = transactionFees.Fee_Amount__c;
                                isFeesSet = true;
                				break;
                			}
                		}
                        if(isFeesSet == false){
                            lt.Associated_Fee__c = 0;
                        }
                	}
                	else{
                		lt.Associated_Fee__c = 0;
                	}
                }
                
                 if (acc.Allow_New_Application_as_Provider__c == true || acc.Allow_Renewal_as_Assistant__c == true){
                 	if (LicensingRTName == 'FCC Assistant Renewal' && acc.Allow_Renewal_as_Assistant__c == true){
                 		lt.SetProviderAsAssistant__c = true;
                 	}
                 }
                 else{
                 	lt.SetProviderAsAssistant__c = false;
                 }
                /*if(acc.Renewal_date__c != null && leadConfig != null){
                     if (leadConfig.FCC_Renewal_Significant_Delay__c != null){
                         accRenewalDate = acc.Renewal_date__c.addDays(Integer.valueOf(leadConfig.FCC_Renewal_Significant_Delay__c));
                     }
                }
                
                //Associated Fee ONLY set on spl Transactions FCC applying as Assistant OR Assistant applying as Provider
                if (acc.Allow_New_Application_as_Provider__c == true || acc.Allow_Renewal_as_Assistant__c == true){
                    if (LicensingRTName == 'FCC New License' && acc.Allow_New_Application_as_Provider__c == true){
                        lt.Associated_Fee__c = providerFeeMap.get('Family Child Care').New_License_Fee__c;
                    }
                    
                    if (LicensingRTName == 'FCC Assistant Renewal' && acc.Allow_Renewal_as_Assistant__c == true){
                        lt.SetProviderAsAssistant__c = true;
                        if(lt.License_Requested__c.contains('Certified')){
                           lt.Associated_Fee__c = providerFeeMap.get('FCC Assistant').License_Renewal_Fee__c;
                        }
                        else{
                            lt.Associated_Fee__c = 0;
                        }                        
                     }
                }
                else{
                    lt.SetProviderAsAssistant__c = false;
                }*/
                
                List<Transaction_Process_Step__c> listSteps =  mapProcessStep.get(lt.Transaction_Configuration__c);
                
                if(listSteps != null && listSteps.size() > 0){
                    for(Transaction_Process_Step__c transactionProcessStep : listSteps){
                        lt.put(transactionProcessStep.Associated_Transaction_Field__c, '');
                        List<Step_Process_Rule__c> listProcessRule = transactionProcessStep.Step_Process_Rules__r;
                        
                        for(Step_Process_Rule__c processRule : listProcessRule){
                            if(lt.get(processRule.Standard_Process_Rule__r.API_Name_of_field_to_be_Tested__c) == false){
                                lt.put(transactionProcessStep.Associated_Transaction_Field__c , lt.get(transactionProcessStep.Associated_Transaction_Field__c) + ', ' + processRule.Standard_Process_Rule__r.Message_If_Field_False__c);
                            }
                        }

                        string fieldValue = string.valueof(lt.get(transactionProcessStep.Associated_Transaction_Field__c));
                        
                        if(string.isNotBlank(fieldValue)){
                            fieldValue = fieldValue.substring(2, fieldValue.length());
                            lt.put(transactionProcessStep.Associated_Transaction_Field__c, fieldValue);
                        }
                    }
                }
                
                if(string.isBlank(lt.Missing_to_move_to_Under_Review__c)){
                    if(string.isNotEmpty(lt.Missing_Elements_For_Licensor_2__c) && lt.Missing_Elements_For_Licensor_2__c.contains('Not Under Review')){
                        lt.Missing_Elements_For_Licensor_2__c = lt.Missing_Elements_For_Licensor_2__c.replace('Not Under Review','');
                        lt.Missing_Elements_For_Licensor_2__c = lt.Missing_Elements_For_Licensor_2__c.replace(',,',',');
                        if(lt.Missing_Elements_For_Licensor_2__c.trim() == ',')
                            lt.Missing_Elements_For_Licensor_2__c = '';
                    }
                    if(string.isNotEmpty(lt.Missing_Elements_For_Finalizing__c) && lt.Missing_Elements_For_Finalizing__c.contains('Not Under Review')){
                        lt.Missing_Elements_For_Finalizing__c = lt.Missing_Elements_For_Finalizing__c.replace('Not Under Review','');
                        lt.Missing_Elements_For_Finalizing__c = lt.Missing_Elements_For_Finalizing__c.replace(',,',',');
                        if(lt.Missing_Elements_For_Finalizing__c.trim() == ',')
                            lt.Missing_Elements_For_Finalizing__c = '';
                    }
                }
                if(string.isNotEmpty(lt.Missing_Elements_For_Licensor_2__c) && lt.Missing_Elements_For_Licensor_2__c.trim() == ',')
                    lt.Missing_Elements_For_Licensor_2__c = '';
                if(string.isNotEmpty(lt.Missing_Elements_For_Licensor_2__c) && lt.Missing_Elements_For_Finalizing__c.trim() == ',')
                    lt.Missing_Elements_For_Finalizing__c = '';     
                        
                if(string.isBlank(lt.Missing_Elements_For_Licensor_2__c)){
                    lt.Ready_for_Processing__c = true;
                }
                else{
                    lt.Ready_for_Processing__c = false;
                }
                  
                if (string.isBlank(lt.Missing_Elements_For_Finalizing__c)){
                    lt.Ready_for_Closing_LT__c = true;
                }
                else{
                    lt.Ready_for_Closing_LT__c = false;
                }     
            }//end for
        //}//End of isTransactionSubmitted check
    }
    
     public static void updateRegion(){
        Set<Id> providerSet = new Set<Id>();
        Set<Id> citySet = new Set<Id>();
        List<City_Assignment__c> listCity = new List<City_Assignment__c>();
        Map<Id, List<City_Assignment__c>> mapCityAssignment = new Map<Id, List<City_Assignment__c>>();
        
        Map<Id,Licensing_Transaction__c> mapAssignedTo = new Map<Id,Licensing_Transaction__c>();
        Set<Id> setUsers = new set<Id>();
        Map<Id, User> mapUser = new Map<Id, User>();
        
        Map<Id,RecordType> maptransRecordType = new Map<Id,RecordType>([select id,name,SobjectType from RecordType where (name like '%Change%' or name like '%Move%') AND SobjectType = 'Licensing_Transaction__c']);
        
        Map<Id,RecordType> mapAlltransRecordType = new Map<Id,RecordType>([select id,name,SobjectType from RecordType where SobjectType = 'Licensing_Transaction__c']);
        
        Set<Id> setTransaction = new Set<Id>();
        for(Licensing_Transaction__c lt : newList){
            if(maptransRecordType.get(lt.RecordTypeId) != null){
                providerSet.add(lt.provider__c);
                citySet.add(lt.New_City__c);
            }            
            if(oldLT != null && oldLT.get(lt.Id) != null){
                if(lt.Assigned_To__c != oldLT.get(lt.Id).Assigned_To__c){
                    mapAssignedTo.put(lt.Id, lt);
                    setUsers.add(lt.Assigned_To__c);
                    setUsers.add(oldLT.get(lt.Id).Assigned_To__c);
                }               
                if(lt.Licensor_Re_assignment_for_Region_Change__c == false && oldLT.get(lt.Id).Licensor_Re_assignment_for_Region_Change__c == true){
                    setTransaction.add(lt.Id);
                }
            }
        }
        
        if(citySet.size() > 0){
            listCity = [SELECT City__r.Name, Region__r.Name, Applicable_To__c, City__c, Region__c
                                            FROM City_Assignment__c
                                            WHERE City__r.Id IN : citySet];
            
            for(City_Assignment__c cityAssignment : listCity){
                List<City_Assignment__c> listCityAssignment;
                if(mapCityAssignment.get(cityAssignment.City__c) == null){
                    listCityAssignment = new List<City_Assignment__c>();
                }
                else{
                    listCityAssignment = mapCityAssignment.get(cityAssignment.City__c);
                }
                listCityAssignment.add(cityAssignment);
                mapCityAssignment.put(cityAssignment.City__c, listCityAssignment);
            }
        }
        
        if(providerSet.size() > 0){
            providerMap = new Map<Id,Account>([select Id, Name, RecordType.Name, RecordType.DeveloperName,Region__r.Name from Account where Id in :providerSet]);
        }
        
        List<Messaging.SingleEmailMessage> listMail = new List<Messaging.SingleEmailMessage>();
        
        for(Licensing_Transaction__c lt : newList){
            if(maptransRecordType.get(lt.RecordTypeId) != null){
                if(mapCityAssignment.get(lt.New_City__c) != null){
                    Account acc = providerMap.get(lt.Provider__c);
                    List<City_Assignment__c> listCityAssignment = mapCityAssignment.get(lt.New_City__c);
                    
                    for(City_Assignment__c cityAssignment : listCityAssignment){
                        if(cityAssignment.Applicable_To__c.contains(acc.RecordType.Name)){
                            if(acc.Region__r.Name != cityAssignment.Region__r.Name){
                                lt.New_Region__c = cityAssignment.Region__r.Name;
                                break;
                            }
                        }
                    }
                }
            }
        }
        
        if(setUsers.size() > 0){            
            mapUser = new Map<Id,User>([select Id, Region__c from User where Id in : setUsers]);
            
            EmailTemplate template = [SELECT Body,brandtemplateid,Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Provider_Region_Changed_Licensor_Re_assigned'];
                    
            for(Licensing_Transaction__c lt : newList){
                if(mapAssignedTo.get(lt.Id) != null){
                    if(oldLT != null && oldLT.get(lt.Id) != null && mapUser.get(oldLT.get(lt.Id).Assigned_To__c) != null){
                        if(mapUser.get(lt.Assigned_To__c).Region__c != mapUser.get(oldLT.get(lt.Id).Assigned_To__c).Region__c){
                            String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + lt.Id;
                            string bodyText = template.Body
                                .replace('{!Licensing_Transaction__c.RecordType}', mapAlltransRecordType.get(lt.RecordTypeId).Name)
                                .replace('{!Licensing_Transaction__c.Provider__c}', providerMap.get(lt.provider__c).Name)
                                .replace('{!Licensing_Transaction__c.Link}', fullRecordURL);
                
                            lt.Licensor_Re_assignment_for_Region_Change__c = false;
                            setTransaction.add(lt.Id);
                             
                             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                             mail.setTargetObjectId(lt.Assigned_To__c);
                             mail.setSubject(template.Subject);     
                             mail.setPlainTextBody(bodyText);
                             mail.setSaveAsActivity(false); 
                             listMail.add(mail);
                             
                             mail = new Messaging.SingleEmailMessage();
                             mail.setTargetObjectId(oldLT.get(lt.Id).Assigned_To__c);
                             mail.setSubject(template.Subject);     
                             mail.setPlainTextBody(bodyText);
                             mail.setSaveAsActivity(false); 
                             listMail.add(mail);
                        }                   
                    }
                }
            }
        }
        
        if(listMail.size() > 0){
            Messaging.sendEmail(listMail);
        }
        
        if(setTransaction.size() > 0){
            List<Task> listTask = [select Id, Subject, Status from Task where whatId in : setTransaction and
                                    Status <> 'Completed' and Subject like '%Change of address: Re-assign Licensor for change in region%'];
            
            for(Task task : listTask){
                task.Status = 'Completed';
            }
            
            if(listTask.size() > 0)
                update listTask;
        }
     }
     //End of Utility Methods
}