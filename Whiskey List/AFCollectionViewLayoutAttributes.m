//
//  AFCollectionViewLayoutAttributes.m
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewLayoutAttributes.h"

NSString * const AFCollectionViewLayoutModeKey = @"AFCollectionViewLayoutModeKey";

@implementation AFCollectionViewLayoutAttributes

-(id)copyWithZone:(NSZone *)zone
{
    AFCollectionViewLayoutAttributes *attributes = [super copyWithZone:zone];
    
    attributes.layoutMode = self.layoutMode;
    
    return attributes;
}

@end
