public with sharing class AdoptionTriggerHandler {
    public static void TriggerForSendingEmails(List<Adoption__c> newAdoptions, Map<Id, Adoption__c> oldAdoptions) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    
        for(Adoption__c a : [Select Person__r.Name,Person__r.SurName__c,Person__r.E_mail__c, Status__c, Animal__r.Name from Adoption__c Where Id IN : newAdoptions])
        {
            if(a.Status__c != oldAdoptions.get(a.Id).Status__c){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {a.Person__r.E_mail__c};
                mail.setToAddresses(toAddresses);
                mail.setSubject('Change of adoption status');
                mail.setPlainTextBody('Good Morning '+a.Person__r.Name+' '+a.Person__r.Surname__c+'\nStatus of adoption for your animal '+ a.Animal__r.Name + ' has changed to '+a.Status__c);
                mail.setSenderDisplayName('AnimalShelter Support');
                mails.add(mail);
            }
        }
        Messaging.sendEmail(mails);
    }

    public static void UpdateNumberOfAdoptions(List<Adoption__c> newAdoptions, Map<Id, Adoption__c> oldAdoptions) {
        List<Shelter__c> shelters = new List<Shelter__c>();
    
        for (Adoption__c a : [SELECT Status__c, Animal__r.Shelter__r.Number_Of_Adoptions__c FROM Adoption__c WHERE Id IN :newAdoptions]) {
            if (a.Status__c != oldAdoptions.get(a.Id).Status__c && a.Status__c == 'Approved') {
                
                    if(a.Animal__r.Shelter__r != null)
                    {
                        a.Animal__r.Shelter__r.Number_Of_Adoptions__c +=1;
                        shelters.add(a.Animal__r.Shelter__r);
                    }
            }
        }
        update shelters;
    }

    public static void TriggerToGivingFreeFood(List<Adoption__c> newAdoptions) {
        List<Person__c> people = new List<Person__c>();    
        for(Adoption__c adp : [SELECT RecordType.Name, Person__r.Points__c From Adoption__c where Id IN : newAdoptions])
        {
            if(adp.RecordTypeId != null)
            {
                
                if(adp.RecordType.Name == 'Real'){
                    adp.Person__r.Points__c +=20;
                }
                else if(adp.RecordType.Name == 'Virtual'){
                    adp.Person__r.Points__c +=10;
                }
                
                if(adp.Person__r.Points__c >=30)
                {
                    adp.Person__r.Points__c -=30;
                    System.debug('Karma została przyznana');
                }
                
                if(!people.contains(adp.Person__r)){
                    people.add(adp.Person__r);
                }
            }
        }
        update people;
    }

    public static void UpdateNumberOfAvailableAdoptions(List<Adoption__c> newAdoptions, Map<Id, Adoption__c> oldAdoptions, Integer option) {
        List<Adoption__c> adoptions;
    
        if(option == 1) {
            adoptions = new List<Adoption__c>([SELECT Status__c, Animal__r.Shelter__c, Amount__c, RecordType.DeveloperName 
                FROM Adoption__c 
                WHERE Id IN: oldAdoptions.keySet()]);
        } else {
            adoptions = new List<Adoption__c>([SELECT Status__c, Animal__r.Shelter__c, Amount__c, RecordType.DeveloperName 
                FROM Adoption__c 
                WHERE Id IN: newAdoptions.keySet()]);
        }
        
        Set<Id> SheltersId = new Set<Id>();
        
        for(Adoption__c a: adoptions) {
            SheltersId.add(a.Animal__r.Shelter__c);
        }
        
        Map<ID, Shelter__c> loadedShelters = new Map<ID, Shelter__c>([SELECT Id, Number_Of_Unadopted_Animals__c FROM Shelter__c WHERE Id IN: SheltersId]);
        
        List<Shelter__c> updatedShelters = new List<Shelter__c>();
        
        for (Adoption__c a : adoptions) {
             if(a.Status__c == 'In progress' && a.RecordType.DeveloperName == 'Virtual' && option != 1) {
                 if(loadedShelters.containsKey(a.Animal__r.Shelter__c)) {
                      Shelter__c s = loadedShelters.get(a.Animal__r.Shelter__c);
                      s.Number_Of_Unadopted_Animals__c +=1;
                      updatedShelters.add(s);
                 }
             }
             
             if(a.Status__c == 'Approved' && a.RecordType.DeveloperName == 'Virtual' && option == 2) {
                 if(loadedShelters.containsKey(a.Animal__r.Shelter__c)) {
                      Shelter__c s = loadedShelters.get(a.Animal__r.Shelter__c);
                      s.Number_Of_Unadopted_Animals__c -=1;
                      updatedShelters.add(s);
                 }
             }
             
             if(a.Status__c == 'In progress' && a.RecordType.DeveloperName == 'Virtual' && option == 1) {
                 if(loadedShelters.containsKey(a.Animal__r.Shelter__c)) {
                      Shelter__c s = loadedShelters.get(a.Animal__r.Shelter__c);
                      s.Number_Of_Unadopted_Animals__c -=1;
                      updatedShelters.add(s);
                 }
             }
        }
        update updatedShelters;
    }



}