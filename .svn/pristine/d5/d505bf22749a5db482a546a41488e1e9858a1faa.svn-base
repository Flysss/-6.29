//
//  EditUserNameViewController.h
//  SalesHelper_A
//
//  Created by summer on 14/12/30.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ModelViewController.h"

@protocol ChuanrenmingNamedelegate <NSObject>

-(void)Chuanmingzidelegate:(NSString* )NameStr;

@end



@interface EditUserNameViewController : ModelViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property(nonatomic,retain)id<ChuanrenmingNamedelegate>delegeate;
@end

