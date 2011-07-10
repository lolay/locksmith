//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
// This is based on code found here: http://overhrd.com/?p=208
#import <Foundation/Foundation.h>

@interface LolayKeychain : NSObject

+ (BOOL) save:(NSString*)value forKey:(NSString*)key;
+ (NSString*) stringForKey:(NSString*)key;
+ (BOOL) deleteForKey:(NSString*)key;

@end