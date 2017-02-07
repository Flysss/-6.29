//
//  ClientsAddFollowUpViewController.m
//  SalesHelper_A
//
//  Created by summer on 15/11/6.
//  Copyright © 2015年 X. All rights reserved.
//

#import "ClientsAddFollowUpViewController.h"
#import "LVRecordTool.h"
@interface ClientsAddFollowUpViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UITextViewDelegate>

@end

@implementation ClientsAddFollowUpViewController
{
    LVRecordTool * recordTool;
    
    __weak IBOutlet UIView *RecordPressView;
    
    __weak IBOutlet UIImageView * RecordStatusIma;
    
    __weak IBOutlet UILabel *RecordStatusLabel;
    
    __weak IBOutlet UIImageView *showVoiceImg;
    
    __weak IBOutlet UILabel *timeLabel;
    
    __weak NSTimer * _timer;
    
    __weak IBOutlet UIImageView *voiceSoundImg;
    
    NSInteger timeCount;
    
    __weak IBOutlet UILabel *remarkRecord;
    
    NSInteger count;
    
    __weak NSTimer * playTimer;
    
    
    NSInteger playTimeCount;

    UIView * _cover;
    
    UIDatePicker * _picker;
    
    UILabel * dataTimeLabel;
    
    UIView * holdView;
    
    UITextView * remarkTextView;
    
    UILabel * followUplable;
    
    NSString * timeSp;
    
    NSString * accRecordUrl;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden  = YES;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    recordTool = [LVRecordTool sharedRecordTool];
    
    
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:@selector(saveInfo)];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"添加跟进记录";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightBtn setImage:nil forState:UIControlStateNormal];
    self.rightBtn.tintColor = [UIColor whiteColor];
    
   
    showVoiceImg.hidden = YES;
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playOrStopRecord)];
    [showVoiceImg addGestureRecognizer:tap];
    showVoiceImg.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *presss = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [RecordPressView addGestureRecognizer:presss];

}

- (void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveInfo
{
    if ([dataTimeLabel.text isEqualToString: @""] || dataTimeLabel.text.length == 0)
    {
        NSDate * date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:date];
        NSDate *localeDate = [date dateByAddingTimeInterval:interval];
        
        // 时间转换成时间戳
        timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
    }
    //取消转圈
    [self.view Loading_0314];
    
    RequestInterface * interface2 = [[RequestInterface alloc] init];
    [interface2 requestUploadAvatarInterfaceWithNSData:[NSData dataWithContentsOfURL:[recordTool recordFileUrl]]];
    [interface2 getInterfaceRequestObject:^(id data) {
        [self.view Hidden];
        
        if ([[data objectForKey:@"success"] boolValue]) {
            accRecordUrl = [data objectForKey:@"datas"];
            
//            NSLog(@"%@",accRecordUrl);
            
            NSDictionary * dict = @{
                                    @"token":self.login_user_token,
                                    @"recommendId":self.userID,
                                    @"followType":followUplable.text,
                                    @"remarks":remarkTextView.text,
                                    @"recodeTime":timeSp,
                                    @"voiceUrl":accRecordUrl ? accRecordUrl:@"",
                                    };
            RequestInterface * interface = [[RequestInterface alloc]init];
            [interface requestAddFollowUpWithDict:dict];
            [interface getInterfaceRequestObject:^(id data2) {
            
                if ([[data2 objectForKey:@"success"] boolValue]) {
                    
                    if (self.refreshBlock) {
                        self.refreshBlock();
                    }
                    
                    [self.view makeToast:@"保存成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    });                }
            } Fail:^(NSError *error) {
                [self.view Hidden];
            }];

        }
        else
        {
            [self.view makeToast:@"网络错误"];
            [self.view Hidden];

        }
    } Fail:^(NSError *error) {
        [self.view makeToast:@"网络错误"];
    }];

    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [playTimer invalidate];
}

- (void)longPress:(UILongPressGestureRecognizer *)press
{
    switch (press.state)
    {
        case UIGestureRecognizerStateBegan :
        {
            [recordTool stopPlaying];
            showVoiceImg.hidden = NO;
            timeCount = 0;
            count = 0;
            [recordTool startRecording];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
            RecordStatusIma.image = [UIImage imageNamed:@"语音备注-按下"];
            RecordStatusLabel.text = @"录音中...";
            remarkRecord.text = @"松开停止";
            break;
        }
        case UIGestureRecognizerStateChanged: {
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            [_timer invalidate];
            _timer = nil;
            [recordTool stopRecording];
            RecordStatusIma.image = [UIImage imageNamed:@"语音备注-默认"];
            RecordStatusLabel.text = @"按住说话";
            remarkRecord.text = @"语音备注";
            
            break;
        }
        case UIGestureRecognizerStateFailed: {
            break;
        }
        default: {
            break;
        }
    }
}
- (void)playOrStopRecord
{
    playTimeCount = 0 ;
    if ([recordTool.player isPlaying])
    {
        [playTimer invalidate];
        [voiceSoundImg stopAnimating];
        [recordTool stopPlaying];
    }
    [playTimer invalidate];
    playTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playTimeChange) userInfo:nil repeats:YES];
    [recordTool playRecordingFile];
    
    NSMutableArray *arrayImage = [NSMutableArray array];
    //遍历图片
    for (int i = 1; i < 4; i++) {
        //类似 c，格式控制，不足两位0补齐
        NSString *name = [NSString stringWithFormat:@"语音播放%d.png", i];
        UIImage *image = [UIImage imageNamed:name];
        //添加到数组里
        [arrayImage addObject:image];
    }
    voiceSoundImg.animationImages = arrayImage;
    voiceSoundImg.animationDuration = 3;
    voiceSoundImg.animationRepeatCount = 100;
    [voiceSoundImg startAnimating];

}
- (void)playTimeChange
{
    playTimeCount ++;
    if (playTimeCount <= timeCount) {
        if (timeCount < 10) {
            timeLabel.text = [NSString stringWithFormat:@"00:0%ld",(long)playTimeCount];
        }else
        {
            timeLabel.text = [NSString stringWithFormat:@"00:%ld",(long)playTimeCount];
        }

    }else
    {
        [playTimer invalidate];
        [voiceSoundImg stopAnimating];
    }
}
- (void)changeImage
{
    count++;
    
    [recordTool.recorder updateMeters];//更新测量值
        CGFloat lowPassResults = pow(10, (0.05 * [recordTool.recorder peakPowerForChannel:0]));
        CGFloat result  = 10 * (float)lowPassResults;
        NSInteger no = 0;
        if (result > 0 && result <= 3) {
            no = 1;
        }else if (result > 3.0 && result <= 10) {
            no = 2;
        } else if (result > 10 && result <= 20) {
            no = 3;
        } else if (result > 20) {
            no = 4;
        }else
        {
            no = 1;
        }
    voiceSoundImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"语音播放%ld.png",(long)no]];
    timeCount = count/5;
    if (timeCount < 60) {
        if (timeCount < 10) {
            timeLabel.text = [NSString stringWithFormat:@"00:0%ld",(long)timeCount];
        }else
        {
            timeLabel.text = [NSString stringWithFormat:@"00:%ld",(long)
                              timeCount];
        }
    }else
    {
        [_timer invalidate];
        _timer = nil;
        [recordTool stopRecording];
        RecordStatusIma.image = [UIImage imageNamed:@"语音备注-默认"];
        RecordStatusLabel.text = @"按住说话";
        remarkRecord.text = @"语音备注";
    }
    
}

