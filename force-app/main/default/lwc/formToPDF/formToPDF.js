import { LightningElement, track, wire } from 'lwc';
import jsPDF from "@salesforce/resourceUrl/jsPDF";
import { loadScript } from "lightning/platformResourceLoader";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import addAdoption from '@salesforce/apex/EinsteinTokenGenerator.addAdoption';
// import getShelterRecords from '@salesforce/apex/getShelters.getShelterRecords';
import getAllAnimalObjects from '@salesforce/apex/SandboxAuthorization.getAnimalsObjects';


export default class Form extends LightningElement {
  @track animalName = 'arek';
  @track firstName = 'Jakub';
  @track lastName = 'Szewczyk';
  @track email = 'kuba2002@gmail.com';
  @track shelter = '';
  @track shelterOptions = [];
  @track shelters = [];
  @track animals = [];

  handleAnimalNameChange(event) {
    this.animalName = event.target.value;
  }

  handleFirstNameChange(event) {
    this.firstName = event.target.value;
  }

  handleLastNameChange(event) {
    this.lastName = event.target.value;
  }

  handleEmailChange(event) {
    this.email = event.target.value;
  }

  handleShelterChange(event) {
    this.shelter = event.target.value;
  }


  getOptions(field) {
      const breed = this.animals.map((animal) => {
          return animal[field]
      });
      
      const breeds = [...new Set(breed)];

      const newBreedOptions = breeds.map((breed) => {
          return { label: String(breed), value: String(breed) };
      });
      return [...newBreedOptions]
  }

  @wire(getAllAnimalObjects, {})
    wiredAnimalsObjects({ error, data }) {
      console.log('data: '+data)  
      if (data) {
            this.animals = data;

            this.shelters = this.getOptions('Shelter__c')
           // this.ageOptions = this.getOptions('Age__c')
     
           // console.log("The breed options: ", this.breedOptions);
        } else if (error) {
            console.log(error);
        }
    }


  //loading script
  jsPdfInitialized=false;
  renderedCallback(){
      loadScript(this, jsPDF ).then(() => {});
      if (this.jsPdfInitialized) {
          return;
      }
      this.jsPdfInitialized = true;
  }

  createPdf() {
    if(
      this.animalName === '' ||
      this.firstName === '' ||
      this.lastName === '' ||
      this.email === '' ||
      this.shelter === '' ||
      this.adoptionDate === '' 
    ) {
        const showToastEvent = new ShowToastEvent({
          title: 'Empty Fields',
          message: 'Fill every field',
          variant: 'failure'
      });
      this.dispatchEvent(showToastEvent);
      return;
    } 
    const { jsPDF } = window.jspdf;
    const doc = new jsPDF();
    doc.setFontSize(24);
    doc.setFont('helvetica')
    doc.text("Adoption", 90, 20,)        
    doc.setFontSize(10)
    doc.setFont('arial black')
    doc.text("Imie zwierzecia:", 20, 40)
    doc.text("Imie:", 20, 50)
    doc.text("Nazwisko:", 20, 60)
    doc.text("Email:", 20, 70)
    doc.text("Schronisko:", 20, 80)
    doc.setFontSize(14)
    doc.setFont('times')
    doc.text(this.animalName, 45, 40)
    doc.text(this.firstName, 45, 50)
    doc.text(this.lastName, 45, 60)
    doc.text(this.email, 45, 70)
    doc.text(this.shelter, 45, 80)
    

    console.log('1')
    var out = doc.output("datauristring").split(',')[1]

    const showToastEvent = new ShowToastEvent({
        title: 'Success',
        message: 'PDF Created',
        variant: 'success'
    });
    this.dispatchEvent(showToastEvent);
    addAdoption({ isID: false, base64: out })
      .then(result => {
        const showToastEvent = new ShowToastEvent({
            title: 'Success',
            message: 'Adoption added',
            variant: 'success'
        });
        this.dispatchEvent(showToastEvent);
        console.log('result: '+result)
      })
      .catch(error => {
          console.log(error)
      });

    this.animalName = '';
    this.firstName = '';
    this.lastName = '';
    this.email = '';
    this.shelter = '';
    this.adoptionDate = '';
  }
  generateData(){
      this.createPdf();
  }
}
