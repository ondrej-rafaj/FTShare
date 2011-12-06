//
//  FTShare.m
//  IKEA_settings
//
//  Created by cescofry on 28/09/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTShare.h"

@implementation FTShare

@synthesize facebook;

@synthesize mailDelegate = _mailDelegate;

@synthesize referencedController = _referencedController;
@synthesize facebookParams = _facebookParams;
@synthesize facebookGetParams = _facebookGetParams;
@synthesize twitterParams = _twitterParams;


#pragma mark Initialization

- (id)initWithReferencedController:(id)controller
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [self setReferencedController:controller];
        _twitterEngine = [[FTShareTwitter alloc] init];
        _facebookEngine = [[FTShareFacebook alloc] init];
        self.facebook = nil;
    }
    
    return self;
}

#pragma mark Memory management

- (void)dealloc {
    [_facebookEngine release], _facebookEngine = nil;
    [_twitterEngine release], _twitterEngine = nil;
    
    
    _mailDelegate = nil;
    _referencedController = nil;
    [super dealloc];
}

/**
 * Use this method, then implement the delegates
 */

- (void)showActionSheetWithtitle:(NSString *)title andOptions:(FTShareOptions)options {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:title 
                                  delegate:self 
                                  cancelButtonTitle:nil 
                                  destructiveButtonTitle:nil 
                                  otherButtonTitles:nil];
    int index = 0;
    if (options & FTShareOptionsMail) {
        [actionSheet addButtonWithTitle:@"Mail"];
        index++;
    }
    if (options & FTShareOptionsFacebook){
        [actionSheet addButtonWithTitle:@"Facebook"];
        index++;
    } 
    if (options & FTShareOptionsTwitter){
        [actionSheet addButtonWithTitle:@"Twitter"];
        index++;
    }
    
    [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet setCancelButtonIndex:index];
    
    [actionSheet showInView:[(UIViewController *)self.referencedController view]];
    [actionSheet release];
}


/**
 *
 * Twitter Section
 *
 */

- (void)setUpTwitterWithConsumerKey:(NSString *)consumerKey secret:(NSString *)secret andDelegate:(id<FTShareTwitterDelegate>)delegate {
    [_twitterEngine setUpTwitterWithConsumerKey:consumerKey secret:secret referencedController:_referencedController andDelegate:delegate];
}


/**
 *
 * Facebook Section
 *
 */

- (void)setUpFacebookWithAppID:(NSString *)appID permissions:(FTShareFacebookPermission)permissions andDelegate:(id<FTShareFacebookDelegate>)delegate {
    [_facebookEngine setUpFacebookWithAppID:appID referencedController:_referencedController andDelegate:delegate];
    self.facebook = _facebookEngine.facebook;
    [_facebookEngine setUpPermissions:permissions];
}



/**
 *
 * Mail Section
 *
 */

#pragma mark --
#pragma mark Mail
- (void)shareViaMail:(FTShareMailData *)data {
    if (![data isRequestValid]) return;

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
    
    

	if(mc) [self.referencedController presentModalViewController:mc animated:YES];
	[mc release];  
}


#pragma mark Mail controller delegates
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
   
    if (self.mailDelegate && [self.mailDelegate respondsToSelector:@selector(mailSent:)]) {
        [self.mailDelegate mailSent:result];
    }
    [controller dismissModalViewControllerAnimated:YES];
}
 

#pragma mark --
#pragma mark UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *btnText = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([btnText isEqualToString:@"Mail"]) {
        //implement mail
        if (self.mailDelegate && [self.mailDelegate respondsToSelector:@selector(mailShareData)]) {
            FTShareMailData *data = [self.mailDelegate mailShareData];
            if (!data) return;
            [self shareViaMail:data];
        }
    }
    else  if ([btnText isEqualToString:@"Facebook"]) {
        //implement FAcebook
        [_facebookEngine shareViaFacebook:nil];
    }
    else  if ([btnText isEqualToString:@"Twitter"]) {
        //implement Twitter
        [_twitterEngine shareViaTwitter:nil];
    }
}


@end
