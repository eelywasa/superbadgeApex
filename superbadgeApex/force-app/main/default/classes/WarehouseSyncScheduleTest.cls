@isTest
private class WarehouseSyncScheduleTest {
    
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    static testmethod void test() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
        Test.startTest();
            String jobId = System.schedule('ScheduledApexTest',CRON_EXP, new WarehouseSyncSchedule());  
        Test.stopTest();
    }
}