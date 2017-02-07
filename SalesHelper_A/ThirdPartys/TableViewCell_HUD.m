//
//  TableViewCell_HUD.m
//  SalesHelperC
//
//  Created by summer on 15/4/21.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "TableViewCell_HUD.h"

@interface TableViewCell_HUD()

//
@property(weak, nonatomic) IBOutlet UIView * UIView_0314;

//内容
@property(weak, nonatomic) IBOutlet UILabel * UIlabel_Text;

//是否选中
@property(weak, nonatomic) IBOutlet UILabel * UIlabel_IsSelected;

@end

@implementation TableViewCell_HUD

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@synthesize UIView_0314;

- (void)awakeFromNib {
    // Initialization code
//    NSArray * arr = self.UIView_0314.constraints;
    
//    距离底边0.5
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.UIView_0314 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0f constant:self.contentView.bounds.size.height - 0.5]];
//
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.UIView_Separator_Down attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.5f]];
    
//    约束
//    NSDictionary * viewsDic = NSDictionaryOfVariableBindings(UIView_0314);
//    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[UIView_0314]-0-|"
//                                                                     options:0
//                                                                     metrics:nil
//                                                                       views:viewsDic]];
//    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[UIView_0314]-0.5-|"
//                                                                     options:0
//                                                                     metrics:nil
//                                                                       views:viewsDic]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@synthesize DataSource_0314;
-(void)setDataSource_0314:(NSDictionary *)newValue{
    DataSource_0314 = newValue;
    
//    NSArray * arr = self.UIView_0314.constraints;//获取分隔线所有的约束
//    //遍历所有的约束，找到高度
//    for (NSLayoutConstraint * layout in arr) {
//        if(layout.firstAttribute == NSLayoutAttributeBottom){
//            layout.constant = 0.5;//修改宽度
//        }
//    }
    
    self.UIlabel_Text.text = [self.DataSource_0314 valueForKeyPath:@"text"];
    if([self.DataSource_0314.allKeys containsObject:@"hightLight"]){
        self.HightLight_0314 = [[self.DataSource_0314 valueForKey:@"hightLight"] boolValue];
        
        if([self.DataSource_0314.allKeys containsObject:@"disabled"] && [[self.DataSource_0314 valueForKey:@"disabled"] boolValue]){
            self.Disabled_0314 = [[self.DataSource_0314 valueForKey:@"disabled"] boolValue];
        }
    }
    else if([self.DataSource_0314.allKeys containsObject:@"disabled"]){
        self.Disabled_0314 = [[self.DataSource_0314 valueForKey:@"disabled"] boolValue];
    }
        
}

//高亮
@synthesize HightLight_0314;
-(void)setHightLight_0314:(BOOL)newValue{
    HightLight_0314 = newValue;
    if(newValue){
        self.UIlabel_Text.textColor = RGBACOLOR(218, 43, 43, 1);
        self.UIlabel_IsSelected.alpha = 1;
    }
    else{
        self.UIlabel_Text.textColor = RGBACOLOR(49, 129, 255, 1);
        self.UIlabel_IsSelected.alpha = 0;
    }
}

//禁用
@synthesize Disabled_0314;
-(void)setDisabled_0314:(BOOL)newValue{
    Disabled_0314 = newValue;
    if(newValue){
        self.UIlabel_Text.textColor = [UIColor lightGrayColor];
    }
    else{
       self.UIlabel_Text.textColor = RGBACOLOR(49, 129, 255, 1);
    }
}


@end
