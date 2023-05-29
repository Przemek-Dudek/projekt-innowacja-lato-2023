public with sharing class HoursController {
    @AuraEnabled(Cacheable=true)
    public static List<String> showHours(String shelterID) {
        List<Shelter__c> shelter = [select Time_Opened__c, Time_Opened_in_Weekend__c from Shelter__c where Id =: shelterID];
        if(shelter.isEmpty()) {
            return null;
        }
        Shelter__c record = shelter[0];
        List<String> hours = new List<String>();
        hours.add(record.Time_Opened__c);
        hours.add(record.Time_Opened_in_Weekend__c);
        return hours;
    }
}