/**
 * @File Name          : TR_OrderItem.trigger
 * @Description        : 
 * @Author             : taniaoliveirafartaria@gmail.com
 * Ver       Date            Author      		    Modification
 * 1.0    27/05/2020   taniaoliveirafartaria@gmail.com     Initial Version
**/
trigger TR_OrderItem on OrderItem (after update, after insert, after delete) {

    if (Trigger.isUpdate || Trigger.isInsert ) {
        TH_OrderItem.productValidation(Trigger.new);
    }else if(Trigger.isDelete){
        TH_OrderItem.productValidation(Trigger.old);
    }

}