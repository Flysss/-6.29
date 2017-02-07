//
//  ZJPostReplyView.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/20.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJPostReplyView.h"
#import "UIColor+HexColor.h"
#import "BHFirstListModel.h"
#import "BHHuaTiModel.h"

#define KWIDTH [UIScreen mainScreen].bounds.size.width - (10+10+35) - 15 //宽度
#define KnumberOfLines 1 //最多显示多少行
#define KHEIGHT 16 //限制高度

@implementation ZJPostReplyView

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

        self.lblName = [[UILabel alloc]init];
        self.lblName.textColor = [UIColor colorWithHexString:@"a4a4a4"];
        self.lblName.font = [UIFont systemFontOfSize:13];
        self.lblName.numberOfLines = KnumberOfLines;
        [self addSubview:self.lblName];
        
        self.lblMore = [[UILabel alloc]init];
        self.lblMore.textColor = [UIColor colorWithHexString:@"a4a4a4"];
        self.lblMore.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.lblMore];
        
        self.lblName2 = [[UILabel alloc]init];
        self.lblName2.textColor = [UIColor colorWithHexString:@"a4a4a4"];
        self.lblName2.font = [UIFont systemFontOfSize:13];
        self.lblName2.numberOfLines = KnumberOfLines;
        [self addSubview:self.lblName2];
        
        self.lblName3 = [[UILabel alloc]init];
        self.lblName3.textColor = [UIColor colorWithHexString:@"a4a4a4"];
        self.lblName3.font = [UIFont systemFontOfSize:13];
        self.lblName3.numberOfLines = KnumberOfLines;
        [self addSubview:self.lblName3];
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
   
}
- (void)setModel:(BHFirstListModel *)model
{
    _model = model;
    
    self.lblName.hidden = YES;
    self.lblName2.hidden = YES;
    self.lblName3.hidden = YES;
    self.lblMore.hidden = YES;
    CGFloat H = 0;
    

    if (model.hui.count == 1)
    {
        self.lblName.hidden = NO;

        NSString *huifuName = [NSString stringWithFormat:@"%@:",model.hui[0][@"name"]];
        NSString *name = [NSString stringWithFormat:@"%@ %@",huifuName,model.hui[0][@"contents"]];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:name];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name rangeOfString:huifuName]];
        self.lblName.attributedText = [self emojiMatching:str];
        CGFloat lHeight = [ZJPostReplyView heightForStr:str.string width:KWIDTH font:13];
        if (lHeight > KHEIGHT) {
            lHeight = KHEIGHT;
        }
        self.lblName.frame = CGRectMake(5, 5, KWIDTH, lHeight);
        
        H += 5+lHeight+3;

    }
    
    else if (model.hui.count == 2)
    {
        
        self.lblName.hidden = NO;

        NSString *huifuName = [NSString stringWithFormat:@"%@:",model.hui[0][@"name"]];
        NSString *name = [NSString stringWithFormat:@"%@ %@",huifuName,model.hui[0][@"contents"]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:name];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name rangeOfString:huifuName]];
        self.lblName.attributedText = [self emojiMatching:str];
        CGFloat lHeight = [ZJPostReplyView heightForStr:str.string width:KWIDTH font:13];
        if (lHeight > KHEIGHT) {
            lHeight = KHEIGHT;
        }
        self.lblName.frame = CGRectMake(5, 5, KWIDTH, lHeight);
        
        H += 5+lHeight+3;
        
        
        self.lblName2.hidden = NO;
        NSString *huifuName2 = [NSString stringWithFormat:@"%@:",model.hui[1][@"name"]];
        NSString *name2 = [NSString stringWithFormat:@"%@ %@",huifuName2,model.hui[1][@"contents"]];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:name2];
        [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name2 rangeOfString:huifuName2]];
        self.lblName2.attributedText = [self emojiMatching:str2];
        
        CGFloat lblHeight = [ZJPostReplyView heightForStr:str2.string width:KWIDTH font:13];
        if (lblHeight > KHEIGHT) {
            lblHeight = KHEIGHT;
        }
        self.lblName2.frame = CGRectMake(5, H, KWIDTH, lblHeight);
        
        H += lblHeight+3;
    }
    
    else if (model.hui.count == 3)
    {
        
        self.lblName.hidden = NO;
        NSString *huifuName = [NSString stringWithFormat:@"%@:",model.hui[0][@"name"]];
        NSString *name = [NSString stringWithFormat:@"%@ %@",huifuName,model.hui[0][@"contents"]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:name];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name rangeOfString:huifuName]];
        self.lblName.attributedText = [self emojiMatching:str];
        CGFloat lHeight = [ZJPostReplyView heightForStr:str.string width:KWIDTH font:13];
        if (lHeight > KHEIGHT) {
            lHeight = KHEIGHT;
        }
        self.lblName.frame = CGRectMake(5, 5, KWIDTH, lHeight);
        
        H += 5+lHeight+3;
        
        
        self.lblName2.hidden = NO;
        NSString *huifuName2 = [NSString stringWithFormat:@"%@:",model.hui[1][@"name"]];
        NSString *name2 = [NSString stringWithFormat:@"%@ %@",huifuName2,model.hui[1][@"contents"]];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:name2];
        [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name2 rangeOfString:huifuName2]];
        self.lblName2.attributedText = [self emojiMatching:str2];
        CGFloat lblHeight = [ZJPostReplyView heightForStr:str2.string width:KWIDTH font:13];
        if (lblHeight > KHEIGHT) {
            lblHeight = KHEIGHT;
        }
        self.lblName2.frame = CGRectMake(5, H, KWIDTH, lblHeight);
        
        H += lblHeight+3;
        
        self.lblName3.hidden = NO;
        NSString *huifuName3 = [NSString stringWithFormat:@"%@:",model.hui[2][@"name"]];
        NSString *name3 = [NSString stringWithFormat:@"%@ %@",huifuName3,model.hui[2][@"contents"]];
        NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:name3];
        [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name3 rangeOfString:huifuName3]];
        self.lblName3.attributedText = [self emojiMatching:str3];
        
        CGFloat lblHeight2 = [ZJPostReplyView heightForStr:str3.string width:KWIDTH font:13];
        if (lblHeight2 > KHEIGHT) {
            lblHeight2 = KHEIGHT;
        }
        self.lblName3.frame = CGRectMake(5, H, KWIDTH, lblHeight2);
        H += lblHeight2+3;
    }
   else if (model.hui.count > 3)
   {
       self.lblName.hidden = NO;
       NSString *huifuName = [NSString stringWithFormat:@"%@:",model.hui[0][@"name"]];
       NSString *name = [NSString stringWithFormat:@"%@ %@",huifuName,model.hui[0][@"contents"]];
       NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:name];
       [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name rangeOfString:huifuName]];
       self.lblName.attributedText = [self emojiMatching:str];
       CGFloat lHeight = [ZJPostReplyView heightForStr:str.string width:KWIDTH font:13];
       if (lHeight > KHEIGHT) {
           lHeight = KHEIGHT;
       }
       self.lblName.frame = CGRectMake(5, 5, KWIDTH, lHeight);
       
       H += 5+lHeight+3;
       
       
       self.lblName2.hidden = NO;
       NSString *huifuName2 = [NSString stringWithFormat:@"%@:",model.hui[1][@"name"]];
       NSString *name2 = [NSString stringWithFormat:@"%@ %@",huifuName2,model.hui[1][@"contents"]];
       NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:name2];
       [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name2 rangeOfString:huifuName2]];
       self.lblName2.attributedText = [self emojiMatching:str2];
       CGFloat lblHeight = [ZJPostReplyView heightForStr:str2.string width:KWIDTH font:13];
       if (lblHeight > KHEIGHT) {
           lblHeight = KHEIGHT;
       }

       self.lblName2.frame = CGRectMake(5, H, KWIDTH, lblHeight);
       
       H += lblHeight+3;
       
       self.lblName3.hidden = NO;
       NSString *huifuName3 = [NSString stringWithFormat:@"%@:",model.hui[2][@"name"]];
       NSString *name3 = [NSString stringWithFormat:@"%@ %@",huifuName3,model.hui[2][@"contents"]];
       NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:name3];
       [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name3 rangeOfString:huifuName3]];
       self.lblName3.attributedText = [self emojiMatching:str3];
       
       CGFloat lblHeight2 = [ZJPostReplyView heightForStr:str3.string width:KWIDTH font:13];
       if (lblHeight2 > KHEIGHT) {
           lblHeight2 = KHEIGHT;
       }
       self.lblName3.frame = CGRectMake(5, H, KWIDTH, lblHeight2);
       H += lblHeight2+3;
       
       self.lblMore.hidden = NO;
       self.lblMore.text = [NSString stringWithFormat:@"查看全部%@条评论",model.huis];
       self.lblMore.frame = CGRectMake(5, H, KWIDTH, KHEIGHT);
       
   }
    
    
}

