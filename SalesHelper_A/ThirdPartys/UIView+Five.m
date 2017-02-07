//
//  UIView+Five.m
//  WXMedia
//
//  Created by User on 14-8-5.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import "UIView+Five.h"
#import "TableView_HUD.h"
#import <objc/runtime.h>

@implementation UIView (Five)

#pragma mark 属性
/**信息提示框*/
//static char HUDKEY_BE;

@dynamic hud;
//-(void)setHud:(MBProgressHUD *)newValue{
//	objc_setAssociatedObject(self.superview, &HUDKEY_BE, newValue, OBJC_ASSOCIATION_RETAIN);
//}
-(MBProgressHUD *)hud{
//	MBProgressHUD * hud_0314 = objc_getAssociatedObject(self.superview, &HUDKEY_BE);
//	
//	if(hud_0314 == nil){
//		hud_0314 = [MBProgressHUD showHUDAddedTo:self animated:YES];
//		
//		self.hud =
//		[self addSubview:hud_0314];
//	}
//	
//
//	
//	return objc_getAssociatedObject(self.superview, [@"hud" UTF8String]);
	
	MBProgressHUD * hud_0314 = [MBProgressHUD HUDForView:self];

	if(hud_0314 == nil){
		hud_0314 = [MBProgressHUD showHUDAddedTo:self animated:YES];
		[self addSubview:hud_0314];
	}
	
	return hud_0314;
}

/**弹出层容器*/
static char PANELKEY_BE;

@dynamic uv_Panel;
-(void)setuv_Panel:(UIView *)newValue{
	objc_setAssociatedObject(self.superview, &PANELKEY_BE, newValue, OBJC_ASSOCIATION_RETAIN);
}
-(UIView *)uv_Panel{
	UIView * uv_Panel = objc_getAssociatedObject(self, &PANELKEY_BE);

	return uv_Panel;
}


#pragma 显示
/**提示信息*/
- (void)Message:(NSString *)message{
	[self Message:message HiddenAfterDelay:2.0];
}

/**提示信息，N秒后关闭*/
- (void)Message:(NSString *)message HiddenAfterDelay:(NSTimeInterval)delay{
	[self Message:message YOffset:0.0 HiddenAfterDelay:delay];
}

/**自定义提示框位置*/
- (void)Message:(NSString *)message YOffset:(float)yoffset HiddenAfterDelay:(NSTimeInterval)delay{
	
	MBProgressHUD * hud_0314 = self.hud;

	hud_0314.yOffset = yoffset;
	hud_0314.mode = MBProgressHUDModeText;
	hud_0314.labelText = message;
	[hud_0314  show:true];
	
	[hud_0314  hide:true afterDelay:delay];

}

/**展示Loading标示*/
- (void)Loading:(NSString *)message{
	MBProgressHUD * hud_0314 = self.hud;
	hud_0314.yOffset = 0.0;
	hud_0314.mode = MBProgressHUDModeIndeterminate;
	hud_0314.labelText = message;
	[hud_0314  show:true];
}

/**隐藏*/
- (void)HiddenAfterDelay:(NSTimeInterval)delay{
	[self.hud  hide:true afterDelay:delay];
}

/**隐藏*/
- (void)Hidden{
	[self.hud hide:YES];
}

- (void)Loading_0314{
	[self touchesEnded:nil withEvent:nil];

	MBProgressHUD * hud_0314 = self.hud;
	
	hud_0314.mode = MBProgressHUDModeIndeterminate;
	[hud_0314  show:true];
}

/*是否Loading中*/
- (BOOL)IsLoading{
	MBProgressHUD * hud_0314 = self.hud;
	
	if((hud_0314.mode == MBProgressHUDModeIndeterminate || hud_0314.mode == MBProgressHUDModeIndeterminate) &&
	   !hud_0314.isHidden){
		return YES;
	}
	else{
		return NO;
	}
}

#pragma mark 用UIAlertView弹出提示信息

- (void)AlertMessage:(NSString *)message withTitile:(NSString *)title{
    [self Hidden];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"知道了",nil];
    
    [alert show];
}

- (void)AlertMessage:(NSString *)message withTitile:(NSString *)title withDelegate:(id)delegate{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:delegate
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"知道了",nil];
    
    [alert show];
}

#pragma mark 弹出UIView

