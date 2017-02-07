//
//  HWMessageCell.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/18.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWMessageCell.h"
#import "HWMessageModel.h"


@interface HWMessageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *DZImageView;

@property (weak, nonatomic) IBOutlet UILabel *text;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;



@end

@implementation HWMessageCell

+ (instancetype)messageCell{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HWMessageCell" owner:nil options:nil] lastObject];
    
}

- (void)awakeFromNib {
   
    self.contextLabel.numberOfLines = 4;
    self.picImageView.layer.masksToBounds = YES;

    self.iconView.layer.cornerRadius = 45/2;
    self.iconView.layer.masksToBounds = YES;
    
    
}

- (void)setModel:(HWMessageModel *)model
{
    _model = model;
    
    if (![model.iconpath isKindOfClass:[NSNull class]]) {
        
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.iconpath] placeholderImage:[UIImage imageNamed:@"默认个人图像"]];
    }
    
    self.nameLabel.text = model.name;
    
    if (![model.org_name isKindOfClass:[NSNull class]]) {
    
        self.sourceLabel.text = model.org_name;
    }
    self.timeLabel.text = model.addtime;
   
    
    if ([model.istype isEqualToString:@"1"]) {//点赞
        self.text.hidden = YES;
        self.DZImageView.hidden = NO;


    }else if ([model.istype isEqualToString:@"3"]){//评论
        self.text.hidden = NO;
        self.DZImageView.hidden = YES;
        NSLog(@"------------%@",model.contents);
        self.text.text = model.contents;
        
    }else if ([model.istype isEqualToString:@"2"]){//关注
        self.text.hidden = NO;
        self.DZImageView.hidden = YES;
        self.text.text = @"关注了我";
        
    }else{ //@了我
        self.text.hidden = NO;
        self.DZImageView.hidden = YES;
        self.text.text = @"@了我";

        
    }
    
    
    if (![model.postImgpath isEqualToString:@""]) {
        
        self.contextLabel.hidden = YES;
        self.picImageView.hidden = NO;
        
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.postImgpath]];
        
    }else if (model.postContents)
    {
        self.picImageView.hidden = YES;
        self.contextLabel.hidden = NO;
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:model.postContents];
        self.contextLabel.attributedText = attr;
        
        
    }else{
        
        self.contextLabel.hidden = YES;
        self.picImageView.hidden = YES;
        
    }
    
    
    
}

+ (instancetype)messageCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    
    HWMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [HWMessageCell messageCell];
        
    }

    return cell;

    
}
@end
