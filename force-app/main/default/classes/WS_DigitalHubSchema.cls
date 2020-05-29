/**
 * @File Name          : WS_DigitalHubSchema.cls
 * @Description        : Class to store classes representing JOINTHEDIGITALHUB data model
 * @Author             : taniaoliveirafartaria@gmail.com
 * Ver       Date            Author      		    Modification
 * 1.0    27/05/2020   taniaoliveirafartaria@gmail.com     Initial Version
**/
public class WS_DigitalHubSchema {
  
    public class VehicleResponse { 
        public String vin;
        public String vehicleRegNum;
        public String regNumCountryKey; 
        public String oemVin;
        public String manufacturer; 
        public String modelRange;  
        public String vehicleType;  
        public String customerRegDate;
        public MeasuringPoint measuringPoint;
        public VehicleTextData vehicleTextData;

      
    }
    public class MeasuringPoint {
        public String measPoint;
        public String counterReading;
        public String mpUnit;
    }
    
    public class NoteText {
        public String tagColumn;
        public String textLine;
    }

    
    public class InformationText{
        public String textLine;
    }

    public class VehicleTextData {
        public InformationText informationText;
        public List<NoteText> noteText;
    }

    public static VehicleResponse parse(String json) {
        return (VehicleResponse) System.JSON.deserialize(json, VehicleResponse.class);
    }

}
