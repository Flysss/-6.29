//
//  ItemCollectionView.m
//  ChatRoomDemo
//
//  Created by summer on 14/12/22.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ItemCollectionView.h"
#import "ItemCollectionCell.h"
CGFloat itemSpace = 15.0;
CGFloat itemborderWidth = 10.0;
CGFloat itemLineSpace = 15.0;
NSString *itemSelectedReuseIdentifier = @"ItemCollectionSelectedCell";
NSString *itemNomalReuseIdentifier = @"ItemCollectionNomalCell";
@implementation ItemCollectionView

@synthesize selectedItem = _selectedItem,itemArr = _itemArr,hiddenItemView = _hiddenItemView;
-(instancetype)initWithItemArr:(NSArray *)itemArr OrignalY:(CGFloat)y
{
    self.hiddenItemView = YES;
    //默认选择0
    _selectedItem = 0;
    _itemArr = itemArr;
    //每个item高度和宽度
    CGFloat itemWidth = (SCREEN_WIDTH-itemSpace*2-itemborderWidth*2)/3;
    CGFloat itemHeight = itemWidth/3.0;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    flowLayout.minimumLineSpacing = itemLineSpace;
    self = [super initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 0) collectionViewLayout:flowLayout];

    if (self)
    {
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:[ItemCollectionCell class] forCellWithReuseIdentifier:itemNomalReuseIdentifier];
        [self registerClass:[ItemCollectionCell class] forCellWithReuseIdentifier:itemSelectedReuseIdentifier];
    }
    return self;
}

//计算高度
-(CGFloat)getCollectionViewHeightWithItemArr:(NSArray *)itemArr
{
    //每个item高度和宽度
    CGFloat itemWidth = (SCREEN_WIDTH-itemSpace*2-itemborderWidth*2)/3;
    CGFloat itemHeight = itemWidth/3.0;
    //行数
    NSInteger itemRows = itemArr.count/3;
    if (itemArr.count%3!=0)
    {
        itemRows+=1;
    }
    CGFloat collectionViewHeight = itemRows*itemHeight+itemLineSpace*(itemRows+1);\
    
    return MIN(collectionViewHeight, SCREEN_HEIGHT-self.top-49-64);
}

//选中项
-(void)setSelectedItem:(NSInteger)selectedItem
{
    _selectedItem = selectedItem;
    [self reloadData];
}
//更新数据
-(void)setItemArr:(NSArray *)itemArr
{
    _itemArr = itemArr;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];

    [self setHeight:[self getCollectionViewHeightWithItemArr:itemArr]];
    [UIView commitAnimations];
    [self reloadData];
}

-(void)setHiddenItemView:(BOOL)hiddenItemView
{
    _hiddenItemView = hiddenItemView;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    if (hiddenItemView)
    {
        self.height = 0.0;
    }
    else
    {
        self.height = [self getCollectionViewHeightWithItemArr:_itemArr];
    }
    [UIView commitAnimations];
}

#pragma mark UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itemArr.count;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(itemLineSpace, itemborderWidth,itemLineSpace , itemborderWidth);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row==_selectedItem)
    {
        ItemCollectionCell *selectedCell = (ItemCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:itemSelectedReuseIdentifier forIndexPath:indexPath];
        selectedCell.itemLabel.text = [_itemArr objectAtIndex:indexPath.row];
        selectedCell.signImageView.hidden = NO;
        selectedCell.clipsToBounds = YES;
        selectedCell.layer.borderColor = LeftMenuVCBackColor.CGColor;
        selectedCell.layer.borderWidth = 1.0;
//        selectedCell.layer.cornerRadius = 2.0;
        return selectedCell;
    }
    else
    {
        ItemCollectionCell *cell = (ItemCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:itemNomalReuseIdentifier forIndexPath:indexPath];
        cell.itemLabel.text = [_itemArr objectAtIndex:indexPath.row];
        cell.layer.borderColor = RGBCOLOR(225, 225, 225).CGColor;
        cell.layer.borderWidth = 1.0;
//        cell.layer.cornerRadius = 2.0;
        return cell;
    }

    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.hiddenItemView = YES;
    [self.itemDelelgate itemCollectionView:self DidSelectedItemIndex:indexPath.row ItemTitle:[_itemArr objectAtIndex:indexPath.row]];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
