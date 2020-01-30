trigger MaintenanceRequest on Case (after update) {
    // call MaintenanceRequestHelper.updateWorkOrders
    List<Id> closedRequests = new List<Id>();

    for(Case request: Trigger.new){
        Case requestBefore = Trigger.oldMap.get(request.Id);
        if((request.Status=='Closed' && requestBefore.Status!='Closed') && (request.type=='Repair' || request.Type=='Routine Maintenance')){
            closedRequests.add(request.Id);
        }
    }
    MaintenanceRequestHelper.updateWorkOrders(closedRequests);  
}