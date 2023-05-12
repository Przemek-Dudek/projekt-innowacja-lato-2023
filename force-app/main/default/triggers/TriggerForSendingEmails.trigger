trigger TriggerForSendingEmails on Adoption__c (after update) {
    
     

	List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    
    for(Adoption__c a : [Select Person__r.Name,Person__r.SurName__c,Person__r.E_mail__c, Status__c, Animal__r.Name from Adoption__c Where Id IN : Trigger.new])
    {
        if(a.Status__c != Trigger.oldMap.get(a.Id).Status__c){
       		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        	String[] toAddresses = new String[] {a.Person__r.E_mail__c};
        	mail.setToAddresses(toAddresses);
        	mail.setSubject('Change of adoption status');
        	mail.setPlainTextBody('Good Morning '+a.Person__r.Name+' '+a.Person__r.Surname__c+'\nStatus of adoption for your animal '+ a.Animal__r.Name + ' has changed to '+a.Status__c);
        	mail.setSenderDisplayName('AnimalShelter Support');
  			mails.add(mail);
        }
    }
    Messaging.sendEmail(mails);
    
}