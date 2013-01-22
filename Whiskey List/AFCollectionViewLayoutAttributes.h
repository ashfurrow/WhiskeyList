//
//  AFCollectionViewLayoutAttributes.h
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const AFCollectionViewLayoutModeKey;

typedef enum {
    AFCollectionViewLayoutAttributesLayoutModeGrid = 0,
    AFCollectionViewLayoutAttributesLayoutModeList
}AFCollectionViewLayoutAttributesLayoutMode;


@interface AFCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, assign) AFCollectionViewLayoutAttributesLayoutMode layoutMode;

@end
