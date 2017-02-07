//
//  MySaleOfficeViewController.m
//  SalesHelper_A
//
//  Created by flysss on 16/4/29.
//  Copyright © 2016年 X. All rights reserved.
//

#import "MySaleOfficeViewController.h"
#import "popTableView.h"
#import "UIColor+Extend.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ChooseTableCell.h"
#import "ProjectUtil.h"
#import "RecommendTableViewCell.h"
#import "SelectdShareViewController.h"
#import "SalesOfficeCell.h"

@interface MySaleOfficeViewController () <UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,UISearchBarDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic,retain)NSMutableArray * info;

//下拉列表Tableview
@property (nonatomic, weak) popTableView * listTableView;

//下拉列表字典
@property (nonatomic, strong) NSMutableArray * listArr;

@property (nonatomic, strong)NSMutableArray * choosenArray;

@end

@implementation MySaleOfficeViewController
{
    NSInteger  pageIndex;
    NSMutableArray * arr1;
    NSMutableArray * arr2;
    NSMutableArray * arr3;
    NSMutableArray * arr4;
    
    UIButton * selectedBtn;

    NSMutableDictionary  * requestParam ;
    
    UISearchBar * mySearchBar;
    UIView * coverView;
    NSString * location;
    NSInteger count ;//记录数组个数

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tap.numberOfTapsRequired = 1;
    tap.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tap];
    //注册键盘即将升起通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardDidShowNotification object:nil];
    //注册键盘即将消失通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden) name:UIKeyboardDidHideNotification object:nil];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:@selector(click_makeSure)];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH-60, 24, 50, 40);
    self.rightBtn.titleLabel.font = Default_Font_16;
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self layoutSubViews];

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"location_City"] &&
        [defaults objectForKey:@"location_City"] != [NSNull null])
    {
        location = [defaults objectForKey:@"location_City"];
    }else
    {
        location = @"1171";
    }
    pageIndex = 1;
    self.info = [NSMutableArray arrayWithCapacity:0];
    self.choosenArray = [NSMutableArray arrayWithCapacity:0];
    
    NSDictionary * param = @{
                             @"districtPId":location,
                             @"page":[NSString stringWithFormat:@"%ld",(long)pageIndex],
                             @"size":@"10"
                             };
    requestParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [self requestTableListDataWithParam:requestParam];
    [self requestPopViewListData];
}
#pragma  mark -- 请求列表数据
-(void)requestTableListDataWithParam:(NSDictionary*)dict
{

    RequestInterface * loadPerpoty = [[RequestInterface alloc]init];
    [self.view Loading_0314];
    [loadPerpoty requestGetPropertyInfosWithParam:dict];
    [loadPerpoty getInterfaceRequestObject:^(id data) {
        
        [self.tableView headerEndRefreshing];
        if ([[data objectForKey:@"success"] boolValue])
        {
            [self.view Hidden];
            self.tableView.emptyDataSetDelegate = self;
            self.tableView.emptyDataSetSource = self;
            [self.info removeAllObjects];
            [self.info addObjectsFromArray:[data objectForKey:@"datas"]];
            
            
            [self refreshingTableView];
            if ([[data objectForKey:@"datas"] count] == 0)
            {
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
        [self.tableView headerEndRefreshing];
    }];
    
    
}
#pragma  mark -- 请求弹出分类列表数据
-(void)requestPopViewListData
{
    NSDictionary * param = @{
                              @"districtId":location,
                            };
    
    RequestInterface * loadPerpoty = [[RequestInterface alloc] init];
    
    [loadPerpoty requestGetHouseAttributeWithParam:param];
    [loadPerpoty getInterfaceRequestObject:^(id data) {
        
        if ([data objectForKey:@"success"]) {
            
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

- (void)keyboardWillShow
{
    self.tableView.allowsSelection = NO;
}
- (void)keyboardWillHidden
{
    self.tableView.allowsSelection = YES;
    
}
- (void)commentTableViewTouchInSide{
    [mySearchBar resignFirstResponder];
    mySearchBar.showsCancelButton = NO;
}

-(void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)click_makeSure
{
    
    NSMutableArray * array  = [NSMutableArray arrayWithCapacity:0];
    
    for (id obj in self.choosenArray)
    {
       [array addObject:obj[@"id"]];
    }
    NSString * pidsStr = [array componentsJoinedByString:@","];
    NSDictionary * dict = @{
                        @"token":GetUserID,
                        @"prids":pidsStr
                        };
    
    RequestInterface * interface = [[RequestInterface alloc]init];
    
    [interface requestMySalesOfficeToShareWithParam:dict];
    [interface getInterfaceRequestObject:^(id data) {
        
        if ([[data objectForKey:@"success"] boolValue])
        {
            NSLog(@"%@-%@",data,pidsStr);
            [self.view makeToast:@"恭喜您的售楼部开通成功！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
    } Fail:^(NSError *error) {
        
        [self.view makeToast:@"加载失败"];
    }];
    
    
//    SelectdShareViewController * VC = [[SelectdShareViewController alloc]init];
//    VC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:VC animated:YES];
    
}

-(void)layoutSubViews
{
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 71, SCREEN_WIDTH,30)];
    mySearchBar.delegate = self;
    [mySearchBar setContentMode:UIViewContentModeCenter];
    [mySearchBar setPlaceholder:@"输入楼盘名称快速查找"];
    mySearchBar.showsCancelButton = NO;
    mySearchBar.layer.cornerRadius = 5.0f;
    mySearchBar.layer.masksToBounds = YES;
    mySearchBar.searchBarStyle =  UISearchBarStyleMinimal ;
    mySearchBar.translucent = YES;
    [self.view addSubview:mySearchBar];


    CGFloat width = SCREEN_WIDTH/4;
    
    NSArray * array = @[@"区域",@"类型",@"面积",@"价格"];
    for (int i = 0; i< 4; i++)
    {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(width*i, 108, width, 44)];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"销邦-首页-房源-区域选择.png"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor hexChangeFloat:KQianheiColor] forState:UIControlStateNormal];
        btn.titleLabel.font = Default_Font_15;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 2000+i;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 17)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(10,width-18, 10, 2)];
        [self.view addSubview:btn];
        
        if (i < 3)
        {
            UIView * verLine = [[UIView alloc]initWithFrame:CGRectMake(80*(i+1), 108+ 7, 0.5, 30)];
            verLine.backgroundColor = [UIColor grayColor];
            verLine.alpha = 0.5;
            [self.view addSubview:verLine];
        }
        
    }
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 108.5, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = [UIColor grayColor];
    line1.alpha = 0.5;
    [self.view addSubview:line1];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 108.5+44, SCREEN_WIDTH, 0.5)];
    line2.backgroundColor = [UIColor grayColor];
    line2.alpha = 0.5;
    [self.view addSubview:line2];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame), SCREEN_WIDTH, SCREEN_HEIGHT-152) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[RecommendTableViewCell class] forCellReuseIdentifier:@"RecommendTableViewCell"];
