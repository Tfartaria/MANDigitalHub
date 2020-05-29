/**
 * @File Name          : TH_Opportunity.cls
 * @Description        : 
 * @Author             : taniaoliveirafartaria@gmail.com
 * Ver       Date            Author      		    Modification
 * 1.0    27/05/2020   taniaoliveirafartaria@gmail.com     Initial Version
**/
public class TH_Opportunity {
    
        private final static String CLOSED_WON = 'Closed Won';
        private final static String PURCHASED ='Purchased';
        private static Date today = Date.today();

        public static void trucksToAssets(Map<Id, Opportunity> oldOppByIds, Map<Id, Opportunity> oppsByIds){

            Map<Id, Opportunity> wonOppByIds = new Map<Id, Opportunity>();

            for(Opportunity opp :oppsByIds.values()){
                If (opp.StageName == CLOSED_WON && opp.StageName != oldOppByIds.get(opp.Id).StageName){
                    wonOppByIds.put(opp.id, opp);
                }
            }
            if(wonOppByIds.size()>0){
                List<Opportunity> oppsWithTruckItems = DM_Opportunity.getOppsWithTruckItems(wonOppByIds.keySet());
                List<Asset> assestToInsert = new List<Asset>();
                for(Opportunity opp :oppsWithTruckItems){
                    List<Asset> trucksToAssest = TH_Opportunity.createAssets(opp, opp.OpportunityLineItems);
                    assestToInsert.addAll(trucksToAssest);
                }
                Database.insert(assestToInsert);     
            }
            
        }

        private static List<Asset> createAssets (Opportunity opp, List<OpportunityLineItem> oppTruckItems){
            List<Asset> trucksToAssetsToInsert = new List<Asset>();
            for(OpportunityLineItem truckItem: oppTruckItems){
                Asset newAsset = new Asset(
                    Name = truckItem.Product2.ProductCode + ' - ' + opp.Name,
                    AccountId = opp.AccountId,
                    ContactId = opp.ContactId,
                    Product2Id = truckItem.Product2Id,
                    Quantity = truckItem.Quantity,
                    Price = truckItem.TotalPrice,
                    Status = PURCHASED,
                    PurchaseDate = today
                );
                trucksToAssetsToInsert.add(newAsset);
            }
            return trucksToAssetsToInsert;

        }
    
}
