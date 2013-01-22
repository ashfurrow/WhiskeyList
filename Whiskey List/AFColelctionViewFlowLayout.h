//
//  AFColelctionViewFlowLayout.h
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFCollectionViewLayoutAttributes.h"

#define kMaxGridItemDimension   140
#define kMaxGridItemSize        CGSizeMake(kMaxGridItemDimension, kMaxGridItemDimension)

#define kMaxListItemSize        CGSizeMake(300, 100)

@interface AFColelctionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) AFCollectionViewLayoutAttributesLayoutMode layoutMode;

@end
