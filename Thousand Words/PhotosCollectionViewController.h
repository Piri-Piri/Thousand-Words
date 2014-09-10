//
//  PhotosCollectionViewController.h
//  Thousand Words
//
//  Created by David Pirih on 09.09.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface PhotosCollectionViewController : UICollectionViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) Album *album;

- (IBAction)cameraAction:(UIBarButtonItem *)sender;

@end
