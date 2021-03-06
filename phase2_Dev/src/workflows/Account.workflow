<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Automatically_alert_EEC_of_FCC_Assistant_certificate_renewal_120_days</fullName>
        <description>Automatically alert EEC of FCC Assistant certificate renewal - 120 days</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X94_FCC_Assistant_Notification_to_Assistant_120_days_prior_to_license_Renewal</template>
    </alerts>
    <alerts>
        <fullName>Automatically_alert_EEC_of_FCC_Assistant_certificate_renewal_30_days</fullName>
        <description>Automatically alert EEC of FCC Assistant certificate renewal - 30 days</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X96_FCC_Assistant_Renewal_Reminder_to_Assistant_30_days_prior_to_license_exp</template>
    </alerts>
    <alerts>
        <fullName>Automatically_alert_EEC_of_FCC_Assistant_certificate_renewal_60_days</fullName>
        <description>Automatically alert EEC of FCC Assistant certificate renewal - 60 days</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X95_FCC_Assistant_Renewal_Reminder_to_Assistant_60_days_prior_to_license_exp</template>
    </alerts>
    <alerts>
        <fullName>Automatically_alert_EEC_of_licensing_renewal_120_days</fullName>
        <description>Automatically alert EEC of licensing renewal - 120 days</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X54_Notification_to_Provider_120_days_prior_to_license_Renewal</template>
    </alerts>
    <alerts>
        <fullName>Automatically_alert_EEC_of_licensing_renewal_30_days</fullName>
        <description>Automatically alert EEC of licensing renewal - 30 days</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X56_Renewal_Reminder_to_Provider_30_days_prior_to_license_expiration</template>
    </alerts>
    <alerts>
        <fullName>Automatically_alert_EEC_of_licensing_renewal_60_days</fullName>
        <description>Automatically alert EEC of licensing renewal - 60 days</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X55_Renewal_Reminder_to_Provider_60_days_prior_to_license_expiration</template>
    </alerts>
    <alerts>
        <fullName>Email_Provider_to_submit_Quarterly_Restraint_Report</fullName>
        <description>Email Provider to submit Quarterly Restraint Report</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X50_Notification_to_Provider_to_Submit_Quarterly_Restratint_Report</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Provider_When_Report_Published_on_Web</fullName>
        <description>Email to Provider When Report Published on Web</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/Test_13_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Followup_Reminder_to_Provider_to_Submit_Quarterly_Restraint_Report</fullName>
        <description>Followup Reminder to Provider to Submit Quarterly Restraint Report</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X51_Followup_15_Days_to_Submit_Quarterly_Restratint_Report</template>
    </alerts>
    <alerts>
        <fullName>Followup_Reminder_to_Provider_to_Submit_Quarterly_Restraint_Report_After_30_Days</fullName>
        <description>Followup Reminder to Provider to Submit Quarterly Restraint Report - After 30 Days</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X52_Followup_20_Days_to_Submit_Quarterly_Restratint_Report</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_licensors</fullName>
        <description>Send email to licensors</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EEC_Int_Communication_Template_Folder/X132_Reminder_Sent_to_Provider_for_Missing_Investigation_Conclusion_for_Foster</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_provider</fullName>
        <description>Send email to Provider</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X131_Investigation_conclusion_missing_for_a_Foster_Home_51A_or_Incident_from_po</template>
    </alerts>
    <alerts>
        <fullName>X100_FCC_Assistant_Licensing_Transaction_Processed_Notification_to_Provider</fullName>
        <description>100 - FCC Assistant Licensing Transaction Processed - Notification to Provider</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X100_FCC_Assistant_FCC_Transaction_Processed</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Account_RecordType_FCC</fullName>
        <field>RecordTypeId</field>
        <lookupValue>FCC</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Account RecordType FCC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Account_RecordType_FCC_Assistant</fullName>
        <field>RecordTypeId</field>
        <lookupValue>FCC_Assistant</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Account RecordType FCC Assistant</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Check_Provider_uncheck_flag_hidden</fullName>
        <field>Uncheck_Flags_Hidden__c</field>
        <literalValue>1</literalValue>
        <name>Check Provider.uncheck flag hidden</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Check_Use_Physical_Restraints</fullName>
        <description>When Restraint Method is anything other than NonRestraint, ensure that the Use Physical Restraints box is checked</description>
        <field>Use_Physical_Restraints__c</field>
        <literalValue>1</literalValue>
        <name>Check Use Physical Restraints</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>City</fullName>
        <description>Shipping City = Billing City</description>
        <field>ShippingCity</field>
        <formula>BillingCity</formula>
        <name>City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Last_Calculated_Differential_Visit</fullName>
        <field>LastCalcDiffVisit__c</field>
        <formula>Last_Calculated_Differential_Visit__c</formula>
        <name>Copy Last_Calculated_Differential_Visit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mailing_Address_Reformating_2</fullName>
        <field>Mailing_Address_Reformated__c</field>
        <formula>ShippingStreet &amp; &quot;, &quot; &amp; ShippingCity &amp; &quot; &quot; &amp; ShippingState &amp; &quot; &quot; &amp; ShippingPostalCode</formula>
        <name>Mailing Address Reformating</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_AccountRecord_Type_Hidden_value</fullName>
        <field>AccountRecord_Type_Hidden__c</field>
        <name>Reset AccountRecord Type Hidden value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Provider_Uncheck_Flag_Hidden</fullName>
        <field>Uncheck_Flags_Hidden__c</field>
        <literalValue>0</literalValue>
        <name>Reset Provider.Uncheck Flag Hidden</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Last_Address_Changed_Date</fullName>
        <field>Last_Address_Change_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Last Address Changed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Last_Legal_Order_Change_Date</fullName>
        <field>Last_Legal_Order_Change_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Last Legal Order Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Last_Provider_Type_Change_Date</fullName>
        <field>Last_Provider_Type_Change_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Last Provider Type Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Last_Status_Changed_Date_to_Today</fullName>
        <description>Since the provider&apos;s status has changed, update the Last Status Changed Date to today&apos;s date</description>
        <field>Status_Last_Changed_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Last Status Changed Date to Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_License_For_10_Upgrade_Date</fullName>
        <field>License_For_10_Upgrade_Date__c</field>
        <formula>Last_Issue_Date__c</formula>
        <name>Set License For 10 Upgrade Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Next_FCC_Renewal_Visit_c_to_NULL</fullName>
        <field>Next_FCC_Renewal_Visit__c</field>
        <name>Set Next_FCC_Renewal_Visit__c to NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Previous_License_Number</fullName>
        <field>Previous_License_Number__c</field>
        <formula>IF(NOT(ISBLANK(Current_License_Number__c)), Current_License_Number__c,&apos;&apos;)</formula>
        <name>Set Previous License Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Visit_Provider_Diff_License_to_NULL</fullName>
        <field>Differential_Licensing_Lifecycle__c</field>
        <name>Set Visit.Provider.Diff-License to NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Visit_Provider_Differential_Licensin</fullName>
        <description>Set Visit.Provider.Differential Licensing Lifecycle field to:
