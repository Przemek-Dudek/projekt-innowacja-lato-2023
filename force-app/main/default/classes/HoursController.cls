public with sharing class HoursController {
    @AuraEnabled(Cacheable=true)
    public static String showHours(String shelterID) {
        List<Shelter__c> shelter = [select Time_Opened__c from Shelter__c where Id =: shelterID];
        if(shelter == null) {
            return null;
        }
        Shelter__c record = shelter[0];
        if(record.Time_Opened__c == null)
            return null;
        return record.Time_Opened__c;
    }
}