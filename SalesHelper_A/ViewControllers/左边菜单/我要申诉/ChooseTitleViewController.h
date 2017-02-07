//
//  ChooseTitleViewController.h
//  SalesHelper_A
//
//  Created by summer on 14/12/30.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ModelViewController.h"

@protocol ChooseTitleViewControllerDelegate <NSObject>

-(void)getChoosedTitle:(NSString *)title Index:(NSInteger)index;

@end


@interface ChooseTitleViewController : ModelViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITableView *titleTableView;
@property (nonatomic,assign)NSInteger titleIndex;

@property (nonatomic,assign)id <ChooseTitleViewControllerDelegate>delegate;

@end
