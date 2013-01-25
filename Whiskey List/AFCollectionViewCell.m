//
//  AFCollectionViewCell.m
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewCell.h"
#import "AFCollectionViewLayoutAttributes.h"

@interface AFCollectionViewCellSelectedView : UIView

@property (nonatomic, assign) BOOL selected;

@end

@implementation AFCollectionViewCell
{
    UILabel *nameLabel;
    UILabel *regionLabel;
    UIImageView *imageView;
    
    UIView *labelBackgroundView;
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    self.backgroundColor = [UIColor colorWithWhite:0.96f alpha:1.0f];

    AFCollectionViewCellSelectedView *selectedBackgroundView = [[AFCollectionViewCellSelectedView alloc] initWithFrame:CGRectZero];
    self.selectedBackgroundView = selectedBackgroundView;
    
//    self.backgroundView = [[AFCollectionViewCellSelectedView alloc] initWithFrame:CGRectZero];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor darkTextColor];
    nameLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:nameLabel];
    
    regionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    regionLabel.backgroundColor = [UIColor clearColor];
    regionLabel.textColor = [UIColor darkTextColor];
    regionLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:regionLabel];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.backgroundColor = [UIColor blueColor];
    [self.contentView insertSubview:imageView belowSubview:nameLabel];
    
    labelBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    labelBackgroundView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    [self.contentView insertSubview:labelBackgroundView belowSubview:nameLabel];
    
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 10.0f;
    
    return self;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    [self setName:@""];
    [self setImage:nil];
}

-(void)setName:(NSString *)name
{
    nameLabel.text = name;
}

-(void)setImage:(UIImage *)image
{
    if (!image)
    {
        imageView.image = [UIImage imageNamed:@"missing"];
    }
    else
    {
        imageView.image = image;
    }
}

-(void)setRegion:(NSString *)region
{
    regionLabel.text = region;
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    if (![layoutAttributes isKindOfClass:[AFCollectionViewLayoutAttributes class]]) return;
    
    AFCollectionViewLayoutAttributes *castedLayoutAttributes = (AFCollectionViewLayoutAttributes *)layoutAttributes;
    
    const CGFloat inset = 0.0f;
    const CGFloat textMargin = 10.0f;
    
    if (castedLayoutAttributes.layoutMode == AFCollectionViewLayoutAttributesLayoutModeGrid)
    {
        imageView.frame = CGRectInset(self.contentView.bounds, inset, inset);
        labelBackgroundView.alpha = 1.0f;
        nameLabel.frame = CGRectInset(CGRectMake(textMargin, CGRectGetHeight(self.contentView.bounds) - 40, CGRectGetWidth(self.contentView.bounds) - 2.0f*textMargin, 40), inset, inset);
        regionLabel.frame = CGRectInset(CGRectMake(textMargin, CGRectGetHeight(self.contentView.bounds) - 40, CGRectGetWidth(self.contentView.bounds) - 2.0f*textMargin, 40), inset, inset);
        regionLabel.alpha = 0.0f;
        labelBackgroundView.frame = CGRectInset(CGRectMake(0, CGRectGetHeight(self.contentView.bounds) - 40, CGRectGetWidth(self.contentView.bounds), 40), inset, inset);
    }
    else if (castedLayoutAttributes.layoutMode == AFCollectionViewLayoutAttributesLayoutModeList)
    {
        imageView.frame = CGRectMake(inset, inset, CGRectGetHeight(self.contentView.bounds) - inset*2.0f, CGRectGetHeight(self.contentView.bounds) - inset*2.0f);
        nameLabel.frame = CGRectMake(CGRectGetHeight(self.contentView.bounds) + textMargin, 5.0f, CGRectGetWidth(self.contentView.bounds) - CGRectGetHeight(self.contentView.bounds) - 2.0f*textMargin, 44);
        regionLabel.frame = CGRectMake(CGRectGetHeight(self.contentView.bounds) + textMargin, 45, CGRectGetWidth(self.contentView.bounds) - CGRectGetHeight(self.contentView.bounds) - 2.0f*textMargin, 44);
        regionLabel.alpha = 1.0f;
        labelBackgroundView.alpha = 0.0f;
        labelBackgroundView.frame = CGRectMake(CGRectGetHeight(self.contentView.bounds), inset, CGRectGetWidth(self.contentView.bounds) - CGRectGetHeight(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds) - inset*2.0f);
    }
}

@end

@implementation AFCollectionViewCellSelectedView

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGRect drawRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
//    CGContextSetRGBFillColor(context, 3.0f/255.0f, 121.0f/255.0f, 239.0f/255.0f, self.selected ? 0.5f : 1.0f);
    CGContextSetRGBFillColor(context, 100.0f/255.0f, 140.0f/255.0f, 200.0f/255.0f, 1.0f);
    
    CGContextFillRect(context, drawRect);
    
    // Create a gradient from white to black
    CGFloat colors [] = {
        1.0, 1.0, 1.0, 0.3,
        0.0, 0.0, 0.0, 0.3
    };
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGContextSetBlendMode(context, kCGBlendModeOverlay);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    
    CGContextRestoreGState(context);
}

@end
