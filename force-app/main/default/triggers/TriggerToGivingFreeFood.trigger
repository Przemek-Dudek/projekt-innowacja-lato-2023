trigger TriggerToGivingFreeFood on Adoption__c (after insert) {
    AdoptionTriggerHandler.TriggerToGivingFreeFood(Trigger.new, Trigger.oldMap);
}