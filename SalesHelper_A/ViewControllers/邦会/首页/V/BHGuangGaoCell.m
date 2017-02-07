//
//  BHGuangGaoCell.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/18.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHGuangGaoCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+AutoLayout.h"

@implementation BHGuangGaoCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.imgBac = [[UIImageView alloc]init];
        self.imgBac.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imgBac];
        [self.imgBac autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.imgBac autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.imgBac autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.imgBac autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    }
    return self;
}

- (void)cellForModel:(BHFirstListModel *)model
{
    self.imgBac.frame = self.frame;
    
    [self.imgBac sd_setImageWithURL:[NSURL URLWithString:model.imgpath] placeholderImage:[UIImage imageNamed:@"pp_pg"]];
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
