/**
 * @File Name          : WS_DigitalHub.cls
 * @Description        : Use this class to access JOINTHEDIGITALHUB web service
 * @Author             : taniaoliveirafartaria@gmail.com
 * Ver       Date            Author      		    Modification
 * 1.0    27/05/2020   taniaoliveirafartaria@gmail.com     Initial Version
**/
public class WS_DigitalHub {
    public static final String RESULTCODE_OK = 'OK';
    public static final String RESULTCODE_KO = 'KO';
    public static final Id USERPROFILEID = Userinfo.getProfileId();
    private static final DigitalHub__c DIGITALHUB_SETTINGS = DigitalHub__c.getinstance(USERPROFILEID); 

    public class WRP_VehicleResult {
		public String resultCode;
		public String errorMessage;

		public WS_DigitalHubSchema.VehicleResponse vehicleDetails;

		public WRP_VehicleResult(WS_DigitalHubSchema.VehicleResponse vehicleDetails) {
            this.resultCode = RESULTCODE_OK;
			this.vehicleDetails = vehicleDetails;
		}
		public WRP_VehicleResult(String errorMessage) {
			this.resultCode = RESULTCODE_KO;
			this.errorMessage = errorMessage;
		}
    }
    
    public static WRP_VehicleResult getVehicleResult(){
        WS_DigitalHubSchema.VehicleResponse vehicleResp = new WS_DigitalHubSchema.VehicleResponse();
        WS_DigitalHubService digitalHubService = new WS_DigitalHubService();
        try{
            vehicleResp = digitalHubService.vehicleInfo(DIGITALHUB_SETTINGS.CorrelationId__c);
            return new WRP_VehicleResult(vehicleResp);
        }catch(Exception ex){
            return new WRP_VehicleResult(ex.getMessage());
        }
    }

}
