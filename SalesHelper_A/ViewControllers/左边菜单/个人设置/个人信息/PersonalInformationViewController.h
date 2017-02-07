//
//  PersonalInformationViewController.h
//  SalesHelper_A
//
//  Created by ZhipuTech on 14/12/21.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ModelViewController.h"

@interface PersonalInformationViewController : ModelViewController <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
/**
 *头像视图View
 */
@property (weak, nonatomic) IBOutlet UIView *headView;
/**
 *头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
/**
 *我的账户
 */
@property (weak, nonatomic) IBOutlet UILabel *account;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *sexView;

@end
