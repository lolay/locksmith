//
//  Copyright 2012 Lolay, Inc.
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

#import <CommonCrypto/CommonDigest.h>
#import "NSData+LolaySha512.h"

@implementation NSData (LolaySha512)

- (NSData*) sha512Data {
	unsigned char hash[CC_SHA512_DIGEST_LENGTH];
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
	if (CC_SHA512([self bytes], (CC_LONG) [self length], hash)) {
#else
	if (CC_SHA512([self bytes], (CC_LONG64) [self length], hash)) {
#endif
		return [NSData dataWithBytes:hash length:CC_SHA512_DIGEST_LENGTH];
	}
	return nil;	
}

+ (NSData*) sha512DataWithData:(NSData*) data {
	return [data sha512Data];
}

@end
