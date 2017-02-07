//
//  BHGongGaoCell.h
//  SalesHelper_A
//
//  Created by zhipu on 16/2/24.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHGongGaoCell : UITableViewCell

@property (nonatomic, strong)UIImageView *imgHead;
@property (nonatomic, strong)UILabel *lblName;
@property (nonatomic, strong)UILabel *lblTime;
@property (nonatomic, strong)UILabel *lblBody;
@property (nonatomic, strong)UIButton *btnPingLun;
@property (nonatomic, strong)UIButton *btnZan;

- (void)cellForModel;
+ (CGFloat )heightForCell:(NSString *)str;

@end
