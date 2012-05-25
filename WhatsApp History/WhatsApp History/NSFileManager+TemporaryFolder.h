//
//  NSFileManager+TemporaryFolder.h
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (TemporaryFolder)

- (NSURL *)temporaryFolderWithBaseName:(NSString *)baseName error:(NSError **)error;

@end
