//
//  ZJShareIconView.h
//  SalesHelper_A
//
//  Created by zhipu on 16/6/17.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJShareIconView : UIView

@property (nonatomic, strong) UIButton *btnShare;
@property (nonatomic, strong) UILabel *lblTitle;

- (void)shareIconViewWithIcom:(NSString *)icon title:(NSString *)title;

- (void)shareIconViewWithDic:(NSDictionary *)dic;

- (void)shareIconViewWithDic1:(NSDictionary *)dic;

@end
