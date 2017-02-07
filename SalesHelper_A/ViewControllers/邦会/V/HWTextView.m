
//
//  HWTextView.m
//  HW_微博
//
//  Created by 胡伟 on 16/1/20.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import "HWTextView.h"

@interface HWTextView ()

@property (nonatomic,weak) UILabel *placeLabel;

@end

@implementation HWTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.alwaysBounceVertical = YES;
        UILabel *placeLabel = [UILabel new];
        placeLabel.backgroundColor = [UIColor clearColor];
        placeLabel.numberOfLines = 0;
        self.placeLabel = placeLabel;
        placeLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:placeLabel];
        self.font = [UIFont systemFontOfSize:14];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
               
    }
    return self;
    
    
    
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textDidChange];
}
- (void)setFont:(UIFont *)font
{
    
    [super setFont:font];
    self.placeLabel.font = font;
    [self setNeedsLayout];
    
}
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)textDidChange
{
    
    self.placeLabel.hidden = self.hasText;
    
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    
    [attributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, attributed.length)];
    
    
    
    [super setAttributedText:attributed];
    
    
    
    
    
    [self textDidChange];
    
}
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    
    self.placeLabel.text = placeholder;
    
    [self setNeedsLayout];
    
    
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    
    _placeholderColor = placeholderColor;
    self.placeLabel.textColor = placeholderColor;
    
    
    
}
- (void)layoutSubviews
{
  
    
    self.placeLabel.x = 5;
    self.placeLabel.y = 7;
    self.placeLabel.width = self.width - 2 * self.placeLabel.x;
    
    
    CGSize MaxSize = CGSizeMake(self.placeLabel.width, MAXFLOAT);
    
    NSDictionary *attr = @{
                           NSFontAttributeName : self.placeLabel.font
                           };
    CGRect rect = [self.placeLabel.text boundingRectWithSize:MaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
    self.placeLabel.height = rect.size.height;
    
    

    
}
@end
