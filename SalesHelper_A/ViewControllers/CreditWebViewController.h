//
//  CreditWebViewController.h
//  dui88-iOS-sdk
//
//  Created by xuhengfei on 14-5-16.
//  Copyright (c) 2014年 cpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditWebView.h"

@interface CreditWebViewController : UIViewController

@property(nonatomic,strong) NSString *needRefreshUrl;

@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UIButton * rightBtn;
@property (nonatomic, strong) UILabel * titleLabel;

-(id)initWithUrl:(NSString*)url;
-(id)initWithUrlByPresent:(NSString *)url;
-(id)initWithRequest:(NSURLRequest*)request;

@end
