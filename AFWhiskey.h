//
//  Whiskey.h
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-25.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AFRegion;

@interface AFWhiskey : NSManagedObject

@property (nonatomic, retain) NSString * canonicalName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * nose;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * taste;
@property (nonatomic, retain) NSManagedObject *image;
@property (nonatomic, retain) AFRegion *region;

@end
