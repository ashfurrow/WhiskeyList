//
//  AFDetailViewController.h
//  Whiskey List
//
//  Created by Ash Furrow on 2013-01-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
