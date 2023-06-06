trigger UpdateNumberOfAdoptions on Adoption__c (after update) {
    AdoptionTriggerHandler.UpdateNumberOfAdoptions(Trigger.new, Trigger.oldMap);
}