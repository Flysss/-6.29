//
//  HWGongGaoChildFrame.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/8.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWGongGaoChildFrame.h"
#import "HWGongGaoChildModel.h"
@implementation HWGongGaoChildFrame

- (void)setChild:(NSArray *)child
{
    _child = child;


    NSInteger count = child.count;

    CGFloat H = 0;

    if (count == 1) {//一条评论
        HWGongGaoChildModel *childModel = child[0];

        CGFloat nameX = 0;
        CGFloat nameY = 10;
        NSString *name = [NSString stringWithFormat:@"%@ 回复:%@",childModel.name,childModel.contents];
        CGSize nameSize = [name sizeWithFont:[UIFont systemFontOfSize:9]];
        self.oneHuiFuFrame = (CGRect){{nameX, nameY}, nameSize};
        H = CGRectGetMaxY(self.oneHuiFuFrame);



    }else if (count == 2){//两条评论

        HWGongGaoChildModel *childModel1 = child[0];
        CGFloat oneNameX = 10;
        CGFloat oneNameY = 10;
        NSString *oneName = [NSString stringWithFormat:@"%@ 回复:%@",childModel1.name,childModel1.contents];
        CGSize oneNameSize = [oneName sizeWithFont:[UIFont systemFontOfSize:9]];
        self.oneHuiFuFrame = (CGRect){{oneNameX, oneNameY}, oneNameSize};

        HWGongGaoChildModel *childModel2 = child[1];
        CGFloat twoNameX = 10;
        CGFloat twoNameY = CGRectGetMaxY(self.oneHuiFuFrame) + 10;
        NSString *twoName = [NSString stringWithFormat:@"%@ 回复:%@",childModel2.name,childModel2.contents];
        CGSize twoNameSize = [twoName sizeWithFont:[UIFont systemFontOfSize:9]];
        self.twoHuiFuFrame = (CGRect){{twoNameX, twoNameY}, twoNameSize};
        H = CGRectGetMaxY(self.twoHuiFuFrame);


    }else if (count == 3)//三条评论
    {

        HWGongGaoChildModel *childModel1 = child[0];
        CGFloat oneNameX = 10;
        CGFloat oneNameY = 10;
        NSString *oneName = [NSString stringWithFormat:@"%@ 回复:%@",childModel1.name,childModel1.contents];
        CGSize oneNameSize = [oneName sizeWithFont:[UIFont systemFontOfSize:9]];
        self.oneHuiFuFrame = (CGRect){{oneNameX, oneNameY}, oneNameSize};

        HWGongGaoChildModel *childModel2 = child[1];
        CGFloat twoNameX = 10;
        CGFloat twoNameY = CGRectGetMaxY(self.oneHuiFuFrame) + 10;
        NSString *twoName = [NSString stringWithFormat:@"%@ 回复:%@",childModel2.name,childModel2.contents];
        CGSize twoNameSize = [twoName sizeWithFont:[UIFont systemFontOfSize:9]];
        self.twoHuiFuFrame = (CGRect){{twoNameX, twoNameY}, twoNameSize};


        HWGongGaoChildModel *childModel3 = child[2];
        CGFloat threeNameX = 10;
        CGFloat threeNameY = CGRectGetMaxY(self.oneHuiFuFrame) + 10;
        NSString *threeName = [NSString stringWithFormat:@"%@ 回复:%@",childModel3.name,childModel3.contents];
        CGSize threeNameSize = [threeName sizeWithFont:[UIFont systemFontOfSize:9]];
        self.threeHuiFuFrame = (CGRect){{threeNameX, threeNameY}, threeNameSize};

        H = CGRectGetMaxY(self.threeHuiFuFrame);



    }else{ //更多评论

        HWGongGaoChildModel *childModel1 = child[0];
        CGFloat oneNameX = 10;
        CGFloat oneNameY = 10;
        NSString *oneName = [NSString stringWithFormat:@"%@ 回复:%@",childModel1.name,childModel1.contents];
        CGSize oneNameSize = [oneName sizeWithFont:[UIFont systemFontOfSize:9]];
        self.oneHuiFuFrame = (CGRect){{oneNameX, oneNameY}, oneNameSize};


        HWGongGaoChildModel *childModel2 = child[1];
        CGFloat twoNameX = 10;
        CGFloat twoNameY = CGRectGetMaxY(self.oneHuiFuFrame) + 10;
        NSString *twoName = [NSString stringWithFormat:@"%@ 回复:%@",childModel2.name,childModel2.contents];
        CGSize twoNameSize = [twoName sizeWithFont:[UIFont systemFontOfSize:9]];
        self.twoHuiFuFrame = (CGRect){{twoNameX, twoNameY}, twoNameSize};


        HWGongGaoChildModel *childModel3 = child[2];
        CGFloat threeNameX = 10;
        CGFloat threeNameY = CGRectGetMaxY(self.twoHuiFuFrame) + 10;
        NSString *threeName = [NSString stringWithFormat:@"%@ 回复:%@",childModel3.name,childModel3.contents];
        CGSize threeNameSize = [threeName sizeWithFont:[UIFont systemFontOfSize:9]];
        self.threeHuiFuFrame = (CGRect){{threeNameX, threeNameY}, threeNameSize};





        CGFloat moreButtonX = 10;
        CGFloat moreButtonY = CGRectGetMaxY(self.threeHuiFuFrame) + 10;

        NSString *moreButtonTitle = [NSString stringWithFormat:@"更多%d条回复",count];
        CGSize moreButtonSize = [moreButtonTitle sizeWithFont:[UIFont systemFontOfSize:9]];
        
        self.moreButtonFrame = (CGRect){{moreButtonX, moreButtonY}, moreButtonSize};
        
        
        
        H = CGRectGetMaxY(self.moreButtonFrame);
    }
    
    
    
    CGFloat x = 0;
    CGFloat y = 0; // 高度 = 原创微博最大的Y值
    CGFloat w = SCREEN_WIDTH;
    self.frame = CGRectMake(x, y, w, H);

    
    
}


@end
