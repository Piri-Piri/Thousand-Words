//
//  PictureDataTransformer.m
//  Thousand Words
//
//  Created by David Pirih on 09.09.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

#import "PictureDataTransformer.h"

@implementation PictureDataTransformer

+(Class)transformedValueClass {
    return [NSData class];
}

+(BOOL)allowsReverseTransformation {
    return YES;
}

-(id)transformedValue:(id)value {
    return UIImagePNGRepresentation(value);
}

-(id)reverseTransformedValue:(id)value {
    return [UIImage imageWithData:value];
}

@end
