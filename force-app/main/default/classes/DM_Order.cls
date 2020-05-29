/**
 * @File Name          : DM_Order.cls
 * @Description        : 
 * @Author             : taniaoliveirafartaria@gmail.com
 * Ver       Date            Author      		    Modification
 * 1.0    27/05/2020   taniaoliveirafartaria@gmail.com     Initial Version
**/
public class DM_Order {

	public static List<Order> getOrdersWithOrderItems(Set<Id> orderIds) {

		List<Order> OrdersWithOrderItems = new List<Order>([
			SELECT Id, Name, ErrorMessage__c, (SELECT Id,
       			OrderId,   
				Quantity,
				PricebookEntry.Product2.Id,
				PricebookEntry.Product2.ParentProduct__c,
				PricebookEntry.Product2.Family
				FROM OrderItems) 
			FROM Order where Id
				IN :orderIds
		]);

		return ordersWithOrderItems;
	}

}