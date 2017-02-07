//
//  ExcelLabelsStyle.h
//  SalesHelper_A
//
//  Created by Reconcilie on 14/10/19.
//  Copyright (c) 2014年 zhipu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExcelLabelsStyleDelegate <NSObject>

-(void)labelViewDidSelectedItem:(NSInteger)index WithTag:(NSInteger)tag;

@end

typedef NS_ENUM(NSInteger, KRecommendType){
    KRecommendSuccess=1,
    KRecommendFail=2,
};

@interface ExcelLabelsStyle : UIView {
    NSArray *columnsWidths;
    KRecommendType recommendType;
    uint numRows;
    uint dy;
}

@property (nonatomic,assign)id<ExcelLabelsStyleDelegate>delegate;

- (id)initWithFrame:(CGRect)frame andColumnsWidths:(NSArray*)columns WithType:(KRecommendType)type;
- (void)setColumnsWidths:(NSArray*)columns WithType:(KRecommendType)type;
- (void)addRecord:(NSArray*)record BackgroudColor:(UIColor *)color;
@end