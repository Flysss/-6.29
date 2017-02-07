//
//  ExcelLabelsStyle.m
//  SalesHelper_A
//
//  Created by Reconcilie on 14/10/19.
//  Copyright (c) 2014年 zhipu. All rights reserved.
//

#import "ExcelLabelsStyle.h"

@implementation ExcelLabelsStyle


- (id)initWithFrame:(CGRect)frame andColumnsWidths:(NSArray*)columns WithType:(KRecommendType)type{
    self = [super initWithFrame:frame];
    if (self) {
        [self setColumnsWidths:columns WithType:type];
    }
    return self;
}

- (void)setColumnsWidths:(NSArray*)columns WithType:(KRecommendType)type{
    numRows = 0;
    self->columnsWidths = columns;
    self->dy = 0;
    self->numRows = 0;
    self->recommendType = type;
}


- (void)addRecord:(NSArray*)record BackgroudColor:(UIColor *)color {
    if(record.count == 0){
//        NSLog(@"!!! Number of items does not match number of columns. !!!");
        return;
    }
    
    uint rowHeight = 35;
	uint dx = 0;
	
    NSMutableArray* labels = [[NSMutableArray alloc] init];
    
	//CREATE THE ITEMS/COLUMNS OF THE ROW
    for(uint i=0; i<record.count; i++){
        float colWidth;
        if (record.count == 1) {
            colWidth = self.frame.size.width-2;	//colwidth as given at setup
        }else{
            colWidth = [[self->columnsWidths objectAtIndex:i] floatValue];	//colwidth as given at setup
        }

        CGRect rect = CGRectMake(dx, dy, colWidth, rowHeight);
		
		//ADJUST X FOR BORDER OVERLAPPING BETWEEN COLUMNS
		if(i>0){
			rect.origin.x -= i;
		}
        
        //--------------------------------------------
        
        UILabel* col1 = [[UILabel alloc] init];
        [col1.layer setBorderColor:[[UIColor colorWithWhite:0.821 alpha:1.000] CGColor]];
        [col1.layer setBorderWidth:1.0];
        col1.font = Default_Font_15;
        col1.textColor = RGBCOLOR(147, 147, 147);
        col1.tag = self->numRows+100;
        if ((i == record.count-1)&&i>0) {
            if (recommendType == KRecommendSuccess) {
                col1.textColor = RGBACOLOR(25, 182, 248, 1);
            }else {
                col1.textColor = RGBACOLOR(245, 32, 45, 1);
            }
            
            UITapGestureRecognizer *tap = [[ UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClickAction:)];
            col1.userInteractionEnabled = YES;
            [col1 addGestureRecognizer:tap];
        }
        
		col1.frame = rect;
        
		
		//SET LEFT RIGHT MARGINS & ALIGNMENT FOR THE LABEL
		NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		style.alignment = NSTextAlignmentCenter;
		style.headIndent = 10;
		style.firstLineHeadIndent = 5.0;
		style.tailIndent = -10.0;
		
		
		//SPECIAL TREATMENT FOR THE FIRST ROW
        if(self->numRows == 0){
            style.alignment = NSTextAlignmentCenter;
            col1.backgroundColor = color;
            //[UIColor colorWithRed:255/255.0 green:244/255.0 blue:226/255.0 alpha:1];
            if (recommendType == KRecommendSuccess) {
                col1.textColor = RGBACOLOR(245, 32, 45, 1);
            }else {
                col1.textColor = RGBACOLOR(133, 133, 133, 1);
            }
            col1.font = [UIFont systemFontOfSize:18];
        }
		
		
		NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[record objectAtIndex:i] attributes:@{ NSParagraphStyleAttributeName : style}];
		
		
        col1.lineBreakMode = NSLineBreakByCharWrapping;
        col1.numberOfLines = 0;
		col1.attributedText = attrText;
//        if ((i == record.count-1) && i>0) {
//            col1.attributedText = [self addUnderlineWithString:[record objectAtIndex:i] WithAttributes:@{ NSParagraphStyleAttributeName : style}];
//        }
		[col1 sizeToFit];
        
		
		//USED TO FIND HEIGHT OF LONGEST LABEL
        CGFloat h = col1.frame.size.height + 10;
        if(h > rowHeight){
            rowHeight = h;
        }
        
		//MAKE THE LABEL WIDTH SAME AS COLUMN'S WIDTH
		rect.size.width = colWidth;
        col1.frame = rect;
        
        [labels addObject:col1];
		
		//USED FOR SETTING THE NEXT COLUMN X POSITION
		dx += colWidth;
    }
    
    
	//MAKE ALL THE LABELS OF SAME HEIGHT AND THEN ADD TO VIEW
    for(uint i=0; i<labels.count; i++){
        UILabel* tempLabel = (UILabel*)[labels objectAtIndex:i];
        CGRect tempRect = tempLabel.frame;
        tempRect.size.height = rowHeight;
		tempLabel.frame = tempRect;
        [self addSubview:tempLabel];
    }
	
    self->numRows++;
	
	
	//ADJUST y FOR BORDER OVERLAPPING BETWEEN ROWS
	self->dy += rowHeight-1;
	
	
	//RESIZE THE MAIN VIEW TO FIT THE ROWS
	CGRect tempRect = self.frame;
	tempRect.size.height = dy;
	self.frame = tempRect;
}


-(void)labelClickAction:(UITapGestureRecognizer *)sender
{
    [self.delegate labelViewDidSelectedItem:sender.view.tag-100 WithTag:self.tag];
}

-(NSMutableAttributedString *)addUnderlineWithString:(NSString *)string WithAttributes:style
{
    //CREAT UNDER LINE WITH STRING
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string attributes:style];
    NSRange attributedRange = {0,[attributedString length]};
    
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:attributedRange];
    return attributedString;
}

@end
