//
//  FTShareEmail.m
//  FTShareView
//
//  Created by cescofry on 06/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTShareEmail.h"

#pragma mark --
#pragma mark Data Type

@implementation FTShareEmailData

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


#pragma mark --
#pragma mark Class

@implementation FTShareEmail

@synthesize mailDelegate = _mailDelegate;

#pragma mark --
#pragma mark Mail


- (void)setUpEmailWithRefencedController:(id)controller andDlelegate:(id<FTShareEmailDelegate>)delegate {
    _referencedController = controller;
    self.mailDelegate = delegate;
}

- (void)shareViaMail:(FTShareEmailData *)data {
    if (![data isRequestValid]) {
        if (self.mailDelegate && [self.mailDelegate respondsToSelector:@selector(mailShareData)]) {
            data = [self.mailDelegate mailShareData];      
            if (![data isRequestValid]) [NSException raise:@"Mail cannot post empy data" format:nil];
        }
        
    }
    
	MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init]; 
	mc.mailComposeDelegate = self;  
	
	[mc setSubject:data.subject];  
	
	[mc setMessageBody:data.plainBody isHTML:NO];
    if (data.htmlBody && [data.htmlBody length] > 0) {
        [mc setMessageBody:data.htmlBody isHTML:YES];
    }
	
    if (data.attachments && [data.attachments count] > 0) {
        for (NSDictionary *dict in data.attachments) {
            NSData *data = [dict objectForKey:@"data"];
            NSString *type = [dict objectForKey:@"type"];
            NSString *name = [dict objectForKey:@"name"];
            [mc addAttachmentData:data mimeType:type fileName:name];
        }
    }
	
	[mc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    
    
	if(mc) [_referencedController presentModalViewController:mc animated:YES];
	[mc release];  
}


#pragma mark Mail controller delegates
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    if (self.mailDelegate && [self.mailDelegate respondsToSelector:@selector(mailSent:)]) {
        [self.mailDelegate mailSent:result];
    }
    [controller dismissModalViewControllerAnimated:YES];
}

@end
