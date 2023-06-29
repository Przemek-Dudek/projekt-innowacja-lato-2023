import { LightningElement, track } from 'lwc';
import jsPDF from "@salesforce/resourceUrl/jsPDF";
import { loadScript } from "lightning/platformResourceLoader";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class Form extends LightningElement {
  @track animalName = 'a';
  @track firstName = 'a';
  @track lastName = 'a';
  @track email = 'a';
  @track shelter = 'a';
  @track adoptionDate = '';

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

  handleAdoptionDateChange(event) {
    this.adoptionDate = event.target.value;
  }

  //loading script
  jsPdfInitialized=false;
  renderedCallback(){
      //console.log(this.contact.data);
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
    doc.setFontSize(20);
    doc.setFont('helvetica')
    doc.text("Adoption", 90, 20,)        
    doc.setFontSize(10)
    doc.setFont('arial black')
    doc.text("Imie zwierzecia:", 20, 40)
    doc.text("Imie i nazwisko:", 20, 50)
    doc.text("Email:", 20, 60)
    doc.text("Schronisko:", 20, 70)
    doc.text("Data adopcji:", 20, 80)
    doc.setFontSize(10)
    doc.setFont('times')
    doc.text(this.animalName, 45, 40)
    doc.text(this.firstName + ' ' + this.lastName, 45, 50)
    doc.text(this.email, 45, 60)
    doc.text(this.shelter, 45, 70)
    doc.text(this.adoptionDate, 45, 80)
    //doc.save("CustomerInvoice.pdf")
    const showToastEvent = new ShowToastEvent({
        title: 'Success',
        message: 'PDF downloaded',
        variant: 'success'
    });
    this.dispatchEvent(showToastEvent);

    const pdfData = doc.output('arraybuffer');
    console.log("pdfData: "+doc.output('arraybuffer'))

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
