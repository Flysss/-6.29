//
//  DialViewController.m
//  SalesHelper_C
//
//  Created by summer on 14-10-10.
//  Copyright (c) 2014年 X. All rights reserved.
//
#import "SegmentView.h"
#import "DialViewController.h"
#import "CallDetailViewController.h"
#import "UIView+Five.h"

@interface DialViewController ()<UITextFieldDelegate,UIActionSheetDelegate>
{
    UIView *_phoneKeyBoardView;
    UITextField *_phoneField;
    UIButton *_phoneBtn;
  //  #warning 从服务器获取到的，主要目的是为了审批的时候关闭省钱电话，只用本机拨打
    /**打电话类型*/
    NSInteger TYPE_CALL;//打电话
}
@end

@implementation DialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
    
    UILabel * titleLabel = [UILabel new];
    titleLabel.text = @"免费电话";
    titleLabel.font = [UIFont systemFontOfSize:20];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
}

-(void)layoutSubViews{
    
    TYPE_CALL = 2;
    
    
    CGFloat topInputViewHeight = 50.0;
    CGFloat numBtnWidth = (SCREEN_WIDTH-0.5*2)/3.0;
    CGFloat numBtnHeight = numBtnWidth/2.0;
    CGFloat phoneKeyBoardViewHeight = topInputViewHeight+numBtnHeight*4+0.5*4;
    _phoneKeyBoardView = [CreatCustom creatUIViewWithFrame:CGRectMake(0, SCREEN_HEIGHT-64.0-49.0-49.0-phoneKeyBoardViewHeight, SCREEN_WIDTH, phoneKeyBoardViewHeight) BackgroundColor:RGBCOLOR(220, 220, 220)];
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 54, topInputViewHeight)];
    topLabel.text = @" +86";
    topLabel.textColor = [UIColor lightGrayColor];
    topLabel.backgroundColor = [UIColor whiteColor];
    topLabel.font =[UIFont systemFontOfSize:20];;
    [_phoneKeyBoardView addSubview:topLabel];
    
    _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(topLabel.right, 0, _phoneKeyBoardView.width-topLabel.width, topInputViewHeight)];
    _phoneField.delegate = self;
    _phoneField.textAlignment = NSTextAlignmentCenter;
    _phoneField.backgroundColor = [UIColor whiteColor];
    _phoneField.font = [UIFont systemFontOfSize:25];
    _phoneField.enabled = NO;
    _phoneField.textColor = [UIColor blackColor];
    _phoneField.text = @"";
    [_phoneKeyBoardView addSubview:_phoneField];
    NSInteger itemIndex = 0;
    NSArray *numBtnTitleArr = [NSArray arrayWithObjects:@"1     ",@"2 ABC ",@"3 DEF ",@"4 GHI ",@"5 JKL ",@"6 MNO ",@"7 PQRS",@"8 TUV ",@"9 WXYZ",@"",@"0 +   ",@"",nil];
    for (int i=0; i<4; i++)
    {
         for (int j=0; j<3; j++)
         {
             UIButton *numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
             numBtn.frame = CGRectMake((numBtnWidth +0.5)*j,0.5+_phoneField.bottom+(0.5+numBtnHeight)*i , numBtnWidth, numBtnHeight);
             
             [numBtn setBackgroundImage:[CreatCustom creatUIImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
             [numBtn setBackgroundImage:[CreatCustom creatUIImageWithColor:RGBCOLOR(232, 233, 233)] forState:UIControlStateHighlighted];
             NSString *numBtnStr = [numBtnTitleArr objectAtIndex:itemIndex];
             numBtn.tag = [numBtnStr integerValue];
             NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:numBtnStr attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:25] forKey:NSFontAttributeName]];
             if ((![numBtnStr isEqualToString:@""])&&(![numBtnStr isEqualToString:@"1"]))
             {
                 [attributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]
                                                ,NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange(2, attributedStr.length-2)];
             }
             if (![numBtnStr isEqualToString:@""])
             {
                 [numBtn addTarget:self action:@selector(numBtnAction:) forControlEvents:UIControlEventTouchUpInside];
             }
             [numBtn setAttributedTitle:attributedStr forState:UIControlStateNormal];
             [numBtn setAttributedTitle:attributedStr forState:UIControlStateHighlighted];
             [_phoneKeyBoardView addSubview:numBtn];
             itemIndex++;
         }
    }
    [self.view addSubview:_phoneKeyBoardView];
    
    UIButton *hiddenPhoneViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hiddenPhoneViewBtn.frame = CGRectMake(0, _phoneKeyBoardView.bottom, 90, 49.0);
    [hiddenPhoneViewBtn setImage:[UIImage imageNamed:@"bohjp_xia"] forState:UIControlStateNormal];
    [hiddenPhoneViewBtn setImage:[UIImage imageNamed:@"bohjp"] forState:UIControlStateSelected];
    [hiddenPhoneViewBtn addTarget:self action:@selector(hiddenKeyBoardViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [hiddenPhoneViewBtn setBackgroundColor:RGBCOLOR(230, 236, 240)];
    [self.view addSubview:hiddenPhoneViewBtn];
    
    _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _phoneBtn.frame = CGRectMake(hiddenPhoneViewBtn.right, _phoneKeyBoardView.bottom, SCREEN_WIDTH-hiddenPhoneViewBtn.width*2, 49.0);
    [_phoneBtn setTitle:@"呼叫" forState:UIControlStateNormal];
    _phoneBtn.backgroundColor = RGBCOLOR(136, 136, 136);//RGBCOLOR(34, 160, 43);
    [_phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_phoneBtn addTarget:self action:@selector(phoneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _phoneBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:_phoneBtn];
    
   UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(_phoneBtn.right, _phoneKeyBoardView.bottom, 90, 49.0);
    [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteBtn setBackgroundColor:RGBCOLOR(230, 236, 240)];
    [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
}



#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * MOBILE = @"^1([0-9])\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if (![regextestmobile evaluateWithObject:_phoneField.text]) {
        [self.view makeToast:@"请输入正确的手机号码"];
        return;
    }
//    else
//    {
//        switch (1) {
//                
//            case 1:{//系统
//                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phoneField.text];
//                UIWebView * callWebview = [[UIWebView alloc] init];
//                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//                [self.view addSubview:callWebview];
//            }
//                break;
//                
//            case 2:{//省钱
//                CallDetailViewController *callDetailVC = [[CallDetailViewController alloc]init];
//                callDetailVC.phoneNumber = _phoneField.text;
//                [self.navigationController presentViewController:callDetailVC animated:YES completion:nil];
//            }
//                break;
//                
//            case 3:{//都显示
//                NSMutableArray * arr = [[NSMutableArray alloc] init];
//                [arr addObject:@{@"text" : @"本机呼叫" , @"type" : @"1"}];
//                [arr addObject:@{@"text" : @"省钱电话" , @"type" : @"2"}];
//                
////                                [self.view ShowData:arr Height:250 CellSelected:^(NSDictionary *dic) {
////                                    if ([[dic valueForKey:@"type"] isEqualToString:@"1"]) {
////                                        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phoneField.text];
////                                        UIWebView * callWebview = [[UIWebView alloc] init];
////                                        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
////                                        [self.view addSubview:callWebview];
////                                    }
////                                    else if ([[dic valueForKey:@"type"] isEqualToString:@"2"]) {
////                                        CallDetailViewController *callDetailVC = [[CallDetailViewController alloc] init];
////                                        callDetailVC.phoneNumber = _phoneField.text;
////                                        [self.navigationController presentViewController:callDetailVC animated:YES completion:nil];
////                                    }
////                                }];
//            }
//                break;
//                
//            default:{//默认系统
//                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phoneField.text];
//                UIWebView * callWebview = [[UIWebView alloc] init];
//                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//                [self.view addSubview:callWebview];
//            }
//                break;
//                
//        }
    

    
    if (buttonIndex == 0) {//省钱电话拨打
        
                CallDetailViewController *callDetailVC = [[CallDetailViewController alloc]init];
                callDetailVC.phoneNumber = _phoneField.text;
                [self presentViewController:callDetailVC animated:YES completion:nil];
    }else if (buttonIndex == 1)
    {//系统电话拨打
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSString *telUrl = [NSString stringWithFormat:@"tel:%@",_phoneField.text];
        NSURL *telURL =[NSURL URLWithString:telUrl];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebview];
    }else if(buttonIndex==2){//取消
        
        return;
    }
//}
}

