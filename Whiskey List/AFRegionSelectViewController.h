//
//  AFRegionSelectViewController.h
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-24.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFRegion;
@class AFRegionSelectViewController;

@protocol AFRegionSelectViewControllerDelegate <NSObject>

-(void)regionSelectViewController:(AFRegionSelectViewController *)controller didSelectRegion:(AFRegion *)region;

@end

@interface AFRegionSelectViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) AFRegion *region;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) id<AFRegionSelectViewControllerDelegate> delegate;

@end
