/**
 * @File Name          : TR_OpportunityLineItem.trigger
 * @Description        : 
 * @Author             : taniaoliveirafartaria@gmail.com
 * Ver       Date            Author      		    Modification
 * 1.0    27/05/2020   taniaoliveirafartaria@gmail.com     Initial Version
**/
trigger TR_OpportunityLineItem on OpportunityLineItem (after update, after insert, after delete) {

    if (Trigger.isUpdate || Trigger.isInsert ) {
        System.debug('START TRIGGER OpportunityLineItem');
        System.debug('Trigger.newMap:'+Trigger.new);
        TH_OpportunityLineItem.productValidation(Trigger.new);
    }else if(Trigger.isDelete){
        TH_OpportunityLineItem.productValidation(Trigger.old);
    }
}