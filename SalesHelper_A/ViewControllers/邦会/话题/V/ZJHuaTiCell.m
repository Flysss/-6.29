//
//  ZJHuaTiCell.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/26.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJHuaTiCell.h"

#import "ZJPostHead.h"
#import "BHHuaTiModel.h"
#import "ZJPostBottomBar.h"
#import "HWContentsLabel.h"
#import "ZJPostPicView.h"
#import "ZJPostNewBottomBar.h"
#import "ZJPostPingLunView.h"
#import "UIColor+HexColor.h"
#import "ZJPostFirstLikeView.h"
#import "ZJPostReplyView.h"
#import "ZJForwardView.h"

#define HeadViewHeight 35+29/2
#define ForwardViewHeight 60


@implementation ZJHuaTiCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.postHeadView = [[ZJPostHead alloc]init];
        [self.contentView addSubview:self.postHeadView];
        
        self.lblbody = [[HWContentsLabel alloc]init];
        [self.contentView addSubview:self.lblbody];
        
        self.postPicView = [[ZJPostPicView alloc]init];
        [self.contentView addSubview:self.postPicView];
        
        self.postNewBar = [[ZJPostNewBottomBar alloc]init];
        [self.contentView addSubview:self.postNewBar];
        
        self.postPingView = [[ZJPostPingLunView alloc]init];
        [self.contentView addSubview:self.postPingView];
        
        self.forwardView = [[ZJForwardView alloc]init];
        [self.contentView addSubview:self.forwardView];
    }
    return self;
}

- (void)setModel:(BHHuaTiModel *)model
{
    _model = model;
    
    if (![model.forward isKindOfClass:[NSDictionary class]])
    {
        self.forwardView.hidden = YES;
        self.postPingView.zanCount = _zanArr;
        
        CGFloat H = 0;
        self.postHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HeadViewHeight);
        H = HeadViewHeight;
        
        self.lblbody.hidden = YES;
        if (![model.attributedContents.string isEqualToString:@""])
        {
            self.lblbody.hidden = NO;
            CGFloat textX = 10+10+35;
            CGFloat textY = H+10;
            CGFloat maxW = self.width - textX - 10;
            CGSize maxSize = CGSizeMake(maxW, 120);
            CGSize textSize = [model.attributedContents boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            if (textSize.height > 120) {
                textSize.height = 120;
            }
            self.lblbody.frame = (CGRect){{textX,textY},textSize};
            
            H += textSize.height+10;
        }
        
        self.postPicView.hidden = YES;
        if (![model.imgpath isEqualToString:@""]) {
            self.postPicView.hidden = NO;
            CGFloat picHeight = [ZJPostPicView HeightForHView:model];
            self.postPicView.frame = CGRectMake(10+10+35, H, SCREEN_WIDTH-(10+10+35), picHeight);
            H += picHeight;
            self.postNewBar.frame = CGRectMake(10+10+35, CGRectGetMaxY(self.postPicView.frame), SCREEN_WIDTH-(10+10+35), 43);
        }
        else
        {
            self.postNewBar.frame = CGRectMake(10+10+35, H, SCREEN_WIDTH-(10+10+35), 43);
        }
        H += 43;
        
        self.postPingView.hidden = YES;
        if (_zanArr.count != 0 || model.hui.count != 0)
        {
            self.postPingView.hidden = NO;
            self.postPingView.frame = CGRectMake(10+10+35, H, SCREEN_WIDTH-(10+10+35), [ZJPostPingLunView heightForHView:model zanArr:_zanArr]);
            H += [ZJPostPingLunView heightForHView:model zanArr:_zanArr];
        }
        
    }
    else
    {
        self.postPingView.zanCount = _zanArr;
        
        self.forwardView.hidden = NO;
        self.postPicView.hidden = YES;
        self.lblbody.hidden = YES;
        
        CGFloat H = 0;
        self.postHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HeadViewHeight);
        H = HeadViewHeight;
        
        if (![model.attributedContents.string isEqualToString:@""])
        {
            self.lblbody.hidden = NO;
            CGFloat textX = 10+10+35;
            CGFloat textY = H+10;
            CGFloat maxW = self.width - textX - 10;
            CGSize maxSize = CGSizeMake(maxW, 120);
            CGSize textSize = [model.attributedContents boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            if (textSize.height > 120) {
                textSize.height = 120;
            }
            self.lblbody.frame = (CGRect){{textX,textY},textSize};
            
            H += textSize.height+10;
        }
        
        self.forwardView.frame = CGRectMake(10+10+35, H+10, SCREEN_WIDTH-(10+10+35), ForwardViewHeight);
        H += ForwardViewHeight+10;
        
        self.postNewBar.frame = CGRectMake(10+10+35, H, SCREEN_WIDTH-(10+10+35), 43);
        H += 43;
        
        self.postPingView.hidden = YES;
        if (_zanArr.count != 0 || model.hui.count != 0)
        {
            self.postPingView.hidden = NO;
            self.postPingView.frame = CGRectMake(10+10+35, H, SCREEN_WIDTH-(10+10+35), [ZJPostPingLunView heightForHView:model zanArr:_zanArr]);
            H += [ZJPostPingLunView heightForHView:model zanArr:_zanArr];
        }
    }
    
    self.postHeadView.Hmodel = model;
    self.postPicView.Hmodel = model;
    self.postNewBar.Hmodel = model;
    self.postPingView.Hmodel = model;
    self.lblbody.attributedText = model.attributedContents;
    self.forwardView.dic = model.forward;
}

