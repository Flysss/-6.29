//
//  HWSearchBar.m
//  HW_微博
//
//  Created by 胡伟 on 16/1/16.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import "HWSearchBar.h"
#import "UIImage+HW.h"
@implementation HWSearchBar


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.font = [UIFont systemFontOfSize:14];
        
        self.background = [UIImage resizeImage:@"searchbar_textfield_background"];
    
        UIImageView *leftView = [UIImageView new];
        leftView.image = [UIImage imageNamed:@"首页_搜索"];
        leftView.width = leftView.image.size.width + 10;
        leftView.height = leftView.image.size.height;
        leftView.contentMode = UIViewContentModeCenter;
        
        
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
    }
    return self;
}



+ (instancetype)searchbar
{
 return [[self alloc] init];
    
}
@end
