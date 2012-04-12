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

#import "NSUserDefaults+LolayBase64.h"
#import "NSData+LolayBase64.h"
#import "NSString+LolayBase64.h"

@implementation NSUserDefaults (LolayBase64)

- (void) setCodableObject:(id<NSCoding>) value forKey:(NSString*) defaultName {
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:value];
    NSString* string = [NSData base64StringWithData:data];
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:defaultName];
}

- (id<NSCoding>) codableObjectForKey:(NSString *) defaultName {
    NSString* string = [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
    NSData* data = [NSString base64DataWithString:string];
    id<NSCoding> obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return obj;
}

@end
