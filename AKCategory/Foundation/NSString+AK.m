//
//  NSString+Regex.m
//  JiuCai
//
//  Created by ak on 15/7/29.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#import "NSString+AK.h"
#import "Regex.h"
@implementation NSString (AK)

+ (NSString *)urlEncodeWithEncoding:(NSStringEncoding)encoding string:(NSString *)string {
    NSArray *escapeChars = @[ @";", @"/", @"?", @":", @"@", @"&", @"=", @"+", @"$", @",", @"!", @"'", @"(", @")", @"*" ];
    NSArray *replaceChars = @[ @"%3B", @"%2F", @"%3F", @"%3A", @"%40", @"%26", @"%3D", @"%2B", @"%24", @"%2C", @"%21", @"%27", @"%28", @"%29", @"%2A" ];
    
    int len = (int)[escapeChars count];
    NSMutableString *temp = [[string stringByAddingPercentEscapesUsingEncoding:encoding] mutableCopy];
    for (int i = 0; i < len; i++) {
        [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
                              withString:[replaceChars objectAtIndex:i]
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [temp length])];
    }
    return temp;
}
//MARK:Regex
- (BOOL)isEmail{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kCheckEmail];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}


- (BOOL)isMobileNumber
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kCheckMobileNo];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}

- (BOOL)isPersonalID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kCheckPersonalID];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}
- (BOOL)isPersonalIDWithX
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kCheckPersonalID2];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}

- (BOOL)isPersonalName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kCheckPersonalName];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}

- (BOOL)isTradePwd
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kCheckTradePwd];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}

- (BOOL)isNumber
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kCheckNumber];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}

- (BOOL)isNumberInclude0
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kCheckNumber2];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}

- (BOOL)isLoginPwd
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kCheckLoginPwd];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}


- (BOOL)isDecimal
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",kCheckDecimal];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}

@end
