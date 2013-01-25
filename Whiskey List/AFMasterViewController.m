//
//  AFMasterViewController.m
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFMasterViewController.h"

// Controllers
#import "AFDetailViewController.h"
#import "AFColelctionViewFlowLayout.h"
#import "AFNavigationController.h"

// Extensions
#import "AFMasterViewController+NSFetchedResultsController.h"

// Views
#import "AFCollectionViewCell.h"

@interface AFMasterViewController ()

@property (nonatomic, strong) AFColelctionViewFlowLayout *collectionViewLayout;

@property (nonatomic, strong) NSMutableArray *objectChanges;
@property (nonatomic, strong) NSMutableArray *sectionChanges;

@property (nonatomic, strong) UISegmentedControl *layoutModeSelectionSegmentedControl;

@property (nonatomic, strong) UIImageView *noResultsImageView;

@end

static NSString *CellIdentifier = @"CellIdentifier";

@implementation AFMasterViewController
{
    NSFetchedResultsController *_fetchedResultsController;
}

-(void)loadView
{
    // Create our view
    
    // Create an instance of our custom flow layout.
    self.collectionViewLayout = [[AFColelctionViewFlowLayout alloc] init];
    
    // Create a new collection view with our flow layout and set ourself as delegate and data source.
    UICollectionView *newCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
    newCollectionView.dataSource = self;
    newCollectionView.delegate = self;
    
    newCollectionView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"subtle_stripes"] resizableImageWithCapInsets:UIEdgeInsetsZero]];
    newCollectionView.alwaysBounceVertical = YES;
    
    // Register our classes so we can use our custom subclassed cell and header
    [newCollectionView registerClass:[AFCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    // Set up the collection view geometry to cover the whole screen in any orientation and other view properties.
    newCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    newCollectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    // Finally, set our collectionView (since we are a collection view controller, this also sets self.view)
    self.collectionView = newCollectionView;
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    _objectChanges = [NSMutableArray array];
    _sectionChanges = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modelChanged:) name:AFModelRelationWasUpdatedNotification object:nil];
    
    self.noResultsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add"]];
    self.noResultsImageView.userInteractionEnabled = NO;
    self.noResultsImageView.contentMode = UIViewContentModeRight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationItem];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateNoResultsView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFCollectionViewCell *cell = (AFCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFDetailViewController *viewController = [[AFDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.whiskey = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - NSNotificationCenter Methods

-(void)modelChanged:(NSNotification *)notification
{
    if (!notification.object) return;
    
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:notification.object];
    
    if (!indexPath) return; 
    
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - Fetched Results Controller

-(NSFetchedResultsController *)nonCachedFetchedResultsController
{
    return _fetchedResultsController;
}

-(void)setNonCachedFetchedResultsController:(NSFetchedResultsController *)resultsController
{
    _fetchedResultsController = resultsController;
}

#pragma mark - User Interaction Code

-(void)layoutModeSegmentedValueChanged:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:self.layoutModeSelectionSegmentedControl.selectedSegmentIndex forKey:AFCollectionViewLayoutModeKey];
    
    // values for selected index corresponds to AFCollectionViewLayoutAttributesLayoutMode
    [UIView animateWithDuration:0.5f animations:^{
        [self.collectionViewLayout setLayoutMode:(AFCollectionViewLayoutAttributesLayoutMode)self.layoutModeSelectionSegmentedControl.selectedSegmentIndex];
    }];
}

-(void)promptForNewWhiskey:(id)sender
{
    AFDetailViewController *viewController = [[AFDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.managedObjectContext = self.managedObjectContext;
    viewController.creatingNewEntity = YES;
    AFNavigationController *navigationController = [[AFNavigationController alloc] initWithRootViewController:viewController];
    navigationController.navigationBar.barStyle = self.navigationController.navigationBar.barStyle;
    navigationController.navigationBar.translucent = self.navigationController.navigationBar.translucent;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Private Custom Methods

-(void)updateNoResultsView
{
    if ([self numberOfSectionsInCollectionView:self.collectionView] == 0 ||
        [self collectionView:self.collectionView numberOfItemsInSection:0] == 0)
    {
        [self.parentViewController.view addSubview:self.noResultsImageView];
        self.noResultsImageView.frame = CGRectMake(0, 64, 320, 131);
    }
    else
    {
        [self.noResultsImageView removeFromSuperview];
    }
}

- (void)configureCell:(AFCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell setName:[object valueForKey:@"name"]];
    [cell setRegion:[object valueForKeyPath:@"region.name"]];
    [cell setImage:[UIImage imageWithData:[object valueForKeyPath:@"image.imageData"]]];
}

-(void)setupNavigationItem
{
    self.layoutModeSelectionSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[[UIImage imageNamed:@"grid"], [UIImage imageNamed:@"list"]]];
    self.layoutModeSelectionSegmentedControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:AFCollectionViewLayoutModeKey];
    self.layoutModeSelectionSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.layoutModeSelectionSegmentedControl addTarget:self action:@selector(layoutModeSegmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    //TODO: segmented control accessibility
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.layoutModeSelectionSegmentedControl];;
    leftBarButtonItem.style = UIBarButtonItemStylePlain;
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.title = NSLocalizedString(@"Whiskey List", @"Main view controller title");
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(promptForNewWhiskey:)];
    addButton.accessibilityLabel = NSLocalizedString(@"Add a new whiskey", @"add button accessibility label.");
    self.navigationItem.rightBarButtonItem = addButton;
}

@end
