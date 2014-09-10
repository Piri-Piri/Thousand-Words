//
//  PhotoDetailViewController.h
//  Thousand Words
//
//  Created by David Pirih on 10.09.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

@interface PhotoDetailViewController : UIViewController

@property (strong,nonatomic) Photo *photo;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)addFilterAction:(UIButton *)sender;
- (IBAction)deleteAction:(UIButton *)sender;

@end
