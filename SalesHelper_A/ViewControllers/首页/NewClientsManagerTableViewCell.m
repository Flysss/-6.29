//
//  NewClientsManagerTableViewCell.m
//  SalesHelper_A
//
//  Created by summer on 15/11/2.
//  Copyright © 2015年 X. All rights reserved.
//

#import "NewClientsManagerTableViewCell.h"

@implementation NewClientsManagerTableViewCell
{
    __weak IBOutlet UILabel *namePicLabel;
    
    __weak IBOutlet UILabel *nameLabel;
    
    __weak IBOutlet UILabel *levelLabel;
    
    __weak IBOutlet UILabel *phoneLabel;
    
    __weak IBOutlet UIImageView *faceImageView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDataSource:(NSDictionary *)dataSource
{
    namePicLabel.text = [[dataSource objectForKey:@"name"] substringToIndex:1];
    namePicLabel.backgroundColor = [ProjectUtil colorWithHexString:[ProjectUtil makeColorStringWithNameStr:[dataSource objectForKey:@"name"]]];
    namePicLabel.layer.cornerRadius = 19;
    namePicLabel.layer.masksToBounds = YES;
    
    nameLabel.text = [dataSource objectForKey:@"name"];
    
    if ([dataSource objectForKey:@"intention_rank"] != nil && [dataSource objectForKey:@"intention_rank"] != [NSNull null] && [dataSource objectForKey:@"intention_rank"]) {
        levelLabel.text = [dataSource objectForKey:@"intention_rank"];
    }else
    {
        levelLabel.hidden = YES;
    }
    levelLabel.layer.borderWidth = 0.5;
    levelLabel.layer.cornerRadius = 2;
    levelLabel.layer.borderColor = [ProjectUtil colorWithHexString:@"EF5F5F"].CGColor;
    phoneLabel.text = [dataSource objectForKey:@"phone"];
    
#pragma mark --判断是否有头像
    faceImageView.layer.cornerRadius = 19;
    faceImageView.layer.masksToBounds = YES;
//    if ([dataSource objectForKey:@"face"] != nil || [dataSource objectForKey:@"face"] != [NSNull null] || ![[dataSource objectForKey:@"face"] isEqualToString:@""])
//    {
//        NSString * faceUrl = [NSString stringWithFormat:@"%@%@",@"http://app.hfapp.cn/",[dataSource objectForKey:@"face"]];
//        [faceImageView sd_setImageWithURL:[NSURL URLWithString:faceUrl] placeholderImage:nil];
//        namePicLabel.hidden = YES;
//        faceImageView.hidden = NO;
//    }
//    else
//    {
//        faceImageView.hidden = YES;
//        namePicLabel.hidden = NO;
//    }

    
    
    NSString *faceUrl = dataSource[@"face"];
    
    NSLog(@"%@", dataSource);
        if (
            dataSource[@"face"] != nil &&
            [dataSource objectForKey:@"face"] != [NSNull null] &&
            ![[dataSource objectForKey:@"face"] isEqualToString:@""] &&
            ![faceUrl isEqualToString:@"<null>"]
            )
        {
            NSString * faceUrl = [NSString stringWithFormat:@"%@/%@",Image_Url,[dataSource objectForKey:@"face"]];
            [faceImageView sd_setImageWithURL:[NSURL URLWithString:faceUrl] placeholderImage:nil];
            namePicLabel.hidden = YES;
            faceImageView.hidden = NO;
        }
        else
        {
            faceImageView.hidden = YES;
            namePicLabel.hidden = NO;
        }
}
@end
