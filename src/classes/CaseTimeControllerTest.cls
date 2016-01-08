@IsTest
public class CaseTimeControllerTest {

    
    @testSetup 
    public static void setTuTestdata() {
    
        Case newCase = new Case();
        newCase.Subject = 'test';        
        insert newCase;   
    }
    
    
    
    @IsTest
    public static void testRecordSession(){
       
        Case testCase = [select Subject from Case where Subject = 'test']; 
        ApexPages.StandardController strc = new ApexPages.StandardController(testCase);       
        CaseTimeController contr = new CaseTimeController(strc); 
        
        Test.startTest();
        CaseTimeController.recordSession(testCase.Id, '56');
        Test.stopTest();
        
        List<Session_Time__c> sessions = contr.sessions;
        System.assertEquals(sessions.size(), 1);
        System.assertEquals(sessions.get(0).Duration__c, 56);
        System.assertEquals(contr.cumulativeTime, 56);
    }
    
    
    @IsTest
    public static void testRecordManualSession(){
        
        Case testCase = [select Subject from Case where Subject = 'test']; 
        ApexPages.StandardController strc = new ApexPages.StandardController(testCase);    
        CaseTimeController contr = new CaseTimeController(strc); 
        contr.recordId = testCase.Id;
        contr.duration = '100';
        contr.comments = 'this is a test';

        Test.startTest();
        contr.recordManualSession();
        Test.stopTest();
        
        List<Session_Time__c> sessions = contr.manualSessions;
        System.assertEquals(sessions.size(), 1);
        System.assertEquals(sessions.get(0).Duration__c, 100);
        System.assertEquals(contr.cumulativeTime, 100);
        
    }
    

}