//    [self.tableView registerClass:[SalesOfficeCell class] forCellReuseIdentifier:@"SalesOfficeCell"];

    [self.view addSubview:self.tableView];
    
    
}

- (void)clickBtn:(UIButton *)button
    {
        static char key;
        
        if (button.tag == 2000)
        {
            self.listArr = arr1;
            
        }else if (button.tag == 2001)
        {
            self.listArr = arr2;

        }else if (button.tag == 2002)
        {
            self.listArr = arr3;
            
        }else if (button.tag == 2003)
        {
            self.listArr = arr4;
        }
        if (self.listTableView != nil)
        {
            [self.listTableView removeFromSuperview];
            [coverView removeFromSuperview];
        }
        if (selectedBtn == button) {
            [self.listTableView removeFromSuperview];
            [coverView removeFromSuperview];
            
            selectedBtn = nil;
        }
        else
        {
            selectedBtn = button;
            popTableView * table = [[popTableView alloc]initWithFrame:CGRectMake(0, 153, self.view.width, 44 * 5)];
            coverView = [[UIView alloc]initWithFrame:CGRectMake(0,104 + (44 * 5), self.view.width,self.view.height - 104 + (44 * 5))];
            coverView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.5];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
            [coverView addGestureRecognizer:tap];
            coverView.userInteractionEnabled = YES;
            [self.view addSubview:coverView];
            self.listTableView = table;
            
            objc_setAssociatedObject(self.listTableView,&key, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            self.listTableView.DataSource_0314 = self.listArr;
            [self.listTableView CellSelected:^(NSDictionary *dic) {
                [button setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
                [mySearchBar resignFirstResponder];
                mySearchBar.showsCancelButton = NO;
                [self.listTableView removeFromSuperview];
                [coverView removeFromSuperview];
                if (button.tag == 2000)
                {
                    if ([button.titleLabel.text isEqualToString:@"全部"] || [button.titleLabel.text isEqualToString:@"区域"])
                    {
                        if ([requestParam objectForKey:@"districtId"]) {
                            [requestParam removeObjectForKey:@"districtId"];
                        }
                    }else
                    {
                        [requestParam setObject:[dic objectForKey:@"id"] forKey:@"districtId"];
                    }
                }
                
                if (button.tag == 2001) {
                    if ([button.titleLabel.text isEqualToString:@"全部"] || [button.titleLabel.text isEqualToString:@"类型"]) {
                        if ([requestParam objectForKey:@"stateId"]) {
                            [requestParam removeObjectForKey:@"stateId"];
                        }
                    }else
                    {
                        [requestParam setObject:[dic objectForKey:@"id"] forKey:@"stateId"];
                    }
                }
                
                if (button.tag == 2002) {
                    if ([button.titleLabel.text isEqualToString:@"全部"] || [button.titleLabel.text isEqualToString:@"面积"]) {
                        if ([requestParam objectForKey:@"proportionId"]) {
                            [requestParam removeObjectForKey:@"proportionId"];
                        }
                    }
                    else
                    {
                        [requestParam setObject:[dic objectForKey:@"id"] forKey:@"proportionId"];
                    }
                }
                
                if (button.tag == 2003) {
                    if ([button.titleLabel.text isEqualToString:@"价格"] || [button.titleLabel.text isEqualToString:@"待定"]) {
                        if ([requestParam objectForKey:@"priceId"]) {
                            [requestParam removeObjectForKey:@"priceId"];
                        }
                    }
                    else
                    {
                        [requestParam setObject:[dic objectForKey:@"id"] forKey:@"priceId"];
                    }
                }
                
                if ([button.titleLabel.text isEqualToString:@"全部"] || [button.titleLabel.text isEqualToString:@"面积"]) {
                    if ([requestParam objectForKey:@"proportionId"]) {
                        [requestParam removeObjectForKey:@"proportionId"];
                    }
                }
                if ([button.titleLabel.text isEqualToString:@"价格"] || [button.titleLabel.text isEqualToString:@"待定"]) {
                    if ([requestParam objectForKey:@"priceId"]) {
                        [requestParam removeObjectForKey:@"priceId"];
                    }
                }
                if ([button.titleLabel.text isEqualToString:@"全部"] || [button.titleLabel.text isEqualToString:@"类型"]) {
                    if ([requestParam objectForKey:@"stateId"]) {
                        [requestParam removeObjectForKey:@"stateId"];
                    }
                }
                if ([button.titleLabel.text isEqualToString:@"全部"] || [button.titleLabel.text  isEqualToString:@"区域"]) {
                    if ([requestParam objectForKey:@"districtId"]) {
                        [requestParam removeObjectForKey:@"districtId"];
                    }
                }
                
                [self requestTableListDataWithParam:requestParam];
                
            }];
            [self.view addSubview:table];
        }
}
//触摸遮罩 取消下拉列表
-(void)tap
{
    [self.listTableView removeFromSuperview];
    [coverView removeFromSuperview];
}
#pragma mark - UISerchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    mySearchBar.showsCancelButton = YES;
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    mySearchBar.showsCancelButton = NO;
    
    [mySearchBar resignFirstResponder];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    mySearchBar.showsCancelButton = NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (mySearchBar.text.length) {
        
        [requestParam setObject:mySearchBar.text forKey:@"properName"];
        
        [self requestTableListDataWithParam:requestParam];
    }
    [mySearchBar resignFirstResponder];
}

