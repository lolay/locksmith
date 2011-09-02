//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <CommonCrypto/CommonHMAC.h>
#import "NSData+LolayHmacSha1.h"

@implementation NSData (LolayHmacSha1)

// From http://stackoverflow.com/questions/735714/iphone-and-hmac-sha-1-encoding
- (NSData*) hmacSha1DataWithKey:(NSData*) key {
    void* buffer = malloc(CC_SHA1_DIGEST_LENGTH);
    CCHmac(kCCHmacAlgSHA1, [key bytes], [key length], [self bytes], [self length], buffer);
    return [NSData dataWithBytesNoCopy:buffer length:CC_SHA1_DIGEST_LENGTH freeWhenDone:YES];
}

- (NSData*) hmacSha1DataWithKeyString:(NSString*) key {
	return [self hmacSha1DataWithKeyString:key keyEncoding:NSUTF8StringEncoding];
}

- (NSData*) hmacSha1DataWithKeyString:(NSString*) key keyEncoding:(NSStringEncoding) keyEncoding {
	return [self hmacSha1DataWithKey:[key dataUsingEncoding:keyEncoding]];
}


+ (NSData*) hmacSha1Data:(NSData*) data key:(NSData*) key {
	return [data hmacSha1DataWithKey:key];
}

+ (NSData*) hmacSha1Data:(NSData*) data keyString:(NSString*) key {
	return [data hmacSha1DataWithKeyString:key keyEncoding:NSUTF8StringEncoding];
}

+ (NSData*) hmacSha1Data:(NSData*) data keyString:(NSString*) key keyEncoding:(NSStringEncoding) keyEncoding {
	return [data hmacSha1DataWithKey:[key dataUsingEncoding:keyEncoding]];
}

@end
