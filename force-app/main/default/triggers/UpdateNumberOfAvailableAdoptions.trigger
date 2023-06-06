trigger UpdateNumberOfAvailableAdoptions on Adoption__c (after update, after insert, before delete) {
    AdoptionTriggerHandler.UpdateNumberOfAvailableAdoptions(Trigger.new, Trigger.oldMap);
}