//
//  HWMessageModel.h
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/21.
//  Copyright © 2016年 X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWMessageModel : NSObject

/**     帖子id*/
@property (nonatomic,copy) NSString *ID;

/**     归属地*/
@property (nonatomic,copy) NSString *org_name;

/**     uid*/
@property (nonatomic,copy) NSString *uid;

/**     eventid*/
@property (nonatomic,copy) NSString *eventid;


/**     postImgpath*/
@property (nonatomic,copy) NSString *postImgpath;

/**     iconpath*/
@property (nonatomic,copy) NSString *iconpath;


/**     uid*/
@property (nonatomic,copy) NSString *postContents;

/**     addtime 时间戳*/
@property (nonatomic,copy) NSString *addtime;

/**     setAddtime 时间*/
@property (nonatomic,copy) NSString *setAddtime;

/**     姓名*/
@property (nonatomic,copy) NSString *name;

/**     type*/
@property (nonatomic,copy) NSString *istype;

/**     contents*/
@property (nonatomic,copy) NSString *contents;

/**     user*/
@property (nonatomic,copy) NSString *user;


/**     remark*/
@property (nonatomic,copy) NSString *remark;

@end
