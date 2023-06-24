public with sharing class SandboxAuthorization {
    
    private static String token='';
    public static String getAccessToken() {
        String loginUrl = 'https://login.salesforce.com/services/oauth2/token';

        HttpRequest req = new HttpRequest();
        req.setEndpoint(loginUrl);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');

        String requestBody = 'grant_type=password&'
            + 'client_id=3MVG9QV5z8XnLDvwzWOhGIwhTEmMWXYtxhVrgQ9jAvVUMqXUBi2Hai0bojZp3n.4Yz2qpjn.fOB9l2YRJCdzc&'
            + 'client_secret=F593FA5F308584CD77A842CEEC53846F9F6DF6CCD7192B6B91C69873CE977EF2&'
            + 'username=restuser@innowacja.rest&'
            + 'password=restInnowacja123X6j0DRDGgHPFMoq1dqt4KSKQx';

        req.setBody(requestBody);

        HttpResponse res = new HttpResponse();
        Http http = new Http();

        
        try {
            res = http.send(req);
        } catch (System.CalloutException e) {
            System.debug('Callout error: ' + e.getMessage());
        }
        
        if (res.getStatusCode() == 200) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String accessToken = (String) responseMap.get('access_token');
            return accessToken;
        } else {
            System.debug('Error during access token retrieval. Status code: ' + res.getStatusCode());
            return null;
        }
    }
    
    public static List<String> getAnimalIds(integer day) {        
        token = SandboxAuthorization.getAccessToken();
        String endpoint;

        if(day == 0)
            endpoint = 'https://cw-inn.my.salesforce.com/services/apexrest/MissingAnimals?groupId=G1';
        else
            endpoint = 'https://cw-inn.my.salesforce.com/services/apexrest/MissingAnimals?dayDelta=' + String.valueOf(day) + '&groupId=G1';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + token);
        
        HttpResponse response = http.send(request);
        
        List<String> idList = new List<String>();
        if (response.getStatusCode() == 200) {
            String idText = response.getBody();
            idText = idText.substring(2,idText.length()-2);
            String cleanText = idText.replaceAll('[\\\\"]', '');
            
            idList = cleanText.split(',');
        } else {
            String errorMessage = 'Wystąpił błąd: ' + response.getStatusCode();
            idList.add(errorMessage);
        }
        return idList;
    }
    
    
    public static String getAnimalPhotoURL(String animalId) {
        String endpoint = 'https://cw-inn.my.salesforce.com/services/apexrest/MissingAnimals/' + animalId;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + token);
        
        HttpResponse response = http.send(request);     
        if (response.getStatusCode() == 200) {
        	return response.getBody();
        } else {
		    System.debug('Error during access token retrieval. Status code: ' + response.getStatusCode());
            return null;

        }
    }
    
    @AuraEnabled(Cacheable = true)
    public static Map<String, String> getAllAnimalPhotos(integer day) {
        Map<String, String> photosMap = new Map<String, String>();
        for(String singleId : SandboxAuthorization.getAnimalIds(day)) {
            String photoURL = getAnimalPhotoURL(singleId);
            if(photoURL != null)
                photosMap.put(singleId, photoURL);
        }
		
        return photosMap;
    }


    public static String getAllAnimals() {        
        token = SandboxAuthorization.getAccessToken();
        //String endpoint = 'https://cw-inn.my.salesforce.com/services/data/v56.0/sobjects/animal__c';

        String endpoint = 'https://cw-inn.my.salesforce.com/services/data/v56.0/query/?q=SELECT+name,Breed__c,PhotoUrl__c+from+Animal__c';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + token);
        
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            return response.getBody();
        }
        String errorMessage = 'Wystąpił błąd: ' + response.getStatusCode();
        return null;
    }

    @AuraEnabled(Cacheable = true)
    public static List<Animal__c> getAnimalsObjects() {
        String jsonAnimals = getAllAnimals();
        if(jsonAnimals == null) {
            return null;
        }
        List<Animal__c> animals = new List<Animal__c>();
        Map<String, Object> mapJSON = (Map<String, Object>) JSON.deserializeUntyped(jsonAnimals);

        Integer totalSize = (Integer) mapJSON.get('totalSize');
        Boolean done = (Boolean) mapJSON.get('done');
        List<Object> records = (List<Object>) mapJSON.get('records');
        
        for (Object record : records) {
            Map<String, Object> recordMap = (Map<String, Object>) record;
            Map<String, Object> attributesMap = (Map<String, Object>) recordMap.get('attributes');

            String type = (String) attributesMap.get('type');
            String url = (String) attributesMap.get('url');
            String name = (String) recordMap.get('Name');
            String photo = (String) recordMap.get('PhotoUrl__c');
            String breed = (String) recordMap.get('Breed__c');
            animals.add(new Animal__c(Name = name, Breed__c=breed, Photo__c=photo, Shelter__c='a065r000003ct50AAA'));
        }
		
        return animals;
    }

}