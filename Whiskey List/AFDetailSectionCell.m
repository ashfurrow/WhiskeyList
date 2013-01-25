//
//  AFDetailSectionCell.m
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-25.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFDetailSectionCell.h"

@implementation AFDetailSectionCell
{
    UITextView *textView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:textView];
    
    return self;
}

-(void)setDetailText:(NSString *)detailText
{
    textView.text = detailText;
}

-(NSString *)detailText
{
    return textView.text;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (self.editing)
    {
        textView.userInteractionEnabled = YES;
    }
    else
    {
        textView.userInteractionEnabled = NO;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.clipsToBounds = NO;
    self.contentView.clipsToBounds = NO;
    
    textView.bounds = self.contentView.bounds;
    textView.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds) + 2.0f);
    textView.frame = CGRectIntegral(textView.frame);
}

@end
