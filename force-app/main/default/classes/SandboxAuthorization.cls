public class SandboxAuthorization {
    public static String authenticate(String endpoint, String token, String username, String password) {

        String authorizationHeader = 'Bearer ' + token;
        String basicAuthHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password));
        

        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Authorization', basicAuthHeader);
        

        Http http = new Http();
        HttpResponse response = http.send(request);
        

        if (response.getStatusCode() == 200) {
            //System.debug('git udalo sie' + response.getBody());
            return response.getBody();
        } else {
            return 'Wystąpił błąd autoryzacji lub dostępu do Sandboxa: ' + response.getStatusCode();
        }
    }
    
    public static String getAnimalIds() {
        String endpoint = 'https://login.salesforce.com';
        String token = 'X6j0DRDGgHPFMoq1dqt4KSKQx';
        String username = 'restuser@innowacja.rest';
        String password = 'restInnowacja123';
        
        String responsestring = SandboxAuthorization.authenticate(endpoint, token, username, password);

        //System.debug('---->' + responsestring + '<----');
        
        endpoint = 'https://craftwarestudents--aimalsint.my.salesforce.com/services/apexrest/MissingAnimals';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + token);
        
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            //System.debug('Siedzi ---->' + response.getBody() + '<----');
            return response.getBody();
            // Przetwarzaj odpowiedź
        } else {
            String errorMessage = 'Wystąpił błąd: ' + response.getStatusCode();
            //System.debug(errorMessage);
            return errorMessage;
            // Obsłuż błąd
        }
    }
}