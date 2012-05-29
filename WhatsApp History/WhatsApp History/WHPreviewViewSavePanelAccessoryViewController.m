//
//  WHPreviewViewSavePanelAccessoryViewController.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHPreviewViewSavePanelAccessoryViewController.h"

@interface WHPreviewViewSavePanelAccessoryViewController ()

@end

@implementation WHPreviewViewSavePanelAccessoryViewController

@synthesize availableFileTypes, fileType;

- (id)init
{
    self = [super initWithNibName:@"PreviewViewSavePanelAccessoryView" bundle:[NSBundle mainBundle]];
    if (self)
    {
        // additional init
        availableFileTypes = [[NSArray alloc] init];
    }
    return self;
}

- (void)awakeFromNib
{
    [fileType selectItemAtIndex:0];
}

#pragma mark Combo Box Data Source

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
    return [availableFileTypes count];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index
{
    return [availableFileTypes objectAtIndex:index];
}

- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string
{
    NSUInteger __block returnValue = -1;
    [availableFileTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([(NSString *)obj isEqualToString:string])
        {
            *stop = YES;
            returnValue = idx;
        }
    }];
    return returnValue;
}

- (NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)string
{
    NSString __block *returnString;
    [availableFileTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([(NSString *)obj compare:string] == NSGreaterThanOrEqualToComparison)
        {
            *stop = YES;
            returnString = obj;
        }
    }];
    return returnString;
}

@end
