public with sharing class TimeConversionController {

    public Decimal s {get;set;}
    
    public String hoursValue{
        get{
            if (s != null) {
                Double h = Math.floor(s/3600); //Get whole hours
                s -= h*3600;
                Double m = Math.floor(s/60); //Get remaining minutes
                s -= m*60;
                return (h < 10 ? '0'+h.format() : h.format())+':'+(m < 10 ? '0'+m.format() : m.format())+':'+(s < 10 ? '0'+s.format() : s.format()); 
            }
            return null;
        }
        set;
        
    }
    
        
        
        
    
}