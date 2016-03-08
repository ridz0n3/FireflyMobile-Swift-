//
//  NSString+ExtraMethod.m
//  VRSM
//
//  Created by ME-Tech MacPro User 2 on 4/23/15.
//  Copyright (c) 2015 Silverlake. All rights reserved.
//

#import "NSString+ExtraMethod.h"
#import "NSMutableString+ExtraMethod.h"

@implementation NSString (ExtraMethod)

- (NSString *)xmlSimpleUnescapeString
{
    NSMutableString *unescapeStr = [NSMutableString stringWithString:self];
    
    return [unescapeStr xmlSimpleUnescape];
}

- (NSString *)xmlSimpleEscapeString
{
    NSMutableString *escapeStr = [NSMutableString stringWithString:self];
    
    return [escapeStr xmlSimpleEscape];
}
@end
