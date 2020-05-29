import { LightningElement, wire, api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import ERRORMESSAGE_FIELD from '@salesforce/schema/Opportunity.ErrorMessage__c';
const FIELDS = [ERRORMESSAGE_FIELD];

export default class LWC_DisplayErrorMessage extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields : FIELDS }) 
    opportunity;

    get message() {
        return getFieldValue(this.opportunity.data, ERRORMESSAGE_FIELD);
    }

}