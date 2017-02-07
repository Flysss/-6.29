//
//  PresentPicViewController.m
//  SalesHelper_A
//
//  Created by flysss on 16/1/7.
//  Copyright © 2016年 X. All rights reserved.
//

#import "PresentPicViewController.h"
#import "LLPhotoScv.h"


@interface PresentPicViewController ()


@property(nonatomic,strong)UIScrollView* scrollView;
@property (nonatomic, strong) LLPhotoScv *scrView;
@end

@implementation PresentPicViewController
{
    NSDictionary* _dict;
    NSInteger countIndex;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    
    [self creatArr];
    [self setNavigationBar];
    
//    [self createScrollView];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelfOnTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)creatArr
{
//    if ([self.idStr isEqualToString:@"2"]) {
//        self.scrView = [[LLPhotoScv alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) andImage:self.imageArrUrl andTitle:nil];
//    }else{
        self.scrView = [[LLPhotoScv alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) andImage:self.imageArrUrl andTitle:self.imageTitleArr];
    
    self.scrView.block = ^(NSInteger  index){
        countIndex = index;
    };
    
//    NSLog(@"%@", self.imageArrUrl);
//        //self.scrView.titleArr = self.imageTitleArr;
//    }
    //self.scrollView.userInteractionEnabled = YES;
    [self.view addSubview:self.scrView];
}

-(void)setNavigationBar{
    
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 30, 40, 40);
    
    [backBtn setImage:[UIImage imageNamed:@"首页-左箭头"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头"]] forState:UIControlStateHighlighted];
    
    [backBtn addTarget:self action:@selector(dismissSelfOnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(SCREEN_WIDTH-50, 30, 40, 40);
    saveBtn.titleLabel.font = Default_Font_17;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveImageToAlbum:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
}
#pragma mark - Handle Tap Genture Reconizer
- (void)dismissSelfOnTap:(UITapGestureRecognizer *)tapGestureRecognizer{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)saveImageToAlbum:(UIButton*)sender
{
    UIImageView *img = [[UIImageView alloc]init];
    [img sd_setImageWithURL:self.imageArrUrl[countIndex]];
    
    UIImageWriteToSavedPhotosAlbum(img.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}
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

- (void)createScrollView{
    
    
    CGFloat imgHeight = SCREEN_WIDTH*2/3;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-imgHeight)/2, SCREEN_WIDTH,imgHeight)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [ UIColor blackColor];
    
    [self.view addSubview:self.scrollView];
   
    
    if ([self.idStr isEqualToString:@"2"]) {
        
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.imageArrUrl.count,imgHeight);
        
        for (int i=0; i<self.imageArrUrl.count;i++) {
            UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i ,0, SCREEN_WIDTH, imgHeight)];
            
            [imageV sd_setImageWithURL:self.imageArrUrl[i] placeholderImage:[UIImage imageNamed:@"pp_bg.png"]];
            
            [_scrollView addSubview:imageV];
        }
    } else {
        
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.imageURLStringsGroup.count,imgHeight);

        for (int i=0; i<self.imageURLStringsGroup.count;i++) {
            UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i ,0, SCREEN_WIDTH, imgHeight)];
            
            [imageV sd_setImageWithURL:self.imageURLStringsGroup[i] placeholderImage:[UIImage imageNamed:@"pp_bg.png"]];
            
            UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, imgHeight-30, SCREEN_WIDTH, 30)];
            titleLabel.text =[NSString stringWithFormat:@"   %@",self.imageTitleArr[i]];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = Default_Font_14;
            titleLabel.backgroundColor = [UIColor blackColor];
            titleLabel.alpha = 0.3;
            titleLabel.textColor = [UIColor whiteColor];
            
            [_scrollView addSubview:imageV];
            [_scrollView addSubview:titleLabel];
        }
        
    }
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
