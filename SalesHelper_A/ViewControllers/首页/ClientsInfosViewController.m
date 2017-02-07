//
//  ClientsInfosViewController.m
//  SalesHelper_A
//
//  Created by summer on 15/11/3.
//  Copyright © 2015年 X. All rights reserved.
//

#import "ClientsInfosViewController.h"
#import <MessageUI/MessageUI.h>
#import "CustmorStatusTableViewCell.h"
#import "ClientsEditViewController.h"
#import "ClientsFollowUpViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "TimeLineViewController.h"

@interface ClientsInfosViewController ()<UITableViewDelegate,UITableViewDataSource,MFMessageComposeViewControllerDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView * myTableView;
@end

@implementation ClientsInfosViewController
{
    UILabel *namePicLabel;

    UILabel *nameLabel;

    UILabel *levelLabel;

    UILabel *sexLabel;
    
    UIImageView *faceImageView;
    
    UILabel * phoneLabel;
    
    NSMutableArray * dataArr;
    
    NSInteger  pageIndex;
    
    UIView * _cover;
    
    NSMutableArray * followUpArr;
    
    UILabel * followUpLabel;
    
    UILabel * remarsLabel;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"客户详情";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];

    _myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _myTableView.emptyDataSetDelegate = self;
    _myTableView.emptyDataSetSource = self;

    [self sendRequst];
    [self requestForFollowUp];
}

//pop
- (void)backlastView
{
    if (self.refreshBlock)
    {
        self.refreshBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)refeshCLientsManager:(MyRefreshBlock)block
{
    self.refreshBlock = block;
}

#pragma mark -- request
-(void)sendRequst
{
    pageIndex = 1;
    NSString * pageStr = [NSString stringWithFormat:@"%ld",(long)pageIndex];
    NSDictionary * param = @{
                             @"token":self.login_user_token,
                             @"phone":[self.custmorData objectForKey:@"phone"],
                             @"Page":pageStr,
                             @"size":@"12",
                             };
    RequestInterface * loadPerpoty = [[RequestInterface alloc] init];
    
    [self.view Loading_0314];
    [loadPerpoty requestGetCustomerQueryRecWithParam:param];
    [loadPerpoty getInterfaceRequestObject:^(id data)
     {
         if ([data objectForKey:@"success"])
         {
             [self.view Hidden];
             NSArray * arr = [data objectForKey:@"datas"];
             if (arr.count != 0) {
                 dataArr = [NSMutableArray array];
                 [dataArr addObjectsFromArray:[data objectForKey:@"datas"]];
                 [_myTableView reloadData];
             }
         }
         else
         {
             [self.view Hidden];
             [self.view makeToast:@"加载失败"];
         }
     } Fail:^(NSError *error) {
         [self.view Hidden];
     }];
    
}

- (void)requestForFollowUp
{
    NSString * pageStr = [NSString stringWithFormat:@"%ld",(long)pageIndex];
    NSDictionary * param = @{
                             @"token":self.login_user_token,
                             @"recommendId":[self.custmorData objectForKey:@"id"],
                             @"Page":pageStr,
                             @"size":@"10",
                             };
    RequestInterface * loadPerpoty = [[RequestInterface alloc]init];
    
    [self.view Loading_0314];
    [loadPerpoty requestFollowUpDatasWith:param];
    [loadPerpoty getInterfaceRequestObject:^(id data)
     {
         if ([[data objectForKey:@"success"] boolValue]) {
             [self.view Hidden];
             NSArray * arr = [data objectForKey:@"datas"];
             if (arr.count == 0) {
                 followUpLabel.text = @"暂无跟进记录";
             }else{
                 followUpArr = [NSMutableArray array];
                 [followUpArr addObjectsFromArray:[data objectForKey:@"datas"]];
                 followUpLabel.text = [ProjectUtil timestampToStrDate:[[[data objectForKey:@"datas"] objectAtIndex:0]objectForKey:@"recodeTime"]];
                 [_myTableView reloadData];
             }
         }else
         {
             [self.view Hidden];
             [self.view makeToast:@"加载失败"];
         }
         
     } Fail:^(NSError *error) {
         [self.view Hidden];
     }];

}

#pragma mark -- UITabelViewDataSource && UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                return 70;
            }else
            {
                return 50;
            }
            break;
        case 1:
            return 50;
            break;
        case 2:
            return 66;
            break;
            
        default:
            return 1;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return dataArr.count;
            break;
        default:
            return 0;
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * idefi = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idefi];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        namePicLabel = (UILabel *)[cell viewWithTag:11];
        
        nameLabel = (UILabel *)[cell viewWithTag:12];
        
        levelLabel = (UILabel *)[cell viewWithTag:14];

        sexLabel = (UILabel *)[cell viewWithTag:13];
        
        faceImageView = (UIImageView *)[cell viewWithTag:10];
        UILabel * level = (UILabel *)[cell viewWithTag:999];
        
        namePicLabel.text = [[_custmorData objectForKey:@"name"] substringToIndex:1];
        namePicLabel.layer.cornerRadius = 19;
        namePicLabel.layer.masksToBounds = YES;
        nameLabel.text = [_custmorData objectForKey:@"name"];
        namePicLabel.backgroundColor = [ProjectUtil colorWithHexString:[ProjectUtil makeColorStringWithNameStr:[_custmorData objectForKey:@"name"]]];
        
        if ([_custmorData objectForKey:@"intention_rank"] == nil ||
            [_custmorData objectForKey:@"intention_rank"] == [NSNull null] ||
            [[_custmorData objectForKey:@"intention_rank"] isEqualToString:@""])
        {
            level.hidden = YES;
            levelLabel.hidden = YES;
        }
        else
        {
            levelLabel.text = [_custmorData objectForKey:@"intention_rank"];
            
        }
        levelLabel.layer.borderWidth = 0.5;
        levelLabel.layer.cornerRadius = 2;
        levelLabel.layer.borderColor = [ProjectUtil colorWithHexString:@"EF5F5F"].CGColor;
        NSString * str =  [[_custmorData objectForKey:@"sex"] boolValue] ? @"女" : @"男";
        NSString * ageStr ;
        
        NSLog(@"%@", _custmorData);
        
        //对年龄进行是否为空判断
        if (
            
            [_custmorData objectForKey:@"age"] == nil ||
            [_custmorData objectForKey:@"age"] == [NSNull null] ||
            [[_custmorData objectForKey:@"age"] isEqualToString:@""]
            )
        {
            ageStr = @"未填写";
        }
        else
        {
            ageStr = [NSString stringWithFormat:@"%@岁",[_custmorData objectForKey:@"age"]];
        }
        sexLabel.text = [NSString stringWithFormat:@"%@  %@",str, ageStr];
        
