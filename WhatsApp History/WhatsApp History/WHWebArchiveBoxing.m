//
//  WHWebArchiveBoxing.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <WebKit/WebKit.h>

#import "WHWebArchiveBoxing.h"

@implementation WHWebArchiveBoxing

- (BOOL)saveToURL:(NSURL *)saveURL error:(NSError *__autoreleasing *)error
{
    WebView *webView = [[WebView alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
    NSURLRequest *loadRequest = [[NSURLRequest alloc] initWithURL:url];
    [[webView mainFrame] loadRequest:loadRequest];
    WebArchive *archive = [[[webView mainFrame] dataSource] webArchive];    
    
    NSData *data = [archive data];
    
    return [data writeToURL:saveURL options:NSDataWritingAtomic error:error];
}

@end
