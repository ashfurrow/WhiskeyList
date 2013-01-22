//
//  AFCollectionViewCell.m
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewCell.h"
#import "AFCollectionViewLayoutAttributes.h"

@implementation AFCollectionViewCell
{
    UILabel *nameLabel;
    UIImageView *imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    self.backgroundColor = [UIColor grayColor];

    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedBackgroundView.backgroundColor = [UIColor orangeColor];
    self.selectedBackgroundView = selectedBackgroundView;
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:nameLabel];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.backgroundColor = [UIColor blueColor];
    [self.contentView insertSubview:imageView belowSubview:nameLabel];
    
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
    imageView.image = image;
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    if (![layoutAttributes isKindOfClass:[AFCollectionViewLayoutAttributes class]]) return;
    
    AFCollectionViewLayoutAttributes *castedLayoutAttributes = (AFCollectionViewLayoutAttributes *)layoutAttributes;
    
    if (castedLayoutAttributes.layoutMode == AFCollectionViewLayoutAttributesLayoutModeGrid)
    {
        imageView.frame = CGRectInset(self.contentView.bounds, 5, 5);
        nameLabel.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.4f];
        nameLabel.frame = CGRectInset(CGRectMake(0, CGRectGetHeight(self.contentView.bounds) - 40, CGRectGetWidth(self.contentView.bounds), 40), 5, 5);
    }
    else if (castedLayoutAttributes.layoutMode == AFCollectionViewLayoutAttributesLayoutModeList)
    {
        imageView.frame = CGRectMake(5, 5, CGRectGetHeight(self.contentView.bounds) - 10, CGRectGetHeight(self.contentView.bounds) - 10);
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.frame = CGRectMake(CGRectGetHeight(self.contentView.bounds), 5, CGRectGetWidth(self.contentView.bounds) - CGRectGetHeight(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds) - 10);
    }
}

@end
