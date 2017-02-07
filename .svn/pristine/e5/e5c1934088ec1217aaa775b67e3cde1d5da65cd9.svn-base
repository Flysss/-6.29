//
//  PostAndOrgCell.h
//  SalesHelper_A
//
//  Created by flysss on 16/3/23.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^clickBtnBlock)(UIButton* sender);
@interface PostAndOrgCell : UITableViewCell

//头像
@property (nonatomic, strong) UIImageView* headImg;
//昵称
@property (nonatomic, strong) UILabel * userName;
//等级
@property (nonatomic, strong) UILabel * levelLab;
//机构
@property (nonatomic, strong)UILabel * companyLab;
//加关注
@property (nonatomic, strong)UIButton * focusOnBtn;

@property (nonatomic, copy) clickBtnBlock block;

@property (nonatomic, copy)NSString * userID;

-(void)setSubViewForCell:(NSDictionary*)dict;





@end
