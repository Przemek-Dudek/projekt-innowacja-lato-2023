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
        Long expirationTime = dt.getTime() / 1000 + 3600/3;
        //System.debug(expirationTime);
    
        String claim = '{'+ '"sub":"' + sub + '","aud":"' + aud + '","exp":' + expirationTime + '}';
    
        String encodedHeader = EncodingUtil.base64Encode(Blob.valueOf(header));
        String encodedClaim = EncodingUtil.base64Encode(Blob.valueOf(claim));
    
        String unsignedToken = encodedHeader + '.' + encodedClaim;
    
        Blob privateKeyBlob = EncodingUtil.base64Decode(key);
        Blob signature = Crypto.sign('RSA-SHA256',Blob.valueOf(unsignedToken), privateKeyBlob);   
    
        String encodedSignature = EncodingUtil.base64Encode(signature);
    	encodedSignature = encodedSignature.replaceAll('[+]','-').replaceAll('[/]','_').substring(0,encodedSignature.length()-2);
        String jwt = unsignedToken + '.' + encodedSignature;
		//system.debug('jwt:'+encodedSignature);
        return jwt;
    }    
    
     public static String generateAccessToken() {
        String loginUrl = 'https://api.einstein.ai/v2/oauth2/token';

        HttpRequest req = new HttpRequest();
        req.setEndpoint(loginUrl);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    
        String jwt = generateJWT();
        //String jwt = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJqc3RlbXBuaWFrQGNyYWZ0d2FyZS5iaXoiLCJhdWQiOiJodHRwczovL2FwaS5laW5zdGVpbi5haS92Mi9vYXV0aDIvdG9rZW4iLCJleHAiOjE2ODc3OTk1ODl9.W3w9J6CZm9I1NKwNrKMMgvKF-uDzmHqMjshTk8a7Y00iN6r1OFBclG7RT1WuKo4UYJx4K_OPtd5yaR-0fymNE9CYAQgkpJVHKdzrD7o7yqg_9crdvQj50k-a4FdEb44MVPIK_ZJ3f7A8pe9s-K3LBUTvx8Mo_tgn8cGY4vt2pNjNeWOFBp5oY7X3PQktwp_TabxgCvTgS64LJ5K7DHPcdjdDbBhS-fq8iRS09S1G9b3aiL9KIsj_DTeAgYMoy9WA1kPzN-0bNOf7OTfSrsE622q-TXmOqijDVuIb_1J2fFJ3xfzGwel02c8yj430YzWUDUvonNgV8-50PyeDDdzGBg'; 
        //System.debug('jwt: ' + jwt);
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
            //System.debug('Token: '+(String) responseMap.get('access_token'));
            return (String) responseMap.get('access_token');
        } else {
            System.debug('Wystąpił błąd: ' + res.getStatusCode());
            System.debug('Odpowiedź: ' + res.getBody());
        }
    
        return null;
    }


    @AuraEnabled
    public static String uploadFileToApex(Boolean fromUrl,String base64) {
        String token = generateAccessToken();
        String modelId = 'XQRQJXFGKZYOGSVYDPNNJ5L4SU';


        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.einstein.ai/v2/vision/predict');
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Cache-Control', 'no-cache');
        req.setHeader('Content-Type', 'application/json');

        if(!fromUrl)
			req.setBody('{"modelId":"'+modelId+'","sampleBase64Content":"'+ base64+'"}'); 
        else
            req.setBody('{"modelId":"'+modelId+'","sampleLocation":"'+ base64+'"}');
        
        
        Http http = new Http();
        HttpResponse res = http.send(req);

		
        if (res.getStatusCode() == 200) {
            return res.getBody();
        } else {
            System.debug('Wystąpił błąd: ' + res.getStatusCode());
            System.debug('Odpowiedź: ' + res.getBody());
            return null;
        }
    }


    
    public static String getMostLikelyBreed(String Url)
    {
        
        String json = uploadFileToApex(true,Url);
        if(json == null)
            return null;
        
        String breed;
        Decimal maxProbability = -1;
		Map<String, Object> jsonMap = (Map<String, Object>) System.JSON.deserializeUntyped(json);
		List<Object> probabilities = (List<Object>) jsonMap.get('probabilities');
		for (Object obj : probabilities) {
            System.debug(obj);
    		Map<String, Object> probability = (Map<String, Object>) obj;
   		 	Decimal probabilityValue = (Decimal) probability.get('probability');
    		String label = (String) probability.get('label');
            if(probabilityValue > maxProbability )
            {
                maxProbability = probabilityValue;
                breed = label;
            }
		}
        return breed;
    }

    @AuraEnabled
    public static List<String> readDocument(Boolean isID, String base64)
    {
        String token = generateAccessToken();
        String modelId = 'OCRModel';

        List<Point> points = new List<Point>();
        List<String> response = new List<String>();
        if(isID)
        {
            points.add(new Point(384,130,'Name'));
            points.add(new Point(440,432,'LastName'));
           // points.add(new Point(437,630,'Birthday'));
            points.add(new Point(759,631,'Sex'));
        } 
        else
        {
            
        }


        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.einstein.ai/v2/vision/ocr');
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Cache-Control', 'no-cache');
        req.setHeader('Content-Type', 'application/json');

        
		req.setBody('{"modelId":"'+modelId+'","sampleBase64Content":"'+ base64+'"}'); 
        
        
        
        Http http = new Http();
        HttpResponse res = http.send(req);

		
        if (res.getStatusCode() != 200) {
            System.debug('Wystąpił błąd: ' + res.getStatusCode());
            System.debug('Odpowiedź: ' + res.getBody());
            return null;
        }
        

        System.debug(res.getBody());
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

        Map<String, Object> boundingBox = new Map<String, Object>();

        List<Object> probabilities = (List<Object>) data.get('probabilities');
        for(Point p : points)
        {
            for (Object item : probabilities) {
                Map<String, Object> probability = (Map<String, Object>) item;
    
                boundingBox = (Map<String, Object>) probability.get('boundingBox');

                //System.debug(Decimal.valueOf(String.valueOf(boundingBox.get('minX'))));

                Decimal minX = Decimal.valueOf(String.valueOf(boundingBox.get('minX')));
                Decimal minY = Decimal.valueOf(String.valueOf(boundingBox.get('minY')));
                Decimal maxX = Decimal.valueOf(String.valueOf(boundingBox.get('maxX')));
                Decimal maxY = Decimal.valueOf(String.valueOf(boundingBox.get('maxY')));
                
                if(p.inRectangle(maxY, minY, minX, maxX)) {
                     response.add((String) probability.get('label'));
                 }
                
            }
        }



        System.debug(response);
        
        addPerson(response);

        return response;
    }

    public static void addPerson(List<String> credentials) {
        String gender;
        if(credentials[2] == 'M') {
            gender = 'Male';
        } else {
            gender = 'Female';
        }
        Person person = new Person(Name__c=credentials[0], Surname__c=credentials[1], E_mail__c='asd@wp.pl' ,Sex__c=gender);
        insert person;
    }

    public static void addAdoption(List<String> credentials) {
        String gender;
        if(credentials[2] == 'M') {
            gender = 'Male';
        } else {
            gender = 'Female';
        }
        Person person = new Person(Name__c=credentials[0], Surname__c=credentials[1], E_mail__c='asd@wp.pl' ,Sex__c=gender);
        insert person;
    }


}