//
//  WHMessage.m
//  WhatsApp History
//
//  Created by Stefan Graupner on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AddressBook/AddressBook.h>

#import "WHMessage.h"
#import "WHHistory.h"
#import "WHAttachment.h"

#import "NSDate+JSONFormat.h"

static NSImage *defaultImage;
static NSMutableDictionary *userImageCache;

@interface WHMessage ()
- (void)generateAttributedMessage;
- (void)lookupUserImage;
@end

@implementation WHMessage

@synthesize parent = _parent, originalMessage = _originalMessage, 
            timestamp = _timestamp, author = _author, 
            attributedMessage = _attributedMessage, userImage = _userImage,
            message = _message, attachment = _attachment;

+ (void)initialize
{
    userImageCache = [[NSMutableDictionary alloc] initWithCapacity:2];
    defaultImage = [[NSImage alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForImageResource:@"user"]];
}

- (id)initWithString:(NSString *)string
{
    self = [super init];
    if (self)
    {
        self.originalMessage = string;
        [self addObserver:self forKeyPath:@"message" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"author" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"message"];
    [self removeObserver:self forKeyPath:@"author"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"message"] && _message)
    {
        [self generateAttributedMessage];
    }
    if ([keyPath isEqualToString:@"author"] && _author)
    {
        [self lookupUserImage];
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
    if ([_message length] > 2 && [[_message substringWithRange:NSMakeRange(0, 2)] isEqualToString:@": "])
    {
        self.message = [_message substringFromIndex:2];
    }
    
    if (![_timestamp isKindOfClass:[NSDate class]])
    {
        _parent.message = [NSString stringWithFormat:@"%@\n%@", _parent.message, _originalMessage];
        _message = nil;
    }
}

- (NSDictionary *)serializableRepresentation
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [_timestamp JSONFormat], @"timestamp", 
            _author, @"author", 
            _message, @"message", nil];
}

- (void)generateAttributedMessage
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSFont controlContentFontOfSize:12.0], NSFontAttributeName, 
                                [NSColor blackColor], NSForegroundColorAttributeName, 
                                nil];
    self.attributedMessage = [[NSAttributedString alloc] initWithString:self.message 
                                                             attributes:attributes];
}

- (void)lookupUserImage
{
    if (![userImageCache objectForKey:_author])
    {
        NSString *firstName, *lastName;
        NSScanner *scanner = [NSScanner scannerWithString:_author];
        [scanner scanUpToString:@" " intoString:&firstName];
        lastName = ([_author length] > [scanner scanLocation]) ? [_author substringFromIndex:[scanner scanLocation] + 1]
        : _author;
        
        ABSearchElement *firstNameSearchElement = [ABPerson searchElementForProperty:kABFirstNameProperty 
                                                                               label:nil
                                                                                 key:nil
                                                                               value:firstName 
                                                                          comparison:kABPrefixMatchCaseInsensitive];
        ABSearchElement *lastNameSearchElement = [ABPerson searchElementForProperty:kABLastNameProperty 
                                                                              label:nil
                                                                                key:nil
                                                                              value:lastName
                                                                         comparison:kABSuffixMatchCaseInsensitive];
        ABSearchElement *searchName = [ABSearchElement searchElementForConjunction:kABSearchAnd 
                                                                          children:[NSArray arrayWithObjects:firstNameSearchElement, 
                                                                                    lastNameSearchElement, nil]];
        
        ABSearchElement *nicknameSearchElement = [ABPerson searchElementForProperty:kABNicknameProperty
                                                                              label:nil
                                                                                key:nil
                                                                              value:_author
                                                                         comparison:kABEqualCaseInsensitive];
        ABSearchElement *search = [ABSearchElement searchElementForConjunction:kABSearchOr 
                                                                      children:[NSArray arrayWithObjects:searchName,
                                                                                nicknameSearchElement, nil]];
        
        NSArray *found = [[ABAddressBook sharedAddressBook] recordsMatchingSearchElement:search];
        if ([found count] >= 1)
        {
            ABPerson *person = [found objectAtIndex:0];
            NSImage *image = [[NSImage alloc] initWithData:[person imageData]];
            [userImageCache setObject:image forKey:_author];
        } else 
        {
            [userImageCache setObject:defaultImage forKey:_author];
        }
    }
    
    self.userImage = [userImageCache objectForKey:_author];
}

@end
