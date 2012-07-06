//
//  WHPreviewViewTableViewCell.h
//  WhatsApp History
//
//  Created by Stefan Graupner on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "WHMessage.h"
#import "WHPreviewViewMessageView.h"

@interface WHPreviewViewTableCellView : NSTableCellView

@property (assign) IBOutlet NSTextField *userName;
@property (assign) IBOutlet NSTextField *timestamp;
@property (assign) IBOutlet NSImageCell *userImage;
@property (assign) IBOutlet WHPreviewViewMessageView *messageView;

@end
