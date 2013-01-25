//
//  AFDetailViewController.m
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFDetailViewController.h"
#import "AFRegionSelectViewController.h"

#import "AFRegion.h"

#import "AFPhotoButton.h"
#import "AFNameSectionCell.h"

enum {
    AFDetailViewControllerNameSection = 0,
    AFDetailViewControllerNumberOfSections
};

enum {
    AFDetailViewControllerNameSectionNameRow = 0,
    AFDetailViewControllerNameSectionRegionRow,
    AFDetailViewControllerNameSectionNumberOfRows
};

NSString * const AFModelRelationWasUpdatedNotification = @"AFModelRelationWasUpdatedNotification";

static NSString *NameRowCellIdentifier = @"NameRowCell";
static NSString *RegionRowCellIdentifier = @"RegionRowCellIdentifier";

@interface AFDetailViewController ()

@property (nonatomic, strong) UIImage *savedImage;
@property (nonatomic, strong) AFRegion *savedRegion;

@end

@implementation AFDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    [self.tableView registerClass:[AFNameSectionCell class] forCellReuseIdentifier:NameRowCellIdentifier];
    [self.tableView registerClass:[AFNameSectionCell class] forCellReuseIdentifier:RegionRowCellIdentifier];
}

#pragma mark - Table View Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    return AFDetailViewControllerNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (section == AFDetailViewControllerNameSection)
    {
        return AFDetailViewControllerNameSectionNumberOfRows;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == AFDetailViewControllerNameSectionNameRow)
    {
        AFNameSectionCell *cell = (AFNameSectionCell *)[tableView dequeueReusableCellWithIdentifier:NameRowCellIdentifier forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.enableTextField = YES;
        
        cell.textFieldText = [self.detailItem valueForKey:@"name"];
        cell.textFieldPlaceholder = NSLocalizedString(@"Whiskey Name", @"");
        
        return cell;
    }
    else if (indexPath.row == AFDetailViewControllerNameSectionRegionRow)
    {
        AFNameSectionCell *cell = (AFNameSectionCell *)[tableView dequeueReusableCellWithIdentifier:RegionRowCellIdentifier forIndexPath:indexPath];
        
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        cell.enableTextField = NO;
        
        NSString *regionName = self.savedRegion.name;
        
        if (regionName.length > 0)
        {
            cell.textLabel.text = regionName;
            cell.textLabel.textColor = [UIColor blackColor];
        }
        else
        {
            cell.textLabel.text = NSLocalizedString(@"Select Region", @"");
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
        
        return cell;
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing) return YES;
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing)
    {
        if (indexPath.row == AFDetailViewControllerNameSectionRegionRow && indexPath.section == AFDetailViewControllerNameSection)
        {
            AFRegionSelectViewController *viewController = [[AFRegionSelectViewController alloc] initWithStyle:UITableViewStylePlain];
            viewController.delegate = self;
            viewController.region = self.savedRegion;
            viewController.managedObjectContext = self.managedObjectContext;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

#pragma mark - Overridden Properties

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing)
    {
        self.photoButton.enabled = YES;
    }
    else
    {
        self.photoButton.enabled = NO;
        
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
}

- (void)setDetailItem:(NSManagedObject *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        self.savedRegion = [newDetailItem valueForKey:@"region"];
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

-(NSString *)nameString
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:AFDetailViewControllerNameSectionNameRow inSection:AFDetailViewControllerNameSection];
    
    return [(AFNameSectionCell *)[self.tableView cellForRowAtIndexPath:indexPath] textFieldText];
}

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
    self.photoButton = [AFPhotoButton buttonWithType:UIButtonTypeCustom];
    self.photoButton.frame = CGRectMake(10, 10, 90, 90);
    [self.photoButton addTarget:self action:@selector(userDidTapEditPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:self.photoButton];
    
    if (self.detailItem && !self.creatingNewEntity)
    {
        self.title = [self.detailItem valueForKey:@"name"];
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        self.editing = NO;
        
        [self.photoButton setPhoto:[UIImage imageWithData:[self.detailItem valueForKeyPath:@"image.imageData"]]];
        
        self.title = NSLocalizedString(@"Info", @"Detail edit default title");
    }
    else if (self.creatingNewEntity)
    {
        self.title = NSLocalizedString(@"New Whiskey", @"Detail default title");
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(userDidCancelNewItem:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(userDidFinish:)];
        
        self.editing = YES;
    }
    
    self.tableView.allowsSelectionDuringEditing = YES;
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"subtle_stripes"] resizableImageWithCapInsets:UIEdgeInsetsZero]];
}

