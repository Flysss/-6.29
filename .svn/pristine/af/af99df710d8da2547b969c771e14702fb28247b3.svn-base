//
//  HWTitleButton.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/7.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWTitleButton.h"


@interface HWTitleButton ()




@end
@implementation HWTitleButton

+ (instancetype)titleButton
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HWTitleButton" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    
    self.layer.cornerRadius = 5;
    
    self.layer.masksToBounds = YES;

}
- (IBAction)titleButtonClick {
    
    if ([self.delegate respondsToSelector:@selector(titleButtonDidClick:)]) {
        
        [self.delegate titleButtonDidClick:self];
        
        
    }
    
    
}

@end