+ (CGFloat)heightForStr:(NSString *)str width:(CGFloat)width font:(CGFloat)font
{
    CGSize size = CGSizeMake(width, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGRect rect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}

- (void)setHmodel:(BHHuaTiModel *)Hmodel
{
    _Hmodel = Hmodel;

    self.lblMore.hidden = YES;
    self.lblName.hidden = YES;
    self.lblName2.hidden = YES;
    self.lblName3.hidden = YES;
    CGFloat H = 0;
    
    
    if (Hmodel.hui.count == 1)
    {
        self.lblName.hidden = NO;
        NSString *huifuName = [NSString stringWithFormat:@"%@:",Hmodel.hui[0][@"name"]];
        NSString *name = [NSString stringWithFormat:@"%@ %@",huifuName,Hmodel.hui[0][@"contents"]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:name];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name rangeOfString:huifuName]];
        self.lblName.attributedText = [self emojiMatching:str];
        CGFloat lHeight = [ZJPostReplyView heightForStr:str.string width:KWIDTH font:13];
        if (lHeight > KHEIGHT) {
            lHeight = KHEIGHT;
        }
        self.lblName.frame = CGRectMake(5, 5, KWIDTH, lHeight);
        
        H += 5+lHeight+3;
        
    }
    
    else if (Hmodel.hui.count == 2)
    {
        
        self.lblName.hidden = NO;
        NSString *huifuName = [NSString stringWithFormat:@"%@:",Hmodel.hui[0][@"name"]];
        NSString *name = [NSString stringWithFormat:@"%@ %@",huifuName,Hmodel.hui[0][@"contents"]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:name];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name rangeOfString:huifuName]];
        self.lblName.attributedText = [self emojiMatching:str];
        CGFloat lHeight = [ZJPostReplyView heightForStr:str.string width:KWIDTH font:13];
        if (lHeight > KHEIGHT) {
            lHeight = KHEIGHT;
        }
        self.lblName.frame = CGRectMake(5, 5, KWIDTH, lHeight);
        
        H += 5+lHeight+3;
        
        
        self.lblName2.hidden = NO;
        NSString *huifuName2 = [NSString stringWithFormat:@"%@:",Hmodel.hui[1][@"name"]];
        NSString *name2 = [NSString stringWithFormat:@"%@ %@",huifuName2,Hmodel.hui[1][@"contents"]];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:name2];
        [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name2 rangeOfString:huifuName2]];
        self.lblName2.attributedText = [self emojiMatching:str2];
        CGFloat lblHeight = [ZJPostReplyView heightForStr:str2.string width:KWIDTH font:13];
        if (lblHeight > KHEIGHT) {
            lblHeight = KHEIGHT;
        }
        self.lblName2.frame = CGRectMake(5, H, KWIDTH, lblHeight);
        
        H += lblHeight+3;
    }
    
    else if (Hmodel.hui.count == 3)
    {
        
        self.lblName.hidden = NO;
        NSString *huifuName = [NSString stringWithFormat:@"%@:",Hmodel.hui[0][@"name"]];
        NSString *name = [NSString stringWithFormat:@"%@ %@",huifuName,Hmodel.hui[0][@"contents"]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:name];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name rangeOfString:huifuName]];
        self.lblName.attributedText = [self emojiMatching:str];
        CGFloat lHeight = [ZJPostReplyView heightForStr:str.string width:KWIDTH font:13];
        if (lHeight > KHEIGHT) {
            lHeight = KHEIGHT;
        }
        self.lblName.frame = CGRectMake(5, 5, KWIDTH, lHeight);
        
        H += 5+lHeight+3;
        
        
        self.lblName2.hidden = NO;
        NSString *huifuName2 = [NSString stringWithFormat:@"%@:",Hmodel.hui[1][@"name"]];
        NSString *name2 = [NSString stringWithFormat:@"%@ %@",huifuName2,Hmodel.hui[1][@"contents"]];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:name2];
        [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name2 rangeOfString:huifuName2]];
        self.lblName2.attributedText = [self emojiMatching:str2];
        CGFloat lblHeight = [ZJPostReplyView heightForStr:str2.string width:KWIDTH font:13];
        if (lblHeight > KHEIGHT) {
            lblHeight = KHEIGHT;
        }
        self.lblName2.frame = CGRectMake(5, H, KWIDTH, lblHeight);
        
        H += lblHeight+3;
        
        self.lblName3.hidden = NO;
        NSString *huifuName3 = [NSString stringWithFormat:@"%@:",Hmodel.hui[2][@"name"]];
        NSString *name3 = [NSString stringWithFormat:@"%@ %@",huifuName3,Hmodel.hui[2][@"contents"]];
        NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:name3];
        [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name3 rangeOfString:huifuName3]];
        self.lblName3.attributedText = [self emojiMatching:str3];
        
        CGFloat lblHeight2 = [ZJPostReplyView heightForStr:str3.string width:KWIDTH font:13];
        if (lblHeight2 > KHEIGHT) {
            lblHeight2 = KHEIGHT;
        }
        self.lblName3.frame = CGRectMake(5, H, KWIDTH, lblHeight2);
        H += lblHeight2+3;
    }
    else if (Hmodel.hui.count > 3)
    {
        self.lblName.hidden = NO;
        NSString *huifuName = [NSString stringWithFormat:@"%@:",Hmodel.hui[0][@"name"]];
        NSString *name = [NSString stringWithFormat:@"%@ %@",huifuName,Hmodel.hui[0][@"contents"]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:name];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name rangeOfString:huifuName]];
        self.lblName.attributedText = [self emojiMatching:str];
        CGFloat lHeight = [ZJPostReplyView heightForStr:str.string width:KWIDTH font:13];
        if (lHeight > KHEIGHT) {
            lHeight = KHEIGHT;
        }
        self.lblName.frame = CGRectMake(5, 5, KWIDTH, lHeight);
        
        H += 5+lHeight+3;
        
        
        self.lblName2.hidden = NO;
        NSString *huifuName2 = [NSString stringWithFormat:@"%@:",Hmodel.hui[1][@"name"]];
        NSString *name2 = [NSString stringWithFormat:@"%@ %@",huifuName2,Hmodel.hui[1][@"contents"]];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:name2];
        [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name2 rangeOfString:huifuName2]];
        self.lblName2.attributedText = [self emojiMatching:str2];
        CGFloat lblHeight = [ZJPostReplyView heightForStr:str2.string width:KWIDTH font:13];
        if (lblHeight > KHEIGHT) {
            lblHeight = KHEIGHT;
        }
        self.lblName2.frame = CGRectMake(5, H, KWIDTH, lblHeight);
        
        H += lblHeight+3;
        
        self.lblName3.hidden = NO;
        NSString *huifuName3 = [NSString stringWithFormat:@"%@:",Hmodel.hui[2][@"name"]];
        NSString *name3 = [NSString stringWithFormat:@"%@ %@",huifuName3,Hmodel.hui[2][@"contents"]];
        NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:name3];
        [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:[name3 rangeOfString:huifuName3]];
        self.lblName3.attributedText = [self emojiMatching:str3];
        
        CGFloat lblHeight2 = [ZJPostReplyView heightForStr:str3.string width:KWIDTH font:13];
        if (lblHeight2 > KHEIGHT) {
            lblHeight2 = KHEIGHT;
        }
        self.lblName3.frame = CGRectMake(5, H, KWIDTH, lblHeight2);
        H += lblHeight2+3;
        
        self.lblMore.hidden = NO;
        self.lblMore.text = [NSString stringWithFormat:@"查看全部%@条评论",Hmodel.huis];
        self.lblMore.frame = CGRectMake(5, H, KWIDTH, KHEIGHT);
        
    }

}


