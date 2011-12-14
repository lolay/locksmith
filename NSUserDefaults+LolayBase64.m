//
//  NSUserDefaults+LolayBase64.m
//  MyLifePhone
//
//  Created by Feng Wu on 12/13/11.
//  Copyright (c) 2011 Lolay Inc. All rights reserved.
//

#import "NSUserDefaults+LolayBase64.h"
#import "NSData+LolayBase64.h"
#import "NSString+LolayBase64.h"

@implementation NSUserDefaults (LolayBase64)
- (void) setCodableObject:(id<NSCoding>) value forKey:(NSString*) defaultName {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    NSString *string = [NSData base64StringWithData:data];
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:defaultName];
}

- (id<NSCoding>) codableObjectForKey:(NSString *) defaultName {
    
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
    NSData *data = [NSString base64DataWithString:string];
    id<NSCoding> obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return obj;
}

@end
