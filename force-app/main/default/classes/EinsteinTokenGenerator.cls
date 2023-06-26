public class EinsteinTokenGenerator {
    private static String key = 'MIIEpQIBAAKCAQEAvtuag52ate7f51NR+wwM5ue5vwCE6qTaMf0mNMoL9w9USnWH' +
                                        'dCYoQM6l1XYPpIhklk7C9fWfW5R3xS2AtS1xDqe6MKLUQsUrwu3ihFIS9ZIkR72L'+
                                        'I7sMtlG6JkcX1DCnbIn1ybaB2EsC6//j6mluMLM11lbMUOum7z/yJnlRBD13eQS5'+
                                        'vBx0gFXXmesufTqRdoiIUuyxP1UFutXHMtd3bNx+46zKiH+LJmBUvF9JAAXXwe1V'+
                                        'GwYutnucv7rUtbVoDPIzTJtFSfNrrcfzswCkysKsWS41UBXLYM5B0PGDvpgikV97'+
                                        'EiNGInqfnC2bps2X2IVVLEWX5VQqGYO9ZyVBHQIDAQABAoIBAQCwbAa0SudL7XeD'+
                                        'OX26djUm7GTCrhQvYhtfwgWjHnFY+w6LlYCUWQE0htC8NNnY2UtBtaR5/4ZC/UaJ'+
                                        'ObqTv2GWjmyJsLpMzj3ZflO4xLVJ0sE+n3MSoEDr9zf/UhAw0JiyuAQ/ZTk5Wn1k'+
                                        '8bEYakS1N7M4YhuTYYF5/r4z2kiNhTrOUUwXFUKiTMEJzxTLQiSGuXTKa0INGJUl'+
                                        'Qytq5lM8rbYWwKkLYFuU1TJx1DVrAUh40lmjXeKqYxa466E5uos7iQAQMHvZc2bC'+
                                        'DpHRt19NikEwq7vUtLN43nIdfdCOpcMez7X4TxM22z3YeDt7wKNK46YhorVVH+ag'+
                                        'fP3nraZxAoGBAOirHWUbkEMSxPq/zKRaeE3yu0JK5Zs1jJlpyuojQBdQefd1BNjR'+
                                        '7gDhhqhqJ7yuGUMxZkWRd6OtNkiJ8SGWaTb7tJdWc+BYHQDaUWPHgObrj5yfaPQW'+
                                        'OVezBACjzwM8n0mOTWbyJxqien0ib1o7SV2XDYsuCrGbzYWvkR2TyCF/AoGBANH/'+
                                        'KMlpA8JxZ861xtnxcImO7scjmMGn1ZB7VUTSQkZ9Xy/5CA6Zxr012pJyRXIfjtHy'+
                                        'xjwWS6GifdT2Vwkndn8Z1+u9bJicG3uwd77147QMFoRlhU6/LMrXpr7APoTZkmgL'+
                                        'hvYfHlmwP70bnfQfFFT7Vzqhi8CTpD2slQD/7DNjAoGBAM7Q49UvFiH4+i1l9jMV'+
                                        '1CB9piS8TLKVfAAWgO91HBBdUb08QG221Zfk4Hytt9rI6t3GeIFYV/+fBUSfkT7o'+
                                        '42ejgBiSGXiO+mD6ryRBf3xEYai4LmPhqWEiWGl1MptO9Mw+eOEMWOQdD0JSLKcJ'+
                                        'UiKmFbzk1U6hDqRJtnWTGm9jAoGAQwuwPf3lUWNbvUeUIWlQgNq9qZ7X2px3NxXp'+
                                        'd3uZ5V+J0Is141N9fFOBYVhSi8k/lBBq8iw8IXL7sc6koyuSTao2ofFshpzwuWDy'+
                                        'GmnvNUDWv5aaJTYsWubXOfeu/kNo1wc3I8VzrzbyYrI6kAKMP0Wv5+xD7kw1F+vN'+
                                        '9u++vfkCgYEAozP0nZBrRcx7dEfNDUmFCx/IfuZFlgKtZ2zjpaDsErqsO0uXVYDB'+
                                        '7vj+CFqfgRNqkXStvUQpMyPAZjfrNGO9Lu/H9PMH2CkF011U7aAM2ZTi5foxUNfD'+
                                        'EzTNLN0Z2yQZTeSrTZu4lnUpal+i6yAl4jIBKNVYF0smEeUgYJ/P8Dw=';
    private static final String sub = 'jstempniak@craftware.biz';
    private static final String aud = 'https://api.einstein.ai/v2/oauth2/token';
    private static final String iss = 'developer.force.com';
    
    public static String generateJWT() {      
        String header = '{"alg":"RS256","typ":"JWT"}';
        DateTime dt = System.Now();
        Long expirationTime = dt.getTime() / 1000 + 3000;
    
        String claim = '{"iss":"' + iss + '",""sub":"' + sub + '","aud":"' + aud + '","exp":' + expirationTime + '}';
    
        String encodedHeader = EncodingUtil.base64Encode(Blob.valueOf(header));
        String encodedClaim = EncodingUtil.base64Encode(Blob.valueOf(claim));
    
        String unsignedToken = encodedHeader + '.' + encodedClaim;
    
        Blob privateKeyBlob = EncodingUtil.base64Decode(key);
        Blob signature = Crypto.sign('RSA-SHA256',Blob.valueOf(unsignedToken), privateKeyBlob);   
    
        String encodedSignature = EncodingUtil.base64Encode(signature);
    
        String jwt = unsignedToken + '.' + encodedSignature;
    
        return jwt;
    }    
    
     public static String generateAccessToken() {
        String loginUrl = 'https://api.einstein.ai/v2/oauth2/token';

        HttpRequest req = new HttpRequest();
        req.setEndpoint(loginUrl);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    
        String jwt = generateJWT();
        //String jwt = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.NHVaYe26MbtOYhSKkoKYdFVomg4i8ZJd8_-RU8VNbftc4TSMb4bXP3l3YlNWACwyXPGffz5aXHc6lty1Y2t4SWRqGteragsVdZufDn5BlnJl9pdR_kdVFUsra2rWKEofkZeIC4yWytE58sMIihvo9H1ScmmVwBcQP6XETqYd0aSHp1gOa9RdUPDvoXQ5oqygTqVtxaDr6wUFKrKItgBMzWIdNZ6y7O9E0DhEPTbE9rfBo6KTFsHAZnMg4k68CDp2woYIaXbmYTWcvbzIuHO7_37GT79XdIwkm95QJ7hYC9RiwrV7mesbY4PAahERJawntho0my942XheVLmGwLMBkQ';
        //
        System.debug('jwt: ' + jwt);
        String requestBody = 'grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=' + jwt;
    
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
            return (String) responseMap.get('access_token');
        } else {
            System.debug('Wystąpił błąd: ' + res.getStatusCode());
            System.debug('Odpowiedź: ' + res.getBody());
        }
    
        return null;
    }
    
}