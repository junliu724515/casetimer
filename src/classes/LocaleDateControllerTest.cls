@IsTest
public class LocaleDateControllerTest {

    @IsTest
    public static void testGetTimeZoneValue() {
        
        
        LocaleDateController controller = new LocaleDateController();

        controller.dateValue = DateTime.now();
        
        String dateString = controller.getTimeZoneValue();
        
        System.assert(dateString!=null);       
        
        
    }
    
}