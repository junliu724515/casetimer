Global with sharing class CaseTimeController {
    
   
    public String recordId {get;set;}
    public String duration {get;set;} 
    public String comments {get;set;}
 
    public Decimal cumulativeTime {
        get {
             Case currentCase = [select Id, Cumulative_Time__c from Case where Id =:recordId limit 1];
             return currentCase.Cumulative_Time__c;
        }
        set;
    }
    
    public List<Session_Time__c> sessions {
        get{
            sessions = [select Id, Agent__r.Name, Date__c, Duration__c from Session_Time__c where Case__r.Id=:recordId and Type__c = 'Automatic' order by Date__c desc];
            return sessions;      
        }
        set;      
    }
    
    public List<Session_Time__c> manualSessions {
        get{
           manualSessions = [select Id, Agent__r.Name, Date__c, Duration__c from Session_Time__c where Case__r.Id=:recordId and Type__c = 'Manual' order by Date__c desc];
           return manualSessions;  
        }
        set;
        
    }
    
    public CaseTimeController(ApexPages.StandardController stdController){
        recordId = (String)stdController.getRecord().Id;
    }
    
    @RemoteAction
    Global static String recordSession(String caseId, String duration) {
        
        System.debug('caseId: ' + caseId);
        System.debug('duration: ' + duration);
        
        Session_Time__c session = new Session_Time__c();
        session.Case__c = caseId;
        session.Date__c = System.now();
        session.Duration__c = Integer.valueOf(duration);
        session.Agent__c = UserINFO.getUserId();
        session.Type__c = 'Automatic';
        
        insert session;
     //   System.debug('sessionId: ' + session.Id);
        return session.Id;

    }
 
    
    public PageReference recordManualSession() {
        
        Session_Time__c session = new Session_Time__c();
        session.Case__c = recordId;
        session.Date__c = System.now();
        session.Duration__c = Integer.valueOf(duration);
        session.Agent__c = UserINFO.getUserId();
        session.Type__c = 'Manual';
        session.Comments__c = comments;
        
        insert session;
     //   System.debug('sessionId: ' + session.Id);

        return null;
    }
    
}