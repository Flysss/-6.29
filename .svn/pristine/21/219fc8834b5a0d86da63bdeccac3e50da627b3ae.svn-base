//
//  HWGongGaoToolBar.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/9.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWGongGaoToolBar.h"
#import "HWGongGaoModel.h"
#import "UIColor+HexColor.h"
#import "AFHTTPRequestOperationManager.h"


@interface HWGongGaoToolBar ()
@property (nonatomic, strong) NSMutableArray *btns;



@property (nonatomic,assign) BOOL isAttitudesButton;
@property (nonatomic, weak) UILabel *line;
@end
@implementation HWGongGaoToolBar
- (NSMutableArray *)btns
{
    if (_btns == nil) {
        self.btns = [NSMutableArray array];
    }
    return _btns;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];

//        self.commentsButton = [self setupBtnWithIcon:@"评论" title:@"评论"];
        self.attitudesButton = [self setupBtnWithIcon:@"点赞" title:@" 赞"];
        
        
        
//        [self.commentsButton addTarget:self action:@selector(commentsbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.attitudesButton addTarget:self action:@selector(attitudesButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
        UILabel *line = [[UILabel alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"c8c8c8"];
        [self addSubview:line];
        self.line = line;
        
        
    }
    return self;
}
- (UIButton *)setupBtnWithIcon:(NSString *)icon title:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
   btn.adjustsImageWhenHighlighted = NO;
    
    // 设置间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [self addSubview:btn];
    
    [self.btns addObject:btn];
    
    return btn;
}


- (void)setModel:(BHPingLunModel *)model
{
    _model = model;
    if (_model.is_praise != nil )
    {
        [self.attitudesButton setImage:[UIImage imageNamed:@"点赞之后"] forState:(UIControlStateNormal)];

    }else
    {
        [self.attitudesButton setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
        
    }
//    [self setupButton:self.commentsButton withCount:model.hf_num defaultTitle:@" 评论"];
    [self setupButton:self.attitudesButton withCount:model.dz_num defaultTitle:@" 赞"];
    
}

//-(void)setPmodel:(BHPingLunModel *)Pmodel
//{
//    _Pmodel = Pmodel;
//    if (Pmodel.is_praiks != nil)
//    {
//        
//    }else
//    {
//        
//    }
//    [self setupButton:self.commentsButton withCount:Pmodel.hf_num defaultTitle:@" 评论"];
//    [self setupButton:self.attitudesButton withCount:Pmodel.dz_num defaultTitle:@" 赞"];
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSInteger btnCount = self.btns.count;
    CGFloat btnW = 70;
    CGFloat btnH = self.height;
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.btns[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.y = 0;
        btn.x = (self.width - btnCount * btnW)+ i * btnW;
    }
    self.line.height = 1;
    self.line.y = self.height - 1;
    self.line.width = SCREEN_WIDTH;
}

- (void)setupButton:(UIButton *)button withCount:(NSInteger)count defaultTitle:(NSString *)defaultTitle
{
    if (count > 10000){
        
        defaultTitle = [NSString stringWithFormat:@"%.1f万",count/10000.0];
        defaultTitle = [defaultTitle stringByReplacingOccurrencesOfString:@".0" withString:@""];
        
    }else if (count > 0){
        
        defaultTitle = [NSString stringWithFormat:@"%ld", (long)count];
        
    }
    
    
    [button setTitle:defaultTitle forState:UIControlStateNormal];
    
    
}
- (void)commentsbuttonClick:(UIButton *)button
{
    [self zanAnimation:button];
    

    [[NSNotificationCenter defaultCenter] postNotificationName:HWGongGaoToolBarHuiFuDidClick object:@{@"section":@(self.section)}];
    
    
}
- (void)attitudesButtonClick:(UIButton *)button
{
    
    [self zanAnimation:button];

    [self requsetPingLunZan];
}
- (void)requsetPingLunZan
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *longinuid =  [defaults objectForKey:@"id"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"commentid"] = self.model.pingLunID;
    parame[@"loginuid"] = longinuid;
    [manager POST:@"http://192.168.1.199/index.php/Apis/Forum/setCommentLike/" parameters:parame
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSInteger count =  self.model.dz_num;
         if ([responseObject[@"success"] boolValue] == YES)
         {
            
             [self.attitudesButton setImage:[UIImage imageNamed:@"点赞之后"] forState:(UIControlStateNormal)];
             [self setupButton:self.attitudesButton withCount:count+1 defaultTitle:@"0"];
             _model.is_praise = @"333";
         }
         else
         {
             [self.attitudesButton setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
             [self setupButton:self.attitudesButton withCount:count defaultTitle:@"赞"];
             _model.is_praise = nil;
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];

}
- (void)zanAnimation:(UIButton *)button
{
    CAKeyframeAnimation *k = [CAKeyframeAnimation  animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(0.8)];
    k.calculationMode = kCAAnimationLinear;
    [button.layer addAnimation:k forKey:@"SHOW"];
}
@end
