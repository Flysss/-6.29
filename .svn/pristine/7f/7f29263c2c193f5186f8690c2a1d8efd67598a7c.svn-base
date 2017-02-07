//
//  BHNewPersonCell.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/19.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHNewPersonCell.h"

#import "ZJCellHeadView.h"
#import "ZJPostBodyView.h"
#import "ZJForwardView.h"
#import "BHMyPostsModel.h"
#import "UIColor+HexColor.h"
#import "HWContentsLabel.h"
#import "ZJMyPostBettomView.h"

@implementation BHNewPersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.headView = [[ZJCellHeadView alloc]init];
        [self.contentView addSubview:self.headView];
        
        self.postBodyView = [[ZJPostBodyView alloc]init];
        [self.contentView addSubview:self.postBodyView];
        
        self.lblBody = [[HWContentsLabel alloc]init];
        [self.contentView addSubview:self.lblBody];
        
        self.forwardView = [[ZJForwardView alloc]init];
        self.forwardView.backgroundColor= [UIColor colorWithHexString:@"f3f3f3"];
        [self.contentView addSubview:self.forwardView];
        
        self.MyPostBettomView = [[ZJMyPostBettomView alloc]init];
        [self addSubview:self.MyPostBettomView];
        
        
    }
    return self;
}

- (void)setModel:(BHMyPostsModel *)model
{
    _model = model;
    CGFloat H = 0;
    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 143/2);
    H += 143/2;
    
    self.lblBody.hidden = YES;
    if (model.contents != nil)
    {
        self.lblBody.hidden = NO;
        CGFloat textX = 21/2;
        CGFloat maxW = SCREEN_WIDTH-21;
        CGSize maxSize = CGSizeMake(maxW, 120);
        CGSize textSize = [model.attributedContents boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        if (textSize.height > 120) {
            textSize.height = 120;
        }
        self.lblBody.frame = (CGRect){{textX,CGRectGetMaxY(self.headView.frame)+10},textSize};
        H += textSize.height+10;

    }

    self.forwardView.hidden = YES;
    self.postBodyView.hidden = YES;

    
    if ([model.forward isKindOfClass:[NSDictionary class]])
    {
        self.forwardView.hidden = NO;
        self.forwardView.frame =  CGRectMake(10, H+10, SCREEN_WIDTH-20, 60);
        H += 70;
       
    }
    else
    {
        self.postBodyView.hidden = NO;
        CGFloat height = [ZJPostBodyView heightBodyView:model];
        self.postBodyView.frame = CGRectMake(0, H, SCREEN_WIDTH,height );
        H += height;
    }
    
    CGFloat height = [ZJMyPostBettomView heightBodyView:model];
    self.MyPostBettomView.frame = CGRectMake(21/2,H, SCREEN_WIDTH-21, height);
    H += height;
    
    
    self.headView.model = model;
    self.lblBody.attributedText = model.attributedContents;
    self.postBodyView.model = model;
    self.forwardView.dic = model.forward;
    self.MyPostBettomView.model = model;
}

+ (CGFloat)heightforCell:(BHMyPostsModel *)model
{
    CGFloat H = 0;

    H += 143/2;
    if (model.contents != nil)
    {
        CGFloat maxW = SCREEN_WIDTH-21;
        CGSize maxSize = CGSizeMake(maxW, 120);
        CGSize textSize = [model.attributedContents boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        if (textSize.height > 120) {
            textSize.height = 120;
        }
        H += textSize.height+10;
    }
    if ([model.forward isKindOfClass:[NSDictionary class]])
    {
        H += 70;
    }
    else
    {
        H += [ZJPostBodyView heightBodyView:model];
    }
    H += [ZJMyPostBettomView heightBodyView:model];
    
    return H;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
