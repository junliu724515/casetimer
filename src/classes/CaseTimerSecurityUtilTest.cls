/**
 * Created by Jun Liu on 14/03/2017.
 */
@IsTest(SeeAllData=false)
public with sharing class CaseTimerSecurityUtilTest {


    @isTest
    static void testAdminUser()
    {
        User u = CaseTimerSecurityUtil.getTestAdmin();
        Profile p =
        [SELECT Id, Name FROM Profile WHERE Id=:u.ProfileId LIMIT 1];
        System.assertEquals('System Administrator', p.Name);
    }

    @isTest
    static void testReadUser()
    {
        User u = CaseTimerSecurityUtil.getTestReadUser();
        Profile p =
        [SELECT Id, Name FROM Profile WHERE Id=:u.ProfileId LIMIT 1];
        System.assertEquals('Read Only', p.Name);
    }

    @isTest
    static void testChatterUser()
    {
        User u = CaseTimerSecurityUtil.getTestChatterUser();
        Profile p =
        [SELECT Id, Name FROM Profile WHERE Id=:u.ProfileId LIMIT 1];
        System.assertEquals('Chatter External User', p.Name);
    }

    @isTest
    static void testCanCreateAndUpdateFields()
    {
        User u = CaseTimerSecurityUtil.getTestAdmin();
        Account a = new Account(Name = 'Test Account', Description = 'Test Description');
        System.runAs(u) {
            // Test FLS Createable
            Boolean fieldsCreateable = True;
            try {
                CaseTimerSecurityUtil.oneRecordFieldCreateable(
                        a, Account.SObjectType.getDescribe());
            } catch(CaseTimerException e) {
                fieldsCreateable = False;
            }
            System.assert(fieldsCreateable);
            // Test FLS Updateable
            Boolean fieldsUpdateable = True;
            try {
                CaseTimerSecurityUtil.fieldUpdateable(
                        Account.Description.getDescribe());
            } catch(CaseTimerException e) {
                fieldsUpdateable = False;
            }
            System.assert(fieldsUpdateable);
        }
    }

    @isTest
    static void testCannotCreateOrUpdateFields()
    {
        User u = CaseTimerSecurityUtil.getTestReadUser();
        Account a = new Account(Name = 'Test Account', Description = 'Test Description');
        System.runAs(u) {
            // Test FLS Createable
            Boolean fieldsCreateable = True;
            try {
                CaseTimerSecurityUtil.oneRecordFieldCreateable(
                        a, Account.SObjectType.getDescribe());
            } catch(CaseTimerException e) {
                fieldsCreateable = False;
            }
            System.assert(!fieldsCreateable);
            // Test FLS Updateable
            Boolean fieldsUpdateable = True;
            try {
                CaseTimerSecurityUtil.fieldUpdateable(
                        Account.Description.getDescribe());
            } catch(CaseTimerException e) {
                fieldsUpdateable = False;
            }
            System.assert(!fieldsUpdateable);
        }
    }

    @isTest
    static void testCanReadFields()
    {
        User u = CaseTimerSecurityUtil.getTestAdmin();
        System.runAs(u) {
            Boolean canAccess = CaseTimerSecurityUtil.fieldsAllAccess(
                    Case.SObjectType.getDescribe(),
                    new Set<String>{'account', 'description'});
            System.assert(canAccess);
        }
    }

    @isTest
    static void testCannotReadFields()
    {
        User u = CaseTimerSecurityUtil.getTestReadUser();
        System.runAs(u) {
            Boolean canAccess = CaseTimerSecurityUtil.fieldsAllAccess(
                    Case.SObjectType.getDescribe(),
                    new Set<String>{'account', 'businesshoursid'});
            System.assert(!canAccess);
        }
    }
}