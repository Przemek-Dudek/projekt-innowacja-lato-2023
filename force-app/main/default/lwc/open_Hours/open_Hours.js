import {LightningElement, wire, api} from 'lwc';
import showHours from '@salesforce/apex/HoursController.showHours';
export default class Open_Hours extends LightningElement {
    @api recordId;
    hour;
    weekendHour='';

    @wire(showHours, {shelterID: '$recordId'})
    wiredAccount({ error, data }) {
        if (data) {
            this.hour = data[0];
            this.weekendHour = data[1];
        } else if (error) {
            console.error(error);
        }
    }
}