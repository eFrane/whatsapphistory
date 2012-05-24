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

#import "NSString+Clinching.h"

@interface WHHistory ()
- (NSURL *)unarchiveSourceURLWithArchiveType:(NSString *)archiveType;
- (NSError *)errorWithCode:(NSUInteger)code localizedDescription:(NSString *)description;
@end

static BOOL hasInstance = NO;

@implementation WHHistory

@synthesize sourceURL = _sourceURL;

@synthesize historyString = _historyString;
@synthesize messages      = _messages;
@synthesize lineCount     = _lineCount;
@synthesize mediaCount    = _mediaCount;

#pragma mark Init and dealloc

- (id)initWithSourceURL:(NSURL *)sourceURL
{
    self = [super init];
    if (self)
    {
        self.sourceURL = sourceURL;
        hasInstance = YES;
    }
    return self;
}

- (void)dealloc
{
    hasInstance = NO;
}

#pragma mark Helper methods

+ (void)progress:(NSUInteger)step withMessage:(NSString *)message
{
    if (hasInstance)
    {
        NSMutableDictionary *progressDict = [[NSMutableDictionary alloc] initWithCapacity:2];
        [progressDict setValue:[NSNumber numberWithInteger:step] forKey:@"step"];
        [progressDict setValue:message forKey:@"message"];
        [[NSNotificationCenter defaultCenter] postNotificationName:WHHistoryProgressNotification object:self userInfo:progressDict];
    }
}

- (NSError *)errorWithCode:(NSUInteger)code localizedDescription:(NSString *)description
{
    NSDictionary *dictionary = [NSDictionary 
                                dictionaryWithObjectsAndKeys:description,
                                NSLocalizedDescriptionKey, nil];
    return [NSError errorWithDomain:WHErrorDomain code:1 userInfo:dictionary];
}

- (NSURL *)unarchiveSourceURLWithArchiveType:(NSString *)archiveType
{
    [WHHistory progress:0 withMessage:@"Unarchiving ..."];
    
    // create temporary folder
    NSString *tempFolderTemplate = [NSTemporaryDirectory() 
                                    stringByAppendingPathComponent:@"WAHistoryData.XXXXX"];
    const char * tempFolderCStringTemplate = [tempFolderTemplate fileSystemRepresentation];
    
    char * tempFolder = (char *)malloc(strlen(tempFolderCStringTemplate) + 1);
    strcpy(tempFolder, tempFolderCStringTemplate);
    
    char * result = mkdtemp(tempFolder);
    if (!result)
    {
        NSError *error = [self errorWithCode:1 localizedDescription:NSLocalizedString(@"Could not create temporary folder.", @"" )];
        [[NSNotificationCenter defaultCenter] postNotificationName:WHHistoryErrorNotification object:error];
    }
    
    NSString *tempFolderString = [[NSFileManager defaultManager] 
                                  stringWithFileSystemRepresentation:tempFolder length:strlen(result)];
    free(tempFolder);
    
    BOOL success = NO;
    
    if ([archiveType hasPrefix:@".tar"])
    {
        // use tar for unarchiving
        NSTask *untar = [[NSTask alloc] init];
        [untar setLaunchPath:@"/usr/bin/tar"];
        [untar setArguments:[NSArray arrayWithObjects:@"-xf", tempFolderString, [_sourceURL absoluteString], nil]];
        [untar launch];
        [untar waitUntilExit];
        
        success = ([untar terminationStatus] == 0);
    } else 
    {
        // use zip for unarchiving
        NSTask *unzip = [[NSTask alloc] init];
        [unzip setCurrentDirectoryPath:tempFolderString];
        [unzip setLaunchPath:@"/usr/bin/unzip"];
        [unzip setArguments:[NSArray arrayWithObject:[_sourceURL relativePath]]];
        [unzip launch];
        [unzip waitUntilExit];
        
        success = ([unzip terminationStatus] == 0);
    }
    
    if (success)
    {
        return [NSURL URLWithString:tempFolderString];
    } else 
    {
        NSError *error = [self errorWithCode:2 localizedDescription:NSLocalizedString(@"Unarchiving failed.", @"")];
        [[NSNotificationCenter defaultCenter] postNotificationName:WHHistoryErrorNotification object:error];
        return nil;
    }
}

#pragma mark Main parsing methods

- (void)process
{
    [WHHistory progress:0 withMessage:NSLocalizedString(@"Locating history file", @"")];
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
    
    [WHHistory progress:0 withMessage:NSLocalizedString(@"Counting Lines...", @"")];
    
    NSArray *lines = [[self historyString] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    self.lineCount = [lines count];
    
    _messages = [[NSMutableArray alloc] initWithCapacity:_lineCount];
    [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *shortenedMsg = [obj clinchedStringWithLength:60];
        [WHHistory progress:1 withMessage:[NSString stringWithFormat:NSLocalizedString(@"Processing \"%@\"", @""), shortenedMsg]];
        [_messages addObject:[[WHMessage alloc] initWithString:obj]];
    }];
}


@end
