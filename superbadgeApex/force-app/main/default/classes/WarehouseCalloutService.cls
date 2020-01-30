public with sharing class WarehouseCalloutService {

    public class Equipment {
        Boolean replacement;
        Integer quantity;
        String name;
        Integer maintenanceperiod;
        Integer lifespan;
        Decimal cost;
        String sku;
    }

    // complete this method to make the callout (using @future) to the
    // REST endpoint and update equipment on hand.
    @future(callout=true)
    public static void runWarehouseEquipmentSync(){

        //Construct the callout to the warehouse service
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:Warehouse_Inventory_Management');
            req.setMethod('GET');
            req.setHeader('Content-Type','application/json');
            
            //Make the call
            Http http = new Http();
            HTTPResponse res = http.send(req);

            //Inspect the response
            if(res.getStatusCode()==200){
                //Success
                //Parse the result
                List<WarehouseCalloutService.Equipment> eqs = (List<WarehouseCalloutService.Equipment>) JSON.deserialize(res.getBody(), List<WarehouseCalloutService.Equipment>.class);

                List<Product2> equipmentList = new List<Product2>();
                //Loop through the list and convert to a product sObject
                for(WarehouseCalloutService.Equipment eq : eqs){
                    Product2 equipment = new Product2(Replacement_Part__c=eq.replacement,
                                                      Cost__c = eq.cost,
                                                      Current_Inventory__c=eq.quantity,
                                                      Lifespan_Months__c=eq.lifespan,
                                                      Maintenance_Cycle__c=eq.maintenanceperiod,
                                                      Warehouse_SKU__c=eq.sku,
                                                      Name=eq.name
                                                     );
                    equipmentList.add(equipment); 
                }
                upsert equipmentList Product2.Fields.Warehouse_SKU__c;
            }
            else{
                //Call failed
                system.Debug('Warehouse call failed with status code ' + res.getStatusCode());
            }
        
    }

}