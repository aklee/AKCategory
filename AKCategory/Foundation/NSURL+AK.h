//
//  NSURL+AK.h
//
//  Copyright (c) 2015年 ak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (AK)


//应用有一些文件需要永久的存储在本地使应用支持离线功能。但是这些文件并不包含用户数据，无需备份。防止这些文件被备份。
//从iOS 5.1开始，应用可以使用NSURLIsExcludedFromBackupKey 或 kCFURLIsExcludedFromBackupKey 文件属性来防止文件被备份
//注意：应用应该避免将应用数据和用户数据和在相同的文件中。这样会增加不必要的备份大小并且被认为是违反iOS的数据存储指南。
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
- (NSDictionary *)queryParams;
@end
