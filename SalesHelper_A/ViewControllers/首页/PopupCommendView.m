//
//  PopupCommendView.m
//  SalesHelper_A
//
//  Created by summer on 15/7/11.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "PopupCommendView.h"

@implementation PopupCommendView
{
    
}

//-(id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder]) {
//        self.commendBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//        self.commendBtn.layer.borderWidth = 1.0;
//        self.commendBtn.layer.masksToBounds = YES;
//        self.commendBtn.layer.cornerRadius = 10;
//    }
//    return self;
//}
//-(instancetype)initWithFrame:(CGRect)frame
//{
//    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PopupCommendView" owner:nil options:nil];
//    PopupCommendView *cv =[nibView objectAtIndex:0];
//
//    if (self = [super initWithFrame:frame]) {
//        self.commendBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//        self.commendBtn.layer.borderWidth = 1.0;
//        self.commendBtn.layer.masksToBounds = YES;
//        self.commendBtn.layer.cornerRadius = 10;
//        self.frame = frame;
//    }
//    return cv;
//}
+ (PopupCommendView *)instanceWithFrame:(CGRect)frame
{
    PopupCommendView *view = (PopupCommendView *)[[NSBundle mainBundle] loadNibNamed:@"PopupCommendView" owner:nil options:nil][0];
    view.frame = frame;
    view.commendBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    view.commendBtn.layer.borderWidth = 1.0;
    view.commendBtn.layer.masksToBounds = YES;
    view.commendBtn.layer.cornerRadius = 5;
    view.backGroudViewContent.constant = [UIScreen mainScreen].bounds.size.width;
    view.backGroudView.userInteractionEnabled = NO;
    view.backGroudView.backgroundColor  =[UIColor colorWithRed:0.000 green:0.573 blue:0.821 alpha:1.000];
    return view;
}


//1
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.commendBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.commendBtn.layer.borderWidth = 1.0;
        self.commendBtn.layer.masksToBounds = YES;
        self.commendBtn.layer.cornerRadius = 10;
    }
    return self;
}

//2
- (void)awakeFromNib {
    [super awakeFromNib];
}

//3
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        
    }
}

//4
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}

@end
