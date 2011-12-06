//
//  FTShareEmail.h
//  FTShareView
//
//  Created by cescofry on 06/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

#pragma mark --
#pragma mark Data Type

@interface FTShareEmailData : NSObject {
    NSString *_subject;
    NSString *_plainBody;
    NSString *_htmlBody;
@private
    NSMutableArray *_attachments;
}

@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *plainBody;
@property (nonatomic, retain) NSString *htmlBody;
@property (nonatomic, readonly, retain) NSMutableArray *attachments;

- (void)addAttachmentWithObject:(id)obj type:(NSString *)type andName:(NSString *)name;
- (BOOL)isRequestValid;

@end


#pragma mark --
#pragma mark Class

@protocol FTShareEmailDelegate;
@interface FTShareEmail : NSObject <MFMailComposeViewControllerDelegate, MFMailComposeViewControllerDelegate> {
    id <FTShareEmailDelegate> _mailDelegate;
    id _referencedController;
}

@property (nonatomic, assign) id<FTShareEmailDelegate> mailDelegate;

- (void)setUpEmailWithRefencedController:(id)controller andDlelegate:(id<FTShareEmailDelegate>)delegate;
- (void)shareViaMail:(FTShareEmailData *)data;

@end


#pragma mark --
#pragma mark Delegate

@protocol FTShareEmailDelegate <NSObject>

@optional

- (FTShareEmailData *)mailShareData;
- (void)mailSent:(MFMailComposeResult)result;

@end
