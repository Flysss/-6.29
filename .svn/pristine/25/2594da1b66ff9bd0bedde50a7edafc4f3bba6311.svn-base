//
//  CoreLocationViewController.h
//  SalesHelper_A
//
//  Created by zhipu on 15/7/22.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewController.h"

@protocol locationChooseDelegate <NSObject>

-(void)loadChoosenLocation:(NSDictionary *)loctionDic;

@end


@interface CoreLocationViewController : ModelViewController



@property (weak, nonatomic) IBOutlet UITableView *LocationTableview;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *CitySearchbar;

//运营城市 数据
@property(nonatomic,strong)NSMutableDictionary* Info;
//区头的数据
@property(nonatomic,strong)NSMutableArray* HeadInfo;
//位置代理
@property(nonatomic,assign)id <locationChooseDelegate>delegate;

@end
