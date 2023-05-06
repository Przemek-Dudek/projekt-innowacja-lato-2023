trigger AdoptionStatusTrigger on Adoption__c (after update) {
    
    List<Adoption__c> adds = [Select Contact__c, Status__c, Name from Adoption__c Where Id IN : Trigger.new];
    for(Adoption__c a : adds)
    {
        if(a.Status__c != Trigger.oldMap.get(a.Id).Status__c){
        Contact con = [Select FirstName,LastName,Email from Contact where Id =: a.Contact__c];
        EmailManager.sendMail(con.Email, 'Change of adoption status', 
                    'Good Morning '+con.FirstName+' '+con.LastName+'\nStatus of adoption for your animal '+ a.Name + ' has changed to '+a.Status__c);
        }
    }
    
}