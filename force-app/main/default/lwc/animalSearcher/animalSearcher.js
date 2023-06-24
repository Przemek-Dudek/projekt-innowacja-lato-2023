import { LightningElement, track, wire } from 'lwc';
import getAllAnimalObjects from '@salesforce/apex/SandboxAuthorization.getAnimalsObjects';
export default class AnimalSearcher extends LightningElement {
    @track shelter = 'any';
    @track breed = 'any';
    @track age = 'any';
    @track gender = 'any';
    @track imageFile;
    @track animals = [];
    @track animalsFilter = [...this.animals];
    @track breedOptions = [];
    @track shelterOptions = [];
    @track ageOptions = [];
    

    genderOptions = [
        {label: 'any', value: ''},
        { label: 'Male', value: 'male' },
        { label: 'Female', value: 'female' },
    ];

    handleShelterChange(event) {
        this.shelter = event.target.value;
        if(this.shelter === 'any') {
            this.animalsFilter = [...this.animals]
        } else {
            this.animalsFilter = this.animals.filter((animal) => {
                if (animal['Shelter__c'] === this.shelter) {
                    return animal;
                }
            })  
        }
    }

    handleBreedChange(event) {
        this.breed = event.target.value;
        if(this.breed === 'any') {
            this.animalsFilter = [...this.animals]
        } else {
            this.animalsFilter = this.animals.filter((animal) => {
                if (animal['Breed__c'] === this.breed) {
                    return animal;
                }
            })
        }
    }

    handleFileChange(event) {
        this.imageFile = event.target.files[0];
        // TODO: Use this imageFile with image recognition API to get the breed
    }

    handleAgeChange(event) {
        this.age = event.target.value;
        // TODO: Use this imageFile with image recognition API to get the breed
    }

    handleGenderChange(event) {
        this.gender = event.target.value;
    }

    handleSearch() {
        // TODO: Use the parameters to perform search in Salesforce or through external API
        // This should update the `animals` property with the search results
    }

    funkcja_kuby(field) {
        const breed = this.animals.map((animal) => {
            return animal[field]
        });
        
        const breeds = [...new Set(breed)];

        const newBreedOptions = breeds.map((breed) => {
            return { label: breed, value: breed };
        });
        return [...newBreedOptions, {label: 'any', value: 'any'}]
    }

    @wire(getAllAnimalObjects, {})
    wiredAnimalsObjects({ error, data }) {
        if (data) {
            this.animals = data;
            this.animalsFilter = [...this.animals];
    
            // const breed = this.animals.map((animal) => {
            //     return animal['Breed__c']
            // });

            // const shelter = this.animals.map((animal) => {
            //     return animal['Shelter__c']
            // });
            // const shelters = [...new Set(shelter)];
            
    
            // // Remove duplicates from breed array
            // const breeds = [...new Set(breed)];

            // const newBreedOptions = breeds.map((breed) => {
            //     return { label: breed, value: breed };
            // });
    
            this.breedOptions = this.funkcja_kuby('Breed__c')
            this.shelterOptions = this.funkcja_kuby('Shelter__c')
     
            console.log("The breed options: ", this.breedOptions);
        } else if (error) {
            console.log(error);
        }
    }
    
}