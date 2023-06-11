trigger TriggerForSendingEmails on Adoption__c (after update) {
	AdoptionTriggerHandler.TriggerForSendingEmails(Trigger.new, Trigger.oldMap);
}