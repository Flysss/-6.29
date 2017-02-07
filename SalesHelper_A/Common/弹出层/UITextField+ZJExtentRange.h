//
//  UITextField+ZJExtentRange.h
//  SalesHelper_A
//
//  Created by zhipu on 16/7/8.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ZJExtentRange)
- (NSRange) selectedRange;
- (void) setSelectedRange:(NSRange) range;
@end
