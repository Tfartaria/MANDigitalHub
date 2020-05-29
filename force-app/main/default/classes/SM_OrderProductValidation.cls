/**
 * @File Name          : SM_OrderProductValidation.cls
 * @Description        : 
 * @Author             : taniaoliveirafartaria@gmail.com
 * Ver       Date            Author      		    Modification
 * 1.0    27/05/2020   taniaoliveirafartaria@gmail.com     Initial Version
**/
public class SM_OrderProductValidation {

    private final static String TRUCK = 'Truck';
    private final static String SERVICE = 'Service';
    private final static String MESSAGE_EMPTHY = '';
    private final static String MESSAGE_ADD_TRUCK = 'Please add the truck associated with the service.';
    private final static String MESSAGE_SERVICE_PER_TRUCK = 'Is not allowed to order one service without the related truck. Ensure you have only one service per truck.';
   
    public static void truckService(Set<Id> orderIds){
        Map<Id,Decimal> numberTrucksByProductIds = new Map<Id,Decimal>();
        Map<Id,OrderItem> servicesByProductIds = new Map<Id,OrderItem>();
    
        List<Order> ordersWithItems = DM_Order.getOrdersWithOrderItems(orderIds);
        Map<Id,Order> ordersToAddError = new Map<Id,Order>();
        List<Order> ordersToRemoveError = new List<Order>();

        for(Order orderRecord : ordersWithItems){
            
            for(OrderItem item : orderRecord.OrderItems){
                numberTrucksByProductIds= SM_OrderProductValidation.setNumberTrucksByProductIds(item);
                servicesByProductIds= SM_OrderProductValidation.setServicesByProductIds(item);

           }

            for(OrderItem serviceItem : servicesByProductIds.values()){
                Id parentProduct = serviceItem.PricebookEntry.Product2.ParentProduct__c;

                if(numberTrucksByProductIds.size() == 0 || 
                    numberTrucksByProductIds.get(parentProduct) == null){
                    orderRecord.ErrorMessage__c = MESSAGE_ADD_TRUCK;
                    ordersToAddError.put(orderRecord.Id, orderRecord);

                }else if(numberTrucksByProductIds.get(parentProduct) != null && 
                    serviceItem.Quantity > numberTrucksByProductIds.get(parentProduct) ){
                    orderRecord.ErrorMessage__c = MESSAGE_SERVICE_PER_TRUCK;
                    ordersToAddError.put(orderRecord.Id, orderRecord);
                }
            }     
            if(ordersToAddError.get(orderRecord.Id) == null){
                orderRecord.ErrorMessage__c = MESSAGE_EMPTHY;
                ordersToRemoveError.add(orderRecord);
            }
        }

        if(ordersToAddError.size() > 0){
            Database.update(ordersToAddError.values());
        }
        if(ordersToremoveError.size() > 0){
            Database.update(ordersToRemoveError);
        }
        
    }

    private static Map<Id,Decimal> setNumberTrucksByProductIds(OrderItem item){
        Map<Id,Decimal> numberTrucksByProductIds = new Map<Id,Decimal>();
        String itemFamily = item.PricebookEntry.Product2.Family;
        Id itemParentProduct = item.PricebookEntry.Product2.ParentProduct__c;
        
        if(itemFamily == TRUCK){
            if(numberTrucksByProductIds.get(item.PricebookEntry.Product2.Id)== null){
                numberTrucksByProductIds.put(item.PricebookEntry.Product2.Id, item.Quantity);
            }else{
                Decimal existingTrucks = numberTrucksByProductIds.get(item.PricebookEntry.Product2.Id);
                numberTrucksByProductIds.put(item.PricebookEntry.Product2.Id, item.Quantity+existingTrucks);
            }
        }
        return numberTrucksByProductIds;
    }

    private static Map<Id,OrderItem> setServicesByProductIds(OrderItem item){
        Map<Id,OrderItem> servicesByProductIds = new Map<Id,OrderItem>();
        String itemFamily = item.PricebookEntry.Product2.Family;
        Id itemParentProduct = item.PricebookEntry.Product2.ParentProduct__c;
      
        if(itemFamily == SERVICE && itemParentProduct != null ){
            if(servicesByProductIds.get(item.PricebookEntry.Product2.Id)== null){
                servicesByProductIds.put(item.PricebookEntry.Product2.Id, item);
            }else{
               item.Quantity = item.Quantity + servicesByProductIds.get(item.PricebookEntry.Product2.Id).Quantity;
                servicesByProductIds.put(item.PricebookEntry.Product2.Id, item);

           }
        }
        return servicesByProductIds;
    }

}