-(BOOL)validate
{
    if ([[[self nameString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
        return NO;
    
    return YES;
}

//-(AFRegion *)findOrCreateRegion:(NSString *)regionName
//{    
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
//    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name like[c] %@", regionName];
//    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
//    
//    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
//    
//    if (results.count > 0)
//    {
//        return [results objectAtIndex:0];
//    }
//    else
//    {
//        AFRegion *newRegion = [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:self.managedObjectContext];
//        [newRegion setValue:regionName forKey:@"name"];
//        [newRegion setValue:[regionName lowercaseString] forKey:@"canonicalName"];
//        return newRegion;
//    }
//}

- (void)insertNewObject
{
    NSManagedObject *newWhiskeyObject = [NSEntityDescription insertNewObjectForEntityForName:@"Whiskey" inManagedObjectContext:self.managedObjectContext];
    
    NSString *name = [self nameString];
    
    [newWhiskeyObject setValue:name forKey:@"name"];
    [newWhiskeyObject setValue:[name lowercaseString] forKey:@"canonicalName"];
    
    if (self.savedRegion)
    {
        [newWhiskeyObject setValue:self.savedRegion forKey:@"region"];
        [[newWhiskeyObject valueForKey:@"region"] addWhiskiesObject:newWhiskeyObject];
    }
    
    NSManagedObject *newWhiskeyImage = [NSEntityDescription insertNewObjectForEntityForName:@"WhiskeyImage" inManagedObjectContext:self.managedObjectContext];
    [newWhiskeyImage setValue:newWhiskeyObject forKey:@"whiskey"];
    [newWhiskeyObject setValue:newWhiskeyImage forKey:@"image"];
    [newWhiskeyImage setValue:UIImageJPEGRepresentation(self.savedImage, 0.75f) forKey:@"imageData"];
    
    [self saveContext];
}

-(void)updateItem
{
    [self.detailItem setValue:[self nameString] forKey:@"name"];
    [self.detailItem setValue:[[self nameString] lowercaseString] forKey:@"canonicalName"];
    [[self.detailItem valueForKey:@"region"] removeWhiskiesObject:self.detailItem];
    [self.detailItem setValue:self.savedRegion forKey:@"region"];
    [[self.detailItem valueForKey:@"region"] addWhiskiesObject:self.detailItem];
}

#pragma mark - UIActionSheetDelegate methods
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        [self.photoButton setPhoto:nil];
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
    
    self.savedImage = info[UIImagePickerControllerEditedImage];
    
    [self.photoButton setPhoto:self.savedImage];
    
    [[self.detailItem valueForKey:@"image"] setValue:UIImageJPEGRepresentation(self.savedImage, 0.75f) forKey:@"imageData"];
    [self saveContext];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AFRegionSelectViewControllerDelegate Methods

-(void)regionSelectViewController:(AFRegionSelectViewController *)controller didSelectRegion:(AFRegion *)region
{
    self.savedRegion = region;
    [self.navigationController popToViewController:self animated:YES];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:AFDetailViewControllerNameSectionRegionRow inSection:AFDetailViewControllerNameSection]] withRowAnimation:UITableViewRowAnimationFade];
}

@end
