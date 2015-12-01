@IsTest
public class CaseTimeControllerTest {

    @IsTest
    public static void testRecordSession(){
        
        CaseTimeController.recordSession('50028000004ubJ2', '56');
    }
    
    @IsTest
    public static void testRecordManualSession(){
        
        CaseTimeController.recordManualSession('50028000004ubJ2', '60', 'from unit test');
    }
    
    @IsTest(SeeAllData=true)
    public static void  testGetSessions(){
        
        CaseTimeController controller = new CaseTimeController();
        controller.recordId = '50028000004ubJ2';     
        List<Session_Time__c> sessions = controller.getSessions();
        
        system.assert(sessions.size()>0);
        
    }
}