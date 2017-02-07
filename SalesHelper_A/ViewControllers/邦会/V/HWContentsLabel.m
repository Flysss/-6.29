//
//  HWContentsLabel.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/22.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWContentsLabel.h"
#import "HWLink.h"
#import "UIColor+HexColor.h"
#import "HWContentsTextView.h"
#define HWLinkBGColorTag 100
@interface HWContentsLabel ()<UITextFieldDelegate>

@property (nonatomic,weak) HWContentsTextView *textView;
@property (nonatomic,strong) NSArray *links;
@property (nonatomic, assign)BOOL istouch;

@end

@implementation HWContentsLabel

- (NSArray *)links
{
    if (!_links) {
        NSMutableArray *links = [NSMutableArray array];
        
        [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            NSString *linkText = attrs[HWLinkText];
            if (linkText == nil)
            {
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
                [self addGestureRecognizer:longPress];
                _istouch = YES;
            }

                HWLink *link = [[HWLink  alloc] init];
                link.text = linkText;
                
                
                NSMutableArray *rects = [NSMutableArray array];
                self.textView.selectedRange = range;
                NSArray *selectionRects = [self.textView selectionRectsForRange:self.textView.selectedTextRange];
                
                for (UITextSelectionRect *selectionRect in selectionRects) {
                    if (selectionRect.rect.size.width == 0 || selectionRect.rect.size.height == 0) continue;
                    
                    
                    [rects addObject:selectionRect];
                    
                }
                
                link.rects = rects;
                
                [links addObject:link];
//            }
            
        }];
        
        
        self.links = links;
        
    }
    
    
    return _links;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        HWContentsTextView *textView = [[HWContentsTextView alloc] init];
        textView.scrollEnabled = NO;
        textView.editable = NO;
        textView.userInteractionEnabled = NO;
        textView.backgroundColor = [UIColor clearColor];
        textView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5 );
        [self addSubview:textView];
        self.textView = textView;
        
//        UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//        self.userInteractionEnabled = YES;
//        [self addGestureRecognizer:touch];
    }
    return self;
    
    
}
//文字复制
-(void)longPress:(UILongPressGestureRecognizer *) recognizer

{

    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        
        UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copy:)];
        
        [[UIMenuController sharedMenuController] setMenuItems:@[copyLink]];
        
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
    
    
}
- (void)copy:(id)sender
{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    pboard.string = self.attributedText.string;
    
}
-(BOOL)canBecomeFirstResponder

{
    
    return YES;
    
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender

{
    
    return (action == @selector(copy:));
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    HWLink *touchLink = [self touchLinkWithPoint:point];
    
    
    [self showLinkBackgroudColor:touchLink];
    
    
    
}

- (void)showLinkBackgroudColor:(HWLink *)touchLink
{
    
    for (UITextSelectionRect *selectionRect in touchLink.rects) {
        UIView *view = [[UIView alloc] init];
        view.tag = HWLinkBGColorTag;
        view.frame = selectionRect.rect;
        if (_istouch == NO) {
            view.backgroundColor = [UIColor colorWithHexString:@"bedfff"];
        }
        [self insertSubview:view atIndex:0];
        
        
        
    }
    
    
    
}

- (HWLink *)touchLinkWithPoint:(CGPoint)point
{
    
    __block HWLink *touchLink = nil;
    [self.links enumerateObjectsUsingBlock:^(HWLink *link, NSUInteger idx, BOOL * _Nonnull stop) {
        
        for (UITextSelectionRect *selectionRect in link.rects) {
            if (CGRectContainsPoint(selectionRect.rect, point)) {
                
                touchLink = link;
                *stop = YES;
            }
        }
        
        
        
    }];
    return touchLink;
    
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    HWLink *touchLink = [self touchLinkWithPoint:point];
    
    HWLog(@"---%@",touchLink);
    
        if (touchLink.text != nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:HWLinkDidClickNotification object:nil userInfo:@{HWLinkText : touchLink.text,HWLabelself : self}];
            
    }
    
    
    
    
    
    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self removeLinkBgColor];
        
    });
    
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self removeLinkBgColor];
        
    });
    
    
}

- (void)removeLinkBgColor
{
    //  UIView *bgView = [self viewWithTag:HWLinkBGColorTag];
    //
    //    [bgView removeFromSuperview];
    //
    
    for (UIView *childView in self.subviews) {
        
        if (childView.tag == HWLinkBGColorTag) {
            
            [childView removeFromSuperview];
        }
        
    }
    
}
- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    self.textView.frame = self.bounds;
    
}
- (void)setAttributedText:(NSAttributedString *)attributedText
{
    _attributedText = attributedText;
    
    
    self.textView.attributedText = attributedText;
    
    self.links = nil;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    if ([self touchLinkWithPoint:point]) {
//
//        return self;
//
//    }
//
//    return nil;
//}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self touchLinkWithPoint:point]) {
        
        return YES;
        
    }
    
    return NO;
    
    
    
}


@end