+ (CGFloat)heightForModel:(BHFirstListModel *)model
{
    CGFloat H = 0;
    if (model.hui.count == 1) {
        NSString *huifuName = [NSString stringWithFormat:@"%@:",model.hui[0][@"name"]];
        NSString *name = [NSString stringWithFormat:@"%@ %@",huifuName,model.hui[0][@"contents"]];
        CGFloat lHeight = [ZJPostReplyView heightForStr:name width:KWIDTH font:13];
        if (lHeight > KHEIGHT) {
            lHeight = KHEIGHT;
        }
        H += 5+lHeight+5+2;
    }
    else if (model.hui.count == 2) {
        NSString *huifuName = [NSString stringWithFormat:@"%@:",model.hui[0][@"name"]];
        NSString *name = [NSString stringWithFormat:@"%@ %@",huifuName,model.hui[0][@"contents"]];
        CGFloat lHeight = [ZJPostReplyView heightForStr:name width:KWIDTH font:13];
        if (lHeight > KHEIGHT) {
            lHeight = KHEIGHT;
        }
        H += lHeight+5;
        
        NSString *huifuName2 = [NSString stringWithFormat:@"%@:",model.hui[1][@"name"]];
        NSString *name2 = [NSString stringWithFormat:@"%@ %@",huifuName2,model.hui[1][@"contents"]];
        CGFloat lblHeight = [ZJPostReplyView heightForStr:name2 width:KWIDTH font:13];
        if (lblHeight > KHEIGHT) {
            lblHeight = KHEIGHT;
        }
        H += lblHeight+5+5;

    }
    else if (model.hui.count == 3) {
        NSString *huifuName = [NSString stringWithFormat:@"%@:",model.hui[0][@"name"]];
        NSString *name = [NSString stringWithFormat:@"%@ %@",huifuName,model.hui[0][@"contents"]];
        CGFloat lHeight = [ZJPostReplyView heightForStr:name width:KWIDTH font:13];
        if (lHeight > KHEIGHT) {
            lHeight = KHEIGHT;
        }
        H += 5+lHeight;
        
        NSString *huifuName2 = [NSString stringWithFormat:@"%@:",model.hui[1][@"name"]];
        NSString *name2 = [NSString stringWithFormat:@"%@ %@",huifuName2,model.hui[1][@"contents"]];
        CGFloat lblHeight = [ZJPostReplyView heightForStr:name2 width:KWIDTH font:13];
        if (lblHeight > KHEIGHT) {
            lblHeight = KHEIGHT;
        }
        H += lblHeight+3;
        
        NSString *huifuName3 = [NSString stringWithFormat:@"%@:",model.hui[2][@"name"]];
        NSString *name3 = [NSString stringWithFormat:@"%@ %@",huifuName3,model.hui[2][@"contents"]];
        CGFloat lblHeight2 = [ZJPostReplyView heightForStr:name3 width:KWIDTH font:13];
        if (lblHeight2 > KHEIGHT) {
            lblHeight2 = KHEIGHT;
        }
        H += lblHeight2+5+5;

    }
    else if (model.hui.count > 3)
    {
        NSString *huifuName = [NSString stringWithFormat:@"%@:",model.hui[0][@"name"]];
        NSString *name = [NSString stringWithFormat:@"%@ %@",huifuName,model.hui[0][@"contents"]];
        CGFloat lHeight = [ZJPostReplyView heightForStr:name width:KWIDTH font:13];
        if (lHeight > KHEIGHT) {
            lHeight = KHEIGHT;
        }
        H += 5+lHeight;
        
        NSString *huifuName2 = [NSString stringWithFormat:@"%@:",model.hui[1][@"name"]];
        NSString *name2 = [NSString stringWithFormat:@"%@ %@",huifuName2,model.hui[1][@"contents"]];
        CGFloat lblHeight = [ZJPostReplyView heightForStr:name2 width:KWIDTH font:13];
        if (lblHeight > KHEIGHT) {
            lblHeight = KHEIGHT;
        }
        H += lblHeight+3;
        
        NSString *huifuName3 = [NSString stringWithFormat:@"%@:",model.hui[2][@"name"]];
        NSString *name3 = [NSString stringWithFormat:@"%@ %@",huifuName3,model.hui[2][@"contents"]];
        CGFloat lblHeight2 = [ZJPostReplyView heightForStr:name3 width:KWIDTH font:13];
        if (lblHeight2 > KHEIGHT) {
            lblHeight2 = KHEIGHT;
        }
        H += lblHeight2+5;
        H += 20+5;
    }
    return H;
}

