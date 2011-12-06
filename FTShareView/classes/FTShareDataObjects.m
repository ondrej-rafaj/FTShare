//
//  FTShareDataObjects.m
//  IKEA_settings
//
//  Created by Francesco on 04/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTShareDataObjects.h"

#pragma mark Twitter Data Structure

#pragma mark Facebook Data Structure




@implementation FTShareFacebookGetData

@synthesize message = _message;
@synthesize readType;

- (id)init {
	self = [super init];
	if (self) {
		readType = FTShareFacebookGetDataReadTypeMePhotos;
	}
	return self;
}

- (BOOL)isRequestValid {
    BOOL isValidMessage = (self.message && [self.message length] > 0);
    BOOL isValidImage = YES;
    BOOL valid = (isValidMessage || isValidImage);
    if (!valid) NSLog(@"Facebook request seams not valid");
    return valid;
}

- (NSMutableDictionary *)dictionaryFromParams {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //if (self.message) [dict setObject:self.message forKey:@"message"];
    return dict;
}

- (void)dealloc {
    [_message release], _message = nil;
    [super dealloc];
}

@end


#pragma mark Mail Data Structure

@implementation FTShareMailData

@synthesize subject = _subject;
@synthesize plainBody = _plainBody;
@synthesize htmlBody = _htmlBody;
@synthesize attachments = _attachments;

- (id)init {
    self = [super init];
    if (self) {
        _attachments = [[NSMutableArray alloc] init];
    }
    return self;
}


- (BOOL)isRequestValid {
    BOOL isValidSubject = (self.subject && ([self.subject length] > 0));
    BOOL isPlain = (self.plainBody && ([self.plainBody length] > 0));
    BOOL isHtml = (self.htmlBody && ([self.htmlBody length] > 0));
    BOOL valid = (isValidSubject && ((isHtml && isPlain) || isPlain));
    if (!valid) NSLog(@"Mail requst eams not valid");
    return valid;
}

- (void)addAttachmentWithObject:(NSData *)data type:(NSString *)type andName:(NSString *)name {
    NSDictionary *dict = [NSDictionary 
                          dictionaryWithObjects:[NSArray arrayWithObjects:data, type, name, nil] 
                          forKeys:[NSArray arrayWithObjects:@"data", @"type", @"name", nil] ];
    [_attachments addObject:dict];
}

- (void)dealloc {
    
    [_subject release], _subject = nil;
    [_plainBody release], _plainBody = nil;
    [_htmlBody release], _htmlBody = nil;
    [_attachments release], _attachments = nil;
    [super dealloc];
}

@end
