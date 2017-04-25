<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Licensing Transaction Created for FCC Change of Name</fullName>
        <active>false</active>
        <formula>AND( OR( ISCHANGED( FirstName ), ISCHANGED( LastName ) ),  Account.RecordType.Name = &quot;Family Child Care&quot;,  LastModifiedBy.Profile.Name = &quot;EEC Community Standard User&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
