//
//  AFDetailViewController.h
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFRegionSelectViewController.h"

@class AFPhotoButton;
@class AFWhiskey;

extern NSString * const AFModelRelationWasUpdatedNotification;

@interface AFDetailViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, AFRegionSelectViewControllerDelegate>

@property (strong, nonatomic) AFWhiskey *whiskey;

@property (nonatomic, assign) BOOL creatingNewEntity;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) AFPhotoButton *photoButton;

@end
