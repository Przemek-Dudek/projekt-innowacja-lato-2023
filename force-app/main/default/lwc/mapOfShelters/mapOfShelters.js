import {LightningElement, api, wire} from 'lwc';
import getShelters from '@salesforce/apex/mapOfSheltersController.getShelters'





export default class LightningMapExample extends LightningElement {
    @api recordId;
    mapMarkers = [];

  
    


    @wire(getShelters, {})
    wiredAccount({ error, data }) {
        if (data) {
        
            console.log(data);
            console.log("------------------------")
            this.mapMarkers = [];
            data.forEach((element) => {
                console.log(element.City__c);
                this.mapMarkers.push({location:{City: element.City__c, Country: element.Country__c, PostalCode: element.PostalCode__c, Street: element.Street__c},title: element.Name})
            });
            console.log("------------------------")
            //console.log(mapMarkers);

            // this.mapMarkers = data.map(element => {
            //     return {
            //       location: {
            //         City: element.City__c,
            //         Country: element.Country__c,
            //         PostalCode: element.PostalCode__c,
            //         Street: element.Street__c
            //       },
            //       title: element.Name
            //     };
            //   });

            // this.jakasNazwa = data;
            console.log(this.mapMarkers);
            // console.log("------------------------");

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