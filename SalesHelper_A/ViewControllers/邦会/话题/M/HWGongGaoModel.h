//
//  HWGongGaoModel.h
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/8.
//  Copyright © 2016年 X. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HWGongGaoChildModel;
@interface HWGongGaoModel : NSObject
/** 评论id  */
@property (nonatomic,copy) NSString *ID;

/**   评论人id  (uid)  */
@property (nonatomic,copy) NSString *uid;


/**   评论内容  */
@property (nonatomic,copy) NSString *contents;

/**   是否显示赞  */
@property (nonatomic,assign) NSString *is_praise;

/**   评论人头像  */
@property (nonatomic,copy) NSString *iconpath;

/**   评论人姓名  */
@property (nonatomic,copy) NSString *name;

/**   回复个数  */
@property (nonatomic,assign) NSInteger hf_num;


/**   点赞个数  */
@property (nonatomic,assign) NSInteger dz_num;


/**   发帖时间  */
@property (nonatomic,copy) NSString *addtime;


/**   子评论  */
@property (nonatomic,strong) NSArray *child;

@end
