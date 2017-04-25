<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Early_Education_and_Child_Care_Department_Submission_Confirmation_Change_of_Addr</fullName>
        <description>Early Education and Child Care Department - Submission Confirmation (Change of Address)</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X47b_Transaction_Electronic_Submission_Confirmation_Address_Change_docx</template>
    </alerts>
    <alerts>
        <fullName>Early_Education_and_Child_Care_Department_Submission_Confirmation_New_License_Re</fullName>
        <description>Early Education and Child Care Department - Submission Confirmation (New License / Renewal / Upgrade)</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X47a_Transaction_Electronic_Submission_Confirmation_New_App_Renewal_Upgrade</template>
    </alerts>
    <alerts>
        <fullName>Early_Education_and_Child_Care_Department_Submission_Confirmation_Other_Transact</fullName>
        <description>Early Education and Child Care Department - Submission Confirmation (Other Transactions)</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X47c_Transaction_Electronic_Submission_Confirmation_Other</template>
    </alerts>
    <alerts>
        <fullName>Email_FCC_Assistant_to_Notify_14_Days_Has_Passed_Since_Submission_Via_Portal</fullName>
        <description>Email FCC Assistant to Notify 14 Days Has Passed Since Submission Via Portal</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X103_FCC_Assistant_Submitted_Transaction_still_pending_after_14_days</template>
    </alerts>
    <alerts>
        <fullName>Email_Licensor_that_a_Licensing_Transaction_Requires_Review</fullName>
        <description>Email Licensor that a Licensing Transaction Requires Review</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_User_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X60_New_Licensing_Transaction_to_Review</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_to_Provider_after_Licensing_Transaction_Sent_For_Revision</fullName>
        <description>Email Notification to Provider after Licensing Transaction Sent For Revision</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X89_Notification_to_Provider_after_Licensing_Transaction_Sent_For_Revision</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_to_Provider_after_Rejected_Documents_Sent_For_Revision</fullName>
        <description>Email Notification to Provider after Rejected Documents Sent For Revision</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X90_Notification_to_Provider_after_Rejected_Documents_Sent_For_Revision</template>
    </alerts>
    <alerts>
        <fullName>Email_Provider_to_Notify_14_Days_Has_Passed_Since_Submission_Via_Portal</fullName>
        <description>Email Provider to Notify 14 Days Has Passed Since Submission Via Portal</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X76_Submitted_Transaction_still_pending_after_14_days</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_to_Licensor_that_the_license_is_issued</fullName>
        <description>Email alert to Licensor that the license is issued</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Assigned_User_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X112_Notification_to_Licensor_of_License_issued</template>
    </alerts>
    <alerts>
        <fullName>FCC_Assistant_Remainder_Email_for_signature_of_BRC_Consent</fullName>
        <description>FCC Assistant Remainder Email for signature of BRC Consent</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X98_Signature_of_Licensee_BRC_consent_Pending_Reminder</template>
    </alerts>
    <alerts>
        <fullName>FCC_Assistant_Request_for_signature_of_BRC_Consent</fullName>
        <description>FCC Assistant Request for signature of BRC Consent</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X97_Request_signature_of_Licensee_BRC_consent</template>
    </alerts>
    <alerts>
        <fullName>FCC_Assistant_Transaction_Cancelled_Send_to_Submitter</fullName>
        <description>FCC Assistant Transaction Cancelled - Send to Submitter</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X101_FCC_Assistant_Transaction_Cancelled</template>
    </alerts>
    <alerts>
        <fullName>FCC_Licensing_Transaction_Processed_Notification_to_Provider</fullName>
        <description>FCC Licensing Transaction Processed - Notification to Provider</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X71_FCC_Transaction_Processed</template>
    </alerts>
    <alerts>
        <fullName>FCC_Transaction_Cancelled_Send_to_Submitter</fullName>
        <description>FCC Transaction Cancelled - Send to Submitter</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X72_FCC_Transaction_Cancelled</template>
    </alerts>
    <alerts>
        <fullName>Licensing_Transaction_60_Day_Provider_Alert_if_Transaction_Still_Under_Review</fullName>
        <description>Licensing Transaction - 60 Day Provider Alert if Transaction Still Under Review</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X64_Notification_to_Provider_60_days_after_transaction_submission</template>
    </alerts>
    <alerts>
        <fullName>Licensing_Transaction_FCC_Assistant</fullName>
        <description>Licensing Transaction FCC Assistant Other Transactions</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X92c_FCC_Assistant_Transaction_electronic_submission_confirmation_Other</template>
    </alerts>
    <alerts>
        <fullName>Licensing_Transaction_submitted_for_Assistant_New_Renewal_Upgrade</fullName>
        <description>Licensing Transaction is submitted for Assistant for New License, Renewal, or Upgrade</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X92a_FCC_Assistant_Transaction_submission_confirmation_NewLicense_Renewal_Upgra</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_Assistant_60_days_after_transaction_submission</fullName>
        <description>Notification to Assistant 60 days after transaction submission</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X99_Notification_to_Assistant_60_days_after_transaction_submission</template>
    </alerts>
    <alerts>
        <fullName>Notify_Licensor_of_New_Change_of_Assistant_Update_Transaction_Creation</fullName>
        <description>Notify Licensor of New Change of Assistant Update Transaction Creation</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_User_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X106_New_Change_of_Assistants_on_Transaction</template>
    </alerts>
    <alerts>
        <fullName>Notify_Provider_regarding_Assistant_Update_Transaction_Creation</fullName>
        <description>Notify Provider regarding Assistant Update Transaction Creation</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X47d_Transaction_Electronic_Submission_Confirmation_Assistant_Update</template>
    </alerts>
    <alerts>
        <fullName>Original_Request_for_signature_of_Tax_Certification_Statement_GSA_RP</fullName>
        <description>Original Request for signature of Tax Certification Statement GSA/R&amp;P</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X135_Request_signature_of_Tax_Certification</template>
    </alerts>
    <alerts>
        <fullName>Original_request_for_signature_of_BRC_Consent</fullName>
        <description>Original request for signature of BRC Consent</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X67_Request_signature_of_Licensee_BRC_consent</template>
    </alerts>
    <alerts>
        <fullName>Original_request_for_signature_of_Tax_Certification_Statement</fullName>
        <description>Original request for signature of Tax Certification Statement</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X37_Request_signature_of_Tax_Certification</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Email_for_signature_of_Licensee_BRC_Consent</fullName>
        <description>Reminder Email for signature of Licensee BRC Consent</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X68_Signature_of_Licensee_BRC_consent_Pending_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Email_for_signature_of_Tax_Certification_Statement</fullName>
        <description>Reminder Email for signature of Tax Certification Statement</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X38_Signature_of_Tax_Certification_Pending_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Email_for_signature_of_Tax_Certification_Statement_GSA_RP</fullName>
        <description>Reminder Email for signature of Tax Certification Statement-GSA/R&amp;P</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X136_Signature_of_Tax_Certification_Pending_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_Investigation_Leader_to_inform_of_the_rejection_Use_template_44</fullName>
        <description>Send email to Transaction Assignee to inform of the rejection - Use template #44</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X44_Licensing_Transaction_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_Transaction_Assigned_To</fullName>
        <description>Send email to Transaction Assigned To</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X43_Licensing_Transaction_Approved</template>
    </alerts>
    <alerts>
        <fullName>Send_notification_email_to_Licensing_Transaction_Transaction_Assigned_To_Manager</fullName>
        <description>Send notification email to Licensing_Transaction.Transaction Assigned To.Manager (template #45)</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X45_Licensing_Transaction_Approval_Request_Recalled</template>
    </alerts>
    <alerts>
        <fullName>X100_FCC_Assistant_Licensing_Transaction_Processed_Notification_to_Provider</fullName>
        <description>100 - FCC Assistant Licensing Transaction Processed - Notification to Provider</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X100_FCC_Assistant_FCC_Transaction_Processed</template>
    </alerts>
    <alerts>
        <fullName>X71_FCC_Licensing_Transaction_Processed_Notification_to_Provider</fullName>
        <description>71 - FCC Licensing Transaction Processed - Notification to Provider</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X71_FCC_Transaction_Processed</template>
    </alerts>
    <alerts>
        <fullName>X92b_FCCAssistant_Transaction_Electronic_Submission_Confirmation_New_App_Re</fullName>
        <description>92b - FCCAssistant - Transaction Electronic Submission Confirmation - New App Re</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X92b_FCCAssistant_Transaction_Electronic_Submission_Confirmation_New_App_Re</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Transaction_Status</fullName>
        <description>Change Transaction Status to &quot;Pending Manager Approval&quot;</description>
        <field>Status__c</field>
        <literalValue>Pending Manager Approval</literalValue>
        <name>Change Transaction Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_reset_to_NULL</fullName>
        <field>Document_Info_Missing_Initial_Date__c</field>
        <name>Date reset to NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fill_Document_Info_Missing_Initial_Date</fullName>
        <description>Fill Document / Information Missing Initial Date with the current date</description>
        <field>Document_Info_Missing_Initial_Date__c</field>
        <formula>TODAY()</formula>
        <name>Fill Document Info Missing Initial Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Licensee_BRC_Status_to_Sent</fullName>
        <field>Licensee_BRC_Consent_Status__c</field>
        <literalValue>Sent</literalValue>
        <name>Licensee BRC Status to &quot;Sent&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Start_Approval_Process_Flag</fullName>
        <field>Start_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Reset Start Approval Process Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Flag_on_Pending_Email_to_False</fullName>
        <field>Pending_Email_to_Provider_Rgd_Trans__c</field>
        <literalValue>0</literalValue>
        <name>Set Flag on Pending Email to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Missing_Elements_for_Finalizing</fullName>
        <field>Missing_Elements_For_Finalizing__c</field>
        <formula>Missing_Elements_For_Licensor_2__c</formula>
        <name>Set Missing Elements for Finalizing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Missing_Elements_for_Finalizing2</fullName>
        <field>Missing_Elements_For_Finalizing__c</field>
        <formula>If(AND(Contains(Missing_Elements_For_Finalizing__c,&apos;Status Incorrect&apos;),
TEXT(Status__c) = &apos;Under Review&apos;)
 , SUBSTITUTE(Missing_Elements_For_Finalizing__c, &apos;Status Incorrect -&apos;, &apos;&apos;),Missing_Elements_For_Finalizing__c)</formula>
        <name>Set Missing Elements for Finalizing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Missing_Elements_for_Licensor</fullName>
        <field>Missing_Elements_For_Licensor_2__c</field>
        <formula>If(Contains(Missing_Elements_For_Licensor_2__c,&apos;Status Incorrect&apos;),
SUBSTITUTE(Missing_Elements_For_Licensor_2__c, &apos;Status Incorrect -&apos;, &apos;&apos;),Missing_Elements_For_Licensor_2__c)</formula>
        <name>Set Missing Elements for Licensor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Previous_Address_1</fullName>
        <description>Set Previous Address 1 with Provider Address 1</description>
        <field>Previous_Street_Address_1__c</field>
        <formula>Provider__r.Provider_Address_1__c</formula>
        <name>Set Previous Address 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Previous_Address_2</fullName>
        <description>Set Previous Address 2 with Provider Address 2</description>
        <field>Previous_Street_Address_2__c</field>
        <formula>Provider__r.Provider_Address_2__c</formula>
        <name>Set Previous Address 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Source_to_Portal</fullName>
        <field>Source__c</field>
        <literalValue>Provider Portal</literalValue>
        <name>Set Source to Portal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_flag_Approved_by_Manager_to_FALSE</fullName>
        <field>Approved_by_Manager__c</field>
        <literalValue>0</literalValue>
        <name>Set flag &quot;Approved by Manager&quot; to FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_flag_Approved_by_Manager_to_TRUE</fullName>
        <field>Approved_by_Manager__c</field>
        <literalValue>1</literalValue>
        <name>Set flag &quot;Approved by Manager&quot; to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tax_Certification_Statement_to_Sent</fullName>
        <description>Update Tax Certification Statement Status to &quot;Sent&quot;</description>
        <field>Tax_Certification_Status__c</field>
        <literalValue>Sent</literalValue>
        <name>Tax Certification Statement to &quot;Sent&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Assigned_To_Manager_Email</fullName>
        <field>Assigned_To_Manager_Email__c</field>
        <formula>Assigned_To__r.Manager.Email</formula>
        <name>Update Assigned To Manager Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Assigned_To_User_Email</fullName>
        <field>Assigned_User_Email__c</field>
        <formula>Assigned_To__r.Email</formula>
        <name>Update Assigned To User Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Assistant_BRC_Renewal</fullName>
        <field>BRC_Renewal__c</field>
        <formula>IF( RecordType.Name = &quot;FCC Assistant Renewal&quot;, &quot;Yes&quot;, &quot;No&quot;)</formula>
        <name>Update Assistant BRC Renewal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BRC_Consent_Request_Date</fullName>
        <description>Update BRC Consent Request Date to today</description>
        <field>Licensee_BRC_Consent_Request_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update BRC Consent Request Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BRC_Current_Mailing_Address</fullName>
        <field>BRC_Current_Mailing_Address__c</field>
        <formula>IF(ISBLANK(  Provider__r.ShippingStreet ), Provider__r.Provider_Full_Address__c ,  Provider__r.Mailing_Address_Reformated__c  )</formula>
        <name>Update BRC Current Mailing Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BRC_First_Name</fullName>
        <field>BRC_First_Name__c</field>
        <formula>Submitter__r.Contact.FirstName</formula>
        <name>Update BRC First Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BRC_Last_Name</fullName>
        <field>BRC_Last_Name__c</field>
        <formula>Submitter__r.Contact.LastName</formula>
        <name>Update BRC Last Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BRC_Renewal</fullName>
        <field>BRC_Renewal__c</field>
        <formula>IF( RecordType.Name = &quot;FCC Renewal&quot;, &quot;Yes&quot;, &quot;No&quot;)</formula>
        <name>Update BRC Renewal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Time_Transaction_Closed</fullName>
        <description>Update the Date / Time transaction closed field with the current date / time</description>
        <field>Date_Time_Transaction_Closed__c</field>
        <formula>NOW()</formula>
        <name>Update Date / Time Transaction Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Name</fullName>
        <description>This rule will update the Record Type Name to &quot;FCC Assistant Change of Address</description>
        <field>RecordTypeId</field>
        <lookupValue>FCC_Assistant_Change_of_Address</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Approved_by_Manager</fullName>
        <description>Update Status to &quot;Approved by Manager&quot;</description>
        <field>Status__c</field>
        <literalValue>Approved By Manager</literalValue>
        <name>Update Status to &quot;Approved by Manager&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Under_Review</fullName>
        <description>Update Status to &quot;Under Review&quot;</description>
        <field>Status__c</field>
        <literalValue>Under Review</literalValue>
        <name>Update Status to &quot;Under Review&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Tax_Cer_Trans_Request_Date</fullName>
        <description>Update Tax Certification Statement Request Date to today</description>
        <field>Tax_Certification_Statement_Request_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Tax Cer Trans Request Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Assistant - Licensing Transaction 60 Day Provider Alert If It Remains Under Review</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Account.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>FCC Assistant</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>FCC Assistant Renewal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Under Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Electronic_Communication__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Document_Information_Missing__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Assistant email (time based follow-up/alerts) on Licensing Transaction when it remains in Under Review status beyond the 60 day stipulated allowance</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notification_to_Assistant_60_days_after_transaction_submission</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_sent_Notification_to_Assistant_60_days_after_transaction_submission_99</name>
                <type>Task</type>
            </actions>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Change Record Type to FCC Assistant Change of Adress</fullName>
        <actions>
            <name>Update_Record_Type_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Licensing_Transaction__c.Record_Type_Name_admin_text_field__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Record type Names cannot be set in process flows. This workflow will change the Record type to FCC Assistant Change of Address when the record is created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Doc or Info Missing Initial Date</fullName>
        <actions>
            <name>Fill_Document_Info_Missing_Initial_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the checkbox &quot;Document / Information Missing&quot; is checked, fill &quot;Document / Information Missing Initial Date&quot; with the current date.</description>
        <formula>Document_Information_Missing__c = TRUE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Doc or Info Missing Initial Date NULL</fullName>
        <actions>
            <name>Date_reset_to_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the checkbox &quot;Document / Information Missing&quot; is unchecked, reset &quot;Document / Information Missing&quot; to NULL.</description>
        <formula>Document_Information_Missing__c = FALSE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FCC Assistant Licensing Transaction Via Portal Pending 14 Days after Submitting</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Source__c</field>
            <operation>equals</operation>
            <value>Provider Portal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Electronic_Communication__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>FCC Assistant</value>
        </criteriaItems>
        <description>FCC Assistant Licensing Transaction Via Portal Pending 14 Days after Submitting</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_FCC_Assistant_to_Notify_14_Days_Has_Passed_Since_Submission_Via_Portal</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_sent_Submitted_Transaction_still_pending_after_14_days_103</name>
                <type>Task</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FCC Assistant Request Signature of Licensee BRC Consent</fullName>
        <actions>
            <name>FCC_Assistant_Request_for_signature_of_BRC_Consent</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Licensee_BRC_Status_to_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Assistant_BRC_Renewal</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_BRC_Consent_Request_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_BRC_Current_Mailing_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_BRC_First_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_BRC_Last_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Email_sent_Request_signature_of_BRC_consent_97</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>WF to update the BRC Fields on FCC Assistant</description>
        <formula>AND(  ISPICKVAL( Status__c , &quot;Submitted&quot;),    ISPICKVAL(  Licensee_BRC_Consent_Status__c , &quot;&quot; ),  ISBLANK( Licensee_BRC_Consent_Request_Date__c ),  Provider__r.Electronic_Communication__c = TRUE,  OR( RecordType.Name = &quot;FCC Assistant New License&quot;,      RecordType.Name = &quot;FCC Assistant Renewal&quot;,RecordType.Name = &quot;FCC Assistant License Upgrade&quot;), ISBLANK(Record_Type_Name_admin_text_field__c), ISPICKVAL(Source__c,&quot;Provider Portal&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FCC Assistant Signature of Licensee BRC Consent Reminder</fullName>
        <active>true</active>
        <description>WF to send a Remainder to Assistant to Sign the BRC Concent</description>
        <formula>AND(  OR(ISPICKVAL( Status__c , &quot;Submitted&quot;),ISPICKVAL( Status__c , &quot;Under Review&quot;)),  NOT(ISPICKVAL( Licensee_BRC_Consent_Status__c, &quot;Completed&quot; )),  Provider__r.Electronic_Communication__c = TRUE, OR( RecordType.Name = &quot;FCC Assistant New License&quot;,      RecordType.Name = &quot;FCC Assistant Renewal&quot;,RecordType.Name = &quot;FCC Assistant License Upgrade&quot;), ISBLANK( Record_Type_Name_admin_text_field__c ), ISPICKVAL(Source__c,&quot;Provider Portal&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>FCC_Assistant_Remainder_Email_for_signature_of_BRC_Consent</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_sent_Signature_of_BRC_Consent_Pending_Reminder_98</name>
                <type>Task</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FCC Request Signature of Licensee BRC Consent</fullName>
        <actions>
            <name>Original_request_for_signature_of_BRC_Consent</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Licensee_BRC_Status_to_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_BRC_Consent_Request_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_BRC_Current_Mailing_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_BRC_First_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_BRC_Last_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_BRC_Renewal</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Email_sent_Request_signature_of_BRC_consent_67</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>This workflow is the implementation of https://www.pivotaltracker.com/n/projects/1275588/stories/94665848</description>
        <formula>AND(  ISPICKVAL( Status__c , &quot;Submitted&quot;),    ISPICKVAL(  Licensee_BRC_Consent_Status__c , &quot;&quot; ),  ISBLANK( Licensee_BRC_Consent_Request_Date__c ),  Provider__r.Electronic_Communication__c = TRUE, OR( RecordType.Name = &quot;FCC New License&quot;,      RecordType.Name = &quot;FCC Renewal&quot;,      RecordType.Name = &quot;FCC License Upgrade&quot;,      RecordType.Name = &quot;Change of Address&quot;  ), ISBLANK(Record_Type_Name_admin_text_field__c), ISPICKVAL(Source__c,&quot;Provider Portal&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FCC Request Signature of Tax Statement</fullName>
        <actions>
            <name>Original_request_for_signature_of_Tax_Certification_Statement</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Tax_Certification_Statement_to_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Tax_Cer_Trans_Request_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Email_sent_Request_signature_of_Tax_Certification_37</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>This workflow is the implementation of https://www.pivotaltracker.com/story/show/94665860
------THE WORKFLOW HAS BEEN REPLACED BY PROCESS BUILDER &quot;FCC Request Signature of Tax Certification Statement and Reminder email&quot;---------</description>
        <formula>AND(  ISPICKVAL( Status__c , &quot;Submitted&quot;),    ISPICKVAL( Tax_Certification_Status__c, &quot;&quot; ),  ISBLANK(Tax_Certification_Statement_Request_Date__c),  Provider__r.Electronic_Communication__c = TRUE,    ISPICKVAL(Source__c,&quot;Provider Portal&quot;),  OR( RecordType.Name = &quot;FCC New License&quot;,      RecordType.Name = &quot;FCC Renewal&quot;,      RecordType.Name = &quot;FCC License Upgrade&quot;, RecordType.Name = &quot;FCC Assistant New License&quot;,  RecordType.Name = &quot;FCC Assistant Renewal&quot;,  RecordType.Name = &quot;FCC Assistant License Upgrade&quot;), ISBLANK(Record_Type_Name_admin_text_field__c) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FCC Signature of Licensee BRC Consent Reminder</fullName>
        <active>true</active>
        <description>This workflow is the implementation of https://www.pivotaltracker.com/story/show/94665848</description>
        <formula>AND(  OR(ISPICKVAL( Status__c , &quot;Submitted&quot;),ISPICKVAL( Status__c , &quot;Under Review&quot;)),  NOT(ISPICKVAL( Licensee_BRC_Consent_Status__c, &quot;Completed&quot; )),  Provider__r.Electronic_Communication__c = TRUE, OR( RecordType.Name = &quot;FCC New License&quot;,      RecordType.Name = &quot;FCC Renewal&quot;,      RecordType.Name = &quot;FCC License Upgrade&quot;,      RecordType.Name = &quot;Change of Address&quot;  ), ISBLANK( Record_Type_Name_admin_text_field__c ), ISPICKVAL(Source__c,&quot;Provider Portal&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder_Email_for_signature_of_Licensee_BRC_Consent</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_sent_Signature_of_BRC_Consent_Pending_Reminder_68</name>
                <type>Task</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FCC Signature of Tax Statement Reminder</fullName>
        <active>false</active>
        <description>This workflow is the implementation of https://www.pivotaltracker.com/story/show/94665860
------THE WORKFLOW HAS BEEN REPLACED BY PROCESS BUILDER &quot;FCC Request Signature of Tax Certification Statement and Reminder email&quot;---------</description>
        <formula>AND(  OR(ISPICKVAL( Status__c , &quot;Submitted&quot;),ISPICKVAL( Status__c , &quot;Under Review&quot;)),  NOT(ISPICKVAL( Tax_Certification_Status__c, &quot;Completed&quot; )),  Provider__r.Electronic_Communication__c = TRUE, ISPICKVAL(Source__c,&quot;Provider Portal&quot;), OR( RecordType.Name = &quot;FCC New License&quot;,      RecordType.Name = &quot;FCC Renewal&quot;,      RecordType.Name = &quot;FCC License Upgrade&quot;, RecordType.Name = &quot;FCC Assistant New License&quot;,  RecordType.Name = &quot;FCC Assistant Renewal&quot;,  RecordType.Name = &quot;FCC Assistant License Upgrade&quot;), ISBLANK(Record_Type_Name_admin_text_field__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder_Email_for_signature_of_Tax_Certification_Statement</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_sent_Signature_of_Tax_Certification_Pending_Reminder_38</name>
                <type>Task</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>License Issued</fullName>
        <actions>
            <name>Email_alert_to_Licensor_that_the_license_is_issued</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>$User.Username &lt;&gt;  Assigned_To__r.Username &amp;&amp; License_Issued__c  = true</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Licensing Transaction 45 Day Alert When Transaction Remains Under Review</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Under Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.RecordTypeId</field>
            <operation>notContain</operation>
            <value>Renewal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Is_Provider_With_Licensing_Transaction__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Internal time based follow-up/alerts on Licensing Transaction when it remains in Under Review status beyond the 45 day stipulated allowance</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>New_Licensing_Transaction_not_processed_45_days_notice</name>
                <type>Task</type>
            </actions>
            <timeLength>45</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Licensing Transaction 60 Day Alert When Transaction Remains Under Review</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Under Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.RecordTypeId</field>
            <operation>notContain</operation>
            <value>Renewal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Is_Provider_With_Licensing_Transaction__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Internal time based follow-up/alerts on Licensing Transaction when it remains in Under Review status beyond the 60 day stipulated allowance</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>New_Licensing_Transaction_not_processed_60_days_notice</name>
                <type>Task</type>
            </actions>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Licensing Transaction 60 Day Provider Alert If It Remains Under Review</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Licensing_Transaction__c.Document_Information_Missing__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.RecordTypeId</field>
            <operation>notContain</operation>
            <value>Renewal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Under Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Electronic_Communication__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Provider email (time based follow-up/alerts) on Licensing Transaction when it remains in Under Review status beyond the 60 day stipulated allowance</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Licensing_Transaction_60_Day_Provider_Alert_if_Transaction_Still_Under_Review</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_sent_Notification_to_Provider_60_days_after_transaction_submission_64</name>
                <type>Task</type>
            </actions>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Licensing Transaction 90 Day Alert When Transaction Remains Under Review</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Under Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.RecordTypeId</field>
            <operation>notContain</operation>
            <value>Renewal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Is_Provider_With_Licensing_Transaction__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Internal time based follow-up/alerts on Licensing Transaction when it remains in Under Review status beyond the 90 day stipulated allowance</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>New_Licensing_Transaction_not_processed_90_days_notice</name>
                <type>Task</type>
            </actions>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Licensing Transaction Submitted and Not Assigned</fullName>
        <active>false</active>
        <description>Actions to take when a Licensing Transaction has been submitted but there is no one currently assigned to it</description>
        <formula>AND(ISPICKVAL( Status__c , &quot;Submitted&quot;), ISNULL( Assigned_To__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Licensing Transaction Via Portal Pending 14 Days after Submittng</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Source__c</field>
            <operation>equals</operation>
            <value>Provider Portal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Electronic_Communication__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Family Child Care</value>
        </criteriaItems>
        <description>Provider Licensing Transaction Via Portal Pending 14 Days after Submittng</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Provider_to_Notify_14_Days_Has_Passed_Since_Submission_Via_Portal</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_sent_Submitted_Transaction_still_pending_after_14_days_76</name>
                <type>Task</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Licensing Transactions - Actions for Newly Submitted Transactions</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>Defines the actions and rules to executed when a new Licensing Transaction has been submitted and or edited and Status is &quot;Submitted&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Provider %26 Licensee of FCC Provider Assistant Update - Transaction Creation</fullName>
        <actions>
            <name>Notify_Licensor_of_New_Change_of_Assistant_Update_Transaction_Creation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Notify_Provider_regarding_Assistant_Update_Transaction_Creation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Flag_on_Pending_Email_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Email_sent_Update_of_Assistant_s_List_Successfully_Submitted_47d</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed (Processed)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Electronic_Communication__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Assigned_To__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Source__c</field>
            <operation>equals</operation>
            <value>Provider Portal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>FCC Provider Assistant Update</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Schedule followup task for Assigned User if Visit Not Scheduled in 15 days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Licensing_Transaction__c.To_Schedule_Visit__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Under Review</value>
        </criteriaItems>
        <description>Schedule followup task for Assigned User if Visit Not Scheduled in 15 days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>New_Licensing_Transaction_without_scheduled_visit_15_days_notice</name>
                <type>Task</type>
            </actions>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Set Missing Elements for Finalizing</fullName>
        <actions>
            <name>Set_Missing_Elements_for_Finalizing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Missing Elements for Licensor</fullName>
        <actions>
            <name>Set_Missing_Elements_for_Finalizing2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Missing_Elements_for_Licensor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Under Review</value>
        </criteriaItems>
        <description>Set Licensing Transaction Status and Fee Info. for Missing Elements For Licensor</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Missing Elements for Processing</fullName>
        <active>false</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Ready for Closing Flag</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Licensing_Transaction__c.Missing_to_move_to_Under_Review__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Missing_Elements_For_Finalizing__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Missing_Elements_For_Licensor_2__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Under Review</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Source to %22Web%22 when created by portal user</fullName>
        <actions>
            <name>Set_Source_to_Portal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>CONTAINS( CreatedBy.Profile.Name , &quot;Community&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Licensing Transaction Assigned User Email</fullName>
        <active>false</active>
        <description>Update Licensing Transaction Assigned User Email</description>
        <formula>NOT( ISNULL(&quot;NOT NULL&quot;  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Licensing Transaction Email Addresses</fullName>
        <actions>
            <name>Update_Assigned_To_Manager_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Assigned_To_User_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow update the assigned to email address and manager email address used to send emails.</description>
        <formula>NOT(ISBLANK(Assigned_To__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Transaction Close Date %2F Time</fullName>
        <actions>
            <name>Update_Date_Time_Transaction_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the field Date / Time transaction closed when the transaction is closed.</description>
        <formula>NOT(ISBLANK( Date_Closed__c ))  &amp;&amp;  OR( ISCHANGED(Date_Closed__c), ISNEW())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Close_transaction_after_manager_approval_and_issue_license_if_required</fullName>
        <assignedTo>eecleaddonotreply@state.ma.us</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Close transaction after manager approval (and issue license if required)</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Notification_to_Assistant_60_days_after_transaction_submission_99</fullName>
        <assignedToType>owner</assignedToType>
        <description>Email sent to the Provider 60 days after submission if the status is still pending and there are some missing documents</description>
        <dueDateOffset>60</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Notification to Assistant 60 days after transaction submission - #99</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Notification_to_Provider_60_days_after_transaction_submission_64</fullName>
        <assignedToType>owner</assignedToType>
        <description>Email sent to the Provider 60 days after submission if the status is still pending and there are some missing documents</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Notification to Provider 60 days after transaction submission - #64</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Request_signature_of_BRC_consent_67</fullName>
        <assignedToType>owner</assignedToType>
        <description>Once a license transaction requiring signature of BRC Consent is received, this email is sent to require the licensee to sign a BRC Consent.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Request signature of BRC consent - #67</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Request_signature_of_BRC_consent_97</fullName>
        <assignedToType>owner</assignedToType>
        <description>Once a license transaction requiring signature of BRC Consent is received, this email is sent to require the licensee to sign a BRC Consent.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Request signature of BRC consent - #97</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Request_signature_of_Tax_Certification_37</fullName>
        <assignedToType>owner</assignedToType>
        <description>Once a license transaction requiring signature of Tax Certification Statement is received, this email is sent to require the licensee to sign a Tax Certification Statement.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Request signature of Tax Certification - #37</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Signature_of_BRC_Consent_Pending_Reminder_68</fullName>
        <assignedToType>owner</assignedToType>
        <description>If a BRC Consent is pending for more than 5 days, then this email is sent to remind the user that the document is pending</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Signature of BRC Consent Pending Reminder - #68</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Signature_of_BRC_Consent_Pending_Reminder_98</fullName>
        <assignedToType>owner</assignedToType>
        <description>If a BRC Consent is pending for more than 5 days, then this email is sent to remind the user that the document is pending</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Signature of BRC Consent Pending Reminder - #98</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Signature_of_Tax_Certification_Pending_Reminder_38</fullName>
        <assignedToType>owner</assignedToType>
        <description>If a tax certification statement is pending for more than 5 days, then this email is sent to remind the user that the document is pending</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Signature of Tax Certification Pending Reminder - #38</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Submitted_Transaction_still_pending_after_14_days_103</fullName>
        <assignedToType>owner</assignedToType>
        <description>If a transaction is submitted but remain in status &quot;Submitted&quot; for more than 14 days, this email is sent to the Assistant to request him/her to send the payment of the fee or sign the BRC Consent / Tax Certificate</description>
        <dueDateOffset>14</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Submitted Transaction still pending after 14 days - #103</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Submitted_Transaction_still_pending_after_14_days_76</fullName>
        <assignedToType>owner</assignedToType>
        <description>If a transaction is submitted but remain in status &quot;Submitted&quot; for more than 14 days, this email is sent to the provider to request him/her to send the payment of the fee or sign the BRC Consent / Tax Certificate</description>
        <dueDateOffset>14</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Submitted Transaction still pending after 14 days - #76</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Update_of_Assistant_s_List_Successfully_Submitted_47d</fullName>
        <assignedToType>owner</assignedToType>
        <description>Email sent to the provider to confirm that a &quot;FCC Provider Assistant Update&quot; transaction has been successfully created</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Update of Assistant(s) List Successfully Submitted - #47d</subject>
    </tasks>
    <tasks>
        <fullName>New_Licensing_Transaction_not_processed_45_days_notice</fullName>
        <assignedToType>owner</assignedToType>
        <description>This transaction has been &quot;Under Review&quot; for 45 days and needs to be reviewed</description>
        <dueDateOffset>48</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Licensing Transaction not processed - 45 days notice</subject>
    </tasks>
    <tasks>
        <fullName>New_Licensing_Transaction_not_processed_60_days_notice</fullName>
        <assignedToType>owner</assignedToType>
        <description>This transaction has been &quot;Under Review&quot; for 60 days and needs to be reviewed</description>
        <dueDateOffset>63</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Licensing Transaction not processed - 60 days notice</subject>
    </tasks>
    <tasks>
        <fullName>New_Licensing_Transaction_not_processed_90_days_notice</fullName>
        <assignedToType>owner</assignedToType>
        <description>This transaction has been &quot;Under Review&quot; for 90 days and needs to be reviewed</description>
        <dueDateOffset>93</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Licensing Transaction not processed - 90 days notice</subject>
    </tasks>
    <tasks>
        <fullName>New_Licensing_Transaction_without_scheduled_visit_15_days_notice</fullName>
        <assignedToType>owner</assignedToType>
        <description>This transaction still does not have an attached visit &quot;Scheduled&quot;. Please schedule a visit with this provider.</description>
        <dueDateOffset>18</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Licensing Transaction without scheduled visit - 15 days notice</subject>
    </tasks>
    <tasks>
        <fullName>Re_work_required_on_licensing_transaction_following_review_by_manager_and_reject</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Re-work required on licensing transaction following review by manager and rejection</subject>
    </tasks>
</Workflow>
