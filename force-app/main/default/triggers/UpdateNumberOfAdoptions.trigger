trigger UpdateNumberOfAdoptions on Adoption__c (after update) {
    
    
    Shelter__c sh = null;
    List<Shelter__c> shelters = new List<Shelter__c>();
    Map<ID, Shelter__c> existingShelters = new Map<ID, Shelter__c>([SELECT Id, Number_Of_Adoptions__c FROM Shelter__c]);
    System.debug(existingShelters);
    
    
     for (Adoption__c a : [SELECT Status__c, Animal__r.Shelter__c FROM Adoption__c WHERE Id IN :Trigger.new]) {
        if (a.Status__c != Trigger.oldMap.get(a.Id).Status__c && a.Status__c == 'Approved') {
            
                if(existingShelters.containsKey(a.Animal__r.Shelter__c))
                {
                    sh = existingShelters.get(a.Animal__r.Shelter__c);
                    sh.Number_Of_Adoptions__c +=1;
                    shelters.add(sh);
                    break;
                }
            
        }
    }
    update shelters;

}