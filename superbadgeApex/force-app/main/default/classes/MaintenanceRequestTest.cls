@isTest
public class MaintenanceRequestTest {
    @TestSetup
    static void makeData(){

        //Create vehcile
        Vehicle__c testVehicle = new Vehicle__c(Name='Test Vehicle');
        insert testVehicle;
        
        //Create equipment
        List<Product2> testEquipment = new List<Product2>();
        testEquipment.add(new Product2(Name='Test Equipment 01', Replacement_Part__c=true, Maintenance_Cycle__c=365));
        testEquipment.add(new Product2(Name='Test Equipment 02', Replacement_Part__c=true, Maintenance_Cycle__c=10));
        testEquipment.add(new Product2(Name='Test Equipment 01', Replacement_Part__c=true, Maintenance_Cycle__c=0));
        insert testEquipment;

        //Create cases
        List<Case> testMaintenanceRequests = new List<Case>();
        for(Integer i=1; i<301; i++){
            testMaintenanceRequests.add(new Case(Subject='Test ' + i, Vehicle__c=testVehicle.Id, Equipment__c=testEquipment[1].Id, type='Repair', Status='New'));
        }
        insert testMaintenanceRequests;

        //Create work parts
        List<Work_Part__c> workParts = new List<Work_Part__c>();
        for(Case request: testMaintenanceRequests){
            for(Integer i=1; i<3; i++){
                workParts.add(new Work_Part__c(Equipment__c=testEquipment[i].Id, Maintenance_Request__c=request.Id, Quantity__c=1));
            }
        }
        insert workParts;
    }
    @isTest
    static void noValidUpdates(){
        //Update a case but leave it open
        Case request = [SELECT Id FROM Case WHERE Subject='Test 1'][0];
        request.Status = 'Working';
        update request;
        Integer casesAfter = [SELECT count() FROM Case WHERE Subject='Routine Checkup'];
        System.assertEquals(0,casesAfter);
    }
    @isTest
    static void closeCase(){
        //Update a case but leave it open
        Case request = [SELECT Id FROM Case WHERE Subject='Test 2'][0];
        request.Status = 'Closed';
        update request;
        Integer casesAfter = [SELECT count() FROM Case WHERE Subject='Routine Checkup'];
        System.assertEquals(1,casesAfter);
    }
    @isTest
    static void closeCaseBulk(){
        //Update a case but leave it open
        List<Case> requests = [SELECT Id FROM Case WHERE Status='New'];
        for(Case request: requests){
            request.Status = 'Closed';
        }
        update requests;
        Integer casesAfter = [SELECT count() FROM Case WHERE Subject='Routine Checkup'];
        System.assertEquals(300,casesAfter);
    }
}