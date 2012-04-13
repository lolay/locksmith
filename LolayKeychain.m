//
//  Copyright 2012 Lolay, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "LolayKeychain.h"
#import <Security/Security.h>

@implementation LolayKeychain

#pragma mark Helper Methods

+ (NSMutableDictionary *)createSearchDictionary:(NSString *)key {    
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];  
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    NSData *encodedIdentifier = [key dataUsingEncoding:NSUTF8StringEncoding];    
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];    
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    NSString *serviceName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];    
    DLog(@"[LolayKeychain createSearchDictionary] dictionary: %@ [%@]", searchDictionary, key);
    
    return searchDictionary;
}

+ (NSData *)searchKeychainCopyMatching:(NSString *)key {    
    NSMutableDictionary *searchDictionary = [LolayKeychain createSearchDictionary:key];
    // Add search attributes
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    // Add search return types
    [searchDictionary setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    CFTypeRef result;
    NSData *data;
    OSStatus error = SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary,&result);
    if (error == noErr) {
        data = CFBridgingRelease(result);
    }
    DLog(@"[LolayKeychain searchKeychainCopyMatching] result: %@ [%@]", data, key);

    return data;
}

#pragma mark --
#pragma mark Contract Methods

+ (BOOL) save:(NSString*)value forKey:(NSString*)key {
    BOOL success = NO;
    NSMutableDictionary *dictionary = [LolayKeychain createSearchDictionary:key];
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:data forKey:(__bridge id)kSecValueData];
    OSStatus addStatus = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);    
    DLog(@"[LolayKeychain save] SecItemAdd result: %i [%@]", (int)addStatus, key);
    if (addStatus == errSecSuccess) {
        success =  YES;        
    } else if (addStatus == errSecDuplicateItem) {
        NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];        
        [updateDictionary setObject:data forKey:(__bridge id)kSecValueData];
        OSStatus updateStatus = SecItemUpdate((__bridge CFDictionaryRef)dictionary,(__bridge CFDictionaryRef)updateDictionary);
        DLog(@"[LolayKeychain save] SecItemUpdate result: %i [%@]", (int)updateStatus, key);
        if (updateStatus == errSecSuccess) {
            success =  YES;
        } else {
            success =  NO;
        }
    } else {
        success = NO;
    }
    
    return success;
}

+ (NSString*) stringForKey:(NSString*)key {
    NSString *returnString = nil;
	if (key != nil) {    
        NSData *data = [LolayKeychain searchKeychainCopyMatching:key];
        if (data) {
            returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }    
    DLog(@"[LolayKeychain stringForKey] result: %@ [%@]", returnString, key);

    return returnString;
}

+ (BOOL) deleteForKey:(NSString*)key {
	if (key == nil) {
		return NO;
	}
    
    NSMutableDictionary *searchDictionary = [LolayKeychain createSearchDictionary:key];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)searchDictionary);
    DLog(@"[LolayKeychain deleteForKey] SecItemDelete result: %i [%@]", (int)status, key);
    if (status == errSecSuccess) {
        return YES;
    } 
        
    return NO;
}

@end