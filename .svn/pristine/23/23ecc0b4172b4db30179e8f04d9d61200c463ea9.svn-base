//
//  HWQuanZiCell.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/21.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWQuanZiCell.h"
#import "BHLeftModel.h"

@interface HWQuanZiCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titileLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end

@implementation HWQuanZiCell

+ (instancetype)quanZiCell{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HWQuanZiCell" owner:nil options:nil
             ] lastObject];
    
}

- (void)awakeFromNib {
    // Initialization code
}


+ (instancetype)quanZiCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    
    HWQuanZiCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [HWQuanZiCell quanZiCell];
    }
    
    return cell;
    
    
}

- (void)setModel:(BHLeftModel *)model
{
    _model = model;
    _titileLabel.text = model.topic;
    _countLabel.text = model.huati;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.iconpath]];
}


@end
