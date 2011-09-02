//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSData+LolaySha512.h"

@implementation NSData (LolaySha512)

- (NSData*) sha512Data {
	unsigned char hash[CC_SHA512_DIGEST_LENGTH];
	if (CC_SHA512([self bytes], [self length], hash)) {
		return [NSData dataWithBytes:hash length:CC_SHA512_DIGEST_LENGTH];
	}
	return nil;	
}

+ (NSData*) sha512DataWithData:(NSData*) data {
	return [data sha512Data];
}

@end
