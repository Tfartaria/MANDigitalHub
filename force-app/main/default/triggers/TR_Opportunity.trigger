/**
 * @File Name          : TR_Opportunity.trigger
 * @Description        : 
 * @Author             : taniaoliveirafartaria@gmail.com
 * Ver       Date            Author      		    Modification
 * 1.0    27/05/2020   taniaoliveirafartaria@gmail.com     Initial Version
**/
trigger TR_Opportunity on Opportunity (after update) {
    if(Trigger.isUpdate)
        TH_Opportunity.trucksToAssets(Trigger.OldMap, Trigger.NewMap);
}