//
//  walletCell.h
//  SalesHelper_A
//
//  Created by flysss on 16/4/22.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface walletCell : UITableViewCell

@property (nonatomic, strong) UILabel * nameLabel;

@property (nonatomic, strong)UILabel * statusLabel;

@property (nonatomic, strong) UILabel * timeLabel;

@property (nonatomic, strong) UILabel * moneyLabel;

-(void)setAttributeForCellWithParam:(NSDictionary*)dict;

@end
