//
//  ZJDetailReplyHeaderView.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/26.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJDetailReplyHeaderView.h"
#import "UIColor+HexColor.h"
#import "BHPingLunModel.h"

@implementation ZJDetailReplyHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.headImage = [[UIImageView alloc]init];
        self.headImage.layer.cornerRadius = 20;
        self.headImage.layer.masksToBounds = YES;
        [self addSubview:self.headImage];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"676767"];
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textColor = [UIColor colorWithHexString:@"c8c8c8"];
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.timeLabel];
        
        self.deletButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self addSubview:self.deletButton];
        
        self.bodyLabel = [[UILabel alloc]init];
        self.bodyLabel.numberOfLines = 0;
        self.bodyLabel.textColor = [UIColor colorWithHexString:@"676767"];
        self.bodyLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.bodyLabel];
        
        self.btnZan = [[UIButton alloc] init];
        [self.btnZan addTarget:self action:@selector(zanAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self.btnZan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
        self.btnZan.titleLabel.font = [UIFont systemFontOfSize:13];
        self.btnZan.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self.btnZan setTitleColor:[UIColor colorWithHexString:@"c8c8c8"] forState:(UIControlStateNormal)];
        [self addSubview:self.btnZan];
        
        self.lblLine = [[UILabel alloc]init];
        self.lblLine.backgroundColor = [UIColor colorWithHexString:@"dadadc"];
        [self addSubview:self.lblLine];
    }
    return self;
}



- (void)setModel:(BHPingLunModel *)model
{
    _model = model;
    self.headImage.frame = CGRectMake(12, 6, 40, 40);
   
    
    self.nameLabel.frame =CGRectMake(62, 6, SCREEN_WIDTH-62, 20);
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:10] forKey:NSFontAttributeName];
    CGFloat timeW = [model.addtime boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.width;
    
    self.timeLabel.frame = CGRectMake(62, CGRectGetMaxY(self.nameLabel.frame)+3, timeW, 15);
   
    self.btnZan.height = 15;
    self.btnZan.width = 60;
    
    self.btnZan.x = SCREEN_WIDTH - self.btnZan.width - 20;
    self.btnZan.y = CGRectGetMinY(self.timeLabel.frame);
    [self btnstate:model.dz_num];
    if (model.is_praise != nil)
    {
        [self btnstate:model.dz_num];
        [self.btnZan setImage:[UIImage imageNamed:@"点赞之后"] forState:(UIControlStateNormal)];
        self.btnZan.selected = YES;
    }
    else
    {
        [self btnstate:model.dz_num];
        [self.btnZan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
        self.btnZan.selected = NO;
    }

    self.deletButton.frame = CGRectMake(CGRectGetMaxX(self.timeLabel.frame), CGRectGetMinY(self.timeLabel.frame), 50, 15);
    self.deletButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.deletButton setTitle:@"删除" forState:(UIControlStateNormal)];
    [self.deletButton setTitleColor:[UIColor colorWithHexString:@"00aff0"] forState:(UIControlStateNormal)];
    [self.deletButton addTarget:self action:@selector(deletReply) forControlEvents:(UIControlEventTouchUpInside)];
    self.deletButton.hidden = YES;
    if ([model.uid isEqualToString:_loginuid])
    {
        self.deletButton.hidden = NO;
    }

    
    CGFloat height = [model.contents boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-92, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
    self.bodyLabel.frame = CGRectMake(62, CGRectGetMaxY(self.timeLabel.frame)+5, SCREEN_WIDTH-92, height);
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.iconpath] placeholderImage:[UIImage imageNamed:@"默认个人图像"]];
    self.nameLabel.text = model.name;
    self.timeLabel.text = model.addtime;
    self.bodyLabel.attributedText = [self emojiMatching:model.contents];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HuiPingLun)];
    [self addGestureRecognizer:tap];
    
    _viewHeight = CGRectGetMaxY(self.bodyLabel.frame)+5;
    
}


- (void)btnstate:(NSInteger)count
{
    if (count > 10000)
    {
        [self.btnZan setTitle:[NSString stringWithFormat:@"%.1f万",(long)count/10000.0] forState:(UIControlStateNormal)];
    }
    else if (count == 0)
    {
        [self.btnZan setTitle:@"赞" forState:(UIControlStateNormal)];
    }
    else
    {
        [self.btnZan setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:(UIControlStateNormal)];
    }
    
}

- (void)deletReply
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickDeletReplyAction:)]) {
        [_delegate clickDeletReplyAction:self];
    }
}

- (void)HuiPingLun
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapSendReplyAction:)]) {
        [_delegate tapSendReplyAction:self];
    }
}
- (void)zanAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickZanReplyAction:)]) {
        [_delegate clickZanReplyAction:self];
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
