//
//  WHMessage.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WHMessage.h"
#import "WHHistory.h"
#import "WHAttachment.h"

#import "NSDate+JSONFormat.h"

@implementation WHMessage

@synthesize parent = _parent, originalMessage = _originalMessage, 
            timestamp = _timestamp, author = _author, 
            attributedMessage = _attributedMessage,
            message = _message, attachment = _attachment;

- (id)initWithString:(NSString *)string
{
    self = [super init];
    if (self)
    {
        self.originalMessage = string;
        [self addObserver:self forKeyPath:@"message" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"message"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (_message)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSFont controlContentFontOfSize:12.0], NSFontAttributeName, 
                                    [NSColor blackColor], NSForegroundColorAttributeName, 
                                    nil];
        self.attributedMessage = [[NSAttributedString alloc] initWithString:self.message 
                                                                 attributes:attributes];
    }
}

- (void)process
{
    [WHHistory message:[NSString stringWithFormat:NSLocalizedString(@"Processing \"%@\"", @""), _originalMessage]];
    NSScanner *scanner = [NSScanner scannerWithString:_originalMessage];
    
    NSString *dateString1, *dateString2;
    
    [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&dateString1];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&dateString2];
    
    NSString *author;
    [scanner scanUpToString:@": " intoString:&author];
    self.author = author;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:NSLocalizedString(@"dd/MM/yyyy HH:mm:ss:", @"Message Date Format")];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setLocale:[NSLocale currentLocale]]; // maybe use systemLocale here?
    _timestamp = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", 
                                            dateString1, dateString2]];
    
    self.message = [_originalMessage substringFromIndex:[scanner scanLocation]];
}

- (NSDictionary *)serializableRepresentation
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [_timestamp JSONFormat], @"timestamp", 
            _author, @"author", 
            _message, @"message", nil];
}

@end
