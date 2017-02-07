//
//  ZJFMDBManager.h
//  SalesHelper_A
//
//  Created by zhipu on 16/4/18.
//  Copyright © 2016年 X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface ZJFMDBManager : NSObject

+ (FMDatabase *)shareDataBase;

+ (void)openDataBase:(FMDatabase *)db update:(NSString *)update;

@end
