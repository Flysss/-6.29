//
//  ClientsFollowUpViewController.m
//  SalesHelper_A
//
//  Created by summer on 15/11/5.
//  Copyright © 2015年 X. All rights reserved.
//

#import "ClientsFollowUpViewController.h"
#import "FollowUpTableViewCell.h"
#import "ClientsAddFollowUpViewController.h"
#import "LVRecordTool.h"
#import "FollowUpDoubleTableViewCell.h"
#import "DOUAudioStreamer.h"
#import <MessageUI/MessageUI.h>


@interface Track : NSObject <DOUAudioFile>
@property (nonatomic, strong) NSURL *audioFileURL;
@end

@implementation Track
@end

@interface ClientsFollowUpViewController () <UITableViewDataSource, UITableViewDelegate,MFMessageComposeViewControllerDelegate>

@end

@implementation ClientsFollowUpViewController
{
    UILabel *namePicLabel;
    
    UILabel *nameLabel;
    
    UILabel *levelLabel;
    
    UILabel *sexLabel;
    
    UIImageView *faceImageView;
    
    UILabel * phoneLabel;
    
    NSMutableArray * dataArr;
    
    NSInteger  pageIndex;
    
    __weak IBOutlet UITableView *myTable;

    UIView * _cover;
    
    NSMutableArray * followUpArr;
    
    UILabel * followUpLabel;
    NSMutableDictionary * _offscreenCells;
    DOUAudioStreamer * _streamer;
    Track * myTrack;
    NSTimer * myTimer;
    
    UILabel *lineLabe;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.followDataSource = [NSMutableArray array];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:@selector(add)];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"跟进记录";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    [self.rightBtn setImage:[UIImage imageNamed:@"销邦-首页-新-增加.png"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"销邦-首页-新-增加.png"] forState:UIControlStateHighlighted];
    [self refresh];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    backView.backgroundColor = [UIColor whiteColor];
    lineLabe = [[UILabel alloc] initWithFrame:CGRectMake(48, 70, 0.5, SCREEN_HEIGHT-64-70)];
    lineLabe.backgroundColor = [UIColor hexChangeFloat:@"d0d0d0"];
    [backView addSubview:lineLabe];
    [myTable setBackgroundView:backView];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -70)
        
    {
        lineLabe.frame = CGRectMake(48, 70-scrollView.contentOffset.y, 0.5, SCREEN_HEIGHT-64-70+scrollView.contentOffset.y);
    }
    else if (scrollView.contentOffset.y > 0)
    {
        lineLabe.frame = CGRectMake(48, 70-scrollView.contentOffset.y, 0.5, SCREEN_HEIGHT-64-70+scrollView.contentOffset.y);
    }
    else
    {
        lineLabe.frame = CGRectMake(48, 70, 0.5, SCREEN_HEIGHT-64-70);
    }
    
}





- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_streamer stop];
    if (myTimer) {
        [myTimer invalidate];
        myTimer = nil;
    }
    _streamer = nil;
}
- (void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --添加跟进记录
- (void)add
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"ClientsManager" bundle:nil];
    ClientsAddFollowUpViewController * recommend = [storyboard instantiateViewControllerWithIdentifier:@"ClientsAddFollowUpViewController"];
    recommend.userID = [self.personalDic objectForKey:@"id"];
    __weak  typeof(&*self)WS  = self;
    [recommend refeshFollowUp:^{
        [WS refresh];
    }];
    [self.navigationController pushViewController:recommend animated:YES];
    
}


