//
//  Region.h
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AFRegion : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *whiskies;
@end

@interface AFRegion (CoreDataGeneratedAccessors)

- (void)addWhiskiesObject:(NSManagedObject *)value;
- (void)removeWhiskiesObject:(NSManagedObject *)value;
- (void)addWhiskies:(NSSet *)values;
- (void)removeWhiskies:(NSSet *)values;

@end
