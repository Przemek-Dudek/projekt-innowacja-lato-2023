public with sharing class mapOfSheltersController {
    @AuraEnabled(Cacheable = true)
    public static List<Shelter__c> getShelters() {
        return [Select Name,Country__c,City__c,PostalCode__c,Street__c From Shelter__c];
    } 
    
}