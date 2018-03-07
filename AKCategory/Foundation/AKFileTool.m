//
//  FileUtil.m
//  FileUtil
//
//  Copyright (c) 2013年 ak. All rights reserved.
//

#import "AKFileTool.h"

@implementation AKFileTool
/// Free disk space in bytes.
static int64_t AKDiskSpaceFree() {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}
+(NSInteger)getDiskSpaceFree{
    return AKDiskSpaceFree();
}
//获取应用程序路径
+(NSString *)getApplicationPath
{
    return NSHomeDirectory();
}

//提供获取document路径
+(NSString *)getDocumentPath
{
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	return [filePaths objectAtIndex: 0];
}

//获取cache缓存路径
+(NSString *)getCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return cachesDir;
}

//获取temp路径
+(NSString *)getTempPath
{
    return NSTemporaryDirectory();
}

+(BOOL)isExist:(NSString *)filePath               //判断文件是否存在
{
    BOOL flag = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        flag = YES;
    }
    else
    {
        flag = NO;
    }
    
    return flag;
}

+(BOOL)isFull:(NSString *)filePath  fullSize:(long long )fullSize            //判断文件是否存在并且完整
{
    BOOL flag = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        flag = YES;
        long long temp=[self getFileSize:filePath];
        if(temp!=fullSize){
            flag=NO;
        }
    }
    else
    {
        flag = NO;
    }
    
    return flag;
}

+(BOOL)removeFile:(NSString *)filePath            //删除文件
{
    BOOL flag = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        if (![fileManager removeItemAtPath:filePath error:nil]) {
            flag = NO;
        }
    }
    return flag;
}

+(BOOL)createAtDir:(NSString *)dirPath
{
    BOOL ret = YES;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:dirPath];
    if(!isDirExist)
    {
        NSError *error = nil;
        BOOL bCreateDir = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if(!bCreateDir){
            ret = NO;
            NSLog(@"创建路径失败. DirPath:%@, Error:%@",dirPath, error);
        }
    }
    return ret;
}

+(BOOL)createDir:(NSString *)dirPath
{
    BOOL ret = YES;
    NSString *header = [NSString stringWithString:dirPath];
    NSMutableArray *stack = [NSMutableArray arrayWithCapacity:5];
    while (![self isExist:header]) {
        [stack addObject:[header lastPathComponent]];
        header = [header stringByDeletingLastPathComponent];
    }
    NSString *lastobj = nil;
    while ([stack count]> 0 && (lastobj = [stack lastObject])) {
        header = [header stringByAppendingPathComponent:lastobj];
        ret = [self createAtDir:header];
        if (!ret) {
            return ret;
        }
        if ([stack count]>0) {
            [stack removeLastObject];
        }
    }
    return ret;
}

