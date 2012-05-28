//
//  NSFileManager+TemporaryFolder.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSFileManager+TemporaryFolder.h"

@implementation NSFileManager (TemporaryFolder)

- (NSURL *)temporaryFolderWithBaseName:(NSString *)baseName error:(NSError **)error
{
    // create temporary folder
    NSString *name = [NSString stringWithFormat:@"%@.XXXXX", baseName];
    NSString *tempFolderTemplate = [NSTemporaryDirectory() 
                                    stringByAppendingPathComponent:name];
    const char * tempFolderCStringTemplate = [tempFolderTemplate fileSystemRepresentation];
    
    char * tempFolder = (char *)malloc(strlen(tempFolderCStringTemplate) + 1);
    strcpy(tempFolder, tempFolderCStringTemplate);
    
    char * result = mkdtemp(tempFolder);
    if (!result)
    {
        if (*error == NULL) *error = nil; // NULL dereferencing
        
        *error = [NSError errorWithDomain:WHErrorDomain 
                                     code:1 
                                 userInfo:[NSDictionary 
                                           dictionaryWithObjectsAndKeys:NSLocalizedString(@"Could not create temporary directory", @""), 
                                           NSLocalizedDescriptionKey, nil]];
        return nil;
    }
    
    NSString *tempFolderString = [[NSFileManager defaultManager] 
                                  stringWithFileSystemRepresentation:tempFolder length:strlen(result)];
    free(tempFolder);
    
    return [NSURL URLWithString:tempFolderString];
}

@end
