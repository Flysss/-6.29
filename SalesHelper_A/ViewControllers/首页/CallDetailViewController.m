//
//  CallDetailViewController.m
//  SalesHelperC
//
//  Created by summer on 14/12/27.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "CallDetailViewController.h"
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>



@interface CallDetailViewController ()
{
    NSTimer *_phoneTimer;//通话时间、
    NSInteger _waitCount;//等待时间、
//    CTCallCenter *_callCenter;
}
@end

@implementation CallDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    self.onPhoneBtn.layer.cornerRadius = 3.0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.callPhoneLabel.text = self.phoneNumber;
    
    self.onPhoneGifWebView.userInteractionEnabled = NO;
    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Preloader" ofType:@"gif"]];
    [self.onPhoneGifWebView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    
    RequestInterface *request = [[RequestInterface alloc]init];
    [request freePhoneCallWithCallKey:@"" Called:self.phoneNumber Token:@""];
    [request getInterfaceRequestObject:^(id data) {
        if ([data[@"code"]integerValue]==1)
        {
            [self.view.window makeToast:@"拨打成功，请耐心等待回拨"];


        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.view.window makeToast:data[@"msg"]];
        }
    } Fail:^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.view makeToast:HintWithNetError];
    }];

    _waitCount = 30;
    _countLabel.text = [NSString stringWithFormat:@"%lds",(long)_waitCount];
    _phoneTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
}

- (void)updateTime
{
    if(_waitCount == 0)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.view.window makeToast:@"发送超时，请重试"];
    }
    else
    {
        _countLabel.text = [NSString stringWithFormat:@"%lds", (long)--_waitCount];
    }
}

#pragma mark 取消通话
- (IBAction)cancelCallAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
