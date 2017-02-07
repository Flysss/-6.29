//
//  FollowUpTableViewCell.m
//  SalesHelper_A
//
//  Created by summer on 15/11/5.
//  Copyright © 2015年 X. All rights reserved.
//

#import "FollowUpTableViewCell.h"
#import <AVFoundation/AVAsset.h>
#import "DOUAudioStreamer.h"



@implementation FollowUpTableViewCell
{
    __weak IBOutlet UILabel *timeLabel;
    
    __weak IBOutlet UILabel *typeLabel;
    
    __weak IBOutlet UIImageView *paopaoImageView;
    
    
    __weak IBOutlet UIImageView * soundAniImageView;
        
    void (^viewClick)();//声明一个block
    
    DOUAudioStreamer * _streamer;

    __weak IBOutlet NSLayoutConstraint *lineWidth;
}

- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)addClickTargetWithVoice:(void(^)())click
{
//    if (![[_dataSource objectForKey:@"recodeType"]isEqualToNumber:@2]) {
        viewClick = click;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickView)];
        paopaoImageView.userInteractionEnabled = YES;
        [paopaoImageView addGestureRecognizer:tap];
//    }
}
- (void)clickView
{
    if (viewClick) {
        viewClick();
        remarkLable.hidden = YES;
    }
}

-(void)setDataSource:(NSDictionary *)dataSource
{
    
//    Track * track = [[Track alloc]init];
//    track.audioFileURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.hfapp.com/%@",[dataSource objectForKey:@"voice"]]];
//    _streamer = [DOUAudioStreamer streamerWithAudioFile:track];
    
    lineWidth.constant = 0.5;
    
    timeLabel.text = [ProjectUtil timestampToStrDate:[dataSource objectForKey:@"recodeTime"]];
    typeLabel.text = [dataSource objectForKey:@"followType"];

    //recodeType 1 只有语音 2 只有文字 3 语音加文字
    if ([[dataSource objectForKey:@"recodeType"]isEqualToNumber:@1]) {
        remarkLable.hidden = YES;
        _voiceTimeLabel.hidden = NO;
        soundAniImageView.hidden = NO;
    }else if ([[dataSource objectForKey:@"recodeType"]isEqualToNumber:@2])
    {
        remarkLable.text =[NSString stringWithFormat:@"备注: %@",[dataSource objectForKey:@"remarks"]];
        remarkLable.hidden = NO;
        soundAniImageView.hidden = YES;
        _voiceTimeLabel.hidden = YES;
    }
}
@end
