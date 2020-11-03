//
//  ServerManager.m
//  RSSchool_8
//
//  Created by Karina on 7/25/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "ServerManager.h"

@interface ServerManager ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation ServerManager


+ (ServerManager*) sharedManager {
    
    static ServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (NSURLSession *)session {
    
    if (!_session ) {
        NSURLSessionConfiguration *configutation = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSString *apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"API key"];
        if (apiKey != nil) {
            configutation.HTTPAdditionalHeaders = @{
                @"x-api-key": apiKey
            };
        }
        _session = [NSURLSession sessionWithConfiguration:configutation];
    } else {
        NSString *oldKey = [_session.configuration.HTTPAdditionalHeaders objectForKey:@"x-api-key"];
        NSString *apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"API key"];
        if (![oldKey isEqualToString:apiKey]) {
            NSURLSessionConfiguration *configutation = [NSURLSessionConfiguration defaultSessionConfiguration];
            configutation.HTTPAdditionalHeaders = @{
                @"x-api-key": apiKey};
            _session = [NSURLSession sessionWithConfiguration:configutation];
        }
    }
    return _session;
}


- (NSMutableURLRequest *)requestWithUrl:(NSString *)stringUrl arguments:(NSDictionary *)arguments {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:stringUrl];
    
    if (arguments) {
        NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray new];
        for(NSString *key in arguments.allKeys) {
            [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:arguments[key]]];
        }
        urlComponents.queryItems = [queryItems copy];
    }
    
    NSURL *url = urlComponents.URL;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    [request setHTTPMethod:@"GET"];
    return request;
//    [request setValue:@"4322d88c-f61c-431a-9880-2888a7f9d090" forHTTPHeaderField:@"x-api-key"];
}

- (void)performGetDataTaskWithRequest:request completion:(void(^)(NSDictionary *, NSError *))completion {
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSError *parsingError;
        NSDictionary *dictionary = [self parseJSONDAta:data error:&parsingError];
        
        if (parsingError) {
            completion(nil, parsingError);
            return;
        }
        
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            
            NSNumber *message = [dictionary objectForKey:@"message"];
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:message forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"wrongApiKey" code:200 userInfo:details];
            completion(nil, error);
            return;
        }
             
        completion(dictionary, nil);
    }];
    [dataTask resume];
}

- (void)performHeadDataTaskWithRequest:request completion:(void(^)(NSInteger, NSError *))completion {
    
    [request setHTTPMethod:@"HEAD"];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(0, error);
            return;
        }
        
        NSHTTPURLResponse *reponse2 = (NSHTTPURLResponse *)response;
        NSDictionary *headers = [reponse2 allHeaderFields];
        NSLog(@"%@", headers);
        NSInteger limit = [headers[@"pagination-count"] integerValue];
//        NSString *limit = (NSString *)headers[@"pagination-count"];
             
        completion(limit, nil);
    }];
    [dataTask resume];
}

- (void)performNetworkEventRequestCallWithFileUpload:(UIImage*)image name:(NSString *)name forUrl:(NSString *)stringUrl completion:(void (^)(NSDictionary*, NSError *))completion {
    
    NSData *dataImage = UIImageJPEGRepresentation(image, 1.0f);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:stringUrl]];
    [request setHTTPMethod:@"POST"];
//    [request setValue:@"4322d88c-f61c-431a-9880-2888a7f9d090" forHTTPHeaderField:@"x-api-key"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    
    if (dataImage) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:dataImage];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSError *parsingError;
        NSDictionary *dictionary = [self parseJSONDAta:data error:&parsingError];
        
        if (parsingError) {
            completion(nil, parsingError);
            return;
        }
        completion(dictionary, nil);
    }];
    [dataTask resume];
}


#pragma mark - Private methods

- (NSDictionary *)parseJSONDAta:(NSData *)data error:(NSError **)error {
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
}


@end
