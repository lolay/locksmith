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

#import "NSData+LolayBase64.h"

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSData (LolayBase64)

// Based on https://github.com/mikeho/QSUtilities/blob/master/QSStrings.m
- (NSData*) base64Data {
	const unsigned char* objRawData = [self bytes];
	char* objPointer;
	char* strResult;
	
	// Get the Raw Data length and ensure we actually have data
	size_t intLength = [self length];
	if (intLength == 0) {
		return nil;
	}
	
	// Setup the String-based Result placeholder and pointer within that placeholder
	strResult = (char*)calloc(((intLength + 2) / 3) * 4, sizeof(char));
	objPointer = strResult;
	
	// Iterate through everything
	while (intLength > 2) { // keep going until we have less than 24 bits
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
		*objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
		*objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
		
		// we just handled 3 octets (24 bits) of data
		objRawData += 3;
		intLength -= 3; 
	}
	
	// now deal with the tail end of things
	if (intLength != 0) {
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		if (intLength > 1) {
			*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
			*objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
			*objPointer++ = '=';
		} else {
			*objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
			*objPointer++ = '=';
			*objPointer++ = '=';
		}
	}
	
	return [NSData dataWithBytesNoCopy:strResult length:objPointer - strResult freeWhenDone:YES];
}

+ (NSData*) base64DataWithData:(NSData*) data {
	return [data base64Data];
}

- (NSString*) base64StringWithEncoding:(NSStringEncoding) encoding {
	NSData* data = [self base64Data];
	return [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:encoding];
}

+ (NSString*) base64StringWithData:(NSData*) data encoding:(NSStringEncoding) encoding{
	return [data base64StringWithEncoding:encoding];
}

- (NSString*) base64String {
	return [self base64StringWithEncoding:NSUTF8StringEncoding];
}

+ (NSString*) base64StringWithData:(NSData*) data {
	return [data base64StringWithEncoding:NSUTF8StringEncoding];
}

@end
