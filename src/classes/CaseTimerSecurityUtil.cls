/**
 * Created by Jun Liu on 14/03/2017.
 */

public with sharing class CaseTimerSecurityUtil {


    public static void fieldCreateable(DescribeFieldResult fdr) {
        if (!fdr.isCreateable()) {
            System.debug(fdr.getName() + ' isnt creatable');
            throw new CaseTimerException('Insufficient Privileges');
        }
    }

    public static void fieldUpdateable(DescribeFieldResult fdr) {
        if (!fdr.isUpdateable()) {
            System.debug(fdr.getName() + ' isnt updateable');
            throw new CaseTimerException('Insufficient Privileges');
        }
    }

    public static void fieldsCreateable(DescribeSObjectResult dsr, Set<String> fields) {
        Map<String, Schema.SObjectField> fieldMap = dsr.fields.getMap();
        for (String field : fields) {
            DescribeFieldResult fdr = fieldMap.get(field).getDescribe();
            System.debug(field + ': ' + fdr.isCreateable());
            fieldCreateable(fdr);
        }
    }

    public static void oneRecordFieldCreateable(sObject record, DescribeSObjectResult dsr) {
        Map<String, Object> popMap = record.getPopulatedFieldsAsMap();
        Set<String> fields = popMap.keySet();
        fieldsCreateable(dsr, fields);
    }

    public static Boolean fieldsAllAccess(DescribeSObjectResult dsr, Set<String> fields) {
        Boolean allAccess = true;
        Map<String, Schema.SObjectField> fieldMap = dsr.fields.getMap();
        for (String field : fieldMap.keySet()) {
            if (fields.contains(field)) {
                DescribeFieldResult fd = fieldMap.get(field).getDescribe();
                if (fd.isAccessible() != true) {
                    allAccess = false;
                }

            }
        }

        return allAccess;

    }

    public static User getTestAdmin() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User u = new User(Alias = 'testadmi', Email = 'testadmin@mpm.slds',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = p.Id,
                TimeZoneSidKey = 'America/Los_Angeles', UserName = 'testadmin@mpm.slds');
        return u;
    }

    public static User getTestReadUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Read Only' LIMIT 1];
        User u = new User(Alias = 'testrea', Email = 'testread@mpm.slds',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = p.Id,
                TimeZoneSidKey = 'America/Los_Angeles', UserName = 'testread@mpm.slds');
        return u;
    }

    public static User getTestChatterUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Chatter External User' LIMIT 1];
        User u = new User(Alias = 'chatfr', Email = 'testchat@mpm.slds',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = p.Id,
                TimeZoneSidKey = 'America/Los_Angeles', UserName = 'testchat@mpm.slds');
        return u;
    }
}