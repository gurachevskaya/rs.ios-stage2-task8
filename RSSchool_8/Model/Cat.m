//
//  Cat.m
//  RSSchool_8
//
//  Created by Karina on 7/25/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "Cat.h"

@implementation Cat

- (id) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        
        _catId = [responseObject objectForKey:@"id"];
        
//        _imageURL = [responseObject objectForKey:@"url"];
        
        NSString* urlString = [responseObject objectForKey:@"url"];
        
        if (urlString) {
            _imageURL = [NSURL URLWithString:urlString];
        }
      
    }
    return self;
}
@end
