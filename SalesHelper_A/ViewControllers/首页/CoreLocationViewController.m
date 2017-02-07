//
//  CoreLocationViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 15/7/22.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "CoreLocationViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface CoreLocationViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,CLLocationManagerDelegate>
{
//tab了view的高度 

    __weak IBOutlet NSLayoutConstraint *_tableViewHeight;

    NSMutableArray* BigArray;
    NSMutableArray* smallArr;
    NSMutableArray* DataSorce;
    NSArray* descripArr;
    NSMutableArray *sortedArray;
    __weak IBOutlet UITableView *tableView;

    __weak IBOutlet NSLayoutConstraint *lineLabW;
}
@property(nonatomic,retain) CLLocationManager *locationManager;

@end

@implementation CoreLocationViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]]];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    
    lineLabW.constant = 0.5;
    
    self.CitySearchbar.hidden = YES;
    _Info = [NSMutableDictionary dictionaryWithCapacity:0];
    _HeadInfo = [NSMutableArray arrayWithCapacity:0];
    
    _locationLabel.clipsToBounds = YES;
    _locationLabel.layer.cornerRadius = 5;
    
    [self layoutLeftBtn];
    
    UILabel * titleLabel = [UILabel new];
    titleLabel.text = @"选择城市";
    titleLabel.font = [UIFont systemFontOfSize:18];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    //ios8SDK 兼容6 和 7 cell下划线
//    if ([_LocationTableview respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_LocationTableview setLayoutMargins:UIEdgeInsetsZero];
//    }
    
    UIImageView* image=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 16, 16)];
    image.image=[UIImage imageNamed:@"销邦-选择城市界面-定位.png"];
    [_locationLabel addSubview:image];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"Login_User_currentLocationCity"]!=nil||[defaults valueForKey:@"Login_User_currentLocationCity"]!=[NSNull null]) {
        _locationLabel.text=[NSString stringWithFormat:@"    %@",[defaults valueForKey:@"Login_User_currentLocationCity"]];
    }
    
    
    [self requestyunyingCity];
    
    
    
    _LocationTableview.sectionIndexColor = [UIColor colorWithWhite:0.387 alpha:1.000];
    _LocationTableview.sectionIndexBackgroundColor = [UIColor clearColor];

    _locationLabel.userInteractionEnabled=YES;
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    //添加手势 让 label可点击
    [self layoutShoushi];
}
-(void)layoutShoushi
{
    
    
    UITapGestureRecognizer* tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClick:)];
    tapgesture.numberOfTapsRequired=1;
    _locationLabel.userInteractionEnabled=YES;
    [_locationLabel addGestureRecognizer:tapgesture];
}

-(void)labelClick:(id)sender
{
        
    for (int i=0; i<BigArray.count; i++) {
        
        NSString* str1=[NSString stringWithFormat:@"    %@",[BigArray[i] objectForKey:@"name"]];
        NSString* str2=_locationLabel.text;
        if ([str1 isEqualToString:str2]) {
            [self.delegate loadChoosenLocation:BigArray[i]];
//            [self.navigationController popViewControllerAnimated:NO];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }

    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 10, 0 , 0);
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:inset];
    }
    if (IOS_VERSION >= 8.0) {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:inset];
        }
    }
    
}

