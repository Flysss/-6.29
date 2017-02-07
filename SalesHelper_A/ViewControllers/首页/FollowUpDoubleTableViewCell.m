//
//  FollowUpDoubleTableViewCell.m
//  SalesHelper_A
//
//  Created by My on 15/11/10.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "FollowUpDoubleTableViewCell.h"

@implementation FollowUpDoubleTableViewCell
{
    __weak IBOutlet UILabel *timeLabel;
    
    __weak IBOutlet UILabel *typeLabel;
    
    __weak IBOutlet UIImageView *paopaoImageView;
    
    
    __weak IBOutlet UIImageView * soundAniImageView;
    
   
    __weak IBOutlet NSLayoutConstraint *lineWidth;
    
    __weak IBOutlet NSLayoutConstraint *remarkLabelWidth;
    void (^viewClick)();//声明一个block
    
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)addClickTargetWithVoice:(void(^)())click
{
    viewClick = click;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickView)];
    paopaoImageView.userInteractionEnabled = YES;
    [paopaoImageView addGestureRecognizer:tap];
}
- (void)clickView
{
    if (viewClick) {
        viewClick();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataSource:(NSDictionary *)dataSource
{
    lineWidth.constant = 0.5;
    timeLabel.text = [ProjectUtil timestampToStrDate:[dataSource objectForKey:@"recodeTime"]];
    typeLabel.text = [dataSource objectForKey:@"followType"];
    remarkLable.text = [NSString stringWithFormat:@"备注: %@",[dataSource objectForKey:@"remarks"]];
}
//- (CGFloat)labelText
@end
