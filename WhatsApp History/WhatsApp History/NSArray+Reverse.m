//
//  NSArray+Reverse.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSArray+Reverse.h"

@implementation NSArray (Reverse)

- (NSArray *)reverse
{
    NSMutableArray *reversedArray = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator]; 
    for (id element in enumerator)
    {
        [reversedArray addObject:element];
    }
    
    return reversedArray;
}

@end

@implementation NSMutableArray (Reverse)

- (void)reverse
{
    if ([self count] == 0) return;
    NSUInteger j = 0, k = [self count] - 1;
    
    while (j < k)
    {
        [self replaceObjectAtIndex:j++ withObject:[self objectAtIndex:k--]];
    }
}

@end
