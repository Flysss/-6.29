//
//  ItemCollectionView.h
//  ChatRoomDemo
//
//  Created by summer on 14/12/22.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemCollectionView.h"

@class ItemCollectionView;
@protocol ItemCollectionViewDelegate

-(void)itemCollectionView:(ItemCollectionView *)itemCollectionView DidSelectedItemIndex:(NSInteger)itemIndex ItemTitle:(NSString *)itemTitle;//返回Item

@end

@interface ItemCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

-(instancetype)initWithItemArr:(NSArray *)itemArr OrignalY:(CGFloat)y;
-(CGFloat)getCollectionViewHeightWithItemArr:(NSArray *)itemArr;

@property (nonatomic,assign)NSInteger selectedItem;//选中项
@property (nonatomic,retain)NSArray *itemArr;//项目数组
@property (nonatomic,assign)BOOL hiddenItemView;//隐藏
@property (nonatomic,assign)id <ItemCollectionViewDelegate>itemDelelgate;
@end
