/**
 * @File Name          : TH_OrderItem.cls
 * @Description        : 
 * @Author             : taniaoliveirafartaria@gmail.com
 * Ver       Date            Author      		    Modification
 * 1.0    27/05/2020   taniaoliveirafartaria@gmail.com     Initial Version
**/
public class TH_OrderItem {
    public static void productValidation(List<OrderItem> orderItems){

        Set<Id> orderIds = new Set<Id>();
        for(OrderItem item :orderItems){
            orderIds.add(item.OrderId);
        }
        SM_OrderProductValidation.TruckService(orderIds);

    }
}
