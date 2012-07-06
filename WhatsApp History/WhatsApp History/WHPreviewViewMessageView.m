//
//  WHPreviewViewMessageView.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHPreviewViewMessageView.h"

@interface WHPreviewViewMessageView ()
- (void)setUpParameters;
@end

@implementation WHPreviewViewMessageView

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self)
    {
        [self setUpParameters];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frameRect textContainer:(NSTextContainer *)container
{
    self = [super initWithFrame:frameRect textContainer:container];
    if (self)
    {
        [self setUpParameters];
    }
    return self;
}

- (void)setUpParameters
{
    [self setEditable:NO];
    [self setSelectable:YES];
}

@end
