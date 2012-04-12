//
//  Copyright 2012 Lolay, Inc. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <CommonCrypto/CommonHMAC.h>
#import "NSData+LolayHmacSha1.h"

@implementation NSData (LolayHmacSha1)

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
