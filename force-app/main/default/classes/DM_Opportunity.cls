/**
 * @File Name          : DM_Opportunity.cls
 * @Description        : 
 * @Author             : taniaoliveirafartaria@gmail.com
 * Ver       Date            Author      		    Modification
 * 1.0    27/05/2020   taniaoliveirafartaria@gmail.com     Initial Version
**/
public class DM_Opportunity {

    private final static String TRUCK = 'Truck';

    public static List<Opportunity> getOppsWithTruckItems(Set<Id> oppIds){

            List<Opportunity> oppsWithTruckItems = new List<Opportunity>([
                SELECT Name,
                AccountId, 
                ContactId, 
                (SELECT Quantity, 
                    Product2Id, 
                    TotalPrice,
                    Product2.Name,
                    Product2.ProductCode
                    FROM OpportunityLineItems 
                    WHERE Product2.Family = :TRUCK ) 
                FROM Opportunity 
                WHERE Id IN :oppIds
            ]);

            return oppsWithTruckItems;
    }


    public static List<Opportunity> getOppsWithItems(Set<Id> oppIds){

        List<Opportunity> oppsWithItems = new List<Opportunity>([
            SELECT Name,
            AccountId, 
            ContactId, 
            (SELECT Quantity, 
                Product2Id, 
                TotalPrice,
                Product2.Name,
                Product2.ProductCode,
                PricebookEntry.Product2.ParentProduct__c,
                PricebookEntry.Product2.Family
                FROM OpportunityLineItems ) 
            FROM Opportunity 
            WHERE Id IN :oppIds
        ]);

        return oppsWithItems;
    }   


}