&quot;Pre-Licensing&quot; if Provider Status &quot;New Application in Progress&quot; OR Provider Status = &quot;Re-open in progress&quot;</description>
        <field>Differential_Licensing_Lifecycle__c</field>
        <literalValue>Pre-Licensing</literalValue>
        <name>Set Visit.Provider.Differential Licensin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Visit_Provider_Prev_Licensing_Visit</fullName>
        <field>Previous_Licensing_Visit_Reason__c</field>
        <formula>NULL</formula>
        <name>Set Visit.Provider.PrevLicenseVisit NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>State</fullName>
        <description>Shipping State = Billing State</description>
        <field>ShippingState</field>
        <formula>BillingState</formula>
        <name>State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Street</fullName>
        <description>Shipping Street  = Billing Street</description>
        <field>ShippingStreet</field>
        <formula>BillingStreet</formula>
        <name>Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Allow_New_Appln_as_Provider</fullName>
        <field>Allow_New_Application_as_Provider__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Allow New Appln as Provider</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Allow_Renewal_as_Assistant</fullName>
        <field>Allow_Renewal_as_Assistant__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Allow Renewal as Assistant</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Use_Physical_Restraints</fullName>
        <description>Since Restraint Method is set to NonRestraint, uncheck the Use Physical Restraints checkbox</description>
        <field>Use_Physical_Restraints__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Use Physical Restraints</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Previous_Type</fullName>
        <field>Previous_Type__c</field>
        <formula>IF(  RecordTypeId  =  PRIORVALUE(RecordTypeId) , Previous_Type__c , PRIORVALUE(  Record_Type_Name__c  ))</formula>
        <name>Update Previous Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type</fullName>
        <description>Update Record Type of Account to FCC Assistant</description>
        <field>RecordTypeId</field>
        <lookupValue>FCC_Assistant</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_type_to_Family_Child_Care</fullName>
        <description>This will update the record type to Family Child Care</description>
        <field>RecordTypeId</field>
        <lookupValue>FCC</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record type to Family Child Care</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_type_to_Large_Group</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Large_Group</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record type to Large Group</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status</fullName>
        <field>Provider_Status__c</field>
        <literalValue>Application Withdrawn / Closed</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Zip_Code</fullName>
        <description>Shipping Zip = Billing Zip</description>
        <field>ShippingPostalCode</field>
        <formula>BillingPostalCode</formula>
        <name>Zip Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AccountRecord Type %28Hidden%29 %3D New Assistant</fullName>
        <actions>
            <name>Update_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.AccountRecord_Type_Hidden__c</field>
            <operation>equals</operation>
            <value>New Assistant</value>
        </criteriaItems>
        <description>When AccountRecord Type (Hidden) = New Assistant upon the conversion of an lead new assistant to an account</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Copy calculated formula Last_Calculated_Differential_Visit%5F%5Fc</fullName>
        <actions>
            <name>Copy_Last_Calculated_Differential_Visit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Last_Calculated_Differential_Visit__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This will copy the calculated value from formula field &quot;Last_Calculated_Differential_Visit__c&quot; to be used in formula field &quot;Need_Licensing_Visit__c&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Feed Previous Type</fullName>
        <actions>
            <name>Update_Previous_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>R&amp;P Umbrella,Large and Small Group Umbrella,FCC Assistant</value>
        </criteriaItems>
        <description>When record type is changed, feed previous record type</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Mailing Address Reformating</fullName>
        <actions>
            <name>Mailing_Address_Reformating_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( ShippingStreet ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Provider Capacity Change to Up to 10 People</fullName>
        <actions>
            <name>Set_License_For_10_Upgrade_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update License For 10 Upgrade Date with Provider.Last Issue Date</description>
        <formula>AND( RecordType.Name= &quot;Family Child Care&quot;,  Capacity__c = &quot;Up to 10 Children&quot;,  OR( PRIORVALUE( Capacity__c ) = &quot;Up to 6 Children&quot;, PRIORVALUE( Capacity__c ) = &quot;Up to 8 Children; 2 School Aged&quot;,  ISBLANK(PRIORVALUE( Capacity__c )) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Provider Capacity Change to Up to 10 People - 270 Day Task Reminder for Renewal</fullName>
        <actions>
            <name>Schedule_the_6_month_follow_up_visit_after_license_upgrade_Up_to_10</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Provider 270 Day Task Reminder for Renewal when Capacity is changed to Up to 10 People</description>
        <formula>AND( RecordType.Name= &quot;Family Child Care&quot;,  Capacity__c = &quot;Up to 10 Children&quot;,  OR( PRIORVALUE( Capacity__c ) = &quot;Up to 6 Children&quot;, PRIORVALUE( Capacity__c ) = &quot;Up to 8 Children; 2 School Aged&quot;,  ISBLANK(PRIORVALUE( Capacity__c )) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Provider Last Status Changed Date Update</fullName>
        <actions>
            <name>Set_Last_Status_Changed_Date_to_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the Last Status Changed Date on the Provider to current date each time the Provider Status field is updated/created</description>
        <formula>ISCHANGED( Provider_Status__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Provider Restraint Method Equal Non-Restraint</fullName>
        <actions>
            <name>Uncheck_Use_Physical_Restraints</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Actions to be performed when the Restraint Method value is changed on a Provider</description>
        <formula>OR(  ISPICKVAL(Restraint_Method__c , &apos;NonRestraint&apos;) ,  ISBLANK(TEXT(Restraint_Method__c))  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Provider Restraint Method Not Equal Non-Restraint</fullName>
        <actions>
            <name>Check_Use_Physical_Restraints</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Actions to be performed when the Restraint Method value is changed on a Provider to any value other than NonRestraint</description>
        <formula>AND(      NOT( ISPICKVAL(Restraint_Method__c , &apos;NonRestraint&apos;) ),      NOT( ISBLANK(TEXT(Restraint_Method__c)) )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Provider Restraint Report Automation Updated</fullName>
        <active>true</active>
        <description>Actions to be performed when the Restraint Report Automation value is changed to TRUE</description>
        <formula>AND( Restraint_Report_Automation__c = TRUE,  OR(Last_Quarterly_Restraint_Published__c &lt;&gt;  Current_Restraint_Report__c,  ISBLANK(  Last_Quarterly_Restraint_Published__c  )))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Collect_Quarterly_Restraint_Report</name>
                <type>Task</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Provider Restraint Report Email and Task Actions</fullName>
        <actions>
            <name>Email_Provider_to_submit_Quarterly_Restraint_Report</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_sent_Notification_to_Provider_to_Submit_Quarterly_Restraint_Report_50</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Actions to be performed when the Restraint Report Automation value is changed to TRUE</description>
        <formula>AND( Restraint_Report_Automation__c = TRUE,  OR(Last_Quarterly_Restraint_Published__c &lt;&gt;  Current_Restraint_Report__c,  ISBLANK( Last_Quarterly_Restraint_Published__c )), Electronic_Communication__c = TRUE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Followup_Reminder_to_Provider_to_Submit_Quarterly_Restraint_Report_After_30_Days</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Collect_Quarterly_Restraint_Report_30days</name>
                <type>Task</type>
            </actions>
            <actions>
                <name>Email_sent_Reminder_2_to_provider_for_restraint_report_to_submit_52</name>
                <type>Task</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Followup_Reminder_to_Provider_to_Submit_Quarterly_Restraint_Report</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_sent_Reminder_1_to_provider_for_restraint_report_to_submit_51</name>
                <type>Task</type>
            </actions>
            <timeLength>25</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Provider status Update</fullName>
        <actions>
            <name>Update_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL( License_Status__c, &apos;Not Licensed&apos;) , OR( ISPICKVAL( Provider_Status__c , &apos;Application To Be Received&apos;) , ISPICKVAL(Provider_Status__c, &apos;Attended to PPM Meeting&apos;)), OR( AND( ISNULL(PPM_Meeting_Attended_Date__c),LastModifiedDate &lt;= Now()-90 ),  PPM_Meeting_Attended_Date__c &lt;= Today()-90 )     )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Reset Provider Flags</fullName>
        <actions>
            <name>Reset_AccountRecord_Type_Hidden_value</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Reset_Provider_Uncheck_Flag_Hidden</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Allow_New_Appln_as_Provider</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Allow_Renewal_as_Assistant</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Account.Uncheck_Flags_Hidden__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Allow_New_Application_as_Provider__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Allow_Renewal_as_Assistant__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Reset Provider.Allow Renewal as Assistant and Provider.Allow New Application as Provider to False</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Last Address Change Date</fullName>
        <actions>
            <name>Set_Last_Address_Changed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updated and filled with today&apos;s date each time the address of the provider is changed (field to consider as a change = Street Address 1 and / or City). It shouldn&apos;t be set when the record is created.</description>
        <formula>(ISCHANGED( Provider_Address_1__c ) || ISCHANGED ( Provider_City__c )) &amp;&amp; NOT(ISNEW())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Last Legal Order Change Date</fullName>
        <actions>
            <name>Set_Last_Legal_Order_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updated and filled with today&apos;s date each time &quot;Legal Order&quot; field is changed to a value &lt;&gt; NULL</description>
        <formula>ISCHANGED( Legal_Order__c ) &amp;&amp; NOT(ISBLANK( Legal_Order__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Last Provider Type Change Date</fullName>
        <actions>
            <name>Set_Last_Provider_Type_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updated and filled with today&apos;s date each time the record type of the provider is changed. It shouldn&apos;t be set when the record is created.</description>
        <formula>ISCHANGED(  RecordTypeId  ) &amp;&amp; NOT(ISNEW())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Shipping Address equals Billing Address</fullName>
        <actions>
            <name>City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Zip_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Shipping Address equals Billing Address</description>
        <formula>NOT(OR(ISBLANK(  BillingCity  )))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Record Type to FCC</fullName>
        <actions>
            <name>Change_Account_RecordType_FCC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Check_Provider_uncheck_flag_hidden</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.AccountRecord_Type_Hidden__c</field>
            <operation>equals</operation>
            <value>Family Child Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Allow_New_Application_as_Provider__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When AccountRecord Type (Hidden) = Family Child Care and Allow New Application as Provideris True, Change the Account Record Type upon closing the Licensing Transaction</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Record Type to FCC Assistant</fullName>
        <actions>
            <name>Change_Account_RecordType_FCC_Assistant</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Check_Provider_uncheck_flag_hidden</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.AccountRecord_Type_Hidden__c</field>
            <operation>equals</operation>
            <value>FCC Assistant</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Allow_Renewal_as_Assistant__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When AccountRecord Type (Hidden) = FCC Assistant and Allow Renewal as Assistant is True, Change the Account Record Type upon closing the Licensing Transaction</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Differential Licensing Lifecycle- NOT New Application Status</fullName>
        <actions>
            <name>Set_Next_FCC_Renewal_Visit_c_to_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Visit_Provider_Diff_License_to_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Visit_Provider_Prev_Licensing_Visit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(OR(ISCHANGED(Provider_Status__c), ISNEW()), NOT(OR(ISPICKVAL(Provider_Status__c, &quot;New Application in Progress&quot;),ISPICKVAL(Provider_Status__c, &quot;Re-open in Progress&quot;))),  ISPICKVAL(License_Status__c, &quot;Not Licensed&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Differential Licensing Lifecycle- New Application Status</fullName>
        <actions>
            <name>Set_Next_FCC_Renewal_Visit_c_to_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Visit_Provider_Differential_Licensin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Visit_Provider_Prev_Licensing_Visit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(OR(ISCHANGED(Provider_Status__c),  ISNEW() ), OR(ISPICKVAL(Provider_Status__c, &quot;New Application in Progress&quot;), ISPICKVAL(Provider_Status__c, &quot;Re-open in Progress&quot;)), ISPICKVAL(License_Status__c, &quot;Not Licensed&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Previous License Number</fullName>
        <actions>
            <name>Set_Previous_License_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Account.Allow_Renewal_as_Assistant__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Record Type %3D Potential Provider to FCC</fullName>
        <actions>
            <name>Update_Record_type_to_Family_Child_Care</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.AccountRecord_Type_Hidden__c</field>
            <operation>equals</operation>
            <value>Potential Provider (FCC)</value>
        </criteriaItems>
        <description>This rule will update the provider record type =  Family Child Care when the Lead record type = Potential Provider</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Record Type %3D Potential Provider to GSA</fullName>
        <actions>
            <name>Update_Record_type_to_Large_Group</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.AccountRecord_Type_Hidden__c</field>
            <operation>equals</operation>
            <value>Potential Provider GSA</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>end the email to provider</fullName>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Account.Electronic_Communication__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>send the email to provider and licensor and create a closed task to indicate that an email was sent</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Collect_Quarterly_Restraint_Report</fullName>
        <assignedToType>owner</assignedToType>
        <description>Collect Quarterly Restraint Report</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Collect Quarterly Restraint Report</subject>
    </tasks>
    <tasks>
        <fullName>Collect_Quarterly_Restraint_Report_30days</fullName>
        <assignedToType>owner</assignedToType>
        <description>Reminder to Licensor to follow up with Provider and collect Quarterly Restraint Report, if not received after 30 days from first creating the email notification</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Collect Quarterly Restraint Report_30days</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Notification_to_Provider_to_Submit_Quarterly_Restraint_Report_50</fullName>
        <assignedToType>owner</assignedToType>
        <description>Email sent to the provider to inform that restraint report for the past quarter should be submitted</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Notification to Provider to Submit Quarterly Restraint Report - #50</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Reminder_1_to_provider_for_restraint_report_to_submit_51</fullName>
        <assignedToType>owner</assignedToType>
        <description>Email sent to the provider 25 days after first email to remind that restraint report must be submitted</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Reminder #1 to provider for restraint report to submit - #51</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Reminder_2_to_provider_for_restraint_report_to_submit_52</fullName>
        <assignedToType>owner</assignedToType>
        <description>Email sent to the provider 30 days after first email to remind that restraint report must be submitted</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Reminder #2 to provider for restraint report to submit - #52</subject>
    </tasks>
    <tasks>
        <fullName>Schedule_the_6_month_follow_up_visit_after_license_upgrade_Up_to_10</fullName>
        <assignedToType>owner</assignedToType>
        <description>Schedule the 6-month follow-up visit after license upgrade (Up to 10)</description>
        <dueDateOffset>270</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Account.Last_Issue_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Schedule the 6-month follow-up visit after license upgrade (Up to 10)</subject>
    </tasks>
</Workflow>
