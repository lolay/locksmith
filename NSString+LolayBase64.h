//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LolayBase64)

- (NSData*) base64DataWithEncoding:(NSStringEncoding) encoding;
+ (NSData*) base64DataWithString:(NSString*) base64String encoding:(NSStringEncoding) encoding;
- (NSData*) base64Data;
+ (NSData*) base64DataWithString:(NSString*) base64String;

@end
