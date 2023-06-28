import { LightningElement, track, wire } from 'lwc';
import getAllAnimalObjects from '@salesforce/apex/SandboxAuthorization.getAnimalsObjects';
import getBreedFromPhoto from '@salesforce/apex/EinsteinTokenGenerator.uploadFileToApex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

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
        if (this.breed !== 'any') {
            const normalizedBreed = this.breed.toUpperCase();
          
            this.animalsFilter = this.animalsFilter.filter((animal) => {
              const normalizedAnimalBreed = animal['Breed__c'];
             
              if (String(normalizedAnimalBreed).toUpperCase() === normalizedBreed) {
                return animal;
              }
            });
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
            getBreedFromPhoto({ base64: base64 })


            getBreedFromPhoto({fromUrl: false, base64: base64 })
                .then(result => {
                    
                    console.log('pierwszy log')
                    const parsedResponse = JSON.parse(result);
                    console.log(parsedResponse)
                    const label = parsedResponse.probabilities[0].label;
                    const replacedLabel = label.replace(/_/g, " ");
                    this.breedOptions.push({ label: String(replacedLabel), value: String(replacedLabel)})

                    this.breed = String(replacedLabel)
                    
                    this.filterAnimals()
                })
                .catch(error => {
                    console.log(error)
                });
        };

        reader.readAsDataURL(file);
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