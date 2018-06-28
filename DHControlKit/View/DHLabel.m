//
//  DHLabel.m
//  DHControlKit
//
//  Created by daixinhui on 2018/5/2.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#import "DHLabel.h"
#include <CoreText/CoreText.h>

@interface DHLabel ()

@property (nonatomic, copy) NSMutableAttributedString *attributedString;

@end

@implementation DHLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureDefaults];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureDefaults];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configureDefaults];
}

- (void)configureDefaults
{
    self.backgroundColor = [UIColor whiteColor];
    self.fontSize = 17.0f;
    self.textColor = [UIColor blackColor];
    self.numberOfLines = 1;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    _attributedText = attributedText;
    self.attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    [self setNeedsDisplay];
}

- (void)setAttributedString:(NSMutableAttributedString *)attributedString
{
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.fontSize] range:[attributedString.string rangeofAll]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:self.textColor range:[attributedString.string rangeofAll]];
    _attributedString = attributedString;
}

//- (void)setFontSize:(CGFloat)fontSize
//{
//    _fontSize = fontSize;
//}
//
//- (void)setTextColor:(UIColor *)textColor
//{
//    _textColor = textColor;
//}


- (void)drawRect:(CGRect)rect
{
    if (self.text.length > 0 || self.attributedText.string.length > 0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, CGRectGetHeight(self.bounds));
        CGContextScaleCTM(context, 1.0f, -1.0f);
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, self.bounds);
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.attributedString.string.length), path, NULL);
        
        CFArrayRef lines = CTFrameGetLines(frame);
        
        DXHDINFO(@"-----%zd-----%@",CFArrayGetCount(lines),lines);
        
        
        CTFrameDraw(frame, context);
        CFRelease(frame);
        CFRelease(framesetter);
        CFRelease(path);
        
        
    }else{
        [super drawRect:rect];
    }
}

@end
