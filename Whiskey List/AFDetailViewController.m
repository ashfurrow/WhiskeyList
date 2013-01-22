//
//  AFDetailViewController.m
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFDetailViewController.h"
#import "AFRegion.h"

NSString * const AFModelRelationWasUpdatedNotification = @"AFModelRelationWasUpdatedNotification";

@interface AFDetailViewController ()
- (void)configureView;
@end

@implementation AFDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Overridden Properties

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing)
    {
        self.nameTextField.enabled = YES;
        self.regionTextField.enabled = YES;
        
    }
    else
    {
        self.nameTextField.enabled = NO;
        self.regionTextField.enabled = NO;
        
        if (self.detailItem)
        {
            if ([self validate])
            {
                [self updateItem];
            }
        }
    }
    
    if (!self.creatingNewEntity)
    {
        if (self.isEditing)
        {
            [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(userDidCancelExistingItem:)] animated:YES];
        }
        else
        {
            [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        }
    }
    
    // We always want to allow editing when creating a new entity
    if (self.creatingNewEntity)
    {
        self.nameTextField.enabled = YES;
        self.regionTextField.enabled = YES;
    }
}

- (void)setDetailItem:(NSManagedObject *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        self.managedObjectContext = newDetailItem.managedObjectContext;
        
        // Update the view.
        [self configureView];
    }
}

#pragma mark - User Interaction Methods

#pragma mark IBActions

-(void)userDidTapEditPhotoButton:(id)sender
{
    BOOL hasExistingPhoto = [self.detailItem valueForKeyPath:@"image.imageData"] != nil;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //If this device has a camera, then present an action sheet
        UIActionSheet *actionSheet;
        
        if (hasExistingPhoto)
        {
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:NSLocalizedString(@"Delete Photo", @"") otherButtonTitles:NSLocalizedString(@"Take a Photo", @""), NSLocalizedString(@"Choose Existing Photo", @""), nil];
        }
        else
        {
            //If this device has a camera, then present an action sheet
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Take a Photo", @""), NSLocalizedString(@"Choose Existing Photo", @""), nil];
        }

        [actionSheet showInView:self.view];
    }
    else
    {
        if (hasExistingPhoto)
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:NSLocalizedString(@"Delete Photo", @"") otherButtonTitles:NSLocalizedString(@"Choose Existing Photo", @""), nil];
            
            [actionSheet showInView:self.view];
        }
        else
        {
            //This device has no camera. Present the image picker now
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = self;
            pickerController.allowsEditing = YES;
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:pickerController animated:YES completion:nil];
        }
    }
}

#pragma mark Others

-(void)userDidCancelNewItem:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)userDidCancelExistingItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)userDidFinish:(id)sender
{
    if (![self validate])
    {
        //TODO: replace this with actual stuff
        [[[UIAlertView alloc] initWithTitle:@"Empty Fields" message:@"Some bullshit error message" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"FINE.", nil] show];
        
        return;
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self insertNewObject];
}

#pragma mark - Private Custom Methods

-(void)saveContext
{
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AFModelRelationWasUpdatedNotification object:self.detailItem];
}

- (void)configureView
{
    if (self.detailItem && !self.creatingNewEntity)
    {
        self.nameTextField.text = [self.detailItem valueForKey:@"name"];
        self.regionTextField.text = [self.detailItem valueForKeyPath:@"region.name"];
        self.title = [self.detailItem valueForKey:@"name"];
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        self.editing = NO;
        
        self.whiskeyImageView.image = [UIImage imageWithData:[self.detailItem valueForKeyPath:@"image.imageData"]];
        
        self.title = NSLocalizedString(@"Info", @"Detail edit default title");
    }
    else if (self.creatingNewEntity)
    {
        self.title = NSLocalizedString(@"New Whiskey", @"Detail default title");
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(userDidCancelNewItem:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(userDidFinish:)];
        
        self.editing = NO;
    }
}

-(BOOL)validate
{
    if ([[self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
        return NO;
    if ([[self.regionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
        return NO;
    
    return YES;
}

-(AFRegion *)findOrCreateRegion:(NSString *)regionName
{    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name like[c] %@", regionName];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    else
    {
        AFRegion *newRegion = [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:self.managedObjectContext];
        [newRegion setValue:regionName forKey:@"name"];
        [newRegion setValue:[regionName lowercaseString] forKey:@"canonicalName"];
        return newRegion;
    }
}

- (void)insertNewObject
{
    NSManagedObject *newWhiskeyObject = [NSEntityDescription insertNewObjectForEntityForName:@"Whiskey" inManagedObjectContext:self.managedObjectContext];
    
    [newWhiskeyObject setValue:self.nameTextField.text forKey:@"name"];
    [newWhiskeyObject setValue:[self.nameTextField.text lowercaseString] forKey:@"canonicalName"];
    [newWhiskeyObject setValue:[self findOrCreateRegion:self.regionTextField.text] forKey:@"region"];
    [[newWhiskeyObject valueForKey:@"region"] addWhiskiesObject:newWhiskeyObject];
    
    NSManagedObject *newWhiskeyImage = [NSEntityDescription insertNewObjectForEntityForName:@"WhiskeyImage" inManagedObjectContext:self.managedObjectContext];
    [newWhiskeyImage setValue:newWhiskeyObject forKey:@"whiskey"];
    [newWhiskeyObject setValue:newWhiskeyImage forKey:@"image"];
    
    [self saveContext];
}

-(void)updateItem
{
    [self.detailItem setValue:self.nameTextField.text forKey:@"name"];
    [self.detailItem setValue:[self findOrCreateRegion:self.regionTextField.text] forKey:@"region"];
    [[self.detailItem valueForKey:@"region"] addWhiskiesObject:self.detailItem];
}

#pragma mark - UIActionSheetDelegate methods
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        self.whiskeyImageView.image = nil;
        [[self.detailItem valueForKey:@"image"] setValue:nil forKey:@"imageData"];
        [self saveContext];
        
        return;
    }
    else if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    
    if (buttonIndex == actionSheet.firstOtherButtonIndex)
    {
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
		{
			//Take new photo
			pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
			pickerController.showsCameraControls = YES;
			if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
			{
				pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
			}
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cannot Take Photo", @"")
															message:NSLocalizedString(@"Unable to access the camera.", @"")
														   delegate:nil
												  cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
												  otherButtonTitles:nil];
			[alert show];
			return;
		}
    }
    else if (buttonIndex == 1)
    {
        //Choose existing photo
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerController methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *newImage = info[UIImagePickerControllerEditedImage];
    
    self.whiskeyImageView.image = newImage;
    
    [[self.detailItem valueForKey:@"image"] setValue:UIImageJPEGRepresentation(newImage, 0.75f) forKey:@"imageData"];
    [self saveContext];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
