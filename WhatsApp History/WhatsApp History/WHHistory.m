//
//  WHHistory.m
//  WhatsApp History
//
//  Errors in WHHistory are posted as WHHistoryErrorNotification with
//  their NSError object set as the notification's object.
//
//  Created by Stefan Graupner on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHHistory.h"
#import "WHMessage.h"

#import "NSFileManager+TemporaryFolder.h"

@interface WHHistory ()
{
    NSArray *lines;
}
- (NSURL *)unarchiveSourceURLWithArchiveType:(NSString *)archiveType;
- (NSError *)errorWithCode:(NSUInteger)code localizedDescription:(NSString *)description;

- (void)obtainHistoryString;
- (void)splitLines;
- (void)consolidateData;
@end

static BOOL hasInstance = NO;

@implementation WHHistory

@synthesize sourceURL = _sourceURL;

@synthesize historyString = _historyString;
@synthesize messages      = _messages;
@synthesize operations    = _operations;

#pragma mark Init and dealloc

- (id)initWithSourceURL:(NSURL *)sourceURL
{
    self = [super init];
    if (self)
    {
        self.sourceURL = sourceURL;
        
        _operations = [[NSOperationQueue alloc] init];
        [_operations setSuspended:YES];
        
        hasInstance = YES;
    }
    return self;
}

- (void)dealloc
{
    hasInstance = NO;
    
    [_operations cancelAllOperations];
}

#pragma mark Helper methods

+ (void)message:(NSString *)message
{
    if (hasInstance)
    {
        NSMutableDictionary *progressDict = [[NSMutableDictionary alloc] initWithCapacity:2];
        [progressDict setValue:message forKey:@"message"];
        [[NSNotificationCenter defaultCenter] postNotificationName:WHHistoryProgressNotification object:self userInfo:progressDict];
    }
}

- (NSError *)errorWithCode:(NSUInteger)code localizedDescription:(NSString *)description
{
    NSDictionary *dictionary = [NSDictionary 
                                dictionaryWithObjectsAndKeys:description,
                                NSLocalizedDescriptionKey, nil];
    return [NSError errorWithDomain:WHErrorDomain code:code userInfo:dictionary];
}

#pragma mark Main parsing methods

- (void)process
{
    [self obtainHistoryString];
    [self splitLines];
    
    _messages = [[NSMutableArray alloc] initWithCapacity:[lines count]];
    [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([(NSString *)obj length] > 1)
        {
            WHMessage *message = [[WHMessage alloc] initWithString:obj];
            
            if (idx > 0)
            {
                [message setParent:[_messages objectAtIndex:[_messages indexOfObject:[_messages lastObject]]]];
            }
            [_messages addObject:message];
            
            [message process];
        }
    }];
    
    [self consolidateData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WHEndProcessingNotification object:nil];
}

- (NSURL *)unarchiveSourceURLWithArchiveType:(NSString *)archiveType
{
    [WHHistory message:@"Unarchiving ..."];
    
    NSError *error;
    NSURL *tempFolderURL = [[NSFileManager defaultManager] temporaryFolderWithBaseName:@"WAHistoryData" error:&error];
    
    if (error != nil)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:WHHistoryErrorNotification object:error];
        return nil;
    }
    
    NSString *tempFolderString = [tempFolderURL relativePath];
    
    NSTask *unarchive = [[NSTask alloc] init];
    [unarchive setCurrentDirectoryPath:tempFolderString];
    
    if ([archiveType hasPrefix:@".tar"])
    {
        // use tar for unarchiving
        [unarchive setLaunchPath:@"/usr/bin/tar"];
        [unarchive setArguments:[NSArray arrayWithObjects:@"-xf", tempFolderString, [_sourceURL relativePath], nil]];
    } else 
    {
        // use zip for unarchiving
        [unarchive setLaunchPath:@"/usr/bin/unzip"];
        [unarchive setArguments:[NSArray arrayWithObject:[_sourceURL relativePath]]];
    }
    
    [unarchive launch];
    [unarchive waitUntilExit];
    
    if ([unarchive terminationStatus] == 0)
    {
        return tempFolderURL;
    } else 
    {
        NSError *error = [self errorWithCode:2 localizedDescription:NSLocalizedString(@"Unarchiving failed.", @"")];
        [[NSNotificationCenter defaultCenter] postNotificationName:WHHistoryErrorNotification object:error];
        return nil;
    }
}

- (void)obtainHistoryString
{
    [WHHistory message:NSLocalizedString(@"Locating history file", @"")];
    if ([[_sourceURL absoluteString] hasSuffix:@".txt"])
    {
        NSError *error = nil;
        _historyString = [NSString stringWithContentsOfURL:_sourceURL encoding:NSUTF8StringEncoding error:&error];
        if (error != nil)
        {
            [[NSNotificationCenter defaultCenter] 
             postNotificationName:WHHistoryErrorNotification object:error];
            return;
        }
    } else
    {
        NSURL __block *historyFolder = nil;
        
        NSArray *archiveSuffixes = [NSArray arrayWithObjects:@".zip", @".tar.gz", 
                                    @".tar.bz2", nil];
        [archiveSuffixes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([[_sourceURL absoluteString] hasSuffix:obj])
            {
                historyFolder = [self unarchiveSourceURLWithArchiveType:obj];
                *stop = YES;
            }
        }];
        
        if (historyFolder == nil) historyFolder = _sourceURL;
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSDirectoryEnumerator *dirEnum = [fm enumeratorAtURL:historyFolder 
                                  includingPropertiesForKeys:NULL
                                                     options:NSDirectoryEnumerationSkipsHiddenFiles | 
                                          NSDirectoryEnumerationSkipsSubdirectoryDescendants 
                                                errorHandler:nil];
        for (NSURL *file in dirEnum)
        {
            if ([[file absoluteString] hasSuffix:@".txt"])
            {
                NSError *error = nil;
                _historyString = [NSString stringWithContentsOfURL:file encoding:NSUTF8StringEncoding error:&error];
                if (error != nil)
                {
                    [[NSNotificationCenter defaultCenter] 
                     postNotificationName:WHHistoryErrorNotification object:error];
                    return;
                }
                break;
            }
        }
    }
    
    if (!_historyString)
    {
        NSError *error = [self errorWithCode:3 localizedDescription:NSLocalizedString(@"No history file found.", @"")];
        [[NSNotificationCenter defaultCenter] postNotificationName:WHHistoryErrorNotification object:error];
        return;
    }
}

- (void)splitLines
{
    [WHHistory message:NSLocalizedString(@"Splitting lines...", @"")];
    lines = [[self historyString] componentsSeparatedByCharactersInSet:
             [NSCharacterSet newlineCharacterSet]];
}

- (void)consolidateData
{
    [WHHistory message:NSLocalizedString(@"Consolidating data...", @"")];
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:[_messages count]];
    
    [_messages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [data addObject:[obj serializableRepresentation]];
    }];
    
    NSError *error;
    NSURL *tempFolder = [[NSFileManager defaultManager] temporaryFolderWithBaseName:@"WAHistory_processed" error:&error];
    
    NSURL *url = [NSURL URLWithString:@"data.json" relativeToURL:tempFolder];
    
    NSData *json = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    [json writeToURL:url atomically:YES];
}

@end
