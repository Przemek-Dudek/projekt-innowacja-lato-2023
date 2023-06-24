import { LightningElement, track, wire } from 'lwc';
import getAllAnimalObjects from '@salesforce/apex/SandboxAuthorization.getAnimalsObjects';
export default class AnimalSearcher extends LightningElement {
    @track shelter = 'any';
    @track breed = 'any';
    @track age = 'any';
    @track imageFile;
    @track animals = [];
    @track animalsFilter = [...this.animals];
    @track breedOptions = [];
    @track shelterOptions = [];
    @track ageOptions = [];
    


    handleShelterChange(event) {
        this.shelter = event.target.value;
        this.filterAnimals();
    }
    handleBreedChange(event) {
        this.breed = event.target.value;
        this.filterAnimals();
    }
    handleAgeChange(event) {
        this.age = event.target.value;
        this.filterAnimals();
    }

    filterAnimals () {
        this.animalsFilter = [...this.animals]
        if(this.shelter !== 'any') {
            this.animalsFilter = this.animals.filter((animal) => {
                if (animal['Shelter__c'] === this.shelter) {
                    return animal;
                }
            })  
        }
        if(this.breed !== 'any'){
            this.animalsFilter = this.animalsFilter.filter((animal) => {
                if (animal['Breed__c'] === this.breed) {
                    return animal;
                }
            })
        }
        if(this.age !== 'any'){
            this.animalsFilter = this.animalsFilter.filter((animal) => {
                if (String(animal['Age__c']) === String(this.age)) {
                    return animal;
                }
            })
        }
    }

    handleFileChange(event) {
        this.imageFile = event.target.files[0];
        // TODO: Use this imageFile with image recognition API to get the breed
    }

    


    handleSearch() {
        // TODO: Use the parameters to perform search in Salesforce or through external API
        // This should update the `animals` property with the search results
    }

    getOptions(field) {
        const breed = this.animals.map((animal) => {
            return animal[field]
        });
        
        const breeds = [...new Set(breed)];

        const newBreedOptions = breeds.map((breed) => {
            return { label: String(breed), value: String(breed) };
        });
        return [...newBreedOptions, {label: 'any', value: 'any'}]
    }

    @wire(getAllAnimalObjects, {})
    wiredAnimalsObjects({ error, data }) {
        if (data) {
            this.animals = data;
            this.animalsFilter = [...this.animals];
        
            this.breedOptions = this.getOptions('Breed__c')
            this.shelterOptions = this.getOptions('Shelter__c')
            this.ageOptions = this.getOptions('Age__c')
     
            console.log("The breed options: ", this.breedOptions);
        } else if (error) {
            console.log(error);
        }
    }
    
}