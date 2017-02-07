//
//  RequestHelper.m
//  KingCheap
//
//  Created by zhipu on 15/8/31.
//  Copyright (c) 2015年 zhipu. All rights reserved.
//

#import "RequestHelper.h"
#import "AFNetworking.h"
#import "NSJSONSerialization+RemovingNulls.h"
//#import "MyConfig.h"

@interface Suffix : AFHTTPResponseSerializer<AFURLResponseSerialization>
@end
@implementation Suffix
-(id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    NSError *dataError=nil;
    id json=[NSJSONSerialization JSONObjectWithData:data options:0 error:&dataError removingNulls:YES ignoreArrays:YES];
    if (dataError) {
        return nil;
    }
    return json;
}
@end
@interface RequestHelper()
@end
AFHTTPRequestOperationManager *manager;
@implementation RequestHelper
//+(void)initialize
//{
//    //manager=[AFHTTPRequestOperationManager manager];
//    manager=[[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:KITF_BASE]];
//    [manager setResponseSerializer:[[Suffix alloc]init]];
//}
+(void)getContentPath:(NSString *)apiPath params:(NSDictionary *)params completeBlock:(void (^)(NSError *, id))block
{
    if (!params) {
        params=@{};
    }

    [manager POST:apiPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject!=nil) {
            block(nil,responseObject);
        }
        else
        {
            block([[NSError alloc] initWithDomain:@"NIL OBJECT" code:0 userInfo:nil],nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(error, nil);
    }];
}
+(void)uploadImgPath:(NSString *)apiPath params:(NSDictionary *)params ImageData:(NSData *)imgdata ImgName:(NSString *)strImgName FileType:(NSString *)filetype completeBlock:(void (^)(NSError *err, id object))block
{
    if (!params) {
        params=@{};
    }
    if (!filetype) {
        filetype=@"image";
    }
    [manager POST:apiPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imgdata name:strImgName fileName:@"filename.png" mimeType:filetype];
        //[formData appendPartWithFormData:imgdata name:imagename];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(nil,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(error, nil);
    }];
}

@end