#pragma mark --客户详情的头像，从上一页传进来的数据
        faceImageView.layer.cornerRadius = 19;
        faceImageView.layer.masksToBounds = YES;
//        NSString *faceUrl = _custmorData[@"face"];
        if ([_custmorData objectForKey:@"face"] != nil &&
            [_custmorData objectForKey:@"face"] != [NSNull null] &&
            ![[_custmorData objectForKey:@"face"] isEqualToString:@""] &&
            ![[_custmorData objectForKey:@"face"] isEqualToString:@"<null>"]
            )
        {
            [faceImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Image_Url, [_custmorData objectForKey:@"face"]]] placeholderImage:[UIImage imageNamed:@"客户-客户管理.png"]];
            namePicLabel.hidden = YES;
            faceImageView.hidden = NO;
        }
        else
        {
            faceImageView.hidden = YES;
            namePicLabel.hidden = NO;
            
        }

    }
    if(indexPath.section == 0 && indexPath.row == 1)
    {
        phoneLabel = (UILabel *)[cell viewWithTag:20];
        phoneLabel.text = [NSString stringWithFormat:@"%@",[_custmorData objectForKey:@"phone"]];
    }
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        followUpLabel = (UILabel *)[cell viewWithTag:100];
    }
    if(indexPath.section == 1 && indexPath.row == 1)
    {
        remarsLabel = (UILabel *)[cell viewWithTag:1024];
        if ([_custmorData objectForKey:@"remarks"] != nil && [_custmorData objectForKey:@"remarks"] && [_custmorData objectForKey:@"remarks"] != [NSNull null]) {
            remarsLabel.text = [_custmorData objectForKey:@"remarks"];
        }
    }
    if (indexPath.section == 2) {
        CustmorStatusTableViewCell * cell = (CustmorStatusTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        cell.dataSource = [dataArr objectAtIndex:indexPath.row];
        
        cell.takeLookBtn.tag = indexPath.row;
        [cell.takeLookBtn addTarget:self action:@selector(clickDimensionalBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }

    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"ClientsManager" bundle:nil];
#pragma mark --跳转到编辑状态
        ClientsEditViewController * recommend = [storyboard instantiateViewControllerWithIdentifier:@"ClientsEditViewController"];
        recommend.custmorData = self.custmorData;
        [self.navigationController pushViewController:recommend animated:YES];
        __weak typeof(self)WS = self;
        [recommend refesh:^(NSDictionary *dict) {
            _custmorData = dict;
            WS.isEdit = YES;
            [_myTableView reloadData];
        }];
    }
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"ClientsManager" bundle:nil];
        ClientsFollowUpViewController * recommend = [storyboard instantiateViewControllerWithIdentifier:@"ClientsFollowUpViewController"];
        if (followUpArr) {
            recommend.followDataSource = followUpArr;
        }
        recommend.personalDic = _custmorData;
        [self.navigationController pushViewController:recommend animated:YES];
    }
    if (indexPath.section == 2)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        TimeLineViewController *vc= [[ TimeLineViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.propertyInfo = [dataArr objectAtIndex:indexPath.row];
        vc.timeLineID = dataArr[indexPath.row][@"id"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
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
    if ([MFMessageComposeViewController canSendText])
    {
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

#pragma mark -- 带看二维码
- (void)clickDimensionalBtn:(UIButton *)button
{
//    UITableViewCell * cell = (UITableViewCell *)[[button superview] superview];
//    NSIndexPath * path = [_myTableView indexPathForCell:cell];
//    NSDictionary * dict = [dataArr objectAtIndex:path.row];
//    NSArray * dataSource = [dict objectForKey:@"data"];
//    NSString * string = [NSString stringWithFormat:@"ThinkPower_%@",[[dataSource objectAtIndex:path.row / 2]objectForKey:@"id"]];
//    UIImage * image = [UIImage creatQRFromString:string withIconImage:nil];
//    [self showQRWithQRimage:image];
//}

NSString *IdStr = dataArr[button.tag][@"id"];
NSString *string = [NSString stringWithFormat:@"ThinkPower_%@", IdStr];
CIImage *image1 = [self createQRForString:string];

UIImage *image2 = [self createNonInterpolatedUIImageFormCIImage:image1 withSize:170];

[self showQRWithQRimage:image2];
}


//生成二维码图片，但没有大小限制
- (CIImage *)createQRForString:(NSString *)qrString
{
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}
//将二维码图片，设置大小
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)showQRWithQRimage:(UIImage *)QRimage
{
    UIView * coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _cover = coverView;
    coverView.backgroundColor = [ProjectUtil colorWithHexString:@"80919191"];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCoverDisAppear)];
    [coverView addGestureRecognizer:tap];
    [self.view.window addSubview:coverView];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(72, 27, 200, 20)];
    label.text = @"带看二维码";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [ProjectUtil colorWithHexString:@"464646"];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 233, 268)];
    imageView.image = [UIImage imageNamed:@"波纹背景.png"];
    CGPoint center = imageView.center;
    center.x = self.view.center.x;
    center.y = self.view.center.y;
    imageView.center = center;
    UIImageView * QRImageView = [[UIImageView alloc]initWithFrame:CGRectMake(31, 65, 170, 170)];
    QRImageView.image = QRimage;
    [imageView addSubview:QRImageView];
    [imageView addSubview:label];
    [_cover addSubview:imageView];
}
- (void)clickCoverDisAppear
{
    [_cover removeFromSuperview];
}
#pragma mark -- 空白页面
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    text = @"该条件下没有数据";
    font =  Default_Font_12;
    textColor = [ProjectUtil colorWithHexString:@"808080"];
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"灰色.png"];
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

