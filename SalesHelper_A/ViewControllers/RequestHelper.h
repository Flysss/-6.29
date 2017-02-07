//
//  RequestHelper.h
//  KingCheap
//
//  Created by zhipu on 15/8/31.
//  Copyright (c) 2015年 zhipu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestHelper : NSObject

+(void)getContentPath:(NSString *)apiPath params:(NSDictionary *)params completeBlock:(void(^)(NSError *err,id result))block;

+(void)uploadImgPath:(NSString *)apiPath params:(NSDictionary *)params ImageData:(NSData *)imgdata ImgName:(NSString *)strImgName FileType:(NSString *)filetype completeBlock:(void (^)(NSError *err, id object))block;

@end
