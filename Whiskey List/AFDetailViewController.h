//
//  AFDetailViewController.h
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const AFModelRelationWasUpdatedNotification;

@interface AFDetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) id detailItem;

@property (nonatomic, assign) BOOL creatingNewEntity;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *regionTextField;

@property (weak, nonatomic) IBOutlet UIImageView *whiskeyImageView;

-(IBAction)userDidTapEditPhotoButton:(id)sender;

@end
