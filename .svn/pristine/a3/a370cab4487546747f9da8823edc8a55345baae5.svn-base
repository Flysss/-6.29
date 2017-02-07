//
//  HWGongGaoChildView.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/8.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWGongGaoChildView.h"
#import "HWGongGaoChildFrame.h"
#import "HWGongGaoChildModel.h"
@interface HWGongGaoChildView ()

@property (nonatomic,weak) UILabel *oneLabel;
@property (nonatomic,weak) UILabel *twoLabel;
@property (nonatomic,weak) UILabel *threeLabel;
@property (nonatomic,weak) UIButton *moreButton;


@end
@implementation HWGongGaoChildView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
                
        UILabel *oneLabel = [[UILabel alloc] init];
        oneLabel.font = [UIFont systemFontOfSize:9];
        [self addSubview:oneLabel];
        self.oneLabel = oneLabel;
        
        UILabel *twoLabel = [[UILabel alloc] init];
        twoLabel.backgroundColor = [UIColor blueColor];
        twoLabel.font = [UIFont systemFontOfSize:9];
        [self addSubview:twoLabel];
        self.twoLabel = twoLabel;
        
        
        UILabel *threeLabel = [[UILabel alloc] init];
        threeLabel.backgroundColor = [UIColor blackColor];
        threeLabel.font = [UIFont systemFontOfSize:9];
        [self addSubview:threeLabel];
        self.threeLabel = threeLabel;
        
        
        UIButton *moreButton = [[UIButton alloc] init];
        moreButton.backgroundColor = [UIColor redColor];
        [self addSubview:moreButton];
        self.moreButton = moreButton;
        
        
        
        
    }
    
    return self;
}


- (void)setChildFrame:(HWGongGaoChildFrame *)childFrame
{
    
    _childFrame = childFrame;
    
    NSInteger count = childFrame.child.count;
    
        
        
    if (count == 1) {
            
            HWGongGaoChildModel *childModel = childFrame.child[0];

            self.oneLabel.text = [NSString stringWithFormat:@"%@ 回复:%@",childModel.name,childModel.contents];
            self.oneLabel.frame = childFrame.oneHuiFuFrame;
            
        }else if (count ==2){
            
            HWGongGaoChildModel *childModel1 = childFrame.child[0];
            
            self.oneLabel.text = [NSString stringWithFormat:@"%@ 回复:%@",childModel1.name,childModel1.contents];
            self.oneLabel.frame = childFrame.oneHuiFuFrame;
            
            
            HWGongGaoChildModel *childModel2 = childFrame.child[1];
            self.twoLabel.text = [NSString stringWithFormat:@"%@ 回复:%@",childModel2.name,childModel2.contents];
            self.twoLabel.frame = childFrame.twoHuiFuFrame;

            
            
            
        }else if (count ==3){
            HWGongGaoChildModel *childModel1 = childFrame.child[0];
            
            self.oneLabel.text = [NSString stringWithFormat:@"%@ 回复:%@",childModel1.name,childModel1.contents];
            self.oneLabel.frame = childFrame.oneHuiFuFrame;
            
            
            HWGongGaoChildModel *childModel2 = childFrame.child[1];
            self.twoLabel.text = [NSString stringWithFormat:@"%@ 回复:%@",childModel2.name,childModel2.contents];
            self.twoLabel.frame = childFrame.twoHuiFuFrame;
            
            
            
            HWGongGaoChildModel *childModel3 = childFrame.child[2];
            self.threeLabel.text = [NSString stringWithFormat:@"%@ 回复:%@",childModel3.name,childModel3.contents];
            self.threeLabel.frame = childFrame.threeHuiFuFrame;

            
            
            
        }else{
            
                       
            
            [self.moreButton setTitle:[NSString stringWithFormat:@"更多%d条回复",count] forState:UIControlStateNormal];
            
            self.moreButton.frame = childFrame.moreButtonFrame;
            
        }
        
        
    
    
}

@end
