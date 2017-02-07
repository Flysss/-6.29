//
//  HomeTableViewCell.h
//  SalesHelper_A
//
//  Created by summer on 15/7/9.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

/**
 *  楼盘id
 */
@property (nonatomic,copy)NSString * ID;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;

@property(nonatomic,retain)NSDictionary * info;
@property (weak, nonatomic) IBOutlet UILabel *smallPicLabel1;
@property (weak, nonatomic) IBOutlet UILabel *smallPicLabel2;

//楼盘展示图
@property (weak, nonatomic) IBOutlet UIImageView *buildingShowImageView;

//

/**
 *  楼盘名称
 */
@property (weak, nonatomic) IBOutlet UILabel *communityName;
/**
 *  是否认证
 */
@property (weak, nonatomic) IBOutlet UIImageView *d;
/**
 *  佣金起价
 */
@property (weak, nonatomic) IBOutlet UILabel *commissionPriceLabel;
/**
 *  楼盘平均单价
 */
@property (weak, nonatomic) IBOutlet UILabel *averagePrice;
/**
 *  补贴金额
 */
@property (weak, nonatomic) IBOutlet UILabel *allowanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;

/**
 *  报名人数
 */
@property (weak, nonatomic) IBOutlet UILabel *signedCounts;


@end
