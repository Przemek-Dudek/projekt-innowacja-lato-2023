public with sharing class NumberOfAdoptionsController {
    @AuraEnabled(Cacheable = true)
    public static Integer get(Id objectID) {
        
        for(Shelter__c s : [Select Number_Of_Adoptions__c From Shelter__c Where Id  =: objectID])
        {
            return Integer.valueOf(s.Number_Of_Adoptions__c);
        }
        return 0;
    }
		
    }