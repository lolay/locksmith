//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import "LolayKeychain.h"
#import <Security/Security.h>

@implementation LolayKeychain

+ (void) save:(NSString*)value forKey:(NSString*)key {
	if (key == nil || value == nil) {
		return;
	}
	
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	
	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[query setObject:key forKey:(__bridge id)kSecAttrAccount];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0
	[query setObject:(__bridge id)kSecAttrAccessibleAlways forKey:(__bridge id)kSecAttrAccessible];
#endif
	
	OSStatus error = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
	if (error == errSecSuccess) {
		// do update
		NSDictionary *attributesToUpdate = [NSDictionary dictionaryWithObject:[value dataUsingEncoding:NSUTF8StringEncoding] 
																	  forKey:(__bridge id)kSecValueData];
		error = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributesToUpdate);
		if (error != errSecSuccess) {
			NSLog(@"SecItemUpdate failed: %i for %@", (int)error, key);
		}
	} else if (error == errSecItemNotFound) {
		// do add
		[query setObject:[value dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
		error = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
		if (error != errSecSuccess) {
			NSLog(@"SecItemAdd failed: %i for %@", (int)error, key);
		}
	}
}

+ (NSString*) stringForKey:(NSString*)key {
	if (key == nil) {
		return nil;
	}
	
	NSMutableDictionary *query = [NSMutableDictionary dictionary];

	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[query setObject:key forKey:(__bridge id)kSecAttrAccount];
	[query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];

	NSData *dataFromKeychain = nil;
    CFTypeRef result;

	OSStatus error = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (error == noErr) {
        dataFromKeychain = CFBridgingRelease(result);
    }
	
	NSString *stringToReturn = nil;
	if (error == errSecSuccess) {
		stringToReturn = [[NSString alloc] initWithData:dataFromKeychain encoding:NSUTF8StringEncoding];
	}
	
	return stringToReturn;
}

+ (void) deleteForKey:(NSString*)key {
	if (key == nil) {
		return;
	}
	
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	
	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[query setObject:key forKey:(__bridge id)kSecAttrAccount];
		
	OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
	if (status != errSecSuccess) {
		NSLog(@"SecItemDelete failed: %@", key);
	}
}

@end