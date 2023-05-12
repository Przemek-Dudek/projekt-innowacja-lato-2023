trigger TriggerToGivingFreeFood on Adoption__c (after insert) {

    List<Person__c> people = new List<Person__c>();
    Map<Id, RecordType> recordTypes = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SObjectType = 'Adoption__c']);
    
    for(Adoption__c adp : [SELECT RecordType.Name, Person__r.Points__c From Adoption__c where Id IN : Trigger.new])
    {
        if(adp.RecordTypeId != null)
        {
         	RecordType rt = recordTypes.get(adp.RecordTypeId);
			
            if(rt.Name == 'Real'){
                adp.Person__r.Points__c +=20;
            }
            else if(rt.Name == 'Virtual'){
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