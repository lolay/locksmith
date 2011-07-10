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
	
	NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithCapacity:3];
	[query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    NSData *encodedKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    [query setObject:encodedKey forKey:(id)kSecAttrGeneric];
	[query setObject:encodedKey forKey:(id)kSecAttrAccount];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0
	[query setObject:(id)kSecAttrAccessibleAlways forKey:(id)kSecAttrAccessible];
#endif
	
	OSStatus error = SecItemCopyMatching((CFDictionaryRef)query, NULL);
	if (error == errSecSuccess) {
		// do update
		NSDictionary *attributesToUpdate = [NSDictionary dictionaryWithObject:encodedKey 
																	  forKey:(id)kSecValueData];
		error = SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)attributesToUpdate);
		if (error != errSecSuccess) {
			NSLog(@"SecItemUpdate failed: %i for %@", (int)error, key);
		}
	} else if (error == errSecItemNotFound) {
		// do add
		[query setObject:[value dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
		error = SecItemAdd((CFDictionaryRef)query, NULL);
		if (error != errSecSuccess) {
			NSLog(@"SecItemAdd failed: %i for %@", (int)error, key);
		}
	}
    
    [query release];
}

+ (NSString*) stringForKey:(NSString*)key {
	if (key == nil) {
		return nil;
	}
	
	NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithCapacity:3];
	[query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    NSData *encodedKey = [key dataUsingEncoding:NSUTF8StringEncoding];
	[query setObject:encodedKey forKey:(id)kSecAttrAccount];
	[query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];

	NSData *dataFromKeychain = nil;
	OSStatus error = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&dataFromKeychain);
	NSString *stringToReturn = nil;
	if (error == errSecSuccess) {
		stringToReturn = [[[NSString alloc] initWithData:dataFromKeychain encoding:NSUTF8StringEncoding] autorelease];
	}
	
	[dataFromKeychain release];
	[query release];
    
	return stringToReturn;
}

+ (void) deleteForKey:(NSString*)key {
	if (key == nil) {
		return;
	}
	
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	[query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    NSData *encodedKey = [key dataUsingEncoding:NSUTF8StringEncoding];
	[query setObject:encodedKey forKey:(id)kSecAttrAccount];
		
	OSStatus status = SecItemDelete((CFDictionaryRef)query);
	if (status != errSecSuccess) {
		NSLog(@"SecItemDelete failed: %@", key);
	}
}

@end