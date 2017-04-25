<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Last_Status_Date</fullName>
        <description>Update the last status updated date for a new change.</description>
        <field>Last_Status_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Last Status Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Transaction Document Status Date on Status Change</fullName>
        <actions>
            <name>Update_Last_Status_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED(Status__c ), ISPICKVAL(Status__c, &apos;New Attachment&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
