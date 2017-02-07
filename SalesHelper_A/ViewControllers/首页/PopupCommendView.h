//
//  PopupCommendView.h
//  SalesHelper_A
//
//  Created by summer on 15/7/11.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupCommendView : UIView
@property (weak, nonatomic) IBOutlet UIButton *commendBtn;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIView *backGroudView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backGroudViewContent;

+ (PopupCommendView *)instanceWithFrame:(CGRect)frame;

@end
