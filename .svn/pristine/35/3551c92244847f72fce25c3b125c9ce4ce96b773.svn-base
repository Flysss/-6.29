//
//  TwohandSearchViewController.m
//  SalesHelper_A
//
//  Created by Brant on 16/1/6.
//  Copyright (c) 2016年 X. All rights reserved.
//

#import "TwohandSearchViewController.h"
#import "TwohandTableViewCell.h"
#import "TwohandDetailViewController.h"
#import "UIColor+HexColor.h"

@interface TwohandSearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UITableView *m_tableView;
@property (nonatomic, strong) UITableView *dataTabelView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@property (nonatomic, copy) NSString *refreshStr;
@end

@implementation TwohandSearchViewController
{
    UISearchBar *searchBar1;
//    CGFloat cellHeight;
    NSArray *hotWordArray;
    
//    NSString *refreshStr;
    int pageNum;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor hexChangeFloat:@"d0d0d0"];
    pageNum = 1;
    hotWordArray = [NSArray array];
    self.dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:nil];
    self.rightBtn.hidden = YES;
    searchBar1 = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 20, SCREEN_WIDTH-40, 44)];
    searchBar1.delegate = self;
    [searchBar1 setBackgroundImage:[ProjectUtil imageWithColor:RGBACOLOR(235, 236, 238, 1) size:CGSizeMake(0.1f, 0.1f)]];
    [searchBar1 setContentMode:UIViewContentModeLeft];
    [searchBar1 setPlaceholder:@"搜索关键词"];
    searchBar1.showsCancelButton = NO;
    searchBar1.tintColor=[UIColor whiteColor];
    [self.topView addSubview: searchBar1];

    [self setSearchBarTextfiled:searchBar1];
    
//    [self creaSearchBar];
    
    [self creatHistoryTableView];
    
    [self creatHotSearch];
    
//    [self requestData];
    [self tableViewConfig];
}

- (void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --创建导航栏的搜索框
- (void)creaSearchBar
{
    searchBar1 = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 30)];
    searchBar1.delegate = self;
    [searchBar1 setBackgroundImage:[ProjectUtil imageWithColor:RGBACOLOR(235, 236, 238, 1) size:CGSizeMake(0.1f, 0.1f)]];
    [searchBar1 setContentMode:UIViewContentModeLeft];
    searchBar1.tintColor=[UIColor whiteColor];
    
    searchBar1.showsCancelButton = NO;
    searchBar1.placeholder = @"搜索关键词";

    self.navigationItem.titleView = searchBar1;
    [self setSearchBarTextfiled:searchBar1];
   
}

- (void)setSearchBarTextfiled:(UISearchBar *)searchBar
{
    for (UIView *view in searchBar.subviews){
        for (id subview in view.subviews){
            if ( [subview isKindOfClass:[UITextField class]] ){
                [(UITextField *)subview setTintColor:[UIColor colorWithHexString:@"00aff0"]];
                return;
            }
        }
    }
}
#pragma mark - UISerchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar1.showsCancelButton = YES;
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    searchBar1.showsCancelButton = NO;
    return YES;
}

//取消搜索
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar1.showsCancelButton = NO;

    [searchBar1 resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

//点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar1 resignFirstResponder];
    
    NSString *searchStr = searchBar1.text;
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSArray * array = [userInfo objectForKey:@"search"];
    
    NSMutableArray *arrrrrrr = [NSMutableArray arrayWithArray:array];
   
    for (int i = 0; i < arrrrrrr.count; i++)
    {
        
        if ([searchStr isEqualToString:arrrrrrr[i]])
        {
            [arrrrrrr removeObject:searchStr];
        }
    }
   
    
    [arrrrrrr insertObject:searchStr atIndex:0];
    [userInfo setObject:arrrrrrr forKey:@"search"];
    [userInfo synchronize];
    
    self.refreshStr = searchBar1.text;
    [self requestDataWithString:searchBar1.text isRefresh:YES];
    
}


//创建列表
- (void)creatHistoryTableView
{
    self.m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    self.m_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.m_tableView.tag = 100;
    self.m_tableView.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
    [self.view addSubview:self.m_tableView];
    
    self.dataTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.dataTabelView.delegate = self;
    self.dataTabelView.dataSource = self;
    self.dataTabelView.tableFooterView = [[UIView alloc] init];
    self.dataTabelView.hidden = YES;
    self.dataTabelView.tag = 101;
    [self.dataTabelView registerClass:[TwohandTableViewCell class] forCellReuseIdentifier:@"searchCell"];
    [self.view addSubview:self.dataTabelView];

}