-(void)refreshingTableView
{
    //下拉刷新
    __block  MySaleOfficeViewController * h = self;
    [_tableView addHeaderWithCallback:^{
        [h refreshingHeaderTableView];
    }];
    //上拉加载
    [_tableView addFooterWithCallback:^{
        [h refreshingFooterTableView];
        
    }];
}

-(void)refreshingHeaderTableView
{
    [self requestTableListDataWithParam:requestParam];
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
        [self.tableView footerEndRefreshing];
        
        if ([data objectForKey:@"success"]) {
            [self.view Hidden];
            [self.info addObjectsFromArray:[data objectForKey:@"datas"]];
            if (![[data objectForKey:@"datas"]count]) {
                [self.view makeToast:@"没有更多数据了"];
            }
            [self.tableView reloadData];
            [_tableView headerEndRefreshing];
            
        }
        else
        {
            pageIndex--;
            [self.view Hidden];
            [self.view makeToast:@"加载失败"];
            [_tableView headerEndRefreshing];
            
        }
        
    } Fail:^(NSError *error) {
        pageIndex--;
        [self.view Hidden];
        [self.tableView footerEndRefreshing];
        
    }];
    
}


#pragma mark  tableView协议代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 96 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.info.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTableViewCell" forIndexPath:indexPath];
//    SalesOfficeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SalesOfficeCell" forIndexPath:indexPath];
    if ([self.info count] > 0)
    {
        [cell setAttributeForCell:self.info[indexPath.row]];
    }
    
    if ([self.choosenArray containsObject:[self.info objectAtIndex:indexPath.row]])
    {
        cell.choosenBtn.selected = YES;
    }
    else
    {
        cell.choosenBtn.selected = NO;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RecommendTableViewCell * cell = (RecommendTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSDictionary * dic = [self.info objectAtIndex:indexPath.row];
    NSLog(@"%@",dic[@"name"]);
    cell.choosenBtn.selected = YES;
    cell.choosen = YES;
    if ([self.choosenArray containsObject:dic])
    {
        [self.choosenArray removeObject:dic];
        cell.choosenBtn.selected = NO;
        cell.choosen = NO;
        
    }
    else
    {
        [self.choosenArray addObject:dic];
        cell.choosenBtn.selected = YES;
        cell.choosen = YES;
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


#pragma mark - 无数据提示
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


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]&& IOS_VERSION >= 8.0)
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
