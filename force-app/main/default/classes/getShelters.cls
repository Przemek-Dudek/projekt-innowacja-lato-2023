public with sharing class getShelters {
    @AuraEnabled(Cacheable = true)
    public static List<String> getShelterRecords() {
        List<String> records =  new List<String>();

        for(Shelter__c sh : [SELECT Name FROM Shelter__c LIMIT 100] ){
            records.add(sh.Name);
        }
        return records;
    }
}