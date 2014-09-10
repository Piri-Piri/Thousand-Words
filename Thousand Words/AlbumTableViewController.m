//
//  AlbumTableViewController.m
//  Thousand Words
//
//  Created by David Pirih on 08.09.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

#import "AlbumTableViewController.h"
#import "Album.h"
#import "CoreDataHelper.h"
#import "PhotosCollectionViewController.h"


@interface AlbumTableViewController () <UIAlertViewDelegate>

@end

@implementation AlbumTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Album"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    NSManagedObjectContext *context = [CoreDataHelper managedObjectContext];
    
    NSError *error = nil;
    NSArray *fetchedAlbums = [context executeFetchRequest:fetchRequest error:&error];
    
    self.albums = [fetchedAlbums mutableCopy];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy instantion

- (NSMutableArray *)albums {
    if(!_albums) _albums = [[NSMutableArray alloc] init];
    return _albums;
}

#pragma mark - IBAction Methods

- (IBAction)addAlbumAction:(UIBarButtonItem *)sender {
    UIAlertView *newAlbumAlertView = [[UIAlertView alloc] initWithTitle:@"New Album" message:@"Enter a name for the new album" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [newAlbumAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [newAlbumAlertView show];
}

#pragma mark - Helper Methods

- (Album *)albumWithName:(NSString *)name {
    NSManagedObjectContext *context = [CoreDataHelper managedObjectContext];
    
    Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    album.name = name;
    album.date = [NSDate date];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Saving album '%@' failed with error '%@'.", name, error.localizedDescription);
    }
    return album;
}

#pragma mark - UIAlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        NSString *alertText = [alertView textFieldAtIndex:0].text;
        NSLog(@"My new ablum name is '%@'", alertText);
        [self.albums addObject:[self albumWithName:alertText]];
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.albums count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.albums count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Album *selectedAlbum = self.albums[indexPath.row];
    cell.textLabel.text = selectedAlbum.name;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    
    cell.detailTextLabel.text = [formatter stringFromDate:selectedAlbum.date];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the albums photos
        Album *album = self.albums[indexPath.row];
        [album removePhotos:album.photos];
        
        // Delete the row from CoreDate
        [album.managedObjectContext deleteObject:album];
        NSError *error = nil;
        if (![album.managedObjectContext  save:&error]) {
            NSLog(@"Deleting album '%@' failed with error '%@'.", album.name, error.localizedDescription);
        }
        
        // Delete the row from Array
        [self.albums removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"albumChoosen"]) {
        if ([segue.destinationViewController isKindOfClass:[PhotosCollectionViewController class]])    {
            PhotosCollectionViewController *photosCollectionViewController = segue.destinationViewController;
        
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            photosCollectionViewController.album = self.albums[indexPath.row];
        }
    }
}

@end
