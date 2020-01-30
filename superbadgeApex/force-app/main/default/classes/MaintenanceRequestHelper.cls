public class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Id> requests){
        // We have been passed a list of updated Ids by the trigger
        // Query for the fields we need
        List<Case> maintenanceRequests = [SELECT Id, Type, Status, Vehicle__c, Equipment__c, ClosedDate,
                                          (SELECT Equipment__r.Maintenance_Cycle__c FROM Work_Parts__r) 
                                          FROM Case WHERE Id IN :requests];
        List<Case> followUps = new List<Case>();

        //Set the defult maintenance cycle to be the largest one in the product database
        Decimal defaultMaintenanceInterval = (Decimal) [SELECT MAX(Maintenance_Cycle__c) m FROM Product2][0].get('m');
        
        // loop through and check for ones where we need to create
        // future checkups
        for(Case mr: maintenanceRequests){
            if((mr.type=='Repair' || mr.Type=='Routine Maintenance') && mr.Status=='Closed'){
                //We have a match
                //Establish when to set the request due date
                Decimal maintenanceInterval = defaultMaintenanceInterval;
                for(Work_Part__c w : mr.Work_Parts__r){
                    if(w.Equipment__r.Maintenance_Cycle__c < maintenanceInterval){
                        maintenanceInterval = w.Equipment__r.Maintenance_Cycle__c;
                    }
                }


                Case followUpMr = new Case(Subject = 'Routine Checkup', 
                                           Type='Routine Maintenance', 
                                           Date_Reported__c=Date.today(),
                                           Vehicle__c = mr.Vehicle__c,
                                           Equipment__c = mr.Equipment__c,
                                           Date_Due__c = mr.ClosedDate.addDays((Integer) maintenanceInterval).date()
                                           );

                followUps.add(followUpMr);
            }
        }
        insert followUps;
    }        
    
}