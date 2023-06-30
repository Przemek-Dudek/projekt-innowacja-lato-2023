import { LightningElement, track, wire } from 'lwc';
import addPerson from '@salesforce/apex/EinsteinTokenGenerator.addPerson';
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
            addPerson({base64: base64 })
                .then(result => {
                    
                })
                .catch(error => {
                    console.log(error)
                });
        };

        reader.readAsDataURL(file);
    }

   

    
    
}