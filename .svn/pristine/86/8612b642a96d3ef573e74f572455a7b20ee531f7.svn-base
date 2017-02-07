//
//  RecommendPropertyViewController.m
//  SalesHelper_A
//
//  Created by summer on 15/7/16.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "RecommendPropertyViewController.h"
#import "popTableView.h"
#import "ChooseTableCell.h"
#import "ProjectUtil.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UIColor+Extend.h"
#import "RecommendTableViewCell.h"


@interface RecommendPropertyViewController ()<UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


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


//自定义导航栏
@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UIButton * rightBtn;
@end

@implementation RecommendPropertyViewController
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
    
    __weak IBOutlet UISearchBar *mySearchBar;
    UIView * coverView ;
    UIBarButtonItem * rightBar;
    NSString * location ;
    NSUInteger count;//记录数组个数
    
//    UIButton* rightBtn;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.topView.backgroundColor = [UIColor hexChangeFloat:@"00aff0"];
    self.backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.backBtn setImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:(UIControlStateNormal)];
    [self.backBtn addTarget:self action:@selector(backlastView) forControlEvents:(UIControlEventTouchUpInside)];
    self.backBtn.frame = CGRectMake(11, 20, 30, 44);
    [self.topView addSubview:self.backBtn];
    
    mySearchBar.delegate = self;
    [mySearchBar setContentMode:UIViewContentModeCenter];
    mySearchBar.showsCancelButton = NO;
    
    self.rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH-70,27,60, 32);
    [self.rightBtn setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.choosenArr.count] forState:UIControlStateNormal];
    self.rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(click_makeSure) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.rightBtn];
    [self.view addSubview:self.topView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"选择楼盘";
    titleLabel.font = Default_Font_18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self.topView addSubview: titleLabel];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"location_City"] && [defaults objectForKey:@"location_City"] != [NSNull null]) {
        location = [defaults objectForKey:@"location_City"];
    }else
    {
        location = @"1171";
    }
    
    pageIndex = 1;
    
    count = self.choosenArr.count;
    
    self.info = [NSMutableArray arrayWithCapacity:0];
    requestParam = [NSMutableDictionary dictionary];
    [requestParam setObject:location forKey:@"districtPId"];
    [requestParam setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [requestParam setObject:@"10" forKey:@"size"];
    
    [self requestWithParam:requestParam];
    
    NSDictionary * param2 = @{
                              @"districtId":location,
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
    
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tableViewGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardDidShowNotification object:nil];//在这里注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden) name:UIKeyboardDidHideNotification object:nil];//在这里注册通知
    
    [self.tableView registerClass:[RecommendTableViewCell class] forCellReuseIdentifier:@"recommendcell"];
    self.tableView.tableFooterView = [[UIView alloc] init];

 
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
    
    NSLog(@"%@",param);
    RequestInterface * loadPerpoty = [[RequestInterface alloc] init];
    
    [self.view Loading_0314];
    [loadPerpoty requestGetPropertyInfosWithParam:param];
    [loadPerpoty getInterfaceRequestObject:^(id data) {
        [self.tableView headerEndRefreshing];
        
        
        if ([data objectForKey:@"success"]) {
            [self.view Hidden];
            self.tableView.emptyDataSetSource = self;
            
            self.tableView.emptyDataSetDelegate = self;
            [self.info removeAllObjects];
            [self.info addObjectsFromArray:[data objectForKey:@"datas"]];
            
            for (int i = 0 ; i < self.info.count; i ++) {
                for (int j = 0; j < self.choosenArr.count; j++) {
                    if ([[[self.choosenArr objectAtIndex:j] objectForKey:@"id"]isEqualToNumber:[[self.info objectAtIndex:i]objectForKey:@"id"]]) {
                        [self.choosenArr removeObjectAtIndex:j];
                        [self.choosenArr addObject:[self.info objectAtIndex:i]];
                    }
                }
            }
            
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
        [self.tableView headerEndRefreshing];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RecommendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"recommendcell" forIndexPath:indexPath];
    if ([self.info count] > 0 ) {
        [cell setAttributeForCell:self.info[indexPath.row]];
    }
    if ([self.choosenArr containsObject:[self.info objectAtIndex:indexPath.row]])
    {
        cell.choosenBtn.selected = YES;
    }
    else
    {
        cell.choosenBtn.selected = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RecommendTableViewCell * cell = (RecommendTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        NSDictionary * dic = [self.info objectAtIndex:indexPath.row];
        cell.choosenBtn.selected = YES;
        cell.choosen = YES;
        if ([self.choosenArr containsObject:dic]){
            [self.choosenArr removeObject:dic];
            cell.choosenBtn.selected = NO;
            cell.choosen = NO;
      
        } else {
            if (self.choosenArr.count >= 3) {
            [ProjectUtil showAlert:@"温馨提示" message:@"您已经选择了最高上限3个楼盘"];
            cell.choosenBtn.selected = NO;
            cell.choosen = NO;
            return;
        }else {
    
            [self.choosenArr addObject:dic];
            cell.choosenBtn.selected = YES;
            cell.choosen = YES;
                }
        }
     [self.rightBtn setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.choosenArr.count]  forState:UIControlStateNormal];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)clickBtn:(UIButton *)button
{
    static char key;
    
   
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
        popTableView * table = [[popTableView alloc]initWithFrame:CGRectMake(0, 148, self.view.width, 44 * 5)];
        coverView = [[UIView alloc]initWithFrame:CGRectMake(0,104 + (44 * 5), self.view.width,self.view.height - 104 + (44 * 5))];
        coverView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.5];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [coverView addGestureRecognizer:tap];
        coverView.userInteractionEnabled = YES;
        [self.view addSubview:coverView];
        self.listTabelView = table;
        
        objc_setAssociatedObject(self.listTabelView,&key, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
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
    
    
    //    objc_setAssociatedObject(table, &key, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//触摸遮罩 取消下拉列表
-(void)tap
{
    [self.listTabelView removeFromSuperview];
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
        
        [self requestWithParam:requestParam];
    }
    [mySearchBar resignFirstResponder];
}


-(void)refreshingTableView
{
    //下拉刷新
    __block  RecommendPropertyViewController * h = self;
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
        [self.tableView footerEndRefreshing];

        if ([data objectForKey:@"success"]) {
            [self.view Hidden];
            [self.info addObjectsFromArray:[data objectForKey:@"datas"]];
            if (![[data objectForKey:@"datas"]count]) {
                [self.view makeToast:@"没有更多数据了"];
            }
            [self.tableView reloadData];
            [_tableView headerEndRefreshing];
            
        }else
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
-(void)backlastView
{
    if (self.choosenArr.count > count) {
        for (int i = 0; i < self.choosenArr.count - count; i++) {
            [self.choosenArr removeLastObject];
        }
    }
    else if (self.choosenArr.count == 0){
        [self.choosenArr removeAllObjects];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//点击确定完成选择
-(void)click_makeSure
{
    
    [self.recommendDelegate addPropertyArrInfo:self.choosenArr];
    
    [self.navigationController popViewControllerAnimated:YES];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
