//
//  PhotosCollectionViewController.m
//  Thousand Words
//
//  Created by David Pirih on 09.09.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

#import "PhotosCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "Photo.h"
#import "PictureDataTransformer.h"
#import "PhotoDetailViewController.h"


@interface PhotosCollectionViewController ()

@property (strong,nonatomic) NSMutableArray *photos;

@end

@implementation PhotosCollectionViewController

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSSet *unsortedPhotos = self.album.photos;
    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    
    NSArray *sortedPhotos = [unsortedPhotos sortedArrayUsingDescriptors:@[dateDescriptor]];
    self.photos = [sortedPhotos mutableCopy];
    
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBAction Methods

- (IBAction)cameraAction:(UIBarButtonItem *)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toPhotoDetails"]) {
        if ([segue.destinationViewController isKindOfClass:[PhotoDetailViewController class]]) {
            NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
            
            PhotoDetailViewController *photoDetailViewController = segue.destinationViewController;
            photoDetailViewController.photo = self.photos[indexPath.row];;
        }
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PhotoCell";
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.backgroundColor = [UIColor whiteColor];
    Photo *photo = self.photos[indexPath.row];
    cell.imageView.image = photo.image;
    
    return cell;
}

# pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"User has taken/choosen a photo.");
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) image = info[UIImagePickerControllerOriginalImage];
    
    [self.photos addObject:[self photoFromImage:image]];
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"User canceled taking/choising a photo.");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper Methods

-(Photo *)photoFromImage:(UIImage *)image {
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:self.album.managedObjectContext];
    photo.image = image;
    photo.date = [NSDate date];
    photo.album = self.album;
    
    NSError *error = nil;
    if (![photo.managedObjectContext save:&error]) {
        // error in saving a photo
        NSLog(@"%@", error);
    }
    
    return photo;
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
