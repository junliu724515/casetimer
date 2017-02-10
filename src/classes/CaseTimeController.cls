Global with sharing class CaseTimeController {


    public String recordId { get; set; }
    public String duration { get; set; }
    public String comments { get; set; }

    public Decimal cumulativeTime {
        get {
            List<Case> currentCases = [select Id, Cumulative_Time__c from Case where Id = :recordId limit 1];
            if (currentCases.size() > 0) {
                return currentCases.get(0).Cumulative_Time__c;
            }
            return 0;
        }
        set;
    }

    public List<Session_Time__c> sessions {
        get {
            sessions = [select Id, Agent__r.Name, Date__c, Duration__c from Session_Time__c where Case__r.Id = :recordId and Type__c = 'Automatic' order by Date__c desc];
            return sessions;
        }
        set;
    }

    public List<Session_Time__c> manualSessions {
        get {
            manualSessions = [select Id, Agent__r.Name, Date__c, Duration__c from Session_Time__c where Case__r.Id = :recordId and Type__c = 'Manual' order by Date__c desc];
            return manualSessions;
        }
        set;

    }

    public Boolean isClosedCase {
        get {
            List<Case> currentCases = [select Status from Case where Id = :recordId limit 1];
            List<CaseStatus> closedCaseStatuses = [select MasterLabel From CaseStatus Where IsClosed = true];
            if (currentCases.size() > 0) {
                String currentStatus = currentCases.get(0).Status;
                for (CaseStatus closedCaseStatus: closedCaseStatuses) {
                    if (currentStatus == closedCaseStatus.MasterLabel) {
                        return true;
                    }
                }
            }
            return false;
        }
        set;

    }

    public CaseTimeController(ApexPages.StandardController stdController) {
        recordId = (String) stdController.getRecord().Id;
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

    @RemoteAction
    Global static Boolean isCaseId(Id objectId) {
        System.debug('id type is: ' + objectId.getSobjectType());
        if (objectId.getSobjectType()==Case.getSObjectType()) {
            return true;
        }
        return false;
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