-(void)layoutLeftBtn
{
    
    UIButton* leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame=CGRectMake(0, 0, 25, 25);
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"销邦-选择城市界面-关闭.png"] forState:UIControlStateNormal];
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"销邦-选择城市界面-关闭.png"] forState:UIControlStateHighlighted];

    [leftbtn addTarget:self action:@selector(backlastView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* back = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem=back;

}
- (IBAction)backTopView:(UIButton *)sender
{
     [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)backlastView
{
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(void)requestyunyingCity
{

    RequestInterface* requestinterfece=[[RequestInterface alloc]init];
    [requestinterfece requestyunyingCitywithdic:nil];
    [self.view Loading_0314];
    [requestinterfece getInterfaceRequestObject:^(id data){
        if ([[data objectForKey:@"success"]boolValue]) {
            BigArray=[NSMutableArray arrayWithArray:[data objectForKey:@"datas"]];
            
            for (int i=0; i<BigArray.count; i++) {
               //取出 bigarr中的大写字母
                NSString* nibStr =[BigArray[i] objectForKey:@"nid"];
                NSString* firstStr=[nibStr substringToIndex:1];
                firstStr = [firstStr uppercaseString];
                
                
                if ([[_Info allKeys]containsObject:firstStr]) {
                    NSMutableArray * arr = [_Info objectForKey:firstStr];
                    [arr addObject:BigArray[i]];
                    
                }
                else
                {
                    NSMutableArray * arr =[NSMutableArray arrayWithCapacity:0];
                    [arr addObject:BigArray[i]];
                    [_Info setObject:arr forKey:firstStr];
                
                }
                
                descripArr = [_Info allKeys];
              
                sortedArray = [[descripArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
                    return [obj1 compare:obj2 options:NSNumericSearch];
                }] mutableCopy];
                
            }
            _tableViewHeight.constant = sortedArray.count * 25 + BigArray.count * 45 - 1;
            [self.view Hidden];
            [_LocationTableview reloadData];
        }

    } Fail:^(NSError * error){
        [self.view Hidden];
    
    }];

}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [_CitySearchbar setShowsCancelButton:YES animated:YES];

}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [_CitySearchbar setShowsCancelButton:NO animated:YES];


}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击了确定");
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * headerLabel = [[UILabel alloc] init];
    headerLabel.backgroundColor = [UIColor colorWithWhite:0.936 alpha:1.000];
    headerLabel.textColor = [UIColor colorWithWhite:0.387 alpha:1.000];
    headerLabel.font = Default_Font_14;
    headerLabel.text = [NSString stringWithFormat:@"   %@",sortedArray[section]];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.frame = CGRectMake(11, 0.0,100, 25);
    return headerLabel;
}
//-(NSString* )tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return sortedArray[section];
//}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.view endEditing:YES];
//
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sortedArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 25;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr = [_Info objectForKey:[sortedArray objectAtIndex:section]];
    return arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;

}
-(UITableViewCell*)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString* identifier=@"cell";
    UITableViewCell* cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
    }
    cell.textLabel.textColor = [UIColor colorWithWhite:0.387 alpha:1.000];
    cell.textLabel.font = Default_Font_17;
    if (_Info.count != 0) {
        cell.textLabel.text=[[[_Info objectForKey:[sortedArray objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row] objectForKey:@"name"];
       
    }
    
    //ios8SDK 兼容6 和 7
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    return cell;
}

//biaoge表格右侧索引
//用于设置sectionIndexTitle
//返回要为一个内容为NSString 的NSArray 里面存放section title;
//默认情况下 section Title根据顺序对应 section 【如果不写tableView: sectionForSectionIndexTitle: atIndex:的话】

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView

{
    NSMutableArray * arr = [NSMutableArray arrayWithArray:sortedArray];
    [arr insertObject:UITableViewIndexSearch atIndex:0];
    return arr;
    
}
//通过传入的传入每个sectionIndex的title,index 来设置这个sectionIndex 对应的section。
//传入 section title 和index 返回其应该对应的session序号。
//一般不需要写 默认section index 顺序与section对应。除非 你的section index数量或者序列与section不同才用修改

- (NSInteger)tableView:(UITableView *)tableView1 sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index == 0)
    {
        [self.CitySearchbar becomeFirstResponder];
    }
    else
    {
           [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index - 1] atScrollPosition:UITableViewScrollPositionTop animated:YES]; 
    }

    return index;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@", [[_Info objectForKey:sortedArray[indexPath.section]] objectAtIndex:indexPath.row]);
    [self.delegate loadChoosenLocation: [[_Info objectForKey:sortedArray[indexPath.section]] objectAtIndex:indexPath.row]];
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