#pragma mark 拨打按钮
- (void)phoneBtnAction:(id)sender{
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"拨打电话"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"省钱电话拨打",@"系统拨打", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

    
//    
//    
//    NSString * MOBILE = @"^1([0-9])\\d{9}$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    if (![regextestmobile evaluateWithObject:_phoneField.text]) {
//        [self.view makeToast:@"请输入正确的手机号码"];
//        return;
//    }
//    else
//    {
//        switch (TYPE_CALL) {
//                
//            case 1:{//系统
//                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phoneField.text];
//                UIWebView * callWebview = [[UIWebView alloc] init];
//                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//                [self.view addSubview:callWebview];
//            }
//                break;
//                
//            case 2:{//省钱
//                CallDetailViewController *callDetailVC = [[CallDetailViewController alloc]init];
//                callDetailVC.phoneNumber = _phoneField.text;
//                [self.navigationController presentViewController:callDetailVC animated:YES completion:nil];
//            }
//                break;
//                
//            case 3:{//都显示
//                NSMutableArray * arr = [[NSMutableArray alloc] init];
//                [arr addObject:@{@"text" : @"本机呼叫" , @"type" : @"1"}];
//                [arr addObject:@{@"text" : @"省钱电话" , @"type" : @"2"}];
//                
////                [self.view ShowData:arr Height:250 CellSelected:^(NSDictionary *dic) {
////                    if ([[dic valueForKey:@"type"] isEqualToString:@"1"]) {
////                        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phoneField.text];
////                        UIWebView * callWebview = [[UIWebView alloc] init];
////                        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
////                        [self.view addSubview:callWebview];
////                    }
////                    else if ([[dic valueForKey:@"type"] isEqualToString:@"2"]) {
////                        CallDetailViewController *callDetailVC = [[CallDetailViewController alloc] init];
////                        callDetailVC.phoneNumber = _phoneField.text;
////                        [self.navigationController presentViewController:callDetailVC animated:YES completion:nil];
////                    }
////                }];
//            }
//                break;
//                
//            default:{//默认系统
//                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phoneField.text];
//                UIWebView * callWebview = [[UIWebView alloc] init];
//                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//                [self.view addSubview:callWebview];
//            }
//                break;
//                
//        }
//    }
}


