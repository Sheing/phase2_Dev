<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notification_to_FCC_Assistant_that_they_were_removed_as_an_Assistant_on_a_Provid</fullName>
        <description>Notification to FCC Assistant that they were removed as an Assistant on a Provider</description>
        <protected>false</protected>
        <recipients>
            <field>FCC_Assistant_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X105_Notification_to_FCC_Assistant_that_they_were_removed_as_an_Assistant</template>
    </alerts>
    <alerts>
        <fullName>Notify_a_FCC_Assistant_when_a_provider_is_either_adding_me_or_removing_me_as_his</fullName>
        <description>Notify a FCC Assistant when a provider is either adding me or removing me as his/her assistant</description>
        <protected>false</protected>
        <recipients>
            <field>FCC_Assistant_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X104_Notification_to_FCC_Assistant_that_they_were_added_as_an_Assistant_on_a_Pr</template>
    </alerts>
    <alerts>
        <fullName>X91_Send_email_to_Provider_when_Assistant_is_reaching_expiration_date_30_days_be</fullName>
        <description>91 - Send email to Provider when Assistant is reaching expiration date (30 days before) but has not submitted a renewal application yet</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X91_Notification_to_Provider_on_Affiliated_Assistant_certificate_expiration_dat</template>
    </alerts>
</Workflow>
