import { LightningElement, api, wire } from 'lwc';
import getAllAnimalPhotos from '@salesforce/apex/SandboxAuthorization.getAllAnimalPhotos';

export default class GetDayDelta extends LightningElement {
  amount = 1;
  mapaData = new Map();
  mappedData = [];

  handleAmountChange(e) {
    this.amount = e.detail.value;
  }

  @wire(getAllAnimalPhotos, { day: '$amount' })
  wiredAnimals({ error, data }) {
    if (data) {
      const parsedData = JSON.parse(JSON.stringify(data));
      this.mapaData = new Map(Object.entries(parsedData));
      this.mappedData = Array.from(this.mapaData, ([key, value]) => ({ key, value: value.slice(1,-1) }));
    } else if (error) {
      console.log(error);
    }
  }
}