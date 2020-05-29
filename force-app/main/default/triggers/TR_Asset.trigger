/**
 * @File Name          : TR_Asset.cls
 * @Description        : 
 * @Author             : taniaoliveirafartaria@gmail.com
 * Ver       Date            Author      		    Modification
 * 1.0    27/05/2020   taniaoliveirafartaria@gmail.com     Initial Version
**/
trigger TR_Asset on Asset (after insert) {

    if(Trigger.isInsert){
        TH_Assets.setTruckDetailsInFuture(Trigger.NewMap.keySet());
    }

}