////准确行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            if (indexPath.row == 0)
            {
                return 70;
            }
            else
            {
                return 50;
            }
            break;
        case 1:
        {
            if ([[self.followDataSource[indexPath.row] objectForKey:@"recodeType"] isEqualToNumber:@1])
            {
                return 120;
            }
            else if  ([[self.followDataSource[indexPath.row] objectForKey:@"recodeType"] isEqualToNumber:@2])
            {
              CGFloat labelHeight  =  [self boundingRectWithSize:CGSizeMake(self.view.width - 100, MAXFLOAT) withString:[[self.followDataSource objectAtIndex:indexPath.row] objectForKey:@"remarks"] font:[UIFont systemFontOfSize:12]].height;
                return labelHeight+98;
            }
            else
            {
                CGFloat labelHeight = [self boundingRectWithSize:CGSizeMake(self.view.width - 100, MAXFLOAT) withString:[[self.followDataSource objectAtIndex:indexPath.row] objectForKey:@"remarks"] font:[UIFont systemFontOfSize:12]].height;
                
                if (self.view.width == 320)
                {
                    return labelHeight+156;
                }
                else
                {
                    return labelHeight + 145;
                }
            }
        }
            break;

        default:
            return 1;
            break;
    }
}
//估算行高
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    } else {
        return 120;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    headerView.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return self.followDataSource.count;
            break;
        default:
            return 0;
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 20, 0, 0);

        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:inset];
        }
        
        
        if (IOS_VERSION >= 8.0) {
            if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
            {
                [cell setPreservesSuperviewLayoutMargins:NO];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:inset];
            }
        }
    } else
    {
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 48, 0, SCREEN_WIDTH-48-0.5);
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:inset];
        }
        
        
        if (IOS_VERSION >= 8.0) {
            if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
            {
                [cell setPreservesSuperviewLayoutMargins:NO];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:inset];
            }
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * idefi = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idefi];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            namePicLabel = [cell viewWithTag:11];
            
            nameLabel = [cell viewWithTag:12];
            
            levelLabel = [cell viewWithTag:14];
            
            sexLabel= [cell viewWithTag:13];
            
            faceImageView= [cell viewWithTag:10];
            
            UILabel * level = [cell viewWithTag:999];
            
            namePicLabel.text = [[_personalDic objectForKey:@"name"] substringToIndex:1];
            namePicLabel.layer.cornerRadius = 19;
            namePicLabel.layer.masksToBounds = YES;
            nameLabel.text = [_personalDic objectForKey:@"name"];
            namePicLabel.backgroundColor = [ProjectUtil colorWithHexString:[ProjectUtil makeColorStringWithNameStr:[_personalDic objectForKey:@"name"]]];
            
            if ([_personalDic objectForKey:@"intention_rank"] == nil ||
                [_personalDic objectForKey:@"intention_rank"] == [NSNull null] ||
                [[_personalDic objectForKey:@"intention_rank"] isEqualToString:@""])
            {
                level.hidden = YES;
                levelLabel.hidden = YES;
            }
            else
            {
                levelLabel.text = [_personalDic objectForKey:@"intention_rank"];
            }
            levelLabel.layer.borderWidth = 0.5;
            levelLabel.layer.cornerRadius = 2;
            levelLabel.layer.borderColor = [ProjectUtil colorWithHexString:@"EF5F5F"].CGColor;
            NSString * str =  [[_personalDic objectForKey:@"sex"] boolValue] ? @"女" : @"男";
            NSString * ageStr ;
            
            
            if ([_personalDic objectForKey:@"age"] != nil &&
                [_personalDic objectForKey:@"age"] != [NSNull null] &&
                ![[_personalDic objectForKey:@"age"] isEqualToString:@""] &&
                ![[_personalDic objectForKey:@"age"] isEqualToString:@"<null>"]
                )
            {
                ageStr = [NSString stringWithFormat:@"%@岁", [_personalDic objectForKey:@"age"]];
            }
            else
            {
                ageStr = @"未填写";
            }
            sexLabel.text = [NSString stringWithFormat:@"%@  %@",str,ageStr];
            
            faceImageView.layer.cornerRadius = 19;
            faceImageView.layer.masksToBounds = YES;
            
            //        NSString *faceUrl = _personalDic[@"dic"];
            
            NSLog(@"%@", _personalDic);
            if (/**faceUrl == nil || [faceUrl isEqualToString:@"<null>"]*/
                [_personalDic objectForKey:@"face"] == nil ||
                [_personalDic objectForKey:@"face"] == [NSNull null] ||
                [[_personalDic objectForKey:@"face"] isEqualToString:@""] ||
                [[_personalDic objectForKey:@"face"] isEqualToString:@"<null>"]
                )
            {
                faceImageView.hidden = YES;
                namePicLabel.hidden = NO;
            }
            else
            {
                [faceImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Image_Url, [_personalDic objectForKey:@"face"]]] placeholderImage:[UIImage imageNamed:@"客户-客户管理.png"]];
                namePicLabel.hidden = YES;
            }

            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            lineLabel.backgroundColor = [UIColor hexChangeFloat:@"d0d0d0"];
            [cell.contentView addSubview:lineLabel];
            
        } else if (indexPath.row == 1) {
            phoneLabel = [cell viewWithTag:20];
            phoneLabel.text = [NSString stringWithFormat:@"%@",[_personalDic objectForKey:@"phone"]];
            
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
            lineLabel.backgroundColor = [UIColor hexChangeFloat:@"d0d0d0"];
            [cell.contentView addSubview:lineLabel];
        }
    }
    
    
    if(indexPath.section == 1)
    {
        if (![[self.followDataSource[indexPath.row] objectForKey:@"recodeType"]isEqualToNumber:@3]) {
          
            FollowUpTableViewCell * cell = [myTable dequeueReusableCellWithIdentifier:@"FollowUp"];
            cell.dataSource = self.followDataSource[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            __weak typeof(&*self)WS = self;
            __block typeof(&*cell)WScell = cell;
            
            if ([[self.followDataSource[indexPath.row] objectForKey:@"recodeType"]  isEqualToNumber:@1])
            {
                [cell addClickTargetWithVoice:^{
                    [WS playWithURLString:[[WS.followDataSource objectAtIndex:indexPath.row] objectForKey:@"voiceUrl"] uploadLabel:WScell.voiceTimeLabel];
                }];
            }
            return cell;
        }
        else
        {
            FollowUpDoubleTableViewCell * cell = [myTable dequeueReusableCellWithIdentifier:@"FollowUpDouble"];
            cell.dataSource = self.followDataSource[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof(&*self)WS = self;
            __block typeof(&*cell)WScell = cell;
            
            [cell addClickTargetWithVoice:^{
                [WS playWithURLString:[[WS.followDataSource objectAtIndex:indexPath.row] objectForKey:@"voiceUrl"] uploadLabel:WScell->voiceTimeLabel];
            }];
            
            return cell;
        }
    }

    return  cell;
}

//播放录音
- (void)playWithURLString:(NSString *)urtString uploadLabel:(UILabel *)label
{
    if (myTimer) {
        [myTimer invalidate];
    }
    
    if (!_streamer) {
        myTrack = [[Track alloc] init];
        myTrack.audioFileURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.hfapp.cn/%@",urtString]];
        _streamer = [[DOUAudioStreamer alloc] initWithAudioFile:myTrack];
//        [DOUAudioStreamer setHintWithAudioFile:myTrack];
    }
    if ([_streamer status] == DOUAudioStreamerPlaying)
    {
        [_streamer stop];
        _streamer = nil;
        return;
    }
    
    if ([_streamer status] == DOUAudioStreamerBuffering)
    {
        [_streamer stop];
        _streamer = nil;
        NSLog(@"缓冲呢");
    }
   
    if ([_streamer status] == DOUAudioStreamerFinished)
    {
        NSLog(@"播放完毕呢");
        _streamer = nil;
        [_streamer play];
        return;
    }
    myTimer =  [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(playMusic:) userInfo:label repeats:YES];
    [_streamer play];
    
}

#pragma mark --定时改变label的显示文字
- (void)playMusic:(NSTimer *)time
{
    UILabel * label = (UILabel *)[time userInfo];
    NSInteger timeCount = (NSInteger)[_streamer currentTime];
    NSString * str ;
    
    if (timeCount < 10) {
        str = [NSString stringWithFormat:@"00:0%ld",(long)timeCount];
    }else
    {
        str = [NSString stringWithFormat:@"00:%ld",(long)timeCount];
    }
    label.text = [NSString stringWithFormat:@"%@",str];
    if ([_streamer duration]) {
        NSLog(@"%f",[_streamer duration]);
    }
    if ([_streamer status] == DOUAudioStreamerBuffering)
    {
        [_streamer stop];
        _streamer = nil;
    }
    if ([_streamer status] == DOUAudioStreamerIdle)
    {
    }
    if ([_streamer status] == DOUAudioStreamerFinished)
    {
        [_streamer stop];
        _streamer = nil;
        [myTimer invalidate];
    }
    //    label.text = [NSString stringWithFormat:@"%f",[_streamer duration]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)boundingRectWithSize:(CGSize)size withString:(NSString *)string font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    CGSize retSize = [string boundingRectWithSize:size
                                          options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}
#pragma mark -- call && message
- (IBAction)call:(id)sender {
    NSURL * url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"tel:%@",phoneLabel.text]];
    
    NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    UIWebView * webView = [[UIWebView alloc] init];
    [webView loadRequest:urlRequest];
    
    [self.view addSubview:webView];
}
- (IBAction)message:(id)sender {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController * messageVC = [[MFMessageComposeViewController alloc] init];
        messageVC.messageComposeDelegate = self;
        messageVC.navigationBar.tintColor = [UIColor blueColor];
        messageVC.recipients = [NSArray arrayWithObject:phoneLabel.text];
        [self.navigationController presentViewController:messageVC animated:YES completion:nil];
    }
    
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}







- (void)refresh
{
    [self.view Loading_0314];
    NSDictionary * param = @{
                             @"token":self.login_user_token,
                             @"recommendId":[self.personalDic objectForKey:@"id"],
                             @"Page":@1,
                             @"size":@10,
                             };
    RequestInterface * interfff = [[RequestInterface alloc] init];
    
    [interfff requestFollowUpDatasWith:param];
    [interfff getInterfaceRequestObject:^(id data)
     {
         
         NSLog(@"%@", data);
        
         if ([[data objectForKey:@"success"] boolValue]) {
             [self.view Hidden];
             NSArray * arrM = [data objectForKey:@"datas"];
             
             if (self.followDataSource)
             {
                 [self.followDataSource removeAllObjects];
             }
             else
             {
                 self.followDataSource = [NSMutableArray array];
             }
             [self.followDataSource addObjectsFromArray:arrM];
             [myTable reloadData];
         }else
         {
             [self.view Hidden];
             [self.view makeToast:@"加载失败"];
         }
         
     } Fail:^(NSError *error) {
         [self.view Hidden];
         NSLog(@"%@",error);
     }];
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
