public with sharing class LocaleDateController {

    
    public DateTime dateValue{get;set;}

    public String getTimeZoneValue() {
        if( dateValue != null ) {
            String localeFormatT = dateValue.format('dd MMM yyyy',UserInfo.getTimeZone().getID());
            return localeFormatT;
        }
        return null;
    }
    
}