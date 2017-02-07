//
//  URLRequest.m
//  SelegementDemo
//
//  Created by summer on 14/10/28.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "URLRequest.h"

@implementation URLRequest
{
    NSMutableData *_receiveData;
    BOOL _isJsonAnalysis;

}
@synthesize urlString = _urlString;
+(URLRequest *)sharedURLRequest
{
    URLRequest *request = [[URLRequest alloc]init];
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    return request;
}

+(id)startSynchronizeGetRequestWithUrlString:(NSString *)urlString IsJsonAnalysis:(BOOL)isJsonAnalysis
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:RequestTimeOutCount];
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (isJsonAnalysis)
    {
        return [URLRequest getJsonSerializationObjectWithData:receivedData];
    }
    else
    {
        return receivedData;
    }
}

+(id)startSynchronizePostRequestWithUrlString:(NSString *)urlString BodyString:(NSString *)bodyString IsJsonAnalysis:(BOOL)isJsonAnalysis
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:RequestTimeOutCount];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (isJsonAnalysis)
    {
        return [URLRequest getJsonSerializationObjectWithData:receivedData];
    }
    else
    {
        return receivedData;
    }

}

-(void)startAsynchronizeGetRequestWithUrlString:(NSString *)urlString HTTPBodyDict:(NSDictionary *)bodyDict IsJsonAnalysis:(BOOL)isJsonAnalysis
{
    
    self.urlString = urlString;
    _isJsonAnalysis = isJsonAnalysis;
    NSURL *url;
    if (bodyDict.count > 0) {
        url = [NSURL URLWithString:[urlString stringByAppendingString:[NSString stringWithFormat:@"%@%@",RequestKey,[self returnBodyStr:bodyDict]]]];
    }else {
        url = [NSURL URLWithString:urlString];
    }
    NSURLCache * URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    NSURLRequest *request ;
    if (self.cachDisk) {
        request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:RequestTimeOutCount];
    }else
    {
        request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:RequestTimeOutCount];
    }

    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)startAsynchronizePostRequestWithUrlString:(NSString *)urlString HTTPBodyDict:(NSDictionary *)bodyDict IsJsonAnalysis:(BOOL)isJsonAnalysis
{
    self.urlString = urlString;
     _isJsonAnalysis = isJsonAnalysis;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
     NSMutableURLRequest *request ;
    if (self.cachDisk) {
        request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:RequestTimeOutCount];
    }else
    {
        request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:RequestTimeOutCount];
    }
    [request setHTTPMethod:@"POST"];
    [ProjectUtil showLog:@"bodyDict = %@",[NSString stringWithFormat:@"%@%@%@",url,RequestKey,[self returnBodyStr:bodyDict]]];
    
    [request setHTTPBody:[[NSString stringWithFormat:@"%@%@",RequestKey,[self returnBodyStr:bodyDict]] dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)startAsynchronizePostRequestWithUrlString:(NSString *)urlString HTTPBodyData:(NSData *)bodyData HTTPHeaderField:(NSString *)httpHeaderField IsJsonAnalysis:(BOOL)isJsonAnalysis
{
    self.urlString = urlString;
    _isJsonAnalysis = isJsonAnalysis;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:RequestTimeOutCount];
    [request setHTTPMethod:@"POST"];
    [request setValue:httpHeaderField forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody:bodyData];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (NSString *)returnBodyStr:(NSDictionary *)dict
{
    NSMutableString *bodyStr = [NSMutableString stringWithFormat:@""];
    for (id dataStr in dict) {
        NSString *headStr = [NSString stringWithFormat:@"&%@=%@",dataStr,dict[dataStr]];
        bodyStr = (NSMutableString *)[bodyStr stringByAppendingString:headStr];
    }
    return bodyStr;
}

-(void)getReceivedData:(RequestURLBlock)requestURLBlock Fail:(RequestURLFailBlock)requestURLFailBlock
{
    _requestURLBlock = requestURLBlock;
    _requestURLFailBlock = requestURLFailBlock;
}

+(id)getJsonSerializationObjectWithData:(NSData *)data
{
  return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
}

#pragma mark connectionDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _receiveData = [NSMutableData data];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (_requestURLFailBlock!=nil)
    {
         _requestURLFailBlock(error);
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_requestURLBlock!=nil)
    {
        id object;
        if (_isJsonAnalysis)
        {
          object = [NSJSONSerialization JSONObjectWithData:_receiveData options:NSJSONReadingMutableLeaves error:nil];
        }
        else
        {
           object = _receiveData;
        }
        _requestURLBlock(object);
    }
}


-(void)startAsynchronizePostRequestWithUrlString:(NSString *)urlString BodyString:(NSString *)bodyString IsJsonAnalysis:(BOOL)isJsonAnalysis
{
    self.urlString = urlString;
    _isJsonAnalysis = isJsonAnalysis;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:RequestTimeOutCount];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

@end
