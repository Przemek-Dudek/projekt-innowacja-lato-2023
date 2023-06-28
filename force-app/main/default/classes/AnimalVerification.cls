public with sharing class AnimalVerification implements Schedulable{

    private static String CRON_EXPRESSION = '0 0 9 * * ?';
    
    public static void scheduleMe(){
        AnimalVerification  schedule = new AnimalVerification();
        System.schedule('Animal Verification Job',CRON_EXPRESSION,schedule);
    }

    public void execute(SchedulableContext sc){

        
        List<Animal__c> animals = new List<Animal__c>();
        Map<String, String> animalPhotos = SandboxAuthorization.getAllAnimalPhotos(1);
       


        for (String animalName : animalPhotos.keySet()) {
            Animal__c animal = SandboxAuthorization.getAnimalsObjects(animalName)[0];
            if(animal.Breed__c == 'Dog')
            {
                animal.Breed__c = EinsteinTokenGenerator.getMostLikelyBreed(animalPhotos.get(animalName));
                animals.add(animal);
            }
        }

    insert animals;
    }
}