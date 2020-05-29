/**
 * @File Name          : DM_Asset.cls
 * @Description        : 
 * @Author             : taniaoliveirafartaria@gmail.com
 * Ver       Date            Author      		    Modification
 * 1.0    27/05/2020   taniaoliveirafartaria@gmail.com     Initial Version
**/
public class DM_Asset {
    
    public static List<Asset> getAssetsByIds(Set<Id> assetIds){

        List<Asset> assetRecords = new List<Asset>([
            SELECT Id, 
            Description, 
            Country__c,
            Product2.ExternalId__c
            FROM Asset 
            WHERE Id IN :assetIds 
            AND Product2.ExternalId__c != null ]);
    
        return assetRecords;
    }




}
