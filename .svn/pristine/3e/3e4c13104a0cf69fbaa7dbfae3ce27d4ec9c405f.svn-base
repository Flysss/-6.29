//
//  CollectionViewCell.m
//  ChatRoomDemo
//
//  Created by summer on 14/12/22.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ItemCollectionCell.h"
@implementation ItemCollectionCell
@synthesize itemLabel = _itemLabel;
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UILabel *itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        itemLabel.textColor = [UIColor blackColor];
        itemLabel.font = [UIFont systemFontOfSize:15];
        itemLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:itemLabel];
        self.itemLabel = itemLabel;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
        imageView.image = [UIImage imageNamed:@"xzbq"];
        imageView.hidden = YES;
        [self addSubview:imageView];
        self.signImageView = imageView;
        
    }
    return self;
}

-(instancetype)initWithCellWidth:(CGFloat)width CellHeight:(CGFloat)height ItemTitle:(NSString *)itemTitle
{
   self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    if (self)
    {
        UILabel *itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        itemLabel.text = itemTitle;
        itemLabel.textColor = [UIColor blackColor];
        itemLabel.font = [UIFont systemFontOfSize:15];
        itemLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:itemLabel];
    }
    return self;
}
@end
