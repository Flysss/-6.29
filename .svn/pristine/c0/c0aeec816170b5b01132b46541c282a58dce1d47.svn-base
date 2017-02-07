//
//  ZJForwardView.m
//  SalesHelper_A
//
//  Created by zhipu on 16/6/15.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJForwardView.h"

#import "UIColor+HexColor.h"

@implementation ZJForwardView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imgForward = [[UIImageView alloc]init];
        self.imgForward.contentMode = UIViewContentModeScaleAspectFill;
        self.imgForward.clipsToBounds = YES;
        [self addSubview:self.imgForward];
        
        self.lblForwardName = [[UILabel alloc]init];
        self.lblForwardName.textColor = [UIColor colorWithHexString:@"00aff0"];
        self.lblForwardName.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.lblForwardName];
        
        self.lblForwardContent = [[UILabel alloc]init];
        self.lblForwardContent.font = [UIFont systemFontOfSize:14];
        self.lblForwardContent.numberOfLines = 2;
        self.lblForwardContent.textColor = [UIColor colorWithHexString:@"696969"];
        [self addSubview:self.lblForwardContent];
        
        self.lblForwardTopic = [[UILabel alloc]init];
        self.lblForwardTopic.font = [UIFont systemFontOfSize:14];
        self.lblForwardTopic.textColor = [UIColor colorWithHexString:@"00aff0"];
        [self addSubview:self.lblForwardTopic];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpAction:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    self.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    
    CGFloat X = 0;
    
    [self.imgForward sd_setImageWithURL:[NSURL URLWithString:dic[@"imgpath"]]];
    
    
    if ([dic[@"name"] isKindOfClass:[NSString class]]) {
        self.lblForwardName.text = [NSString stringWithFormat:@"%@",dic[@"name"]];

    }
    
    
    
    if (dic[@"contents"])
    {
        
        self.lblForwardContent.attributedText = [self emojiMatching:dic[@"contents"]] ;
    }
    
    
    if (dic[@"topic"] && ![dic[@"topic"] isKindOfClass:[NSNull class]])
    {
        NSString *topicStr = [NSString stringWithFormat:@"#%@#",dic[@"topic"]];
        NSString *str = [NSString stringWithFormat:@"%@%@",topicStr,dic[@"contents"]];
        
        NSMutableAttributedString *attributedString = [self emojiMatching:str];
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"00aff0"] range:NSMakeRange(0, topicStr.length)];
        self.lblForwardContent.attributedText = attributedString;
    }
    
    

    
        if (![dic[@"imgpath"] isEqualToString:@""])
        {
            self.imgForward.hidden = NO;
            self.imgForward.frame = CGRectMake(0, 0, self.height, self.height);
            X += self.height;
        }
        else
        {
            
            self.imgForward.hidden = YES;

        }
    
    self.lblForwardName.frame = CGRectMake(X+10, 5, self.width-X-10, 13);
    
    self.lblForwardContent.frame = CGRectMake(X+10, CGRectGetMaxY(self.lblForwardName.frame)+3, self.width-X-10, 36);
    _forward_id = dic[@"id"];
}


+ (CGRect)sizeWithString:(NSString *)str size:(CGSize)size font:(int)font
{
    CGRect bound = [str boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:@(font)} context:nil];
    return bound;
}
- (void)jumpAction:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(ZJForwardViewClickJumpAction:)]) {
        [_delegate ZJForwardViewClickJumpAction:self];
    }
}

- (NSMutableAttributedString *)emojiMatching:(NSString *)str
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
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:str];
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
                textAttachment.bounds = CGRectMake(0, -3, [UIFont systemFontOfSize:14].lineHeight, [UIFont systemFontOfSize:14].lineHeight);
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
