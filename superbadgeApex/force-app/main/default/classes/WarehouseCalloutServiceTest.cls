@isTest
private class WarehouseCalloutServiceTest {
  // implement your mock callout test here
  @isTest 
  static void testWarehouseCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
        
        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();

        //Check to see if we have the expected products
        Integer productCount = [SELECT count() FROM Product2];
        System.assertEquals(2,productCount);

    }
  @isTest
  static void testWarehouseCalloutFailure() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMockFailure()); 
        
        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();

        //Check to see if we have the expected products
        Integer productCount = [SELECT count() FROM Product2];
        System.assertEquals(0,productCount);

    }
}