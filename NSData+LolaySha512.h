//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (LolaySha512)

- (NSData*) sha512Data;
+ (NSData*) sha512DataWithData:(NSData*) data;

@end
