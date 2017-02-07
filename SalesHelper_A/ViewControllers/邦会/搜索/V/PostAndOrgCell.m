//
//  PostAndOrgCell.m
//  SalesHelper_A
//
//  Created by flysss on 16/3/23.
//  Copyright © 2016年 X. All rights reserved.
//

#import "PostAndOrgCell.h"
#import "UIColor+HexColor.h"

@implementation PostAndOrgCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        self.headImg = [[UIImageView alloc]init];
        self.headImg.layer.cornerRadius = 40/2;
        self.headImg.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headImg];
        
        self.userName = [[UILabel alloc]init];
        self.userName.font = Default_Font_15;
        self.userName.textColor = [UIColor colorWithHexString:@"404040"];
         [self.contentView addSubview:self.userName];
        
        self.levelLab = [[UILabel alloc]init];
        self.levelLab.font = Default_Font_13;
        self.levelLab.layer.cornerRadius = 5.0f;
        self.levelLab.layer.borderWidth = 1.0f;
        self.levelLab.textColor = [UIColor colorWithHexString:@"00aff0"];
        self.levelLab.textAlignment = NSTextAlignmentCenter;
        self.levelLab.layer.borderColor = [UIColor colorWithHexString:@"f2f2f2"].CGColor;
        self.levelLab.layer.masksToBounds = YES;
         [self.contentView addSubview:self.levelLab];
        
        self.companyLab = [[UILabel alloc]init];
        self.companyLab.font = Default_Font_13;
        self.companyLab.textColor = [UIColor colorWithHexString:@"bdbdbd"];
        [self.contentView addSubview:self.companyLab];
        
        self.focusOnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.focusOnBtn.frame = CGRectMake(SCREEN_WIDTH-70,15, 70, 30);
        [self.focusOnBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.focusOnBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [self.focusOnBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [self.focusOnBtn setImage:[[UIImage alloc]init] forState:UIControlStateSelected];
        [self.focusOnBtn setTitleColor:[UIColor colorWithHexString:@"404040"] forState:UIControlStateNormal];
        self.focusOnBtn.titleLabel.font = Default_Font_15;
        
        [self.focusOnBtn setImage:[UIImage imageNamed:@"plus_335px_1187514_easyicon.net"] forState:UIControlStateNormal];
        
//        [self.focusOnBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
//        [self.focusOnBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        
        [self.focusOnBtn addTarget:self action:@selector(clickToFocusOn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.focusOnBtn];
        
        self.focusOnBtn.hidden = YES;

        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)setSubViewForCell:(NSDictionary *)dict
{
    
    self.focusOnBtn.tag = [dict[@"uid"] integerValue];
//    if ([self.userID integerValue] ==  [dict[@"uid"] integerValue])
//    {
//        self.focusOnBtn.hidden = YES;
//    }
//    else
//    {
//        self.focusOnBtn.hidden = NO;
//    }
       self.headImg.image = [UIImage imageNamed:@"默认个人图像"];
        if ( dict[@"iconpath"] != nil &&  dict[@"iconpath"] != [NSNull null] &&  dict[@"iconpath"])
        {
            [self.headImg sd_setImageWithURL:[NSURL URLWithString:dict[@"iconpath"]] placeholderImage:[UIImage imageNamed:@"默认个人图像"]];
        }
        if ( dict[@"name"] != nil &&  dict[@"name"] != [NSNull null] &&  dict[@"name"]) {
            self.userName.text = dict[@"name"];////
        }else{
            self.userName.text = @"未知";//dict[@"name"];////
        }
        if ( dict[@"remark"] != nil &&  dict[@"remark"] != [NSNull null] &&  dict[@"remark"]) {
            self.levelLab.text = dict[@"remark"] ;//;//
        }else{
            self.levelLab.text = @"LV.0" ;//;//
        }
        if ( dict[@"org_name"] != nil &&  dict[@"org_name"] != [NSNull null] &&  dict[@"org_name"]) {
            self.companyLab.text = dict[@"org_name"];
        }else{
            self.companyLab.text = @"";//dict[@"org_name"];
        }
        self.headImg.frame = CGRectMake(10,10, 40, 40);
        CGSize userSize = [self sizeForString:self.userName.text font:15 size:CGSizeMake(0, 20)];
        self.userName.frame = CGRectMake(CGRectGetMaxX(self.headImg.frame)+10,10,userSize.width, 20);
        self.companyLab.frame = CGRectMake(CGRectGetMaxX(self.headImg.frame)+10, CGRectGetMaxY(self.userName.frame)+5, self.bounds.size.width-80, 15);
        self.levelLab.frame = CGRectMake(CGRectGetMaxX(self.userName.frame), 12,40,15);
}
-(void)clickToFocusOn:(UIButton*)sender
{
    self.block(sender);
}

#pragma mark-自适应宽高
- (CGSize)sizeForString:(NSString *)str font:(CGFloat)font size:(CGSize)size
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGRect bound = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return bound.size;
}

@end
