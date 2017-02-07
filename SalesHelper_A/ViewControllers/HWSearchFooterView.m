//
//  HWSearchFooterView.m
//  卷皮折扣
//
//  Created by 胡伟 on 16/2/17.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import "HWSearchFooterView.h"

@interface HWSearchFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *claerButton;

@end

@implementation HWSearchFooterView

+ (instancetype)footView
{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HWSearchFooterView" owner:nil options:nil] lastObject];
    
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self.claerButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
}
@end
