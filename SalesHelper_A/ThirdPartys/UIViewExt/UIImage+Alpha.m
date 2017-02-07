//
//  UIImage+Alpha.m
//  SalesHelper_A
//
//  Created by summer on 15/8/1.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "UIImage+Alpha.h"

@implementation UIImage (Alpha)
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageByApplyingAlpha:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, 0.6);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)creatQRFromString:(NSString *)string withIconImage:(NSString *)QRIconImageName
{
    NSData * stringData = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
    CIFilter * cifilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [cifilter setValue:stringData forKey:@"inputMessage"];
    [cifilter setValue:@"H" forKey:@"inputCorrectionLevel"];
//    CIImage * qrCIImage = cifilter.outputImage;
//    CIFilter * colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
//    [colorFilter setDefaults];
//    [colorFilter setValue:qrCIImage forKey:@"inputImage"];
//    [colorFilter setValue:[CIColor colorWithRed:0 green:0 blue:0] forKey:@"inputColor0"];
//    [colorFilter setValue:[CIColor colorWithRed:1 green:1 blue:1] forKey:@"inputColor1"];
    CIImage * colorImage =  [cifilter.outputImage imageByApplyingTransform:CGAffineTransformMakeScale(50, 50)];
    UIImage * codeImage = [UIImage imageWithCIImage:colorImage];
    if (QRIconImageName) {
        UIImage * iconImage = [UIImage imageNamed:QRIconImageName];
        CGRect rect = CGRectMake(0, 0, codeImage.size.width, codeImage.size.height);
        UIGraphicsBeginImageContext(rect.size);
        [codeImage drawInRect:rect];
        CGSize  avatarSize = CGSizeMake(rect.size.width * 0.25, rect.size.height * 0.25);
        CGFloat x = (rect.size.width - avatarSize.width) * 0.5;
        CGFloat y = (rect.size.height - avatarSize.height) * 0.5;
        [iconImage drawInRect:CGRectMake(x, y, avatarSize.width, avatarSize.height)];
        UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        codeImage = resultImage;
    }
    return codeImage;
}

@end
