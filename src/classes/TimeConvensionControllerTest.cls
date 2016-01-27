@IsTest
public class TimeConvensionControllerTest {

    
    @IsTest static void testTimeconversion() {
        
        
        TimeConversionController controller = new TimeConversionController();

        controller.s = 598;
        
        System.assertEquals(controller.hoursValue, '00:09:58'); 
        
        controller.s = null;
        
        System.assert(controller.hoursValue==null); 
        
    }
    
}