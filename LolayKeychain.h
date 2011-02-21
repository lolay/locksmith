//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
// This is based on code found here: http://overhrd.com/?p=208
#import <Foundation/Foundation.h>

@interface LolayKeychain : NSObject

+ (void) save:(NSString*)value forKey:(NSString*)key;
+ (NSString*) stringForKey:(NSString*)key;
+ (void) deleteForKey:(NSString*)key;

@end