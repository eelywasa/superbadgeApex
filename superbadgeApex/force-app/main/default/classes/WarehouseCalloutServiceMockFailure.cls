@isTest
global class WarehouseCalloutServiceMockFailure implements HttpCalloutMock {
    // implement http mock callout
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json; charset=utf-8');
        response.setBody('ERROR');
        response.setStatusCode(500);
        return response; 
    }
}