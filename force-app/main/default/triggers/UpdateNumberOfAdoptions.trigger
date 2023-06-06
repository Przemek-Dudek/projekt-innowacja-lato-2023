trigger UpdateNumberOfAdoptions on Adoption__c (after update) {
    
    
    List<Shelter__c> shelters = new List<Shelter__c>();
    
     for (Adoption__c a : [SELECT Status__c, Animal__r.Shelter__r.Number_Of_Adoptions__c FROM Adoption__c WHERE Id IN :Trigger.new]) {
        if (a.Status__c != Trigger.oldMap.get(a.Id).Status__c && a.Status__c == 'Approved') {
            
                if(a.Animal__r.Shelter__r != null)
                {
                    a.Animal__r.Shelter__r.Number_Of_Adoptions__c +=1;
                    shelters.add(a.Animal__r.Shelter__r);
                }
        }
    }
    update shelters;

}