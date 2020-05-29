/**
 * @File Name          : TH_Assets.cls
 * @Description        : 
 * @Author             : taniaoliveirafartaria@gmail.com
 * Ver       Date            Author      		    Modification
 * 1.0    27/05/2020   taniaoliveirafartaria@gmail.com     Initial Version
**/
public class TH_Assets {
    
    @Future(callout=true)
    public static void setTruckDetailsInFuture(Set<Id> assetsIds){
        List<Asset> assetRecords = DM_Asset.getAssetsByIds(assetsIds);
        List<Asset> assetsToUpdate = new List<Asset> ();
        String externalId;
        WS_DigitalHubSchema.VehicleTextData vehicleData;
        WS_DigitalHub.WRP_VehicleResult result = WS_DigitalHub.getVehicleResult();
        
        if(result.vehicleDetails != null){
            externalId = result.vehicleDetails.vin;
            vehicleData =  result.vehicleDetails.vehicleTextData;
        }else{
            return;
        }

        for(Asset assetRecord :assetRecords){
            if(assetRecord.Product2.ExternalId__c == externalId ){
                String notes;
                Set<WS_DigitalHubSchema.NoteText> noteTexts = new Set<WS_DigitalHubSchema.NoteText>();
                noteTexts.addAll(vehicleData.noteText);
                for(WS_DigitalHubSchema.NoteText note : noteTexts){
                   if(note.textLine != null)
                        notes = note.textLine + ',' +  notes;
                }
                assetRecord.Description = notes;
                assetRecord.Country__c = result.vehicleDetails.regNumCountryKey;
                assetsToUpdate.add(assetRecord);
            }
        }
        if(assetsToUpdate.size()>0)
            Database.update(assetsToUpdate);
    }

}
