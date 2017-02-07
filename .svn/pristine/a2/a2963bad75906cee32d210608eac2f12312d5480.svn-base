//
//  ZJFMDBManager.m
//  SalesHelper_A
//
//  Created by zhipu on 16/4/18.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJFMDBManager.h"

@implementation ZJFMDBManager

+ (FMDatabase *)shareDataBase
{
    static FMDatabase *db = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES).firstObject;
        NSString *newFilePath = [filePath stringByAppendingString:@"banghui.db"];
        db = [FMDatabase databaseWithPath:newFilePath];
    });
    return db;
}

+ (void)openDataBase:(FMDatabase *)db update:(NSString *)update
{
    if ([db open]) {
        [db executeUpdate:update];
    }
    else
    {
        NSLog(@"数据库打开失败");
    }
}

@end
