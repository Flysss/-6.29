//
//  RecommentClientCell.h
//  SalesHelper_A
//
//  Created by Brant on 16/1/26.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^sendBackOfButton)(UIButton* btn,NSString * imageStr);

@interface RecommentClientCell : UITableViewCell

@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) UILabel * confrimLabel;

//状态
@property (nonatomic, strong) UILabel *stageLabel;

@property (nonatomic, strong) UIButton * rejectBtn;

@property (nonatomic, copy) sendBackOfButton  block;

@property (nonatomic, copy)NSString * imageString;

- (void)configtableViewCellWithDic:(NSDictionary *)dic;

+ (CGFloat)tableViewCellHeightWithDic:(NSDictionary *)dic;

@end
