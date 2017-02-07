//
//  URLRequest.h
//  SelegementDemo
//
//  Created by summer on 14/10/28.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RequestTimeOutCount 10

typedef void(^RequestURLBlock)(id data);
typedef void(^RequestURLFailBlock)(NSError *error);
@interface URLRequest : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    RequestURLBlock _requestURLBlock;
    RequestURLFailBlock _requestURLFailBlock;
}
@property (nonatomic,retain)NSString *urlString;

@property (nonatomic,assign)BOOL cachDisk;
+(URLRequest *)sharedURLRequest;

+(id)startSynchronizeGetRequestWithUrlString:(NSString *)urlString IsJsonAnalysis:(BOOL)isJsonAnalysis;

+(id)startSynchronizePostRequestWithUrlString:(NSString *)urlString BodyString:(NSString *)bodyString IsJsonAnalysis:(BOOL)isJsonAnalysis;

-(void)startAsynchronizeGetRequestWithUrlString:(NSString *)urlString HTTPBodyDict:(NSDictionary *)bodyDict IsJsonAnalysis:(BOOL)isJsonAnalysis;

-(void)startAsynchronizePostRequestWithUrlString:(NSString *)urlString HTTPBodyDict:(NSDictionary *)bodyDict IsJsonAnalysis:(BOOL)isJsonAnalysis;

-(void)startAsynchronizePostRequestWithUrlString:(NSString *)urlString HTTPBodyData:(NSData *)bodyData HTTPHeaderField:(NSString *)httpHeaderField IsJsonAnalysis:(BOOL)isJsonAnalysis;

-(void)getReceivedData:(RequestURLBlock)requestURLBlock Fail:(RequestURLFailBlock)requestURLFailBlock;


-(void)startAsynchronizePostRequestWithUrlString:(NSString *)urlString BodyString:(NSString *)bodyString IsJsonAnalysis:(BOOL)isJsonAnalysis;

@end
