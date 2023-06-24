import { LightningElement, track } from 'lwc';

export default class AnimalSearcher extends LightningElement {
    @track shelter = '';
    @track breed = '';
    @track age = '';
    @track gender = '';
    @track imageFile;
    @track animals = [];

    genderOptions = [
        { label: 'Male', value: 'male' },
        { label: 'Female', value: 'female' },
    ];

    handleShelterChange(event) {
        this.shelter = event.target.value;
    }

    handleBreedChange(event) {
        this.breed = event.target.value;
    }

    handleAgeChange(event) {
        this.age = event.target.value;
    }

    handleGenderChange(event) {
        this.gender = event.target.value;
    }

    handleFileChange(event) {
        this.imageFile = event.target.files[0];
        // TODO: Use this imageFile with image recognition API to get the breed
    }

    handleSearch() {
        // TODO: Use the parameters to perform search in Salesforce or through external API
        // This should update the `animals` property with the search results
    }
}