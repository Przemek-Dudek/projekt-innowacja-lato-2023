import {LightningElement, api, wire} from 'lwc';
import get from '@salesforce/apex/NumberOfAdoptionsController.get'



export default class NumberOfAdoptions extends LightningElement {

    @api recordId;
    number;

    @wire(get, { objectID: '$recordId'})
    wiredAccount({ error, data }) {
        if (data) {
            this.number = data;
        }
        else if(data===undefined){
            this.number = 0;
        } 
        else if (error) {
            console.log(error);
        }
    }
}