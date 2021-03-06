<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notification_to_Provider_after_Corrective_Plan_rejected_on_non_compliance_object</fullName>
        <description>Notification to Provider after Corrective Plan rejected (on non-compliance object)</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X88b_Notification_to_Provider_after_Corrective_Plan_rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Updat_Last_Corrective_Action_EEC_Fedback</fullName>
        <description>Update Last Corrective Action EEC Feedback to today</description>
        <field>Last_Corrective_Action_EEC_Feedback__c</field>
        <formula>TODAY()</formula>
        <name>Updat Last Corrective Action EEC Fedback</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Corrective_Actions_Submitter_wi</fullName>
        <description>Update &quot;Corrective Actions Submitter&quot; with First / Last name of the user who did the update</description>
        <field>Corrective_Actions_Submitter__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp; $User.LastName</formula>
        <name>Update &quot;Corrective Actions Submitter&quot; wi</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Create_History_Record_flag</fullName>
        <description>Update create history flag to true.</description>
        <field>Create_History_Record_flag__c</field>
        <literalValue>1</literalValue>
        <name>Update Create History Record flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Corrective_Actions_Received</fullName>
        <description>Update &quot;Date Corrective Actions Received&quot; with Today</description>
        <field>Date_Corrective_Actions_Received__c</field>
        <formula>Today()</formula>
        <name>Update &quot;Date Corrective Actions Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status</fullName>
        <field>Correction_Plan_Status__c</field>
        <literalValue>Provider To Submit</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_To_Review_on_Portal</fullName>
        <description>Set To Review on Portal to true</description>
        <field>To_Review_on_Portal__c</field>
        <literalValue>1</literalValue>
        <name>Update To Review on Portal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_To_review_on_portal_to_False</fullName>
        <description>Update &quot;To review on portal&quot; to False</description>
        <field>To_Review_on_Portal__c</field>
        <literalValue>0</literalValue>
        <name>Update &quot;To review on portal&quot; to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Non Compliant Item Correction Action EEC Feedback Change</fullName>
        <actions>
            <name>Updat_Last_Corrective_Action_EEC_Fedback</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_To_Review_on_Portal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>DUPLICATE - Process flow also exists
If Correction Action Feedback is changed from empty to a value then: 
- Update &quot;Last Corrective Actions EEC Feedback&quot; with Today 
- Update &quot;To review on portal&quot; to True</description>
        <formula>AND(  ISCHANGED( Corrective_Action_EEC_Feedback__c ),  NOT( ISBLANK( Corrective_Action_EEC_Feedback__c )),  NOT(ISBLANK( Corrective_Actions_Submitter__c)), NOT(To_Review_on_Portal__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Non Compliant Item Correction Plan Change</fullName>
        <actions>
            <name>Update_Corrective_Actions_Submitter_wi</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Create_History_Record_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Date_Corrective_Actions_Received</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_To_review_on_portal_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>If Correction Plan is changed from empty to a value then: 
- Update &quot;Date Corrective Actions Received&quot; with Today 
- Update &quot;Corrective Actions Submitter&quot; with user who did the update 
- Update &quot;To review on portal&quot; to False</description>
        <formula>OR(  AND( NOT( ISBLANK( Correction_Plan__c )), ISCHANGED (Correction_Plan__c ), NOT(Save_for_Later__c) ),   AND ( ISCHANGED(Save_for_Later__c), NOT(Save_for_Later__c), NOT( ISBLANK( Correction_Plan__c ))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