#pragma mark -- UITableViewDataSource && UITablevViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 48;
    }else
    {
        return 140;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * idefi = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idefi];
    if (indexPath.section ==0 && indexPath.row == 0) {
        followUplable = (UILabel *)[cell viewWithTag:99];
    }
    if (indexPath.section ==0 && indexPath.row == 1) {
        dataTimeLabel = (UILabel *)[cell viewWithTag:100];
        dataTimeLabel.text = [self dateToString:[NSDate date]];
    }
    if (indexPath.section == 1) {
        remarkTextView = (UITextView *)[cell viewWithTag:101];
        remarkTextView.delegate = self;
        holdView = [cell viewWithTag:102];
    }
    return cell ;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"请选择跟进方式"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"电话跟进",@"短信跟进",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        actionSheet.tag=800;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self showDatePicker];
    }
}




- (void)showDatePicker
{
    UIView * coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _cover = coverView;
    coverView.backgroundColor = [ProjectUtil colorWithHexString:@"80919191"];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCoverDisAppear)];
    [coverView addGestureRecognizer:tap];
    [self.view.window addSubview:coverView];
    _picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 200)];
    _picker.center = _cover.center;
    _picker.backgroundColor = [UIColor whiteColor];
    NSLocale * locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    _picker.locale = locale;
    NSDate * nowDate = [NSDate date];
    //最大时间
    NSCalendar * calendart = [[NSCalendar  alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * offset = [[NSDateComponents alloc]init];
    [offset setMonth:-6];
    NSDate * maxDate = [calendart dateByAddingComponents:offset toDate:nowDate options:0];
    _picker.maximumDate = nowDate;
    _picker.minimumDate = maxDate;
    _picker.datePickerMode = UIDatePickerModeDateAndTime ;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat maggin = 20;
    button.frame = CGRectMake(maggin, _picker.frame.size.height + _picker.frame.origin.y + maggin, self.view.width-maggin * 2, 41);
    [_cover addSubview:button];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitle:@"确定" forState:UIControlStateHighlighted];
    [button setBackgroundColor:[ProjectUtil colorWithHexString:@"e93a3b"]];
    [button addTarget:self action:@selector(pickerValueChange) forControlEvents:UIControlEventTouchUpInside];
    [_cover addSubview:_picker];
}
- (void)clickCoverDisAppear
{
    [_cover removeFromSuperview];
}
- (void)pickerValueChange
{
    dataTimeLabel.text = [self dateToString:_picker.date];
    [self clickCoverDisAppear];
}
- (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormat stringFromDate:date];
    // 时间转换成时间戳
    timeSp = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    
    return dateStr;
}

#pragma mark -- UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    holdView.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        holdView.hidden = NO;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 800)
    {
        switch (buttonIndex)
        {
            case 0:
                followUplable.text = @"电话跟进";
                break;
            case 1:
                followUplable.text = @"短信跟进";
                break;
        }
    }

}

- (void)refeshFollowUp:(MyRefreshBlock)block
{
    self.refreshBlock = block;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
