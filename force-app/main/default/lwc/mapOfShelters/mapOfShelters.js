import {LightningElement, api, wire} from 'lwc';
import getShelters from '@salesforce/apex/mapOfSheltersController.getShelters'





export default class LightningMapExample extends LightningElement {
    @api recordId;
    mapMarkers = [];
    



    @wire(getShelters, {})
    wiredAccount({ error, data }) {
        if (data) {
        
            

            this.mapMarkers = data.map(element => {
                return {
                  location: {
                    City: element.City__c,
                    Country: element.Country__c,
                    PostalCode: element.PostalCode__c,
                    Street: element.Street__c
                  },
                  title: element.Name
                };
              });



        } 
        else if (error) {
            console.log(error);
        }
    }

    listView = 'visable';

    selectedMarkerValue = 'SF1';

    handleMarkerSelect(event) {
        this.selectedMarkerValue = event.target.selectedMarkerValue;
    }
}