//请求数据
- (void)requestDataWithString:(NSString *)string isRefresh:(BOOL)refresh
{
    NSString *cityId = [[NSUserDefaults standardUserDefaults] objectForKey:@"location_City"];
    NSDictionary *dic = @{@"tageName":string,
                          @"districtPId":cityId,
                          @"page":[NSString stringWithFormat:@"%d", pageNum]
                          };

    NSLog(@"%@", dic);
    RequestInterface *interface = [[RequestInterface alloc] init];
    [interface requestTwohandSearchWithDic:dic];
    [self.view Loading_0314];
    [interface getInterfaceRequestObject:^(id data) {
        [self.view Hidden];
        NSLog(@"%@", data);
        if ([data[@"success"] boolValue])
        {
            
            if (refresh)
            {
                [self.dataSourceArr removeAllObjects];
                [self.dataSourceArr addObjectsFromArray:[data objectForKey:@"datas"]];
                
                if (![[data objectForKey:@"datas"] count])
                {
                    self.m_tableView.hidden = NO;
                    self.dataTabelView.hidden = YES;
                    [self.m_tableView reloadData];
                    [self.view makeToast:@"暂无数据"];
                }
                else
                {
                    self.m_tableView.hidden = YES;
                    self.dataTabelView.hidden = NO;
                    [self.dataTabelView reloadData];
                }
            }
            else
            {
                [self.dataSourceArr insertObjects:data[@"datas"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.dataSourceArr.count, [data[@"datas"] count])]];
                NSLog(@"%@", data[@"datas"]);
                if (![[data objectForKey:@"datas"] count])
                {
                    [self.view makeToast:@"没有更多数据了"];
                    pageNum--;
                }
                self.m_tableView.hidden = YES;
                self.dataTabelView.hidden = NO;
                [self.dataTabelView reloadData];
            }
            
        }
        else
        {
            
            [self.view makeToast:@"请求失败"];
            
            self.m_tableView.hidden = NO;
            [self.m_tableView reloadData];
            self.dataTabelView.hidden = YES;
        }    } Fail:^(NSError *error) {
        [self.view Hidden];
        [self.view makeToast:@"网络错误"];
 
        self.m_tableView.hidden = NO;
        [self.m_tableView reloadData];
        self.dataTabelView.hidden = YES;
    }];
    
    
//     if (请求成功)
//     {
//        NSArray *hotArray = @[@"降价房源",@"地铁房",@"学区房",@"门市房",@"市区房",@"高新区",@"刷山区",@"大蜀山", @"呵呵haha"];
//        if (hotArray.count % 4 == 0 && hotArray.count != 0)
//        {
//            cellHeight = 50 + (hotArray.count/4)*45;
//        } else {
//            cellHeight = 50 + (hotArray.count/4+1)*45;
//        }
//        self.m_tableView.hidden = YES;
//        [self.dataTabelView reloadData];
//
//     } 
//     else
//     {
    
//     }
    
}

- (void)creatHotSearch
{
    RequestInterface *interFace = [[RequestInterface alloc] init];
    [self.view Loading_0314];
    [interFace requestTwohandSearchHotWord];
    [interFace getInterfaceRequestObject:^(id data) {
        [self.view Hidden];
        if (data[@"message"])
        {
            hotWordArray = data[@"datas"];
        }
        else
        {
            [self.view makeToast:@"请求失败"];
        }
        [self.m_tableView reloadData];
    
    } Fail:^(NSError *error) {
        [self.view Hidden];
        [self.view makeToast:@"网络错误"];
    }];
}

