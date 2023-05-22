import {LightningElement, wire, api} from 'lwc';
import showHours from '@salesforce/apex/HoursController.showHours';

export default class Open_Hours extends LightningElement {
    @api recordId;
    hour;

    @wire(showHours, {shelterID: '$recordId'})
    wiredAccount({ error, data }) {
        console.log("ID record: " +this.recordId)
        console.log("data: " + data)
        console.log("error: " + JSON.stringify(error))
        if (data) {
            console.log("data: " + data)
            this.hour = data;
        } else if (error) {
            console.error(error);
        }
    }
}