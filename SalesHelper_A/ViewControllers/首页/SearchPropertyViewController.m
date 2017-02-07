//
//  SearchPropertyViewController.m
//  SalesHelper_A
//
//  Created by summer on 15/7/13.
//  Copyright (c) 2015年 X. All rights reserved.q
//

#import "SearchPropertyViewController.h"
#import "ChooseTableCell.h"
#import "ProjectUtil.h"
#import "ListChoosenView.h"
#import <objc/runtime.h>
#import "popTableView.h"
#import "HomeTableViewCell.h"
#import "PropertyDetailViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "HomeTabViewCell.h"
#import "MapViewController.h"

@interface SearchPropertyViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//已被选择的储存数组
@property (retain , nonatomic)NSMutableArray * choosenArr;

@property (nonatomic,retain)NSMutableArray * info;

//下拉列表tableview
@property (nonatomic , weak) popTableView * listTabelView;

//下拉按钮
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
//下拉列表字典
@property (nonatomic ,retain)NSMutableArray * listArr;

@end

@implementation SearchPropertyViewController
{
    NSInteger pageIndex;
    NSMutableArray * arr1;
    NSMutableArray * arr2;
    NSMutableArray * arr3;
    NSMutableArray * arr4;
    UIButton * selectedBtn;
    UILabel * changeLabel;
    __weak IBOutlet UILabel *label2;
    __weak IBOutlet UILabel *label4;
    __weak IBOutlet UILabel *label1;
    __weak IBOutlet UILabel *label3;
    
    NSMutableDictionary  * requestParam ;

    UIView * coverView ;
    UISearchBar * mySearchBar;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.backBtn.hidden = NO;
    mySearchBar.frame = CGRectMake(40, 20, SCREEN_WIDTH-80, 44);
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backLastView) rightItem:@selector(pushToMap)];
    mySearchBar = [[UISearchBar alloc] init];
    mySearchBar.delegate = self;
    [mySearchBar setBackgroundImage:[ProjectUtil imageWithColor:RGBACOLOR(235, 236, 238, 1) size:CGSizeMake(0.1f, 0.1f)]];
    [mySearchBar setContentMode:UIViewContentModeLeft];
    [mySearchBar setPlaceholder:@"搜索关键字"];
    mySearchBar.showsCancelButton = NO;
    mySearchBar.tintColor=[UIColor whiteColor];
    [self.topView addSubview: mySearchBar];
    [self.rightBtn setImage:[UIImage imageNamed:@"地图定位"] forState:UIControlStateNormal];
    
    pageIndex = 1;
    self.info = [NSMutableArray arrayWithCapacity:0];
    self.choosenArr = [NSMutableArray arrayWithCapacity:0];
    requestParam = [NSMutableDictionary dictionary];
    [requestParam setObject:_locationStr forKey:@"districtPId"];
    [requestParam setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [requestParam setObject:@"10" forKey:@"size"];

    if (self.choosenDic) {
        [requestParam setObject:[self.choosenDic objectForKey:@"id"] forKey:@"stateId"];
        label1.text = [self.choosenDic objectForKey:@"name"];
    }
    [self requestWithParam:requestParam];
    
    NSDictionary * param2 = @{
                              @"districtId":_locationStr,
                              };
    [self requestForListView:param2];
    
    self.btn1.tag = 2000;
    self.btn2.tag = 2001;
    self.btn3.tag = 2002;
    self.btn4.tag = 2003;

    
    [self.btn1 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn2 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn3 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn4 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
//    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
//    mySearchBar.delegate = self;
//    [mySearchBar setBackgroundImage:[ProjectUtil imageWithColor:RGBACOLOR(235, 236, 238, 1) size:CGSizeMake(0.1f, 0.1f)]];
//    [mySearchBar setContentMode:UIViewContentModeLeft];
//    [mySearchBar setPlaceholder:@"搜索关键字"];
//    mySearchBar.showsCancelButton = NO;
////    if (!self.choosenDic) {
////        [mySearchBar becomeFirstResponder];
////    }
//    mySearchBar.tintColor=[UIColor whiteColor];
//    self.navigationItem.titleView = mySearchBar;
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tableViewGesture];
    [self setSearchBarTextfiled:mySearchBar];
    
    
//    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame=CGRectMake(0, 0, 27, 27);
//    [btn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];
//
//    [btn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* BACK=[[UIBarButtonItem alloc]initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = BACK;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardDidShowNotification object:nil];//在这里注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden) name:UIKeyboardDidHideNotification object:nil];//在这里注册通知
    
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[HomeTabViewCell class] forCellReuseIdentifier:@"homeCell"];

    self.tableView.separatorColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
   
}
- (void)setSearchBarTextfiled:(UISearchBar *)searchBar{
    for (UIView *view in searchBar.subviews){
        for (id subview in view.subviews){
            if ( [subview isKindOfClass:[UITextField class]] ){
                [(UITextField *)subview setTintColor:[UIColor colorWithRed:0/255.0f green:175/255.0f blue:240/255.0f alpha:1]];
                return;
            }
        }
    }
}
#pragma mark - UISerchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    mySearchBar.frame = CGRectMake(0, 20, SCREEN_WIDTH-40, 44);
    self.backBtn.hidden = YES;
    self.rightBtn.hidden = NO;
    mySearchBar.showsCancelButton = YES;
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [mySearchBar resignFirstResponder];
    mySearchBar.frame = CGRectMake(40, 20, SCREEN_WIDTH-80, 44);
    self.backBtn.hidden = NO;
