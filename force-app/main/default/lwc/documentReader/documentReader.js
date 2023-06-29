import { LightningElement, track, wire } from 'lwc';
import readDocument from '@salesforce/apex/EinsteinTokenGenerator.readDocument';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AnimalSearcher extends LightningElement {    
    handleFileChange(event) {
        const file = event.target.files[0];
        this.uploadFile(file);
    }

    uploadFile(file) {
        const reader = new FileReader();

        reader.onload = () => {
            const base64 = reader.result.split(',')[1];

            const showToastEvent = new ShowToastEvent({
                title: 'Success',
                message: 'Photo uploaded',
                variant: 'success'
            });
            this.dispatchEvent(showToastEvent);
            readDocument({isID: true, base64: base64 })
                .then(result => {
                    const parsedResponse = JSON.parse(result);
                    console.log(parsedResponse)
                })
                .catch(error => {
                    console.log(error)
                });
        };

        reader.readAsDataURL(file);
    }

   

    
    
}