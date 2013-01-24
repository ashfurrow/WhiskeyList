//
//  AFColelctionViewFlowLayout.m
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFColelctionViewFlowLayout.h"

@implementation AFColelctionViewFlowLayout

-(id)init
{
    if (!(self = [super init])) return nil;
    
    _layoutMode = [[NSUserDefaults standardUserDefaults] integerForKey:AFCollectionViewLayoutModeKey];
    
    // Some basic setup. 140x140 + 3*13 ~= 320, so we can get a two-column grid in portrait orientation.
    [self updateSectionInsets];
    [self updateCellGeometry];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSectionInsets) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

#pragma mark - Private Helper Methods

-(void)updateSectionInsets
{
    if (self.layoutMode == AFCollectionViewLayoutAttributesLayoutModeGrid)
    {
        self.sectionInset = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    }
    else if (self.layoutMode == AFCollectionViewLayoutAttributesLayoutModeList)
    {
        self.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    }
}

+(Class)layoutAttributesClass
{
    // Important for letting UICollectionView know what kind of attributes to use.
    return [AFCollectionViewLayoutAttributes class];
}

-(void)updateCellGeometry
{
    if (self.layoutMode == AFCollectionViewLayoutAttributesLayoutModeGrid)
    {
        self.itemSize = kMaxGridItemSize;
        self.minimumInteritemSpacing = 13.0f;
        self.minimumLineSpacing = 13.0f;
    }
    else if (self.layoutMode == AFCollectionViewLayoutAttributesLayoutModeList)
    {
        self.itemSize = kMaxListItemSize;
        self.minimumInteritemSpacing = 10.0f;
        self.minimumLineSpacing = 10.0f;
    }
}

-(void)applyLayoutAttributes:(AFCollectionViewLayoutAttributes *)attributes
{
    // Check for representedElementKind being nil, indicating this is a cell and not a header or decoration view
    if (attributes.representedElementKind == nil)
    {
        // Pass our layout mode onto the layout attributes
        attributes.layoutMode = self.layoutMode;
    }
}

#pragma mark - Overridden Methods

#pragma mark Cell Layout

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
    
    for (AFCollectionViewLayoutAttributes *attributes in attributesArray)
    {
        [self applyLayoutAttributes:attributes];
    }
    
    return attributesArray;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFCollectionViewLayoutAttributes *attributes = (AFCollectionViewLayoutAttributes *)[super layoutAttributesForItemAtIndexPath:indexPath];
    
    [self applyLayoutAttributes:attributes];
    
    return attributes;
}

#pragma mark - Overridden Properties

-(void)setLayoutMode:(AFCollectionViewLayoutAttributesLayoutMode)layoutMode
{
    _layoutMode = layoutMode;
    
    [self updateSectionInsets];
    [self updateCellGeometry];
    
    [self invalidateLayout];
}

@end
