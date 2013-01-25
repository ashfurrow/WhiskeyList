//
//  AFNameSectionCell.m
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-22.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFNameSectionCell.h"

@implementation AFNameSectionCell
{
    UITextField *textField;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
 
    textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.font = [UIFont boldSystemFontOfSize:17];
    [self.contentView addSubview:textField];
    
    [self setTextFieldPlaceholder:@""];
    [self setTextFieldText:@""];
    
    return self;
}

-(void)setEnableTextField:(BOOL)enableTextField
{
    _enableTextField = enableTextField;
    
    if (enableTextField)
    {
        textField.userInteractionEnabled = YES;
    }
    else
    {
        textField.userInteractionEnabled = NO;
    }
}

-(BOOL)becomeFirstResponder
{
    return [textField becomeFirstResponder];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing)
    {
        [textField setEnabled:YES];
    }
    else
    {
        [textField setEnabled:NO];
    }
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    [self setTextFieldPlaceholder:@""];
    [self setTextFieldText:@""];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect originalFrame = self.frame;
    CGSize offset = CGSizeMake(100, 0);
    
    CGFloat newX = offset.width;
    CGFloat newWidth = 320 - offset.width;
    
    CGRect newFrame = CGRectMake(newX, originalFrame.origin.y, newWidth, originalFrame.size.height);
    self.frame = newFrame;
    
    textField.frame = CGRectInset(self.bounds, 10, 10);
}

#pragma mark - Overridden properties

-(void)setTextFieldText:(NSString *)text
{
    [textField setText:text];
}

-(void)setTextFieldPlaceholder:(NSString *)text
{
    [textField setPlaceholder:text];
}

-(NSString *)textFieldText
{
    return [textField text];
}

-(NSString *)textFieldPlaceholder
{
    return [textField placeholder];
}

@end
