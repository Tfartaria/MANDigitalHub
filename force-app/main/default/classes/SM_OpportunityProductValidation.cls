/**
 * @File Name          : SM_OpportunityProductValidation.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 28/05/2020, 20:12:45
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    28/05/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public class SM_OpportunityProductValidation {
    private final static String TRUCK = 'Truck';
    private final static String SERVICE = 'Service';
    private final static String MESSAGE_EMPTHY = '';
    private final static String MESSAGE_ADD_TRUCK = 'Please add the truck associated with the service.';
    private final static String MESSAGE_SERVICE_PER_TRUCK = 'Ensure you have only one service per truck.';
    

    public void truckService(Set<Id> oppIds){
        Map<Id,Decimal> numberTrucksByProductIds = new Map<Id,Decimal>();
        Map<Id,OpportunityLineItem> servicesByProductIds = new Map<Id,OpportunityLineItem>();
        List<Opportunity> oppsWithItems = DM_Opportunity.getOppsWithItems(oppIds);
        Map<Id,Opportunity> oppsToAddError = new Map<Id,Opportunity>();
        List<Opportunity> oppsToRemoveError = new List<Opportunity>();

        for(Opportunity oppRecord : oppsWithItems){
            
            for(OpportunityLineItem item : oppRecord.OpportunityLineItems){
                numberTrucksByProductIds = SM_OpportunityProductValidation.setNumberTrucksByProductIds(item);
                servicesByProductIds= SM_OpportunityProductValidation.setServicesByProductIds(item);
           }

            for(OpportunityLineItem serviceItem : servicesByProductIds.values()){
                Id parentProduct = serviceItem.PricebookEntry.Product2.ParentProduct__c;

                if(numberTrucksByProductIds.size() == 0 || 
                    numberTrucksByProductIds.get(parentProduct) == null){
                        oppRecord.ErrorMessage__c = MESSAGE_ADD_TRUCK;
                        oppsToAddError.put(oppRecord.Id, oppRecord);

                }else if(numberTrucksByProductIds.get(parentProduct) != null && 
                    serviceItem.Quantity > numberTrucksByProductIds.get(parentProduct) ){
                        oppRecord.ErrorMessage__c = MESSAGE_SERVICE_PER_TRUCK;
                    oppsToAddError.put(oppRecord.Id, oppRecord);
                }
            }     
            if(oppsToAddError.get(oppRecord.Id) == null){
                oppRecord.ErrorMessage__c = MESSAGE_EMPTHY;
                oppsToRemoveError.add(oppRecord);
            }
        }

        if(oppsToAddError.size() > 0){
            Database.update(oppsToAddError.values());
        }

        if(oppsToRemoveError.size() > 0){
            Database.update(oppsToRemoveError);
        }    
    }

    private static Map<Id,Decimal> setNumberTrucksByProductIds(OpportunityLineItem item){
        Map<Id,Decimal> numberTrucksByProductIds = new  Map<Id,Decimal>();
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

    private static Map<Id,OpportunityLineItem> setServicesByProductIds(OpportunityLineItem item){
        Map<Id,OpportunityLineItem> servicesByProductIds = new Map<Id,OpportunityLineItem>();
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
