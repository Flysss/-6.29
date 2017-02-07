//
//  HWSearchBarController.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/7.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWSearchBarController.h"
#import "HWSearchBar.h"
#import "HWHistoryTool.h"
#import "HWSearchFooterView.h"
#import "AFNetworking.h"
#import "PrisedTableViewCell.h"

@interface HWSearchBarController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) HWSearchBar *searchBar;
@property (nonatomic,weak) UITableView *historyTableView;
@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *historyArray;
@property (nonatomic,strong) NSMutableArray *displayDatas;



@end

@implementation HWSearchBarController


- (NSMutableArray *)displayDatas
{
    if (!_displayDatas) {
        _displayDatas = [NSMutableArray array];
    }
    
    return _displayDatas;
    
}
- (NSMutableArray *)historyArray
{
    return  [NSMutableArray arrayWithArray:[HWHistoryTool sharedHistoryTool].historyArray];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HWColor(242, 242, 242);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" 取消 " style:UIBarButtonItemStyleDone target:self action:@selector(cancleClick)];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];

    
    [self setupSearchBar];
    [self setupTableView];
    [self setupHistroyTabelView];
    [self setupHistroyTabelViewFooterView];
    
   
    
    
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;

    self.tableView = tableView;
    self.tableView.hidden = YES;
    self.tableView.rowHeight = 70;

    
    [self.view addSubview:tableView];
    
    
}
- (void)setupHistroyTabelView
{
    UITableView *historyTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    historyTableView.delegate = self;
    historyTableView.dataSource = self;
    historyTableView.contentInset = UIEdgeInsetsMake(0, 0,100, 0);
    self.historyTableView = historyTableView;
    [self.view addSubview:historyTableView];
    
    HWSearchFooterView *footerView = [HWSearchFooterView footView];
    [footerView addTarget:self action:@selector(footViewClick)];
    self.historyTableView.tableFooterView = footerView;
    self.historyTableView.sectionFooterHeight = 0;
    
    UILabel *headerView = [[UILabel alloc] init];
    headerView.frame = CGRectMake(0, 0, 0, 44);
    headerView.text = @"   搜索历史";
    headerView.font = [UIFont systemFontOfSize:13];
    
    self.historyTableView.tableHeaderView = headerView;

}


- (void)setupHistroyTabelViewFooterView
{
    HWSearchFooterView *footerView = [HWSearchFooterView footView];
    [footerView addTarget:self action:@selector(footViewClick)];
    self.historyTableView.tableFooterView = footerView;
    self.historyTableView.sectionFooterHeight = 0;
    
    UILabel *headerView = [[UILabel alloc] init];
    headerView.frame = CGRectMake(0, 0, 0, 44);
    headerView.text = @"   搜索历史";
    headerView.font = [UIFont systemFontOfSize:13];
    
    self.historyTableView.tableHeaderView = headerView;

    
}


- (void)setupSearchBar
{
    
    self.searchBar = [HWSearchBar searchbar];
    self.searchBar.width = 350;
    self.searchBar.height = 30;
    self.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchBar.placeholder = @"搜索好友";
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [[HWHistoryTool sharedHistoryTool] saveHistory:textField.text];
    
    
    [self searchDatasWithkeyWord:textField.text];
    
    [self.searchBar resignFirstResponder];
    
    return YES;
    
}

#pragma mark --- UITextFieldDelegate
- (void)textFieldDidChange:(NSNotification *)notification
{
    
    UITextField *textField = [notification object];
    
    if (textField.text.length == 0) {
        
        self.historyTableView.hidden = NO;
        [self.historyTableView reloadData];
        
    }else{
        
        self.historyTableView.hidden = YES;
        [self.displayDatas removeAllObjects];
        
        [self.tableView reloadData];
        
    }

    
}

- (void)cancleClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)footViewClick
{
    [[HWHistoryTool sharedHistoryTool] removeHistoryArray];
    [self.displayDatas removeAllObjects];
    [self.tableView reloadData];
    self.historyTableView.hidden = YES;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (tableView == self.historyTableView) {
        self.historyTableView.tableFooterView.hidden = self.historyArray.count == 0;
        self.historyTableView.tableHeaderView.hidden = self.historyArray.count == 0;
        return self.historyArray.count;

    }else{
        
        return self.displayDatas.count;
        
    }
    
}
#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     if (tableView == self.historyTableView)
     {
         [[HWHistoryTool sharedHistoryTool] saveHistory:self.historyArray[indexPath.row]];
         
         [self searchDatasWithkeyWord:self.historyArray[indexPath.row]];
         self.historyTableView.hidden = YES;
         
     }else{
         
         
         
     }
  
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.historyTableView)
    {
        static NSString *ID = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        
        cell.textLabel.text = self.historyArray[indexPath.row];
        
    
        return cell;

        
        
    }else{
        
        
        static NSString *ID = @"displayCell";
        
        PrisedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!cell) {
            cell = [[PrisedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }

        [cell configTableViewCellWithModel:self.displayDatas[indexPath.row]];
        
        return cell;
        
        
    }
}

- (void)searchDatasWithkeyWord:(NSString *)keyWord
{
    self.tableView.hidden = NO;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"loginuid"] = @"51839";
    parame[@"substr"] = keyWord;
    
    [manager POST:@"http://192.168.1.199/index.php/Apis/Forum/getSearch/" parameters:parame
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([responseObject[@"success"] boolValue] == YES) {
             for (NSDictionary *dict in responseObject[@"datas"])
             {
                 BHPersonMyFansModel *model = [[BHPersonMyFansModel alloc]init];
                 [model setValuesForKeysWithDictionary:dict];
                 [self.displayDatas addObject:model];
             }
         }

         
         
         [self.tableView reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     
     }];
    
    
}
@end
