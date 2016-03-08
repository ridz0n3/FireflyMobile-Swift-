//
//  NSString+ExtraMethod.h
//  VRSM
//
//  Created by ME-Tech MacPro User 2 on 4/23/15.
//  Copyright (c) 2015 Silverlake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ExtraMethod)

+(NSString*)sha256HashFor:(NSString*)input;
+(NSString*)hashkeyForUser;
- (NSString *)MD5String;
+ (NSString *)serializeParams:(NSDictionary *)params;
- (NSString *)xmlSimpleEscapeString;
- (NSString *)xmlSimpleUnescapeString;

@end
