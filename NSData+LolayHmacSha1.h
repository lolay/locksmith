//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (LolayHmacSha1)

- (NSData*) hmacSha1DataWithKey:(NSData*) key;
- (NSData*) hmacSha1DataWithKeyString:(NSString*) key;
- (NSData*) hmacSha1DataWithKeyString:(NSString*) key keyEncoding:(NSStringEncoding) keyEncoding;
+ (NSData*) hmacSha1Data:(NSData*) data key:(NSData*) key;
+ (NSData*) hmacSha1Data:(NSData*) data keyString:(NSString*) key;
+ (NSData*) hmacSha1Data:(NSData*) data keyString:(NSString*) key keyEncoding:(NSStringEncoding) keyEncoding;

@end
