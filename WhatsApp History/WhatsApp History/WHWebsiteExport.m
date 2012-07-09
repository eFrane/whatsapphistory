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
- (NSBundle *)historyStyle;
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
    }
    return self;
}

- (void)save
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    [fm createDirectoryAtURL:self.folderURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSBundle *historyStyle = [self historyStyle];
    NSData *infoData = [NSData dataWithContentsOfURL:[historyStyle URLForResource:@"info" withExtension:@"json"]];
    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:infoData options:0 error:&error];
    
    // copy assets
    for (NSString *asset in [info objectForKey:@"assets"])
    {
        NSURL *fromURL = [historyStyle URLForResource:[asset stringByDeletingPathExtension] withExtension:[asset pathExtension]];
        NSURL *toURL   = [[self.folderURL URLByAppendingPathComponent:[asset stringByDeletingPathExtension]] 
                          URLByAppendingPathExtension:[asset pathExtension]];
        [fm copyItemAtURL:fromURL toURL:toURL error:&error];
    }
    
    // apply template
    NSURL *templateURL = [historyStyle URLForResource:@"index" withExtension:@"mustache"];
    NSString *renderedTemplate = [GRMustacheTemplate renderObject:self.history fromContentsOfURL:templateURL error:&error];
    [renderedTemplate writeToURL:[[self.folderURL URLByAppendingPathComponent:@"index"] URLByAppendingPathExtension:@"html"] 
                      atomically:NO encoding:NSUTF8StringEncoding error:&error];
    
    [historyStyle unload]; // be kind and free memory
}

- (NSBundle *)historyStyle
{
    return [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"Default" 
                                                           withExtension:@"wahistorystyle" 
                                                            subdirectory:@"Styles"]];
}

@end
