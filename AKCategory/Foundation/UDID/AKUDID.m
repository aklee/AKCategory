//
//  AKUDID.m
//
//  Created by ak on 15/7/6.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#import "AKUDID.h"
#import "SSKeychain.h"

@implementation AKUDID

+ (NSString *)createNewUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    NSString* string = CFBridgingRelease(CFUUIDCreateString(NULL, theUUID));
    CFRelease(theUUID);
    return string;
}

+ (NSString *)UDID
{
    return [[self class] UDID:@"userUDID"];
}


+ (NSString *)UDID:(NSString*)k{
    NSString* key = k;
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    // It's important to note that the keychain can be restored to other devices if the user encrypts their backup. This can result in a situation where multiple devices share the same UUID. To avoid this, set the accessibility of your keychain item to kSecAttrAccessibleAlwaysThisDeviceOnly. This will ensure that your UUID does not migrate to any other device.
    [SSKeychain setAccessibilityType:kSecAttrAccessibleAlwaysThisDeviceOnly];
    
    NSString *strApplicationUUID = [SSKeychain passwordForService:appName account:key];
    if (strApplicationUUID == nil) {
        strApplicationUUID = [self createNewUUID];
        [SSKeychain setPassword:strApplicationUUID forService:appName account:key];
    }
    return strApplicationUUID;
    
}
@end
