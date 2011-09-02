//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (LolayBase64)

- (NSData*) base64Data;
+ (NSData*) base64DataWithData:(NSData*) data;
- (NSString*) base64StringWithEncoding:(NSStringEncoding) encoding;
+ (NSString*) base64StringWithData:(NSData*) data encoding:(NSStringEncoding) encoding;
- (NSString*) base64String;
+ (NSString*) base64StringWithData:(NSData*) data;

@end
