//
//  HWRegexResult.h
//  HW_微博
//
//  Created by 胡伟 on 16/1/27.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWRegexResult : NSObject

@property (nonatomic,copy) NSString *string;
@property (nonatomic,assign) NSRange range;

@property (nonatomic,assign,getter=isEmotion) BOOL emotion;

@end
