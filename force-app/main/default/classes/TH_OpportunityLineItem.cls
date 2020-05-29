/**
 * @File Name          : TH_OpportunityLineItem.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 29/05/2020, 10:05:04
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    28/05/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public class TH_OpportunityLineItem {
   
    public static void productValidation(List<OpportunityLineItem> oppItems){
        Set<Id> oppIds = new Set<Id>();
        for(OpportunityLineItem item :oppItems){
            oppIds.add(item.OpportunityId);
        }
        SM_OpportunityProductValidation productValidation = new SM_OpportunityProductValidation();
        productValidation.truckService(oppIds);
    }
    
}
