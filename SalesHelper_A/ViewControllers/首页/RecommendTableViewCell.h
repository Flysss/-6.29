//
//  RecommendTableViewCell.h
//  SalesHelper_A
//
//  Created by flysss on 16/4/7.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendTableViewCell : UITableViewCell

/**
 *  楼盘id
 */
@property (nonatomic,copy)NSString * ID;

@property(nonatomic,retain)NSDictionary * info;

/**
 *  是否选中
 */
@property(nonatomic,assign,getter=isChoosen)BOOL choosen;

@property (strong, nonatomic)  UIButton *choosenBtn;

@property (nonatomic, strong) UILabel* smallPicLabel1;

@property (nonatomic, strong) UILabel* smallPicLabel2;
//楼盘展示图
@property (nonatomic, strong) UIImageView * buildingShowImageView;
/**
 *  楼盘名称
 */
@property (nonatomic, strong) UILabel * communityName;
/**
 *  是否认证
 */
@property (nonatomic, strong) UIImageView* d;
/**
 *  佣金起价
 */
@property (nonatomic, strong) UILabel* commissionPriceLabel;
/**
 *  楼盘平均单价
 */
@property (nonatomic, strong) UILabel* averagePrice;
/**
 *  补贴金额
 */
@property (nonatomic, strong) UILabel* allowanceLabel;

//物业类型
@property (nonatomic, strong) UILabel * tenementLab1;
@property (nonatomic, strong) UILabel * tenementLab2;
@property (nonatomic, strong) UILabel * tenementLab3;
@property (nonatomic, strong) UILabel * tenementLab4;
@property (nonatomic, strong) UILabel * tenementLab5;

/**
 *  报名人数
 */
@property (nonatomic, strong) UILabel* signedCount;

@property (nonatomic, strong)UIImageView* yongImg;

@property (nonatomic, strong)UIImageView* averageImg;

@property (nonatomic, strong)UIImageView* allowanceImg;

@property (nonatomic, strong)UILabel * tagesLab1;
@property (nonatomic, strong)UILabel * tagesLab2;
@property (nonatomic, strong)UILabel * tagesLab3;
@property (nonatomic, strong)UILabel * tagesLab4;
@property (nonatomic, strong)UILabel * tagesLab5;


-(void)setAttributeForCell:(NSDictionary*)dict;

@end
