/**
 * Created by Jun Liu on 5/01/2017.
 */

@IsTest
public  class ClosedCaseTest {


    @IsTest(SeeAllData=false) static void testIsClosedCase() {

        Case newCase = new Case();
        newCase.Subject = 'testClosed';
        newCase.Status = 'Closed';
        insert newCase;
        ApexPages.StandardController strc = new ApexPages.StandardController(newCase);
        CaseTimeController contr = new CaseTimeController(strc);

        Test.startTest();
        Boolean result = contr.isClosedCase;
        Test.stopTest();

        System.assertEquals(result, true);

    }

    @IsTest(SeeAllData=false) static void testIsNotClosedCase() {

        Case newCase = new Case();
        newCase.Subject = 'testClosed';
        newCase.Status = 'New';
        insert newCase;
        ApexPages.StandardController strc = new ApexPages.StandardController(newCase);
        CaseTimeController contr = new CaseTimeController(strc);

        Test.startTest();
        Boolean result = contr.isClosedCase;
        Test.stopTest();

        System.assertEquals(result, false);

    }
}