//
//  WHBoxing.h
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum WHBoxingAttachmentHandlingMode_enum {
    WHMoveBoxingAttachmentHandlingMode, 
    WHDeleteBoxingAttachmentHandlingMode, 
    WHInPlaceBoxingAttachmentHandlingMode,
    
    WHUnknownBoxingAttachmentHandlingMode
} WHBoxingAttachmentHandlingMode;

typedef enum WHTemplateSaveStyle_enum {
    WHIntermediateTemplateSaveStyle,
    WHFinalTemplateSaveStyle,
    
    WHUnknownTemplateSaveStyle
} WHTemplateSaveStyle;

typedef enum WHTemplateProcessingOrder_enum {
    WHNaturalTemplateProcessingOrder,
    WHFirstTemplateProcessingOrder,
    WHLastTemplateProcessingOrder,
    
    WHUnknownTemplateProcessingOrder
} WHTemplateProcessingOrder;

typedef enum WHTemplateRepetitionFrequency_enum {
    WHOnceTemplateRepetitionFrequency,
    WHEachTemplateRepetitionFrequency,
    
    WHUnkownTemplateRepetitionFrequency
} WHTemplateRepetitonFrequency;

@class WHHistory;

@interface WHBoxing : NSObject

@property (readwrite, retain) WHHistory *history;
@property (readwrite, retain) NSURL   *templateSetURL;

@property (readwrite, assign) WHBoxingAttachmentHandlingMode attachmentHandlingMode;

- (id)initWithTemplateSetAtURL:(NSURL *)templateSetURL history:(WHHistory *)history;

- (BOOL)saveToURL:(NSURL *)saveURL error:(NSError *__autoreleasing *)error;
- (void)applyTemplateSet;

- (WHBoxingAttachmentHandlingMode)boxingAttachmentHandlingModeForString:(NSString *)handlingModeString;
- (NSString *)stringForBoxingAttachmentHandlingMode:(WHBoxingAttachmentHandlingMode)handlingmode;
- (WHTemplateSaveStyle)templateSaveStyleForString:(NSString *)templateSaveStyleString;
- (NSString *)stringForTemplateSaveStyle:(WHTemplateSaveStyle)templateSaveStyle;
- (WHTemplateProcessingOrder)templateProcessingOrderForString:(NSString *)templateProcessingOrderString;
- (NSString *)stringForTemplateProcessingOrder:(WHTemplateProcessingOrder)templateProcessingOrder;
- (WHTemplateRepetitonFrequency)templateRepetitionFrequencyForString:(NSString *)templateRepetitionFrequencyString;
- (NSString *)stringForTemplateRepetitionFrequency:(WHTemplateRepetitonFrequency)templateRepetitionFrequency;

@end
