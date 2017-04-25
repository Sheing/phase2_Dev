<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Meeting_Status</fullName>
        <description>When no.of seats is changed and status = Closed for registration, then update status = Closed for registration</description>
        <field>Meeting_Status__c</field>
        <literalValue>Closed for registration</literalValue>
        <name>Update Meeting Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
