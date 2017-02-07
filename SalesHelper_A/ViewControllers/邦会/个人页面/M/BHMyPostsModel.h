//
//  BHMyPostsModel.h
//  SalesHelper_A
//
//  Created by 曾杰 on 16/3/4.
//  Copyright © 2016年 X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHMyPostsModel : NSObject

/**
 *  姓名
 */
@property (nonatomic, strong) NSString *name;
/**
 *  帖子图片
 */
@property (nonatomic, strong) NSString *imgpath;
/**
 *  全部帖子图片
 */
@property (nonatomic, strong) NSArray *imgpathsarr;

/**
 *  看的帖子人的id
 */
@property (nonatomic, strong) NSString *uid;
/**
 *  帖子内容
 */
@property (nonatomic, strong) NSString *contents;
/**
 *  头像图片
 */
@property (nonatomic, strong) NSString *iconpath;
/**
 *  帖子的ID
 */
@property (nonatomic, strong) NSString *tieziID;
/**
 *  等级
 */
@property (nonatomic, strong) NSString *remark;
/**
 *  关注的状态(空显示关注不为空显示取消关注)
 */
@property (nonatomic, strong) NSString *isfocus;
/**
 *  不知道啥意思
 */
@property (nonatomic, strong) NSString *nums;
/**
 *  赞
 */
@property (nonatomic, strong) NSArray *zan;
/**
 *  回复
 */
@property (nonatomic, strong) NSDictionary *hui;
/**
 *  时间
 */
@property (nonatomic, strong) NSString *addtime;
/**
 *  机构名
 */
@property (nonatomic, strong) NSString *org_name;
/**
 *  是否赞
 */
@property (nonatomic, strong) NSString *ispraise;
//点赞数
@property (nonatomic, copy) NSString * praise_num;
/**
 *  发布手机
 */
@property (nonatomic, copy)NSString * source;

@property (nonatomic, copy) NSAttributedString *attributedContents;

@property (nonatomic, copy) NSString *huis;
@property (nonatomic,copy) NSDictionary *subject_id;

/**
 *  @人的数组
 */
@property (nonatomic, strong) NSArray *usercalls;

@property (nonatomic, strong)NSDictionary *forward;

-(void)setAttributeForModel:(NSDictionary*)dict;
@end
