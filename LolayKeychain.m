//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import "LolayKeychain.h"
#import <Security/Security.h>

@implementation LolayKeychain

#pragma mark Helper Methods

+ (NSMutableDictionary *)createSearchDictionary:(NSString *)key {    
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];  
    [searchDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    NSData *encodedIdentifier = [key dataUsingEncoding:NSUTF8StringEncoding];    
    [searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrGeneric];    
    [searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrAccount];
    NSString *serviceName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    [searchDictionary setObject:serviceName forKey:(id)kSecAttrService];    
    NSLog(@"[LolayKeychain createSearchDictionary] dictionary: %@ [%@]", searchDictionary, key);
    
    return [searchDictionary autorelease]; 
}

+ (NSData *)searchKeychainCopyMatching:(NSString *)key {    
    NSMutableDictionary *searchDictionary = [[LolayKeychain createSearchDictionary:key] retain];
    // Add search attributes
    [searchDictionary setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    // Add search return types
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    NSData *result = nil;
    SecItemCopyMatching((CFDictionaryRef)searchDictionary,(CFTypeRef *)&result);
    [searchDictionary release];    
    NSLog(@"[LolayKeychain searchKeychainCopyMatching] result: %@ [%@]", result, key);

    return result;
}

#pragma mark --
#pragma mark Contract Methods

+ (BOOL) save:(NSString*)value forKey:(NSString*)key {
    BOOL success = NO;
    NSMutableDictionary *dictionary = [[LolayKeychain createSearchDictionary:key] retain];
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:data forKey:(id)kSecValueData];
    OSStatus addStatus = SecItemAdd((CFDictionaryRef)dictionary, NULL);    
    NSLog(@"[LolayKeychain save] SecItemAdd result: %i [%@]", (int)addStatus, key);
    if (addStatus == errSecSuccess) {
        success =  YES;        
    } else if (addStatus == errSecDuplicateItem) {
        NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];        
        [updateDictionary setObject:data forKey:(id)kSecValueData];
        OSStatus updateStatus = SecItemUpdate((CFDictionaryRef)dictionary,(CFDictionaryRef)updateDictionary);
        NSLog(@"[LolayKeychain save] SecItemUpdate result: %i [%@]", (int)updateStatus, key);
        if (updateStatus == errSecSuccess) {
            success =  YES;
        } else {
            success =  NO;
        }
        [updateDictionary release];
    } else {
        success = NO;
    }
    
    [dictionary release];
    
    return success;
}

+ (NSString*) stringForKey:(NSString*)key {
    NSString *returnString = nil;
	if (key != nil) {    
        NSData *data = [[LolayKeychain searchKeychainCopyMatching:key] retain];    
        if (data) {
            returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [data release];
        }
    }    
    NSLog(@"[LolayKeychain stringForKey] result: %@ [%@]", returnString, key);

    return [returnString autorelease];
}

+ (BOOL) deleteForKey:(NSString*)key {
	if (key == nil) {
		return NO;
	}
    
    NSMutableDictionary *searchDictionary = [[LolayKeychain createSearchDictionary:key] retain];    
    OSStatus status = SecItemDelete((CFDictionaryRef)searchDictionary);
    NSLog(@"[LolayKeychain deleteForKey] SecItemDelete result: %i [%@]", (int)status, key);
    [searchDictionary release];    
    if (status == errSecSuccess) {
        return YES;
    } 
        
    return NO;
}

@end