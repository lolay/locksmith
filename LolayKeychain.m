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
	
	[query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[query setObject:key forKey:(id)kSecAttrAccount];
	[query setObject:(id)kSecAttrAccessibleWhenUnlocked forKey:(id)kSecAttrAccessible];
	
	OSStatus error = SecItemCopyMatching((CFDictionaryRef)query, NULL);
	if (error == errSecSuccess) {
		// do update
		NSDictionary *attributesToUpdate = [NSDictionary dictionaryWithObject:[value dataUsingEncoding:NSUTF8StringEncoding] 
																	  forKey:(id)kSecValueData];
		
		error = SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)attributesToUpdate);
		NSLog(@"SecItemUpdate failed: %i for %@", (int)error, key);
	} else if (error == errSecItemNotFound) {
		// do add
		[query setObject:[value dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
		
		error = SecItemAdd((CFDictionaryRef)query, NULL);
		NSLog(@"SecItemAdd failed: %i for %@", (int)error, key);
	}
}

+ (NSString*) stringForKey:(NSString*)key {
	if (key == nil) {
		return nil;
	}
	
	NSMutableDictionary *query = [NSMutableDictionary dictionary];

	[query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[query setObject:key forKey:(id)kSecAttrAccount];
	[query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];

	NSData *dataFromKeychain = nil;

	OSStatus error = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&dataFromKeychain);
	
	NSString *stringToReturn = nil;
	if (error == errSecSuccess) {
		stringToReturn = [[[NSString alloc] initWithData:dataFromKeychain encoding:NSUTF8StringEncoding] autorelease];
	}
	
	[dataFromKeychain release];
	
	return stringToReturn;
}

+ (void) deleteForKey:(NSString*)key {
	if (key == nil) {
		return;
	}
	
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	
	[query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[query setObject:key forKey:(id)kSecAttrAccount];
		
	OSStatus status = SecItemDelete((CFDictionaryRef)query);
	if (status != errSecSuccess) {
		NSLog(@"SecItemDelete failed: %@", key);
	}
}

@end