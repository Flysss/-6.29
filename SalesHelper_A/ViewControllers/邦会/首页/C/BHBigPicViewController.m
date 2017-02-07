//
//  BHBigPicViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/23.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHBigPicViewController.h"
#import "UIColor+HexColor.h"

@interface BHBigPicViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIScrollView *mainScrollView;
//@property (nonatomic, strong)NSMutableArray *picArr;
//@property (nonatomic, assign)NSInteger indexPic;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, assign)BOOL isZoom;

@end

@implementation BHBigPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
//    self.indexPic = 0;
//    [self RequestImgDetail];
    [self customScrollView];
    UIButton *btnSave = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnSave setTitle:@"保存" forState:(UIControlStateNormal)];
    btnSave.titleLabel.font = [UIFont systemFontOfSize:11];
    [btnSave setTitleColor:[UIColor colorWithHexString:@"666666"] forState:(UIControlStateNormal)];
    btnSave.frame = CGRectMake(SCREEN_WIDTH/2 - 15, SCREEN_HEIGHT - 49, 30, 30);
    btnSave.backgroundColor = [UIColor whiteColor];
    btnSave.layer.cornerRadius = 15;
    btnSave.layer.masksToBounds = YES;
    [btnSave addTarget:self action:@selector(picSave:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btnSave];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.index = self.mainScrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width ;
    self.label.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.index+1,(unsigned long)self.picArr.count];
    
    NSLog(@"%ld",(long)self.index);
}
-(void)customScrollView
{
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.userInteractionEnabled = YES;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    
    self.mainScrollView.contentSize = CGSizeMake(self.picArr.count*[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    self.mainScrollView.delegate = self;
    self.mainScrollView.contentOffset = CGPointMake(_index*SCREEN_WIDTH, 0);
    //设置放大缩小的最大，最小倍数
    
    

    [self.view addSubview:self.mainScrollView];

    for (int i = 0; i< self.picArr.count; i++)
    {

        UIScrollView *scrolview = [[UIScrollView alloc]init];
        scrolview.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
        scrolview.delegate = self;
        scrolview.tag = 10+i;
        [self.mainScrollView addSubview:scrolview];
        
        scrolview.minimumZoomScale = 1;
        scrolview.maximumZoomScale = 3;
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        [img sd_setImageWithURL:[NSURL URLWithString:self.picArr[i]]];
        img.userInteractionEnabled = YES;
        img.tag = i+1;
        [scrolview addSubview:img];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomPic:)];
        tap1.numberOfTapsRequired = 2;
        [scrolview addGestureRecognizer:tap1];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpFirst)];
        tap.numberOfTapsRequired = 1;
        [scrolview addGestureRecognizer:tap];
        [tap requireGestureRecognizerToFail:tap1];
    }
   

    
   
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width, 30)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.index+1,(unsigned long)self.picArr.count];
    self.label.textColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    
}

- (void)picSave:(UIButton *)btn
{
    UIImageView *img = [[UIImageView alloc]init];
    [img sd_setImageWithURL:self.picArr[_index]];

    UIImageWriteToSavedPhotosAlbum(img.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

-(void)jumpFirst
{
    if (_isAnimation == YES) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        
        CATransition *animation = [CATransition animation];
        animation.duration = 1.0;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"rippleEffect";
        animation.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [self.view viewWithTag:self.index+1];
//    return scrollView.subviews[self.index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    UIPageControl *page = [self.view viewWithTag:600];
//    page.currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)zoomPic:(UITapGestureRecognizer *)tap
{
    float newscale;
    if (_isZoom)
    {
        newscale = 1;
    }
    else
    {
        newscale = 2;
    }

    UIScrollView *scrollView = [tap.view viewWithTag:self.index+10];
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[tap locationInView:tap.view] scrollView:scrollView];
    [scrollView zoomToRect:zoomRect animated:YES];
    [scrollView setZoomScale:newscale animated:YES];//以原先中心为点向外扩
    _isZoom = !_isZoom;
}
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center scrollView:(UIScrollView *)scrollView
{//传入缩放比例和手势的点击的point返回<span style="color:#ff0000;">缩放</span>后的scrollview的大小和X、Y坐标点
    
    CGRect zoomRect;
    NSLog(@"%@",NSStringFromCGRect(scrollView.frame));
    zoomRect.size.height = [scrollView frame].size.height / scale;
    NSLog(@"%f",zoomRect.size.height);
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}
// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
    NSString *msg = nil ;
    
    if(error != NULL){
        
        msg = @"请检查->设置->隐私中该应用是否允许访问相册" ;
        
    }else{
        
        msg = @"保存图片成功" ;
        
    }    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                          
                                                    message:msg
                          
                                                   delegate:self
                          
                                          cancelButtonTitle:@"确定"
                          
                                          otherButtonTitles:nil];
    
    [alert show];
    
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
