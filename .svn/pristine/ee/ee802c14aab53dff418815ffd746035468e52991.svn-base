//
//  HWPhotoCell.h
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/7.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HWPhotoCell;
@protocol HWPhotoCellDelegate <NSObject>

- (void)photoCellDeleteButtonDidClick:(HWPhotoCell *)photoCell;
@end

@interface HWPhotoCell : UICollectionViewCell

@property (nonatomic,weak) id<HWPhotoCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *deleteButton;

@property (nonatomic,strong) NSIndexPath *indexPath;

@end
