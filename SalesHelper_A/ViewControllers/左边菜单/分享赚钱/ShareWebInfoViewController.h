//
//  ShareWebInfoViewController.h
//  SalesHelper_A
//
//  Created by zhipu on 14/12/26.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ModelWebViewController.h"

@interface ShareWebInfoViewController : ModelWebViewController

//@property (nonatomic,retain)NSString *htmlBody;
@property (nonatomic, strong) NSDictionary *shareDict;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end
