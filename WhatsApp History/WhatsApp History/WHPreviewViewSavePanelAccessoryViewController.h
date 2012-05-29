//
//  WHPreviewViewSavePanelAccessoryViewController.h
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WHPreviewViewSavePanelAccessoryViewController : NSViewController <NSComboBoxDataSource>

@property (readwrite, copy) NSArray *availableFileTypes;

@property (readwrite, assign) IBOutlet NSComboBox *fileType;

@end
