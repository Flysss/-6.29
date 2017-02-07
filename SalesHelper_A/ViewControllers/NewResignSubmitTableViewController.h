//
//  NewResignSubmitTableViewController.h
//  SalesHelper_A
//
//  Created by summer on 15/10/10.
//  Copyright © 2015年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewResignSubmitTableViewController : UITableViewController

@property (nonatomic,assign,getter=isPersonal) BOOL personal;


@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;


@end
