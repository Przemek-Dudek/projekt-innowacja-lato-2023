trigger UpdateNumberOfAvailableAdoptions on Adoption__c (after update, after insert, before delete) {
    Integer option = 0;
    if(trigger.isDelete) {
        option = 1;
    } else if(trigger.isUpdate) {
        option = 2;
        AdoptionTriggerHandler.UpdateNumberOfAdoptions(Trigger.new, Trigger.oldMap);
        AdoptionTriggerHandler.TriggerForSendingEmails(Trigger.new, Trigger.oldMap);
    } else {
        AdoptionTriggerHandler.TriggerToGivingFreeFood(Trigger.new);
        option = 3;
    }
    
    AdoptionTriggerHandler.UpdateNumberOfAvailableAdoptions(Trigger.new, Trigger.oldMap, option);
}