//
//  ChooseTableCell.h
//  SalesHelper_A
//
//  Created by summer on 15/7/13.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseTableCell : UITableViewCell
/**
 *  楼盘id
 */
@property (nonatomic,copy)NSString * ID;

@property(nonatomic,retain)NSDictionary * info;

/**
 *  是否选中
 */
@property(nonatomic,assign,getter=isChoosen)BOOL choosen;
/**
 *  对勾
 */
@property (weak, nonatomic) IBOutlet UIButton *choosenBtn;

//楼盘展示图
@property (weak, nonatomic) IBOutlet UIImageView *buildingShowImageView;
/**
 *  楼盘名称
 */
@property (weak, nonatomic) IBOutlet UILabel *communityName;
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


@property (weak, nonatomic) IBOutlet UILabel *smallPicLabel1;
@property (weak, nonatomic) IBOutlet UILabel *smallPicLabel2;
/**
 *  是否认证
 */
@property (weak, nonatomic) IBOutlet UIImageView *d;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
/**
 *  报名人数
 */
@property (weak, nonatomic) IBOutlet UILabel *signedCounts;
@end
