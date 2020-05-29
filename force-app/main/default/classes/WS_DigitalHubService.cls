/**
 * @File Name          : WS_DigitalHubService.cls
 * @Description        : Class to store methods that perform HTTP callouts to JOINTHEDIGITALHUB backend service
 * @Author             : taniaoliveirafartaria@gmail.com
 * Ver       Date            Author      		    Modification
 * 1.0    27/05/2020   taniaoliveirafartaria@gmail.com     Initial Version
**/
public class WS_DigitalHubService {
    
	public String responseJson;
	public String responseStatus;

    public class UnexpectedResponseException extends Exception {
	}

    public WS_DigitalHubSchema.VehicleResponse vehicleInfo(String guid) {
        
        Http httpHelper = new Http();
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:JOINTHEDIGITALHUB');
		request.setMethod('GET');
		string username = '{!$Credential.UserName}';
        string password = '{!$Credential.Password}';
		request.setHeader('client-id', username);
		request.setHeader('client-secret', password);
        request.setHeader('correlation-id', guid );
        System.debug('request:' +request);
        HttpResponse response = new HttpResponse();
        
		response = httpHelper.send(request);
		this.responseJson = response.getBody();
		this.responseStatus = 'HTTP Status: ' + response.getStatusCode() + ' ' + response.getStatus();
		
        WS_DigitalHubSchema.VehicleResponse vehicleRes = new WS_DigitalHubSchema.VehicleResponse();
		try {
			vehicleRes = WS_DigitalHubSchema.VehicleResponse.parse(responseJson);
		} catch (Exception ex) {
			throw new UnexpectedResponseException(responseStatus + '\nBody: ' + responseJson);
		}
		return vehicleRes;
	}

}
