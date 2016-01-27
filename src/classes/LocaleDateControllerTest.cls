@IsTest
public class LocaleDateControllerTest {

    @IsTest static void testGetTimeZoneValue() {
        
        
        LocaleDateController controller = new LocaleDateController();

        controller.dateValue = DateTime.now();
        
        System.assert(controller.getTimeZoneValue()!=null);
     
        
        controller.dateValue = null;
        
        System.assert(controller.getTimeZoneValue()==null);        
        
    }
    
}