#pragma mark 数字按钮
- (void)numBtnAction:(id)sender{
    UIButton *numBtn = (UIButton *)sender;
    
    NSString *phoneNumberStr =   [_phoneField.text stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)numBtn.tag]];
    if (phoneNumberStr.length==0)
    {
        _phoneBtn.backgroundColor = RGBCOLOR(136, 136, 136);
    }
    else
    {
        _phoneBtn.backgroundColor = RGBCOLOR(120, 120, 120);
    }
    
    _phoneField.text = phoneNumberStr;
    
    if(_phoneField.text.length > 0){
        self->_phoneBtn.backgroundColor = RGBCOLOR(34, 160, 43);
        self->_phoneBtn.enabled = YES;
    }
    else{
        self->_phoneBtn.backgroundColor = RGBCOLOR(136, 136, 136);
        self->_phoneBtn.enabled = NO;
    }
}



#pragma mark 删除按钮
- (void)deleteBtnAction:(id)sender{
    NSString *textStr = _phoneField.text;
    if (textStr.length>0)
    {
          _phoneField.text = [textStr substringToIndex:textStr.length-1];
        if (_phoneField.text.length==0)
        {
             _phoneBtn.backgroundColor = RGBCOLOR(136, 136, 136);
        }
    }
  
    if(_phoneField.text.length > 0){
        self->_phoneBtn.backgroundColor = RGBCOLOR(34, 160, 43);
        self->_phoneBtn.enabled = YES;
    }
    else{
        self->_phoneBtn.backgroundColor = RGBCOLOR(136, 136, 136);
        self->_phoneBtn.enabled = NO;
    }
}

#pragma mark 隐藏输入键盘
- (void)hiddenKeyBoardViewAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    [UIView animateWithDuration:0.3 animations:^{
        if (btn.selected)
        {
            [_phoneKeyBoardView setTop:SCREEN_HEIGHT-64.0];
        }
        else
        {
            [_phoneKeyBoardView setTop:SCREEN_HEIGHT-64.0-_phoneKeyBoardView.height-49.0-49.0];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