+ (CGFloat)heightForModel:(BHHuaTiModel *)model zanArr:(NSMutableArray *)zanArr;
{
    
    CGFloat H = 0;
    if (model != nil)
    {
        if (![model.forward isKindOfClass:[NSDictionary class]])
        {
            H = HeadViewHeight;
            if (![model.attributedContents.string isEqualToString:@""])
            {
                CGFloat textX = 10+9+85/2;
                CGFloat maxW = SCREEN_WIDTH - textX - 10;
                CGSize maxSize = CGSizeMake(maxW, 120);
                CGSize textSize = [model.attributedContents boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                if (textSize.height > 120) {
                    textSize.height = 120;
                }
                H += textSize.height+10;
            }
            if (![model.imgpath isEqualToString:@""])
            {
                H += [ZJPostPicView HeightForHView:model ];
            }
            H += 43;
            if (zanArr.count != 0 || model.hui.count != 0)
            {
                H += [ZJPostPingLunView heightForHView:model zanArr:zanArr]+10;
            }
        }else
        {
            H = HeadViewHeight;
            if (![model.attributedContents.string isEqualToString:@""])
            {
                CGFloat textX = 10+9+85/2;
                CGFloat maxW = SCREEN_WIDTH - textX - 10;
                CGSize maxSize = CGSizeMake(maxW, 120);
                CGSize textSize = [model.attributedContents boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                if (textSize.height > 120) {
                    textSize.height = 120;
                }
                H += textSize.height+10;
            }
            H += ForwardViewHeight+10;
            
            H += 43;
            if (zanArr.count != 0 || model.hui.count != 0)
            {
                H += [ZJPostPingLunView heightForHView:model zanArr:zanArr]+10;
            }
        }
        
    }
    
    
   

    
//    CGFloat H = 0;
//    if (model != nil)
//    {
//        if (![model.forward isKindOfClass:[NSDictionary class]])
//        {
//            H = HeadViewHeight;
//            if (![model.attributedContents.string isEqualToString:@""])
//            {
//                CGFloat textX = 10+9+85/2;
//                CGFloat maxW = SCREEN_WIDTH - textX - 10;
//                CGSize maxSize = CGSizeMake(maxW, 120);
//                CGSize textSize = [model.attributedContents boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//                if (textSize.height > 120) {
//                    textSize.height = 120;
//                }
//                H += textSize.height+10;
//            }
//            if (![model.imgpath isEqualToString:@""])
//            {
//                H += [ZJPostPicView HeightForHView:model];
//            }
//            H += 43;
//            if (zanArr.count != 0 || model.hui.count != 0)
//            {
//                H += [ZJPostPingLunView heightForHView:model zanArr:zanArr]+10;
//            }
//        }
//        else
//        {
//            H = HeadViewHeight;
//            if (![model.attributedContents.string isEqualToString:@""])
//            {
//                CGFloat textX = 10+9+85/2;
//                CGFloat maxW = SCREEN_WIDTH - textX - 10;
//                CGSize maxSize = CGSizeMake(maxW, 120);
//                CGSize textSize = [model.attributedContents boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//                if (textSize.height > 120) {
//                    textSize.height = 120;
//                }
//                H += textSize.height+10;
//            }
//            H += ForwardViewHeight+10;
//            
//            H += 43;
//            if (zanArr.count != 0 || model.hui.count != 0)
//            {
//                H += [ZJPostPingLunView heightForHView:model zanArr:zanArr]+10;
//            }
//
//        }
//
//    }
    
    
    return H;
}

@end
