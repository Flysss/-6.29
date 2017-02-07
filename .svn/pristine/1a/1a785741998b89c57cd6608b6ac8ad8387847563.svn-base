//
//  BHPingLunCell.m
//  SalesHelper_A
//
//  Created by 曾杰 on 16/3/10.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHPingLunCell.h"
#import "UIColor+HexColor.h"

@implementation BHPingLunCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.viewBac = [[UIView alloc]init];
        self.viewBac.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
        [self.contentView addSubview:self.viewBac];
        
        self.imgBac = [[UIImageView alloc]init];
        self.imgBac.image =[[UIImage imageNamed:@"liuyankuang_"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        [self.contentView addSubview:self.imgBac];
        
        self.bodyLabel = [[UILabel alloc]init];
        self.bodyLabel.numberOfLines = 0;
        self.bodyLabel.font = [UIFont systemFontOfSize:12];
        self.bodyLabel.textColor = [UIColor colorWithHexString:@"676767"];
        self.bodyLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *longPress = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(delegateHuiFu:)];
        [self.bodyLabel addGestureRecognizer:longPress];
        self.bodyLabel.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
        [self.contentView addSubview:self.bodyLabel];
        
        
        
    }
    return self;
}
- (void)cellForModel:(HWGongGaoChildModel *)model
{
    _hwmodel=model;
    
    NSString *str = nil;
    self.imgBac.hidden = YES;
    self.viewBac.hidden = YES;
    if (model.Hname != nil )
    {
        NSString *name = model.name;
        NSString *Hname = model.Hname;
        
        str =  [NSString stringWithFormat:@"%@ 回复 %@:%@",name,Hname,model.contents];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"00aff0"] range:[str rangeOfString:name]];
        
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"00aff0"] range:[str rangeOfString:Hname]];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attr.length)];
        
        self.bodyLabel.attributedText = [self emojiMatching:attr];

        if (_index == 0) {
            self.imgBac.hidden = NO;
            self.bodyLabel.frame = CGRectMake(62+5, 8, SCREEN_WIDTH-124-10+20, [BHPingLunCell heightForString:str fontSize:12]);
            self.imgBac.frame = CGRectMake(62, 0, SCREEN_WIDTH-124+20, [BHPingLunCell heightForString:str fontSize:12]+10+2);
        }
        else
        {
            self.viewBac.hidden = NO;
            self.viewBac.frame = CGRectMake(62, 0, SCREEN_WIDTH-124+20, [BHPingLunCell heightForString:str fontSize:12]+5);
            self.bodyLabel.frame = CGRectMake(62+5, 1, SCREEN_WIDTH-124-10+20, [BHPingLunCell heightForString:str fontSize:12]);
        }
    }
    else
    {
        NSString *name = model.name;
        
        str = [NSString stringWithFormat:@"%@:%@",name,model.contents];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"00aff0"] range:[str rangeOfString:name]];
        self.bodyLabel.attributedText = [self emojiMatching:attr];
        if (_index == 0) {
            self.imgBac.hidden = NO;
            self.bodyLabel.frame = CGRectMake(62+5, 8, SCREEN_WIDTH-124-10+20, [BHPingLunCell heightForString:str fontSize:12]);
            self.imgBac.frame = CGRectMake(62, 0, SCREEN_WIDTH-124+20, [BHPingLunCell heightForString:str fontSize:12]+10+2);
        }
        else
        {
            self.viewBac.hidden = NO;
            self.viewBac.frame = CGRectMake(62, 0, SCREEN_WIDTH-124+20, [BHPingLunCell heightForString:str fontSize:12]+5);
            self.bodyLabel.frame = CGRectMake(62+5, 1, SCREEN_WIDTH-124-10+20, [BHPingLunCell heightForString:str fontSize:12]);
        }

    }
}
#pragma mark-自适应高度
+ (CGFloat)heightForString:(NSString *)str fontSize:(NSInteger)fontSize
{
    if (str == nil) {
        return 0;
    }
    else
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
        CGRect bound = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-124-10+20, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        return bound.size.height;
    }
}
+ (CGFloat)heightForAttrString:(NSAttributedString *)attr{
    
    if (attr == nil) return 0;
    
    return [attr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 124-10+20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    
}

- (void)delegateHuiFu:(UITapGestureRecognizer *)longPress
{
    if ([self.loginuid isEqualToString:_hwmodel.uid]) {
            [self becomeFirstResponder];

            UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(dele:)];
            
            [[UIMenuController sharedMenuController] setMenuItems:@[copyLink]];
            
            [[UIMenuController sharedMenuController] setTargetRect:self.bodyLabel.frame inView:self.contentView];
            
            [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        }
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(dele:) ){
        return YES;
    }
    return NO;
}
- (void)dele:(UIMenuItem *)item
{
    if (_delegate && [_delegate respondsToSelector:@selector(removeHuiFu:)])
    {
        [_delegate removeHuiFu:self];
    }
}



- (NSMutableAttributedString *)emojiMatching:(NSMutableAttributedString *)attributedText
{
    
    //加载plist文件中的数据
    NSBundle *bundle = [NSBundle mainBundle];
    //寻找资源的路径
    NSString *path = [bundle pathForResource:@"HWemoji1" ofType:@"plist"];
    //获取plist中的数据
    NSArray *face = [[NSArray alloc] initWithContentsOfFile:path];
    
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
    }
    //    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:str];
    //通过正则表达式来匹配字符串
    NSArray *resultArray = [re matchesInString:attributedText.string options:0 range:NSMakeRange(0, attributedText.length)];
    
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        
        //获取原字符串中对应的值
        NSString *subStr = [attributedText.string substringWithRange:range];
        
        for (int i = 0; i < face.count; i ++)
        {
            if ([face[i][@"chs"] isEqualToString:subStr])
            {
                
                //face[i][@"gif"]就是我们要加载的图片
                //新建文字附件来存放我们的图片
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                
                //给附件添加图片
                textAttachment.image = [UIImage imageNamed:face[i][@"png"]];
                textAttachment.bounds = CGRectMake(0, -3, [UIFont systemFontOfSize:13].lineHeight, [UIFont systemFontOfSize:13].lineHeight);
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                
                //把字典存入数组中
                [imageArray addObject:imageDic];
                
            }
        }
    }
    //从后往前替换
    for (NSInteger j = imageArray.count -1; j >= 0; j--)
    {
        NSRange range;
        [imageArray[j][@"range"] getValue:&range];
        //进行替换
        [attributedText replaceCharactersInRange:range withAttributedString:imageArray[j][@"image"]];
        
    }
    return attributedText;
}
@end
