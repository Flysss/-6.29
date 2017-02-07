//
//  HWHistoryTool.m
//  卷皮折扣
//
//  Created by 胡伟 on 16/2/17.
//  Copyright © 2016年 胡伟. All rights reserved.
//    存储搜索历史数据-----------------------------------------------

#import "HWHistoryTool.h"


#define HWSearchHistroyPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"search_history.plist"]
@interface HWHistoryTool ()

@property (nonatomic,strong) NSMutableArray *tempArray;
@end

@implementation HWHistoryTool
SingletonM(HistoryTool)

- (NSMutableArray *)tempArray
{
    if (!_tempArray) {
    
        _tempArray = [NSMutableArray arrayWithContentsOfFile:HWSearchHistroyPath];
        
        if (!_tempArray) {
            _tempArray = [NSMutableArray array];
            
        }
        
    }
    
    return _tempArray;
    
}

- (void)saveHistory:(NSString *)searchHistory
{
    if (searchHistory == nil) return;
    

    [self.tempArray removeObject:searchHistory];
    [self.tempArray insertObject:searchHistory atIndex:0];
    
    [self.tempArray writeToFile:HWSearchHistroyPath atomically:YES];
    
    
    
    
}
- (NSArray *)historyArray
{
    
    return self.tempArray;
    
}

- (void)removeHistoryArray
{
    [self.tempArray removeAllObjects];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:HWSearchHistroyPath error:nil];
    
    
}
@end
