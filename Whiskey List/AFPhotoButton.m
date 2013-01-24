//
//  AFPhotoButton.m
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-24.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFPhotoButton.h"

@implementation AFPhotoButton

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    return self;
}

-(UIImage *)photo
{
    return [[self imageView] image];
}

-(void)setPhoto:(UIImage *)photo
{
    [self setImage:photo forState:UIControlStateNormal];
    [self setImage:photo forState:UIControlStateDisabled];
    
    [self updateBorder];
}

-(void)updateBorder
{
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth = 5.0f;
    
    CGSize size = self.bounds.size;
    CGFloat curlFactor = 10.0f;
    CGFloat shadowDepth = 3.0f;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0f, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, size.height + shadowDepth)];
    [path addCurveToPoint:CGPointMake(0.0f, size.height + shadowDepth)
            controlPoint1:CGPointMake(size.width - curlFactor, size.height + shadowDepth - curlFactor)
            controlPoint2:CGPointMake(curlFactor, size.height + shadowDepth - curlFactor)];
    
    self.layer.shadowPath = [path CGPath];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowOffset = CGSizeMake(0, shadowDepth);
    self.layer.masksToBounds = NO;
    
    if (!self.photo && self.enabled)
    {
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0.0f;
        self.layer.shadowPath = nil;
        self.layer.shadowOpacity = 0.0f;
        self.layer.shadowOffset = CGSizeZero;
    }
    
    [self setNeedsDisplay];
}

-(void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    [self updateBorder];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.layer addAnimation:transition forKey:nil];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!self.photo)
    {
        if (self.enabled)
        {            
            UIFont *font = [UIFont boldSystemFontOfSize:15];
            NSString *text = @"add photo";
            CGRect textRect = CGRectInset(self.bounds, 10, 24);
            
            [[UIColor whiteColor] set];
            [text drawInRect:CGRectOffset(textRect, 0, 1) withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
            [[UIColor colorWithRed:50.0f/255.0f green:79.0f/255.0f blue:133.0f/255.0f alpha:1.0f] set];
            [text drawInRect:textRect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
            
            CGPathRef path = [[UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 5, 5) cornerRadius:3.0f] CGPath];
            
            CGContextSetLineJoin(context, kCGLineJoinRound);
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetLineWidth(context, 1);
            CGFloat lengths[] = {4.0f, 4.0f};
            CGContextSetLineDash(context, 0.0f, lengths, 2);
            CGContextSetAlpha(context, 1);
            
            [[UIColor darkGrayColor] setStroke];
            CGContextSetLineWidth(context, 2);
            CGContextAddPath(context, path);
            CGContextDrawPath(context, kCGPathStroke);
            
        }
        else
        {
            //TODO: missing photo image drawn here
            [[UIColor blueColor] set];
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectInset(self.bounds, 5, 5));
        }
    }
}

@end
