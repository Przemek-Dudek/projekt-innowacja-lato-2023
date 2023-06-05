trigger UpdateNumberOfAdoptions on Adoption__c (after update, after insert, after delete) {
    
    List<Adoption__c> adoptions = new List<Adoption__c>([SELECT Status__c, Animal__r.Shelter__c, Amount__c, RecordType.DeveloperName FROM Adoption__c WHERE Id IN :Trigger.new]);
    Set<Id> SheltersId = new Set<Id>();
    
    for(Adoption__c a: adoptions) {
        SheltersId.add(a.Animal__r.Shelter__c);
    }
    
    System.debug(SheltersId);
    
    List<Shelter__c> existingShelters = new List<Shelter__c>();
    
    for(Id id: SheltersId) {
        existingShelters.add([SELECT Id, Number_Of_Unadopted_Animals__c FROM Shelter__c WHERE Id =: id]);
    }
    
    System.debug(existingShelters);
    
    for (Adoption__c a : adoptions) {
         if(a.Status__c == 'In progress' && a.RecordType.DeveloperName == 'Virtual') {
             for(Shelter__c s: existingShelters) {
                 if(s.Id == a.Animal__r.Shelter__c) {
                     s.Number_Of_Unadopted_Animals__c +=1;
                 }
             }
         }
         
         if(a.Status__c == 'Approved' && a.RecordType.DeveloperName == 'Virtual' && trigger.isupdate) {
             for(Shelter__c s: existingShelters) {
                 if(s.Id == a.Animal__r.Shelter__c) {
                     s.Number_Of_Unadopted_Animals__c -=1;
                 }
             }
         }
         
         if(a.Status__c == 'In progress' && a.RecordType.DeveloperName == 'Virtual' && trigger.isdelete) {
             for(Shelter__c s: existingShelters) {
                 if(s.Id == a.Animal__r.Shelter__c) {
                     s.Number_Of_Unadopted_Animals__c -=1;
                 }
             }
         }
    }
    update existingShelters;
}