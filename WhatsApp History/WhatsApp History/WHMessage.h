//
//  WHMessage.h
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHMessage : NSObject

@property (readwrite, copy) NSString *messageText;

- initWithString:(NSString *)string;

@end