+(BOOL)createFileAtPath:(NSString *)filePath
{
    BOOL ret = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        ret = [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    return ret;
}


+(BOOL)createFile:(NSString*)filePath{
    
    BOOL result=YES;
    //创建文件管理器
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //    BOOL isDir;
    BOOL temp= [fileManager fileExistsAtPath:filePath];
    //   BOOL temp= [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if(temp){
        return YES;
    }
    NSError *error=nil;
    
    NSString *dirPath=[filePath stringByDeletingLastPathComponent];
    result=  [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
    if(error){
        NSLog(@"创建文件失败. FilePath:%@, Error:%@",filePath, error);
    }
    if(!result){
        return result;
    }
    
    result= [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    
    return result;
}
//+(BOOL)createFile:(NSString *)filePath
//{
//    BOOL ret = YES;
//    NSString *header = [NSString stringWithString:filePath];
//    NSMutableArray *stack = [NSMutableArray arrayWithCapacity:5];
//    while (![self isExist:header]) {
//        [stack addObject:[header lastPathComponent]];
//        header = [header stringByDeletingLastPathComponent];
//    }
//    NSString *lastobj = nil;
//    while ([stack count]> 1 && (lastobj = [stack lastObject])) {
//        header = [header stringByAppendingPathComponent:lastobj];
//        ret = [self createAtDir:header];
//        if (!ret) {
//            return ret;
//        }
//        [stack removeLastObject];
//    }
//    if ([stack count] == 1) {
//        //最后一个是文件名
//        header = [header stringByAppendingPathComponent:[stack lastObject]];
//        ret = [self createFileAtPath:header];
//    }
//    return ret;
//}

+(BOOL)saveFile:(NSString *)filePath andData:(NSData *)data
{
    BOOL ret = YES;
        ret = [self createFile:filePath];
    if (ret) {
        ret=[data writeToFile:filePath atomically:YES];
        if(!ret){
            NSLog(@"写入文件失败. FilePath:%@, DataLength:%ld",filePath, data.length);
        }
    }else{
        NSLog(@"创建文件失败. FilePath:%@, DataLength:%ld",filePath, data.length);
    }
    return ret;
}

+(void)saveFileWithAppendData:(NSData *)data withPath:(NSString *)path {
    BOOL result=[self createFile:path];
    //TODO:这里频繁开关通道和写入 有优化的空间 ，拿着开好的handle 分批写入 并且在完成或失败后 关闭文件通道
    if(result){
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
        [handle seekToEndOfFile];
        [handle writeData:data];
        [handle synchronizeFile];
        [handle closeFile];
    }else{
        NSLog(@"创建文件失败. FilePath:%@, DataLength:%ld",path, data.length);
    }
 
}

+ (NSData *)getFileData:(NSString *)path {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [handle readDataToEndOfFile];
    [handle closeFile];
    return data;
}

+ (NSData *)getFileData:(NSString *)path startIndex:(long long)startIndex length:(long long)length {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    [handle seekToFileOffset:startIndex];
    NSData *data = [handle readDataOfLength:length];
    [handle closeFile];
    return data;
}

+(BOOL)moveFileFromPath:(NSString *)from toPath:(NSString *)to {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:from])
        return NO;
    
    if ([fileManager fileExistsAtPath:to])
        [self removeFile:to];
 
    NSString *headerComponent = [to stringByDeletingLastPathComponent];
    if ([self createAtDir:headerComponent])
        return [fileManager moveItemAtPath:from toPath:to error:nil];
    else
        return NO;
}

+(BOOL)copyFIleFromPath:(NSString *)from toPath:(NSString *)to {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:from])
        return NO;
    
    if ([fileManager fileExistsAtPath:to])
        [self removeFile:to];
    
    NSString *headerComponent = [to stringByDeletingLastPathComponent];
    if ([self createAtDir:headerComponent])
        return [fileManager copyItemAtPath:from toPath:to error:nil];
    else
        return NO;
}

+(NSArray *)getFileListInDirPath:(NSString *)dirPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:dirPath error:&error];
    if (error) {
        NSLog(@"获取该 %@ 目录下的文件名及文件夹名失败. Error:%@",dirPath, error);
    }
    return fileList;
}


//获取文件属性
+(unsigned long long)getFileSize:(NSString *)filePath      //获取文件大小
{
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    return [handle seekToEndOfFile];
//    unsigned long long fileLength = 0;
//    NSNumber *fileSize;
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
//    
//    if ((fileSize = [fileAttributes objectForKey:NSFileSize])) {
//        fileLength = [fileSize unsignedLongLongValue];
//    }
//    
//    return fileLength;
}


+(NSString *)getFileCreateDate:(NSString *)filePath          //获取文件创建日期
{
    NSString *fileCreateDate = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
    fileCreateDate = [fileAttributes objectForKey:NSFileCreationDate];
    
    return fileCreateDate;
}


+(NSString *)getFileOwner:(NSString *)filePath             //获取文件所有者
{
    NSString *fileOwner = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
    fileOwner = [fileAttributes objectForKey:NSFileOwnerAccountName];
    
    return fileOwner;
}

+(NSDate *)getFileChangeDate:(NSString *)filePath          //获取文件更改日期
{
    NSDate *date = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
    date = [fileAttributes objectForKey:NSFileModificationDate];
    
    return date;
} 


@end
