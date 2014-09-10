//
//  PhotoDetailViewController.m
//  Thousand Words
//
//  Created by David Pirih on 10.09.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "Photo.h"
#import "FiltersCollectionViewController.h"

@interface PhotoDetailViewController ()

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.imageView.image = self.photo.image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toPhotoFilters"]) {
        if ([segue.destinationViewController isKindOfClass:[FiltersCollectionViewController class]]) {
            FiltersCollectionViewController *filtersCollectionViewController = segue.destinationViewController;
            filtersCollectionViewController.photo = self.photo;
        }
    }
}


#pragma mark - IBActions Method

- (IBAction)addFilterAction:(UIButton *)sender {
    
}

- (IBAction)deleteAction:(UIButton *)sender {
    [[self.photo managedObjectContext] deleteObject:self.photo];
    
    
    NSError *error = nil;
    if (![self.photo.managedObjectContext save:&error]) {
        NSLog(@"Deleting photo '%@' failed with error '%@'.", self.photo, error.localizedDescription);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