+ (CGFloat)heightWithModel:(BHHuaTiModel *)model
{
    CGFloat H = 0;
    if (model.hui.count == 1) {
        NSString *huifuName = [NSString stringWithFormat:@"%@:",model.hui[0][@"name"]];
        NSString *name = [NSString stringWithFormat:@"%@ %@",huifuName,model.hui[0][@"contents"]];
        CGFloat lHeight = [ZJPostReplyView heightForStr:name width:KWIDTH font:13];
        if (lHeight > KHEIGHT) {
            lHeight = KHEIGHT;
        }
        H += 5+lHeight+5+2;
    }
    else if (model.hui.count == 2) {
        NSString *huifuName = [NSString stringWithFormat:@"%@:",model.hui[0][@"name"]];
        NSString *name = [NSString stringWithFormat:@"%@ %@",huifuName,model.hui[0][@"contents"]];
        CGFloat lHeight = [ZJPostReplyView heightForStr:name width:KWIDTH font:13];
        if (lHeight > KHEIGHT) {
            lHeight = KHEIGHT;
        }
        H += 5+lHeight;
        
        NSString *huifuName2 = [NSString stringWithFormat:@"%@:",model.hui[1][@"name"]];
        NSString *name2 = [NSString stringWithFormat:@"%@ %@",huifuName2,model.hui[1][@"contents"]];
        CGFloat lblHeight = [ZJPostReplyView heightForStr:name2 width:KWIDTH font:13];
        if (lblHeight > KHEIGHT) {
            lblHeight = KHEIGHT;
        }
        H += lblHeight+5+5;
        
    }
    else if (model.hui.count == 3) {
        NSString *huifuName = [NSString stringWithFormat:@"%@:",model.hui[0][@"name"]];
        NSString *name = [NSString stringWithFormat:@"%@ %@",huifuName,model.hui[0][@"contents"]];
        CGFloat lHeight = [ZJPostReplyView heightForStr:name width:KWIDTH font:13];
        if (lHeight > KHEIGHT) {
            lHeight = KHEIGHT;
        }
        H += 5+lHeight;
        
        NSString *huifuName2 = [NSString stringWithFormat:@"%@:",model.hui[1][@"name"]];
        NSString *name2 = [NSString stringWithFormat:@"%@ %@",huifuName2,model.hui[1][@"contents"]];
        CGFloat lblHeight = [ZJPostReplyView heightForStr:name2 width:KWIDTH font:13];
        if (lblHeight > KHEIGHT) {
            lblHeight = KHEIGHT;
        }
        H += lblHeight+3;
        
        NSString *huifuName3 = [NSString stringWithFormat:@"%@:",model.hui[2][@"name"]];
        NSString *name3 = [NSString stringWithFormat:@"%@ %@",huifuName3,model.hui[2][@"contents"]];
        CGFloat lblHeight2 = [ZJPostReplyView heightForStr:name3 width:KWIDTH font:13];
        if (lblHeight2 > KHEIGHT) {
            lblHeight2 = KHEIGHT;
        }
        H += lblHeight2+5+5;
        
    }
    else if (model.hui.count > 3)
    {
        NSString *huifuName = [NSString stringWithFormat:@"%@:",model.hui[0][@"name"]];
        NSString *name = [NSString stringWithFormat:@"%@ %@",huifuName,model.hui[0][@"contents"]];
        CGFloat lHeight = [ZJPostReplyView heightForStr:name width:KWIDTH font:13];
        if (lHeight > KHEIGHT) {
            lHeight = KHEIGHT;
        }
        H += 5+lHeight;
        
        NSString *huifuName2 = [NSString stringWithFormat:@"%@:",model.hui[1][@"name"]];
        NSString *name2 = [NSString stringWithFormat:@"%@ %@",huifuName2,model.hui[1][@"contents"]];
        CGFloat lblHeight = [ZJPostReplyView heightForStr:name2 width:KWIDTH font:13];
        if (lblHeight > KHEIGHT) {
            lblHeight = KHEIGHT;
        }
        H += lblHeight+3;
        
        NSString *huifuName3 = [NSString stringWithFormat:@"%@:",model.hui[2][@"name"]];
        NSString *name3 = [NSString stringWithFormat:@"%@ %@",huifuName3,model.hui[2][@"contents"]];
        CGFloat lblHeight2 = [ZJPostReplyView heightForStr:name3 width:KWIDTH font:13];
        if (lblHeight2 > KHEIGHT) {
            lblHeight2 = KHEIGHT;
        }
        H += lblHeight2+5;
        H += 20+5;
    }
    return H;
}

