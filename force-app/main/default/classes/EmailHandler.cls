public with sharing class EmailHandler {
    @AuraEnabled
    public static String sendEmail(Id recordId) {
        if (String.isBlank(recordId)) {
            throw new IllegalArgumentException(Label.NoMatchIdOfRecord);
        }
        try {
            return createEmail(recordId);
        } catch (Exception ex) {
            throw new IllegalArgumentException(ex.getMessage());
        }
    }

    private static String createEmail(Id recordId) {
        try {
            Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(getEmailTemplate().Id, UserInfo.getUserId(), recordId);
            email.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            return UserInfo.getUserEmail();
        } catch (Exception ex) {
            throw new IllegalArgumentException(Label.Error + ' ' + ex.getMessage());
        }
    }

    private static EmailTemplate getEmailTemplate() {
        try {
            return [SELECT Id,
                        Name
                    FROM EmailTemplate
                    WHERE Name = :Settings__mdt.getInstance('Order_Email_Template').Name__c
                    LIMIT 1];
        } catch (Exception ex) {
            throw new IllegalArgumentException(Label.EmailTemplateIsNotFind);
        }
    }
}