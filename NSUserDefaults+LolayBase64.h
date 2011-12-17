//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSUserDefaults (LolayBase64)

- (void) setCodableObject:(id<NSCoding>) value forKey:(NSString*) defaultName;
- (id<NSCoding>) codableObjectForKey:(NSString*) defaultName;

@end
