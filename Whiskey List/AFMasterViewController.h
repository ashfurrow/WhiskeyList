//
//  AFMasterViewController.h
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFDetailViewController;

#import <CoreData/CoreData.h>

@interface AFMasterViewController : UICollectionViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) AFDetailViewController *detailViewController;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
