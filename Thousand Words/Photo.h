//
//  Photo.h
//  Thousand Words
//
//  Created by David Pirih on 09.09.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album;

@interface Photo : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Album *album;

@end
