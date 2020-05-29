import { LightningElement, wire, api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import ERRORMESSAGE_FIELD from '@salesforce/schema/Order.ErrorMessage__c';
import STATUS_FIELD from '@salesforce/schema/Order.Status';
const FIELDS = [ERRORMESSAGE_FIELD,STATUS_FIELD ];

export default class LWC_DisplayErrorMessage extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields : FIELDS }) 
    order;

    get message() {
        return getFieldValue(this.order.data, ERRORMESSAGE_FIELD);
    }

}