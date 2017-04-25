@isTest
public with sharing class HistoryOfNonComplianceTriggerHelperTest {
     
     @isTest static void bulkVisitInsertTest() {
     	
     	HistoryOfNonCompliance__c nc = new HistoryOfNonCompliance__c();
     	
     	nc.Name = '603735';
     	nc.Interaction__c = '1179 - Monitoring Visit';
     	nc.InteractionDate__c = Date.parse('10/14/2014');
     	nc.citation__c = '7.08';
     	
     	insert nc;
     	
     	HistoryOfNonCompliance__c ncResult = [Select Id,Name From HistoryOfNonCompliance__c Where name ='603735'];
     	
     	system.assert(ncResult != null);
     	

     }
}