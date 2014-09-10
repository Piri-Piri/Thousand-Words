//
//  AlbumTableViewController.h
//  Thousand Words
//
//  Created by David Pirih on 08.09.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *albums;

- (IBAction)addAlbumAction:(UIBarButtonItem *)sender;
@end
