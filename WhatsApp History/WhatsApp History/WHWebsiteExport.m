//
//  WHExport.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRMustache.h"

#import "WHWebsiteExport.h"

@interface WHWebsiteExport ()
{
    NSArray *defaultTemplateFiles;
}
@end

@implementation WHWebsiteExport

@synthesize history = _history, folderURL = _folderURL;

- (id)initWithHistory:(WHHistory *)history folderURL:(NSURL *)folderURL
{
    self = [super init];
    if (self)
    {
        _history = history;
        _folderURL = folderURL;
        
        defaultTemplateFiles = [NSArray arrayWithObjects:@"index.html", nil];
    }
    return self;
}

- (void)save
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    [fm createDirectoryAtURL:self.folderURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    // apply template set and save files and stationary data
    
}

@end
