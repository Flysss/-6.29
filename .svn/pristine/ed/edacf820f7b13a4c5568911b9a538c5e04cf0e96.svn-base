//
//  ZJPostPingLunView.m
//  SalesHelper_A
//
//  Created by zhipu on 16/5/16.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJPostPingLunView.h"

#import "ZJPostReplyView.h"
#import "ZJPostFirstLikeView.h"
#import "UIColor+HexColor.h"
#import "BHFirstListModel.h"
#import "BHHuaTiModel.h"

@implementation ZJPostPingLunView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imgReproduction = [[UIImageView alloc]init];
        [self.imgReproduction setImage:[UIImage imageNamed:@"liuyankuang_"]];
        UIEdgeInsets edge = UIEdgeInsetsMake(10, 0, 0,0);
        self.imgReproduction.image = [self.imgReproduction.image resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
        [self addSubview:self.imgReproduction];
        
        self.likeView = [[ZJPostFirstLikeView alloc]init];
        [self addSubview:self.likeView];
        
        self.replyView = [[ZJPostReplyView alloc]init];
        [self addSubview:self.replyView];
        
        self.viewLine = [[UIView alloc]init];
        self.viewLine.backgroundColor = [UIColor colorWithHexString:@"e5e5e7"];
        [self addSubview:self.viewLine];
        
    }
    return self;
}

- (void)setModel:(BHFirstListModel *)model
{
    _model = model;
    self.likeView.zanCount = _zanCount;
    
    self.likeView.hidden = NO;
    self.replyView.hidden = NO;
    self.viewLine.hidden = YES;
    if (model.hui.count == 0) {
        self.replyView.hidden = YES;
    }
    if (_zanCount.count == 0) {
        self.likeView.hidden = YES;
    }
    
    if (_zanCount.count != 0 && model.hui.count != 0) {
        self.viewLine.hidden = NO;

    }
    self.likeView.frame = CGRectMake(0, 0, self.frame.size.width, [ZJPostFirstLikeView heightForView:_zanCount]);
    self.viewLine.frame = CGRectMake(0, CGRectGetMaxY(self.likeView.frame)+3, self.frame.size.width-10, 0.5);
    
    self.replyView.frame = CGRectMake(0, CGRectGetMaxY(self.likeView.frame)+3, self.frame.size.width, [ZJPostReplyView heightForModel:model]);
    self.imgReproduction.frame = CGRectMake(0, 0, self.frame.size.width-10, self.frame.size.height);
    
    
    
    self.replyView.model = model;
    self.likeView.model = model;
}

- (void)setHmodel:(BHHuaTiModel *)Hmodel
{
    _Hmodel = Hmodel;
    self.likeView.zanCount = _zanCount;
    
    self.likeView.hidden = NO;
    self.viewLine.hidden = YES;
    
    if (_zanCount.count == 0) {
        self.likeView.hidden = YES;
    }
    if (_zanCount.count != 0 && Hmodel.hui.count != 0) {
        self.viewLine.hidden = NO;
        
    }
    self.likeView.frame = CGRectMake(0, 0, self.frame.size.width, [ZJPostFirstLikeView heightForView:_zanCount]);
    self.viewLine.frame = CGRectMake(0, CGRectGetMaxY(self.likeView.frame)+3, self.frame.size.width-10, 0.5);
    
    self.replyView.frame = CGRectMake(0, CGRectGetMaxY(self.likeView.frame)+3, self.frame.size.width, [ZJPostReplyView heightWithModel:Hmodel]);
    self.imgReproduction.frame = CGRectMake(0, 0, self.frame.size.width-10, self.frame.size.height);
    
    
    
    self.replyView.Hmodel = Hmodel;
    self.likeView.Hmodel = Hmodel;
}



+ (CGFloat)heightForView:(BHFirstListModel *)model zanArr:(NSArray *)zanArr
{
//    ZJPostFirstLikeView *like = [[ZJPostFirstLikeView alloc]init];
//    like.model = model;
//    ZJPostReplyView *reply = [[ZJPostReplyView alloc]init];
//    reply.model = model;
    return [ZJPostFirstLikeView heightForView:zanArr]+[ZJPostReplyView heightForModel:model];
}

+ (CGFloat)heightForHView:(BHHuaTiModel *)model zanArr:(NSArray *)zanArr
{
    return [ZJPostFirstLikeView heightForView:zanArr]+[ZJPostReplyView heightWithModel:model];
}
@end
