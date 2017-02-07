//
//  ZJPostBodyView.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/19.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJPostBodyView.h"
#import "UIColor+HexColor.h"
#import "BHMyPostsModel.h"
#import "HWContentsLabel.h"
#import "ZJPostImageBodyView.h"
#import "ZJMyPostBettomView.h"
@implementation ZJPostBodyView

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
        self.lblBod = [[UILabel alloc]init];
        self.lblBod.font = [UIFont systemFontOfSize:18];
        self.lblBod.textColor = [UIColor colorWithHexString:@"676767"];
        
        self.imgBodyView = [[ZJPostImageBodyView alloc]init];
        [self addSubview:self.imgBodyView];
        
    }
    return self;
}

- (void)setModel:(BHMyPostsModel *)model
{
    _model = model;
    
    self.imgBodyView.hidden= YES;
    
    CGFloat H = 0;
    
    if (![model.imgpath isEqualToString:@""])
    {
        self.imgBodyView.hidden = NO;
        CGFloat height = [ZJPostImageBodyView HeightForView:model];

        self.imgBodyView.frame = CGRectMake(0, H, SCREEN_WIDTH, height);
        H += height;

    }
    
    self.lblBody.attributedText = model.attributedContents;
    if (model.source == nil)
    {
        model.source = @"";
    }
    
    self.imgBodyView.model = model;

    self.lblBod.text = model.contents;
}

+ (CGFloat)heightForString:(NSString *)str font:(CGFloat)font width:(CGFloat )width
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGRect bound = [str boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return bound.size.height;
}

+ (CGFloat)heightBodyView:(BHMyPostsModel *)model
{
    CGFloat H = 0;

    if (![model.imgpath isEqualToString:@""])
    {
        H += [ZJPostImageBodyView HeightForView:model];
    }

    return H;
    
}

@end