- (void)ShowData:(NSArray *)data Height:(CGFloat)height CellSelected:(void(^)(NSDictionary * dic))cellSelectedBlock{
    CGFloat __block h_0314 = height;
    
    [self HiddenData:^{
        //弹出层
        UIView * view_HUD = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        view_HUD.tag = 03140;
        view_HUD.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view_HUD];
        NSDictionary * viewsDic = NSDictionaryOfVariableBindings(view_HUD,self);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view_HUD]-0-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:viewsDic]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view_HUD]-0-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:viewsDic]];
        
        //背景Button
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.tag = 13140;
        button.alpha = 0;
        button.backgroundColor = [UIColor colorWithRed:65 / 255.0 green:65 / 255.0 blue:65 / 255.0 alpha:0.3];
        [button addTarget:self action:@selector(HiddenData) forControlEvents:UIControlEventTouchUpInside];
        [view_HUD addSubview:button];
        
        viewsDic = NSDictionaryOfVariableBindings(button);
        [view_HUD addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[button]-0-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewsDic]];
        
        [view_HUD addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[button]-0-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewsDic]];
        
        //    数据列表
        TableView_HUD * tableView = [[TableView_HUD alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width - 20, height)];
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        tableView.tag = 23141;
        tableView.DataSource_0314 = [data mutableCopy];
        [view_HUD addSubview:tableView];
        
        [tableView reloadData];
        
        //    Cell选中事件
        [tableView CellSelected:^(NSDictionary * dic){
            [self HiddenData:^(){
                if(cellSelectedBlock){
                    cellSelectedBlock(dic);
                }
            }];
        }];
        
        if(data.count * 44 < self.bounds.size.height - 64){
            h_0314 = data.count * 44.0;
            tableView.scrollEnabled = NO;
        }
        else{
            h_0314 = (NSInteger)height / 44 * 44;
            tableView.scrollEnabled = YES;
        }
        
        //取消Button
        UIButton * button_ESC = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height + height, [UIScreen mainScreen].bounds.size.width, 44)];
        button_ESC.layer.cornerRadius = 6;
        button_ESC.translatesAutoresizingMaskIntoConstraints = NO;
        button_ESC.backgroundColor = RGBACOLOR(255, 255,255, 0.97);
        button_ESC.tag = 23140;
        [button_ESC addTarget:self action:@selector(HiddenData) forControlEvents:UIControlEventTouchUpInside];
        [button_ESC setTitle:@"取消" forState:UIControlStateNormal];
        [button_ESC setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [view_HUD addSubview:button_ESC];
        
        viewsDic = NSDictionaryOfVariableBindings(button_ESC);
        [view_HUD addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[button_ESC]-10-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewsDic]];
        //--------------------------------------------------------------------------------------------------------------
        viewsDic = NSDictionaryOfVariableBindings(tableView,button_ESC);
        NSDictionary * metrics = @{@"h_0314" : [NSNumber numberWithFloat:h_0314]};
        
        [view_HUD addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[tableView]-10-|"
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:viewsDic]];
        
        [view_HUD addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tableView(h_0314)]-8-[button_ESC(44)]-6-|"
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:viewsDic]];
        
        [UIView animateWithDuration:0.5 animations:^(void){
            button.alpha = 1;
            [button_ESC layoutIfNeeded];
            [tableView layoutIfNeeded];
        } completion:^(BOOL finished){
            if(finished){
                //滚动至高亮Cell
                [data enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if(!*stop && [[obj valueForKey:@"hightLight"] boolValue]){
                        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx - 1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                        *stop = YES;
                    }
                }];
            }
        }];
    }];
}

//关闭弹出层For Data
- (void)HiddenData{
    [self HiddenData:nil];
}

- (void)HiddenData:(void(^)())completdBlock{
    UIView * uv_Panel = [self viewWithTag:03140];//弹出层总容器
    
    UIButton * btn_BG = (UIButton *)[self viewWithTag:13140];//背景
    
    UIButton * btn_ESC = (UIButton *)[self viewWithTag:23140];//取消按钮
    
    TableView_HUD * tableView = (TableView_HUD *)[self viewWithTag:23141];//数据TableView
    
    [UIView animateWithDuration:0.3 animations:^(void){
        btn_BG.alpha = 0;
        
        CGRect rect = tableView.frame;
        rect.origin.y = [UIScreen mainScreen].bounds.size.height;
        tableView.frame = rect;
        
        rect = btn_ESC.frame;
        rect.origin.y = [UIScreen mainScreen].bounds.size.height + tableView.frame.size.height + 8;
        btn_ESC.frame = rect;
    } completion:^(BOOL finished){
        if(finished){
            [uv_Panel removeFromSuperview];
            
            if(completdBlock){//动画执行完毕，调用回调方法
                completdBlock();
            }
        }
    }];
}

@end
