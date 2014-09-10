//
//  CoreDataHelper.m
//  Thousand Words
//
//  Created by David Pirih on 09.09.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

+ (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    
    id delegate = [[UIApplication  sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
                   
    return context;
    
}

@end
