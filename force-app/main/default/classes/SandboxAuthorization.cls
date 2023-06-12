public class SandboxAuthorization {
    public static String getAccessToken() {
        String loginUrl = 'https://login.salesforce.com/services/oauth2/token';

        HttpRequest req = new HttpRequest();
        req.setEndpoint(loginUrl);
        req.setMethod('POST');

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
            //System.debug(EncodingUtil.base64Encode(Blob.valueOf(accessToken)));
            return accessToken;
        } else {
            System.debug('Error during access token retrieval. Status code: ' + res.getStatusCode());
            return null;
        }
    }
    
    
    
    public static String getAnimalIds() {        
        String token = EncodingUtil.base64Encode(Blob.valueOf(SandboxAuthorization.getAccessToken()));
        String endpoint = 'https://craftwarestudents--aimalsint.my.salesforce.com/services/apexrest/MissingAnimals';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + token);
        
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            //System.debug('Siedzi ---->' + response.getBody() + '<----');
            return response.getBody();
        } else {
            String errorMessage = 'Wystąpił błąd: ' + response.getStatusCode();
            return errorMessage;
        }
    }
}