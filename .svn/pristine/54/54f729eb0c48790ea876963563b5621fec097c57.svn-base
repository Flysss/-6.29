//
//  UserGuideViewController.m
//  AnJieWealth
//
//  Created by ZhipuTech on 14-7-27.
//  Copyright (c) 2014年 deayou. All rights reserved.
//

#import "UserGuideViewController.h"
//#import "LoginViewController.h"

@interface UserGuideViewController ()
{
    NSArray *_imageArr;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    int with;
    int height;
}
@end

@implementation UserGuideViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        _imageArr = @[@"销邦-引导页1.png",@"销邦-引导页2.png",@"销邦-引导页3.png"];
        _imageArr = @[@"引导页a.png",@"引导页b.png",@"引导页c.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //存数据--->基本数据类型
    [defaults setBool:YES forKey:@"SalesHelper_isNeedDrawal"];//是否需要设置提现账户
    [defaults synchronize];

    
    //计算contentSize宽度
    CGFloat scrollViewWidth = _imageArr.count* SCREEN_WIDTH;

    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    if (IOS_VERSION < 7.0) {
        [_scrollView setTop:0];
    }
    _scrollView.contentSize = CGSizeMake(scrollViewWidth, _scrollView.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    
    for (int i=0; i<_imageArr.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, _scrollView.top, _scrollView.width, _scrollView.height)];
//        NSString *path;
//        if (SCREEN_HEIGHT==480)
//        {
//            path = [[NSBundle mainBundle] pathForResource:[_imageArr objectAtIndex:i] ofType:@"jpg"];
//            imageView.image = [UIImage imageWithContentsOfFile:path];
//        }else if (SCREEN_HEIGHT==568)
//        {
//            path = [[NSBundle mainBundle] pathForResource:[[_imageArr objectAtIndex:i] stringByAppendingString:@"_4inch"] ofType:@"jpg"];
//            imageView.image = [UIImage imageWithContentsOfFile:path];
//        }else if (SCREEN_HEIGHT == 1334/2) {
//            path = [[NSBundle mainBundle] pathForResource:[[_imageArr objectAtIndex:i] stringByAppendingString:@"_4.7inch"] ofType:@"jpg"];
//            imageView.image = [UIImage imageWithContentsOfFile:path];
//        }else if (SCREEN_HEIGHT == 1472/2) {
//            path = [[NSBundle mainBundle] pathForResource:[[_imageArr objectAtIndex:i] stringByAppendingString:@"_5.5inch"] ofType:@"jpg"];
//            imageView.image = [UIImage imageWithContentsOfFile:path];
//        }
        imageView.image = [UIImage imageNamed:_imageArr[i]];
        
        imageView.userInteractionEnabled = YES;
        
        UIButton *enterAppBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnWidth = 175;
        CGFloat btnHeight = 40;
        enterAppBtn.frame = CGRectMake((imageView.width-btnWidth)/2, (imageView.height-70), btnWidth, btnHeight);
        [enterAppBtn setTitleColor:[ProjectUtil colorWithHexString:@"00a1ea"] forState:UIControlStateNormal];//RGBACOLOR(25, 182, 248, 1)
        [enterAppBtn setTitleColor:[ProjectUtil colorWithHexString:@"00a1ea"] forState:UIControlStateHighlighted];
        [enterAppBtn setTitle:@"进入销邦" forState:UIControlStateNormal];
        [enterAppBtn setTitle:@"进入销邦" forState:UIControlStateHighlighted];
        [enterAppBtn setBackgroundColor:[UIColor whiteColor]];
        enterAppBtn.titleLabel.font = Default_Font_20;
        [enterAppBtn addTarget:self action:@selector(enterAppAction) forControlEvents:UIControlEventTouchUpInside];
        
        enterAppBtn.layer.borderWidth = 0.5;
        enterAppBtn.layer.masksToBounds = YES;
        enterAppBtn.layer.borderColor = [ProjectUtil colorWithHexString:@"00a1ea"].CGColor;

        
        [imageView addSubview:enterAppBtn];
        [_scrollView addSubview:imageView];
    }

    CGFloat pageWidth = 30 * _imageArr.count;
    CGFloat pageHeight = 40 ;
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-pageWidth)/2, _scrollView.bottom-106-pageHeight/2 , pageWidth , pageHeight)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.pageIndicatorTintColor = [ProjectUtil colorWithHexString:@"dddddd"];
    _pageControl.currentPageIndicatorTintColor =[ProjectUtil colorWithHexString:@"00a1ea"];
    _pageControl.numberOfPages = _imageArr.count;
    [self.view addSubview:_scrollView];
    [self.view addSubview:_pageControl];
}


//进入APP应用界面
-(void)enterAppAction
{
    //更新登录状态
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"isNotFirstStart"];
    [userDefaults setBool:YES forKey:@"SalesHelper_NoviceRead"];
    [userDefaults synchronize];
    
    [self presentToMainViewController:YES];

    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x/scrollView.width;
    _pageControl.currentPage = index;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
