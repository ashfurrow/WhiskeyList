//
//  AFDetailViewController.m
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFDetailViewController.h"
#import "AFRegion.h"

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

-(void)userDidCancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
        
        self.title = NSLocalizedString(@"Info", @"Detail edit default title");
    }
    else if (self.creatingNewEntity)
    {
        self.title = NSLocalizedString(@"New Whiskey", @"Detail default title");
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(userDidCancel:)];
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
        return newRegion;
    }
}

- (void)insertNewObject
{
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Whiskey" inManagedObjectContext:self.managedObjectContext];
    
    [newManagedObject setValue:self.nameTextField.text forKey:@"name"];
    [newManagedObject setValue:[self findOrCreateRegion:self.regionTextField.text] forKey:@"region"];
    [[newManagedObject valueForKey:@"region"] addWhiskiesObject:newManagedObject];
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

-(void)updateItem
{
    [self.detailItem setValue:self.nameTextField.text forKey:@"name"];
    [self.detailItem setValue:[self findOrCreateRegion:self.regionTextField.text] forKey:@"region"];
    [[self.detailItem valueForKey:@"region"] addWhiskiesObject:self.detailItem];
}
							
@end
