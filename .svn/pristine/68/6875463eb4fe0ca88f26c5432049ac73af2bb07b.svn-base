//
//  ZJPersonHeadView.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/18.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJPersonHeadView.h"
#import "UIColor+HexColor.h"

@implementation ZJPersonHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imgBac = [[UIImageView alloc]init];
        [self addSubview:self.imgBac];
        
        
        
        self.imgHead = [[UIImageView alloc]init];
        [self addSubview:self.imgHead];
        
        self.btnMessage = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnMessage addTarget:self action:@selector(sendMessageAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnMessage];
        
        self.btnGuanZhu = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnGuanZhu addTarget:self action:@selector(guanzhuAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnGuanZhu];
        
        self.lblAddress = [[UILabel alloc]init];
        self.lblAddress.font = [UIFont systemFontOfSize:12];
        self.lblAddress.textColor = [UIColor colorWithHexString:@"ffffff"];
        self.lblAddress.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lblAddress];
        
        self.lblGuanZhuNum = [[UILabel alloc]init];
        self.lblGuanZhuNum.font = [UIFont systemFontOfSize:12];
        self.lblGuanZhuNum.textColor = [UIColor colorWithHexString:@"ffffff"];
        self.lblGuanZhuNum.textAlignment = NSTextAlignmentRight;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapJumpPriVC)];
        [self.lblGuanZhuNum addGestureRecognizer:tap1];
        self.lblGuanZhuNum.userInteractionEnabled = YES;
        [self addSubview:self.lblGuanZhuNum];
        
        self.lblFansNum = [[UILabel alloc]init];
        self.lblFansNum.font = [UIFont systemFontOfSize:12];
        self.lblFansNum.textColor = [UIColor colorWithHexString:@"ffffff"];
        self.lblFansNum.textAlignment = NSTextAlignmentLeft;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapJumpFansVC)];
        [self.lblFansNum addGestureRecognizer:tap2];
        self.lblFansNum.userInteractionEnabled = YES;
        [self addSubview:self.lblFansNum];
        
        self.btnPost = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        [self.btnPost setTitle:@"帖子" forState:(UIControlStateNormal)];
        [self.btnPost addTarget:self action:@selector(postAction:) forControlEvents:(UIControlEventTouchUpInside)];
        self.btnPost.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.btnPost setTitleColor:[UIColor colorWithHexString:@"00aff0"] forState:(UIControlStateNormal)];
        [self addSubview:self.btnPost];
        
        self.btnReply = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        [self.btnReply setTitle:@"回复" forState:(UIControlStateNormal)];
        self.btnReply.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.btnReply setTitleColor:[UIColor colorWithHexString:@"676767"] forState:(UIControlStateNormal)];
        [self.btnReply addTarget:self action:@selector(replyAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnReply];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imgBac.frame = CGRectMake(0, 0, SCREEN_WIDTH, 434/2);
    
    self.imgHead.frame = CGRectMake(SCREEN_WIDTH/2-52/2, 80, 52, 52);
    self.imgHead.layer.cornerRadius = self.imgHead.width/2;
    self.imgHead.layer.masksToBounds = YES;
    
    self.btnMessage.frame = CGRectMake(0, 0, 32, 32);
    self.btnMessage.center = CGPointMake(SCREEN_WIDTH/2-52/2-30-16, CGRectGetCenter(self.imgHead.frame).y);
    
    
    
    self.btnGuanZhu.width = 32;
    self.btnGuanZhu.height = 32;
    self.btnGuanZhu.center = CGPointMake(SCREEN_WIDTH/2+52/2+30+16, CGRectGetCenter(self.imgHead.frame).y);
    
    self.lblAddress.frame = CGRectMake(0, CGRectGetMaxY(self.imgHead.frame)+11.5, SCREEN_WIDTH, 20);
    
    self.lblGuanZhuNum.frame = CGRectMake(0, CGRectGetMaxY(self.lblAddress.frame)+9, SCREEN_WIDTH/2-13, 20);
    
    self.lblFansNum.frame = CGRectMake(SCREEN_WIDTH/2+13,  CGRectGetMaxY(self.lblAddress.frame)+9, SCREEN_WIDTH/2-13, 20);
    
    self.btnPost.frame = CGRectMake(0, 434/2, SCREEN_WIDTH/2, 91/2);
    self.btnReply.frame = CGRectMake(CGRectGetMaxX(self.btnPost.frame), 434/2, SCREEN_WIDTH/2, 91/2);
    
    
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    if ([_dic count] != 0) {
        NSString *Tnum = [NSString stringWithFormat:@"帖子(%@)",_dic[@"Tnum"]];
        NSString *Hnum = [NSString stringWithFormat:@"回复(%@)",_dic[@"Hnum"]];
        [self.btnPost setTitle:Tnum forState:(UIControlStateNormal)];
        [self.btnReply setTitle:Hnum forState:(UIControlStateNormal)];
        if (_dic[@"iconPath"]!= nil && _dic[@"iconPath"] != [NSNull null]) {
            
            [self.imgBac sd_setImageWithURL:[NSURL URLWithString:_dic[@"iconPath"]]];
        }
        self.imgHead.layer.borderWidth = 2;
        self.imgHead.layer.borderColor = [UIColor whiteColor].CGColor;


        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
        effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 434/2);
        [self.imgBac addSubview:effectView];

        if (_dic[@"iconPath"]!= nil && _dic[@"iconPath"] != [NSNull null])
        {
            [self.imgHead sd_setImageWithURL:[NSURL URLWithString:_dic[@"iconPath"]] placeholderImage:[UIImage imageNamed:@"默认个人图像"]];
        }
        
        
        
        if (![_dic[@"orgName"] isKindOfClass:[NSNull class]]) {
            
            self.lblAddress.text = _dic[@"orgName"];
        }
        self.lblGuanZhuNum.text = [NSString stringWithFormat:@"%@ 关注",_dic[@"Gnum"]];
        self.lblFansNum.text = [NSString stringWithFormat:@"%@ 邦粉",_dic[@"Fnum"]];
        
        if ([_dic[@"type"] integerValue]== 1)
        {
            self.btnGuanZhu.hidden = YES;
            self.btnMessage.hidden = YES;
        }
        else
        {
            if ([_dic[@"is_focus"] integerValue] == 3)
            {
                [self.btnGuanZhu setImage:[UIImage imageNamed:@"gzq-1"] forState:(UIControlStateNormal)];
            }
            else
            {
                [self.btnGuanZhu setImage:[UIImage imageNamed:@"gzh-1"] forState:(UIControlStateNormal)];
            }
            [self.btnMessage setImage:[UIImage imageNamed:@"fsx-1"] forState:(UIControlStateNormal)];
        }
    }
}

- (void)sendMessageAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickMessageButtonAction:)]) {
        
        [self.delegate clickMessageButtonAction:self];
        
    }

}

- (void)guanzhuAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickGuanZhuButtonAction:)]) {
        [self.delegate clickGuanZhuButtonAction:self];
    }
}

- (void)postAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickPostButtonAction:)]) {
        
        [self.delegate clickPostButtonAction:self];
        
    }
}

- (void)replyAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickReplyButtonAction:)]) {
        
        [self.delegate clickReplyButtonAction:self];
        
    }
}

- (void)tapJumpPriVC
{
    if ([self.delegate respondsToSelector:@selector(clickJumpPriVCAction:)]) {
        [self.delegate clickJumpPriVCAction:self];
    }
}
- (void)tapJumpFansVC
{
    if ([self.delegate respondsToSelector:@selector(clickJumpFansVCAction:)]) {
        [self.delegate clickJumpFansVCAction:self];
    }
}

@end