//    self.rightBtn.hidden = YES;
    mySearchBar.showsCancelButton = NO;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    mySearchBar.showsCancelButton = NO;
    
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (mySearchBar.text.length) {
        
        [requestParam setObject:mySearchBar.text forKey:@"properName"];
        mySearchBar.frame = CGRectMake(40, 20, SCREEN_WIDTH-80, 44);
        self.backBtn.hidden = NO;
//        self.rightBtn.hidden = YES;
    
        [self requestWithParam:requestParam];
    }
    [mySearchBar resignFirstResponder];
    
}

- (void)pushToMap
{
    MapViewController *vc = [[MapViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.cityId = self.locationStr;
//    vc.cityName = [locationDict objectForKey:@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)keyboardWillShow
{
    self.tableView.allowsSelection = NO;
}
- (void)keyboardWillHidden
{
    self.tableView.allowsSelection = YES;

}
- (void)commentTableViewTouchInSide
{
    mySearchBar.showsCancelButton = NO;
    [mySearchBar resignFirstResponder];
}

-(void)backLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  加载下拉列表
 *
 *  @param param 城市id
 */
- (void)requestForListView:(NSDictionary *)param
{
    RequestInterface * loadPerpoty = [[RequestInterface alloc] init];
    
    [loadPerpoty requestGetHouseAttributeWithParam:param];
    [loadPerpoty getInterfaceRequestObject:^(id data) {
        if ([data objectForKey:@"success"]) {
            self.tableView.emptyDataSetSource = self;
            self.tableView.emptyDataSetDelegate = self;
            NSArray * array  = [[data objectForKey:@"datas"] allKeys];
            for (int i = 0; i < array.count; i ++) {
                NSDictionary * dict =  [data objectForKey:@"datas"];
                if ([array[i]isEqualToString:@"districts"]) {
                    arr1 = [NSMutableArray arrayWithArray:[dict objectForKey:array[i]]];
                    NSDictionary * dict = @{
                                            @"name":@"全部",
                                            };
                    [arr1 insertObject:dict atIndex:0];
                }
                if ([array[i]isEqualToString:@"estates"]) {
                    arr2 = [NSMutableArray arrayWithArray:[dict objectForKey:array[i]]];
                    NSDictionary * dict = @{
                                            @"name":@"全部",
                                            };
                    [arr2 insertObject:dict atIndex:0];
                }
                if ([array[i]isEqualToString:@"proportions"]) {
                    arr3 = [NSMutableArray arrayWithArray:[dict objectForKey:array[i]]];
                    NSDictionary * dict = @{
                                            @"name":@"全部",
                                            };
                    [arr3 insertObject:dict atIndex:0];
                }
                if ([array[i]isEqualToString:@"prices"]) {
                    arr4 = [NSMutableArray arrayWithArray:[dict objectForKey:array[i]]];
                }
            }
        }else
        {
            [self.view Hidden];
            [self.view makeToast:@"加载失败"];
        }
        
    } Fail:^(NSError *error) {
        [self.view Hidden];
    }];

    
}
/**
 *  加载cell数据
 *
 *  @param param 查询字典
 */
- (void)requestWithParam:(NSDictionary *)param
{
    RequestInterface * loadPerpoty = [[RequestInterface alloc] init];
    
    [self.view Loading_0314];
    [loadPerpoty requestGetPropertyInfosWithParam:param];
    [loadPerpoty getInterfaceRequestObject:^(id data) {
        if ([data objectForKey:@"success"]) {
            [self.view Hidden];
            [self.info removeAllObjects];
            [self.info addObjectsFromArray:[data objectForKey:@"datas"]];
            [self refreshingTableView];
            if (![[data objectForKey:@"datas"]count]) {
                [self.view makeToast:@"没有更多数据了"];
            }
            [self.tableView reloadData];
            
        }else
        {
            [self.view Hidden];
            [self.view makeToast:@"加载失败"];
        }
        
    } Fail:^(NSError *error) {
        [self.view Hidden];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.info.count;

}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]&& IOS_VERSION >= 8.0)
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeTabViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
    
    if ([self.info count]>0)
    {
        [cell setAttributeForCell:self.info[indexPath.row]];
        
    }
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    PropertyDetailViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"PropertyDetailViewController"];
    
    PropertyDetailViewController *vc = [[PropertyDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed=YES;
    HomeTableViewCell * cell =  (HomeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    vc.titlestr = cell.communityName.text;
    vc.ID = cell.ID;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];    
}

- (void)clickBtn:(UIButton *)button
{
     if (button.tag == 2000) {
        self.listArr = arr1;

        changeLabel = label2;
    }else if (button.tag == 2001)
    {
        self.listArr = arr2;
        
        changeLabel = label1;
    }else if (button.tag == 2002)
    {
        self.listArr = arr3;
      
        changeLabel = label3;
    }else if (button.tag == 2003)
    {
        self.listArr = arr4;
        changeLabel = label4;
    }
    if (self.listTabelView != nil)
    {
        [self.listTabelView removeFromSuperview];
        [coverView removeFromSuperview];
    }
    if (selectedBtn == button) {
        [self.listTabelView removeFromSuperview];
        [coverView removeFromSuperview];

        selectedBtn = nil;
    }else{
        selectedBtn = button;
        popTableView * table = [[popTableView alloc]initWithFrame:CGRectMake(0, 64+40, self.view.width, 44 * 5)];
        coverView = [[UIView alloc]initWithFrame:CGRectMake(0,64+40 + (44 * 5), self.view.width,self.view.height - 104 + (44 * 5))];
        coverView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.5];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [coverView addGestureRecognizer:tap];
        coverView.userInteractionEnabled = YES;
        [self.view addSubview:coverView];
        self.listTabelView = table;
        
        self.listTabelView.DataSource_0314 = self.listArr;
        [self.listTabelView CellSelected:^(NSDictionary *dic) {
            changeLabel.text = [dic objectForKey:@"name"];
            [mySearchBar resignFirstResponder];
            mySearchBar.showsCancelButton = NO;
            [self.listTabelView removeFromSuperview];
            [coverView removeFromSuperview];
            if (button.tag == 2000) {
                if ([label2.text isEqualToString:@"全部"] || [label2.text isEqualToString:@"区域"]) {
                    if ([requestParam objectForKey:@"districtId"]) {
                        [requestParam removeObjectForKey:@"districtId"];
                    }
                }else
                {
                    [requestParam setObject:[dic objectForKey:@"id"] forKey:@"districtId"];
                }
            }
            
            if (button.tag == 2001) {
                if ([label1.text isEqualToString:@"全部"] || [label1.text isEqualToString:@"类型"]) {
                    if ([requestParam objectForKey:@"stateId"]) {
                        [requestParam removeObjectForKey:@"stateId"];
                    }
                }else
                {
                    [requestParam setObject:[dic objectForKey:@"id"] forKey:@"stateId"];
                }
            }
            
            if (button.tag == 2002) {
                if ([label3.text isEqualToString:@"全部"] || [label3.text isEqualToString:@"面积"]) {
                    if ([requestParam objectForKey:@"proportionId"]) {
                        [requestParam removeObjectForKey:@"proportionId"];
                    }
                }else
                {
                    [requestParam setObject:[dic objectForKey:@"id"] forKey:@"proportionId"];
                }
            }
            
            if (button.tag == 2003) {
                if ([label4.text isEqualToString:@"价格"] || [label4.text isEqualToString:@"待定"]) {
                    if ([requestParam objectForKey:@"priceId"]) {
                        [requestParam removeObjectForKey:@"priceId"];
                    }
                }else
                {
                    [requestParam setObject:[dic objectForKey:@"id"] forKey:@"priceId"];
                }
            }
            
            if ([label3.text isEqualToString:@"全部"] || [label3.text isEqualToString:@"面积"]) {
                if ([requestParam objectForKey:@"proportionId"]) {
                    [requestParam removeObjectForKey:@"proportionId"];
                }
            }
            if ([label4.text isEqualToString:@"价格"] || [label4.text isEqualToString:@"待定"]) {
                if ([requestParam objectForKey:@"priceId"]) {
                    [requestParam removeObjectForKey:@"priceId"];
                }
            }
            if ([label1.text isEqualToString:@"全部"] || [label1.text isEqualToString:@"类型"]) {
                if ([requestParam objectForKey:@"stateId"]) {
                    [requestParam removeObjectForKey:@"stateId"];
                }
            }
            if ([label2.text isEqualToString:@"全部"] || [label2.text isEqualToString:@"区域"]) {
                if ([requestParam objectForKey:@"districtId"]) {
                    [requestParam removeObjectForKey:@"districtId"];
                }
            }

            [self requestWithParam:requestParam];

        }];
        [self.view addSubview:table];
    }
    
}
//触摸遮罩 取消下拉列表
-(void)tap
{
    mySearchBar.showsCancelButton = NO;
    [mySearchBar resignFirstResponder];
    [self.listTabelView removeFromSuperview];
    [coverView removeFromSuperview];
}



-(void)refreshingTableView
{
    //下拉刷新
    __block  SearchPropertyViewController * h = self;
    [_tableView addHeaderWithCallback:^{
        [_tableView headerEndRefreshing];
        [h refreshingHeaderTableView];
    }];
    //上拉加载
    [_tableView addFooterWithCallback:^{
        [h refreshingFooterTableView];
        
    }];
}

-(void)refreshingHeaderTableView
{
    pageIndex = 1;
    [self requestWithParam:requestParam];
}
-(void)refreshingFooterTableView
{
    pageIndex ++;
    NSString * pageIdexStr = [NSString stringWithFormat:@"%ld",(long)pageIndex];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:requestParam];
    [dic setObject:pageIdexStr forKey:@"page"];

    RequestInterface * loadPerpoty = [[RequestInterface alloc] init];
    
    [loadPerpoty requestGetPropertyInfosWithParam:dic];

    [loadPerpoty getInterfaceRequestObject:^(id data) {
        if ([data objectForKey:@"success"]) {
            [self.view Hidden];
            [self.info addObjectsFromArray:[data objectForKey:@"datas"]];
            if (![[data objectForKey:@"datas"]count]) {
                [self.view makeToast:@"没有更多数据了"];
            }
            [self.tableView reloadData];
            [_tableView footerEndRefreshing];

            
        }else
        {
            pageIndex--;
            [self.view Hidden];
            [self.view makeToast:@"加载失败"];
            [_tableView footerEndRefreshing];

        }
        
    } Fail:^(NSError *error) {
        pageIndex--;
        [self.view Hidden];
        [_tableView footerEndRefreshing];

    }];

    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [mySearchBar resignFirstResponder];
    
//     self.navigationController.navigationBar.translucent = YES;
}
- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    text = @"该条件下没有楼盘数据";
    font =  Default_Font_12;
    textColor = [ProjectUtil colorWithHexString:@"808080"];
    
    if (!text) {
        return nil;
    }
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];

}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"灰色.png"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
