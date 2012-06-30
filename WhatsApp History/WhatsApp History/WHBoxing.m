//
//  WHBoxing.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHBoxing.h"
#import "WHHistory.h"

#import "GRMustache.h"

@implementation WHBoxing

@synthesize templateSetURL = _templateSetURL, history = _history;

@synthesize attachmentHandlingMode;

- (id)initWithTemplateSetAtURL:(NSURL *)templateSetURL 
                      history:(WHHistory *)history
{
    self = [super init];
    if (self)
    {
        self.templateSetURL = templateSetURL;
        self.history = history;
        
        attachmentHandlingMode = WHInPlaceBoxingAttachmentHandlingMode;
    }
    return self;
}

- (BOOL)saveToURL:(NSURL *)saveURL error:(NSError *__autoreleasing *)error
{
    /*
      This method needs to be implemented in sub classes.
    */
    return NO;
}

- (void)applyTemplateSet
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSError *error;
    
    /*
        Template folder hierarchy
        -------------------------
     
        template_name/
            |- template.plist
            |- resources/
                |- message.mustache
                |- ...
     
        template.plist
        --------------
     
        meta data for each template file and required attachment handling strategy
    */
//    NSArray *templates = [fm contentsOfDirectoryAtURL:[NSURL URLWithString:@"resources/" relativeToURL:self.templateSetURL] 
//                           includingPropertiesForKeys:nil
//                                              options:NSDirectoryEnumerationSkipsHiddenFiles
//                                                error:&error];
    if (error)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:WHHistoryErrorNotification object:error];
    }
    
    [fm changeCurrentDirectoryPath:[self.templateSetURL relativePath]];
    
    NSURL *settingsURL = [NSURL URLWithString:@"template.plist" relativeToURL:self.templateSetURL];
    
    NSData *settingsData = [fm contentsAtPath:[settingsURL relativePath]];
    NSPropertyListFormat format = NSPropertyListXMLFormat_v1_0;
    
    NSString *errorDesc;
    NSDictionary *settings = (NSDictionary *)[NSPropertyListSerialization 
                                              propertyListFromData:settingsData 
                                              mutabilityOption:NSPropertyListImmutable 
                                              format:&format
                                              errorDescription:&errorDesc];
    NSLog(@"%@", settings);
}

#pragma mark Types

- (WHBoxingAttachmentHandlingMode)boxingAttachmentHandlingModeForString:(NSString *)handlingModeString
{
    if ([handlingModeString isEqualToString:@"inPlace"])
    {
        return WHInPlaceBoxingAttachmentHandlingMode;
    } 
    if ([handlingModeString isEqualToString:@"move"]) {
        return WHMoveBoxingAttachmentHandlingMode;
    } 
    if ([handlingModeString isEqualToString:@"delete"])
    {
        return WHDeleteBoxingAttachmentHandlingMode;
    }
    
    return WHUnknownBoxingAttachmentHandlingMode;
}

- (NSString *)stringForBoxingAttachmentHandlingMode:(WHBoxingAttachmentHandlingMode)handlingmode
{
    switch (handlingmode) {
        case WHInPlaceBoxingAttachmentHandlingMode:
            return @"inPlace";
            break;
            
        case WHMoveBoxingAttachmentHandlingMode:
            return @"move";
            break;
            
        case WHDeleteBoxingAttachmentHandlingMode:
            return @"delete";
            break;
            
        default:
            return nil;
            break;
    }
}

- (WHTemplateSaveStyle)templateSaveStyleForString:(NSString *)templateSaveStyleString
{
    if ([templateSaveStyleString isEqualToString:@"intermediate"])
    {
        return WHIntermediateTemplateSaveStyle;
    }
    
    if ([templateSaveStyleString isEqualToString:@"final"])
    {
        return WHFinalTemplateSaveStyle;
    }
    
    return WHUnknownTemplateSaveStyle;
}

- (NSString *)stringForTemplateSaveStyle:(WHTemplateSaveStyle)templateSaveStyle
{
    switch (templateSaveStyle) {
        case WHIntermediateTemplateSaveStyle:
            return @"intermediate";
            break;
            
        case WHFinalTemplateSaveStyle:
            return @"final";
            break;
            
        default:
            return nil;
            break;
    }
    
    return nil;
}

- (WHTemplateProcessingOrder)templateProcessingOrderForString:(NSString *)templateProcessingOrderString
{
    if ([templateProcessingOrderString isEqualToString:@"natural"])
    {
        return WHNaturalTemplateProcessingOrder;
    }
    
    if ([templateProcessingOrderString isEqualToString:@"first"])
    {
        return WHFirstTemplateProcessingOrder;
    }
    
    if ([templateProcessingOrderString isEqualToString:@"last"])
    {
        return WHLastTemplateProcessingOrder;
    }
    
    return WHUnknownTemplateProcessingOrder;
}

- (NSString *)stringForTemplateProcessingOrder:(WHTemplateProcessingOrder)templateProcessingOrder
{
    switch (templateProcessingOrder) {
        case WHNaturalTemplateProcessingOrder:
            return @"natural";
            break;
            
        case WHFirstTemplateProcessingOrder:
            return @"first";
            break;
            
        case WHLastTemplateProcessingOrder:
            return @"last";
            break;
            
        default:
            return nil;
            break;
    }
}

- (WHTemplateRepetitonFrequency)templateRepetitionFrequencyForString:(NSString *)templateRepetitionFrequencyString
{
    if ([templateRepetitionFrequencyString isEqualToString:@"once"])
    {
        return WHOnceTemplateRepetitionFrequency;
    }
    
    if ([templateRepetitionFrequencyString isEqualToString:@"each"])
    {
        return WHEachTemplateRepetitionFrequency;
    }
    
    return WHUnkownTemplateRepetitionFrequency;
}

- (NSString *)stringForTemplateRepetitionFrequency:(WHTemplateRepetitonFrequency)templateRepetitionFrequency
{
    switch (templateRepetitionFrequency) {
        case WHOnceTemplateRepetitionFrequency:
            return @"once";
            break;
            
        case WHEachTemplateRepetitionFrequency:
            return @"each";
            break;
            
        default:
            return nil;
            break;
    }
}

@end
