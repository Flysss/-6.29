//
//  SearchHistViewController.m
//  SalesHelper_A
//
//  Created by Brant on 16/2/19.
//  Copyright © 2016年 X. All rights reserved.
//

#import "SearchHistViewController.h"
#import "BHMessageCell.h"
#import "RequestInterface.h"


@interface SearchHistViewController ()  <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UITableView *m_tableView;
@property (nonatomic, strong) UITableView *dataTabelView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@property (nonatomic, strong) UISearchBar *m_searchBar;
@property (nonatomic, assign) NSInteger page;

@end

@implementation SearchHistViewController
{
    NSString *refreshStr;
    NSInteger pageNum;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 11, 22)];
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(backToPop) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.dataSourceArr = [NSMutableArray arrayWithCapacity:1];
    pageNum = 1;
    
    [self creatSearchBar];
    
    [self creatTableView];
    
}

- (void)backToPop
{
    [self.m_searchBar resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData:(NSString *)subStr
{
    RequestInterface *interface = [[RequestInterface alloc]init];
    NSDictionary *dic = @{
                          @"substr":subStr,
                          @"loginuid":@"51832",
                          @"p":@(_page),
                          };
    [interface requestBHSeachWithDic:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
         if ([data[@"success"] boolValue] == YES)
         {
             if ([data[@"datas"] count] != 0)
             {
                
                 self.dataSourceArr = data[@"datas"];
                
                 [self.m_tableView reloadData];
             }
             else
             {
                 [self.view makeToast:data[@"message"]];
             }
         }else
         {
             [self.view makeToast:data[@"message"]];
             
         }
     } Fail:^(NSError *error)
     {
         [self.view makeToast:@"请求失败"];
     }];

}


#pragma mark --创建搜索框
- (void)creatSearchBar
{
    self.m_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-60, 30)];
    self.m_searchBar.delegate = self;
    [self.m_searchBar setBackgroundImage:[ProjectUtil imageWithColor:RGBACOLOR(235, 236, 238, 1) size:CGSizeMake(0.1f, 0.1f)]];
    [self.m_searchBar setContentMode:UIViewContentModeLeft];
    self.m_searchBar.tintColor = [UIColor whiteColor];
    
    self.m_searchBar.showsCancelButton = NO;
    self.m_searchBar.placeholder = @"搜索好友";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.m_searchBar];
    //self.m_searchBar;
    [self setSearchBarTextfiled:self.m_searchBar];
    
}

- (void)setSearchBarTextfiled:(UISearchBar *)searchBar
{
    for (UIView *view in searchBar.subviews){
        for (id subview in view.subviews){
            if ( [subview isKindOfClass:[UITextField class]] ){
                [(UITextField *)subview setTintColor:[UIColor blueColor]];
                return;
            }
        }
    }
}

#pragma mark - UISerchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.m_searchBar.showsCancelButton = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    self.m_searchBar.showsCancelButton = NO;
    return YES;
}

//取消搜索
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.m_searchBar.showsCancelButton = NO;
    
    [self.m_searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.m_searchBar resignFirstResponder];
    
    NSString *searchStr = searchBar.text;
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSArray * array = [userInfo objectForKey:@"searchHis"];
    
    NSMutableArray *arrrrrrr = [NSMutableArray arrayWithArray:array];
    
    for (int i = 0; i < arrrrrrr.count; i++)
    {
        
        if ([searchStr isEqualToString:arrrrrrr[i]])
        {
            [arrrrrrr removeObject:searchStr];
        }
    }
    
    
    [arrrrrrr insertObject:searchStr atIndex:0];
    [userInfo setObject:arrrrrrr forKey:@"searchHis"];
    [userInfo synchronize];

}

#pragma mark --创建搜索历史记录列表
- (void)creatTableView
{
    self.m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    self.m_tableView.tableFooterView = [[UIView alloc] init];
    self.m_tableView.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
    self.m_tableView.tag = 100;
    [self.view addSubview:self.m_tableView];
    
    self.dataTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.dataTabelView.delegate = self;
    self.dataTabelView.dataSource = self;
    self.dataTabelView.tableFooterView = [[UIView alloc] init];
    self.dataTabelView.hidden = YES;
    self.dataTabelView.tag = 101;
    [self.view addSubview:self.dataTabelView];
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
        cell.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
        
        if (indexPath.row == 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 15, 20, 20)];
            imageView.image = [UIImage imageNamed:@"历史记录"];
            [cell.contentView addSubview:imageView];
            
            UILabel *lanel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+8, 15, 150, 20)];
            lanel.text = @"搜索历史记录";
            lanel.font = Default_Font_16;
            lanel.textColor = [UIColor hexChangeFloat:@"676767"];
            [cell.contentView addSubview:lanel];
            
        } else {
            NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
            NSArray * array = [userInfo objectForKey:@"searchHis"];
            
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
    } else {
        BHMessageCell *cell = (BHMessageCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[BHMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@", indexPath]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dic = [NSDictionary dictionary];
        [cell configTableViewWithDic:dic];
        
        return cell;
    }
}

- (void)searchTextChange:(UIButton *)sender
{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSArray * array = [userInfo objectForKey:@"searchHis"];
    self.m_searchBar.text = array[sender.tag];
    
    [self.m_searchBar becomeFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.tag == 100) {
        return 70;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    view.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
    
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
    NSArray * array = [userInfo objectForKey:@"searchHis"];
    if (array.count == 0)
    {
        clearbutton.hidden = YES;
    }
    
    return view;

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
        [userInfo setObject:nil forKey:@"searchHis"];
        [userInfo synchronize];
        
        [self.m_tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
        return 45;
    } else {
        return 65;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 100)
    {
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        NSArray * array = [userInfo objectForKey:@"searchHis"];
        
        return array.count+1;
    } else {
        return 10;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


//将列表的分割线从头开始
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
    if (IOS_VERSION >= 8.0) {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
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