- (NSMutableAttributedString *)emojiMatching:(NSMutableAttributedString *)attributedText
{
    
    //加载plist文件中的数据
    NSBundle *bundle = [NSBundle mainBundle];
    //寻找资源的路径
    NSString *path = [bundle pathForResource:@"HWemoji1" ofType:@"plist"];
    //获取plist中的数据
    NSArray *face = [[NSArray alloc] initWithContentsOfFile:path];
    
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
    }
//    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:str];
    //通过正则表达式来匹配字符串
    NSArray *resultArray = [re matchesInString:attributedText.string options:0 range:NSMakeRange(0, attributedText.length)];
    
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        
        //获取原字符串中对应的值
        NSString *subStr = [attributedText.string substringWithRange:range];
        
        for (int i = 0; i < face.count; i ++)
        {
            if ([face[i][@"chs"] isEqualToString:subStr])
            {
                
                //face[i][@"gif"]就是我们要加载的图片
                //新建文字附件来存放我们的图片
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                
                //给附件添加图片
                textAttachment.image = [UIImage imageNamed:face[i][@"png"]];
                textAttachment.bounds = CGRectMake(0, -3, [UIFont systemFontOfSize:13].lineHeight, [UIFont systemFontOfSize:13].lineHeight);
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                
                //把字典存入数组中
                [imageArray addObject:imageDic];
                
            }
        }
    }
    //从后往前替换
    for (NSInteger j = imageArray.count -1; j >= 0; j--)
    {
        NSRange range;
        [imageArray[j][@"range"] getValue:&range];
        //进行替换
        [attributedText replaceCharactersInRange:range withAttributedString:imageArray[j][@"image"]];
        
    }
    return attributedText;
}

@end
