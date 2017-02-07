//
//  MyHeaderCell.m
//  SalesHelper_A
//
//  Created by ZhipuTech on 15/6/13.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "MyHeaderCell.h"
#import "UIImageView+WebCache.h"
@implementation MyHeaderCell
{
    
    __weak IBOutlet UIImageView *headerImageView;
    
    __weak IBOutlet UILabel *userName;
    
    __weak IBOutlet UILabel *iphone;
}
- (void)awakeFromNib {

  
    
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    NSString *urlString = [NSString stringWithFormat:@"%@/SalesServers/%@",REQUEST_SERVER_URL,[defaults objectForKey:@"login_User_face"]];
//    [headerImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"toux"]];

}


@end