#pragma mark --增加刷新控件
- (void)tableViewConfig
{
    __block TwohandSearchViewController *sear = self;
    
    [self.dataTabelView addHeaderWithCallback:^{
        pageNum = 1;
        [sear requestDataWithString:sear.refreshStr isRefresh:YES];
        [sear.dataTabelView headerEndRefreshing];
    }];
    
    [self.dataTabelView addFooterWithCallback:^{
        pageNum++;
        [sear requestDataWithString:sear.refreshStr isRefresh:NO];
        [sear.dataTabelView footerEndRefreshing];
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 100)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@", indexPath]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
        
        if (indexPath.row == 0)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH, 20)];
            label.text = @"热门搜索";
            label.textColor = [UIColor hexChangeFloat:KGrayColor];
            [cell.contentView addSubview:label];
            
            NSInteger count = hotWordArray.count;
            int width = (SCREEN_WIDTH-50)/4;
            int height = 30;
            
            for (int i = 0; i < count; i++)
            {
                UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(10+(i%4)*(width+10), CGRectGetMaxY(label.frame)+15 + (i/4)*(height+15), width, height)];
                [button1 setTitle:hotWordArray[i][@"name"] forState:UIControlStateNormal];
                [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

                button1.titleLabel.font = Default_Font_15;
                button1.layer.cornerRadius = 5;
                button1.layer.masksToBounds = YES;
                if (hotWordArray[i][@"color"] != nil &&
                    hotWordArray[i][@"color"] != [NSNull null] &&
                    hotWordArray[i][@"color"])
                {
                    [button1 setTitleColor:[UIColor hexChangeFloat:hotWordArray[i][@"color"]] forState:UIControlStateNormal];
                    button1.layer.borderColor = [UIColor hexChangeFloat:hotWordArray[i][@"color"]].CGColor;
                }
                
                button1.layer.borderWidth = 0.5;
                
                button1.tag = i;
                [button1 addTarget:self action:@selector(hotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button1];
            }
        }
        else
        {
            NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
            NSArray * array = [userInfo objectForKey:@"search"];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10-25, 45)];
            label.text = array[indexPath.row-1];
            label.font = Default_Font_15;
            label.textColor = [UIColor hexChangeFloat:KBlackColor];
            [cell.contentView addSubview:label];
            
            UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-25, (45-14)/2, 14, 14)];
            [imageButton setBackgroundImage:[UIImage imageNamed:@"倾斜箭头"] forState:UIControlStateNormal];
            imageButton.tag = indexPath.row-1;
            [imageButton addTarget:self action:@selector(searchTextChange:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:imageButton];
            
        }
        return cell;
    }
    else
    {
        TwohandTableViewCell *cell = (TwohandTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[TwohandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@", indexPath]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell configTableCellWithDic:self.dataSourceArr[indexPath.row]];
        return cell;
    }
    
}

#pragma mark --点击热门词汇
- (void)hotButtonClick:(UIButton *)sender
{
//    NSLog(@"%ld", (long)sender.tag);
    [searchBar1 resignFirstResponder];
    self.refreshStr = hotWordArray[sender.tag][@"name"];
    searchBar1.text = hotWordArray[sender.tag][@"name"];
    [self requestDataWithString:hotWordArray[sender.tag][@"name"] isRefresh:YES];
    
    //点击热门词汇，保存热门词汇到搜索历史
    NSString *searchStr = hotWordArray[sender.tag][@"name"];
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSArray * array = [userInfo objectForKey:@"search"];
    NSMutableArray *arrrrrrr = [NSMutableArray arrayWithArray:array];
    
    for (int i = 0; i < arrrrrrr.count; i++)
    {
        if ([searchStr isEqualToString:arrrrrrr[i]])
        {
            [arrrrrrr removeObject:searchStr];
        }
    }
    [arrrrrrr insertObject:searchStr atIndex:0];
    [userInfo setObject:arrrrrrr forKey:@"search"];
    [userInfo synchronize];
    
}

- (void)searchTextChange:(UIButton *)sender
{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSArray * array = [userInfo objectForKey:@"search"];
    searchBar1.text = array[sender.tag];
    
    [searchBar1 becomeFirstResponder];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.tag == 100)
    {
        return 70;
    }
    else
    {
        return 0.01;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView.tag == 100)
    {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        view.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
        
        UIButton *clearbutton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-130)/2, 28, 130, 30)];
        clearbutton.layer.cornerRadius = 5;
        clearbutton.layer.masksToBounds = YES;
        clearbutton.layer.borderColor = [UIColor hexChangeFloat:@"d0d0d0"].CGColor;
        clearbutton.layer.borderWidth = 0.5;
        [clearbutton setTitle:@"清除搜索历史" forState:UIControlStateNormal];
        [clearbutton setTitleColor:[UIColor hexChangeFloat:KBlueColor] forState:UIControlStateNormal];
        [clearbutton addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:clearbutton];
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        NSArray * array = [userInfo objectForKey:@"search"];
        if (array.count == 0)
        {
            clearbutton.hidden = YES;
        }
        
        return view;
    }
    else
    {
        return nil;
    }
}

#pragma mark --清空历史记录
- (void)clearBtnClick
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认清空历史？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        [userInfo setObject:nil forKey:@"search"];
        [userInfo synchronize];
        
        [self.m_tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100)
    {
        if (indexPath.row == 0)
        {
            //        return cellHeight;
//            return 200;
            if (hotWordArray.count <4) {
                return 60+45;
            } else {
               
                if (hotWordArray.count%4 == 0)
                {
                    return 60+ (hotWordArray.count/4)*45;

                } else {
                    return 60+ (hotWordArray.count/4 + 1)*45;
                }
            }
        }
        else
        {
            return 45;
        }
    }
    else
    {
        return 100;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 100)
    {
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        NSArray * array = [userInfo objectForKey:@"search"];
        return array.count+1;
    }
    else
    {
        return self.dataSourceArr.count;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100)
    {
        if (indexPath.row != 0)
        {
            NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
            NSArray * array = [userInfo objectForKey:@"search"];
            
//            NSLog(@"%@", array[indexPath.row-1]);
            
            self.refreshStr = array[indexPath.row-1];
            searchBar1.text = array[indexPath.row-1];
            [self requestDataWithString:array[indexPath.row-1] isRefresh:YES];
            
        }
    }
    else
    {
        TwohandDetailViewController *vc = [[TwohandDetailViewController alloc] init];
        vc.strId = self.dataSourceArr[indexPath.row][@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



//将列表的分割线从头开始
//最新的，简便些
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if (IOS_VERSION >= 8.0)
    {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchBar1 resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
