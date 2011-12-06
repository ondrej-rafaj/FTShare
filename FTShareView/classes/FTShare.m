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



@synthesize referencedController = _referencedController;


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
        
        _emailEngine = [[FTShareEmail alloc] init];
    }
    
    return self;
}

#pragma mark Memory management

- (void)dealloc {
    [_facebookEngine release], _facebookEngine = nil;
    [_twitterEngine release], _twitterEngine = nil;
    [_emailEngine release], _emailEngine = nil;
    
    _referencedController = nil;
    [super dealloc];
}



#pragma mark Twitter section

- (void)setUpTwitterWithConsumerKey:(NSString *)consumerKey secret:(NSString *)secret andDelegate:(id<FTShareTwitterDelegate>)delegate {
    [_twitterEngine setUpTwitterWithConsumerKey:consumerKey secret:secret referencedController:_referencedController andDelegate:delegate];
}

- (void)shareViaTwitter:(FTShareTwitterData *)data {
    [_twitterEngine shareViaTwitter:data];
}


#pragma mark Facebook section

- (void)setUpFacebookWithAppID:(NSString *)appID permissions:(FTShareFacebookPermission)permissions andDelegate:(id<FTShareFacebookDelegate>)delegate {
    [_facebookEngine setUpFacebookWithAppID:appID referencedController:_referencedController andDelegate:delegate];
    self.facebook = _facebookEngine.facebook;
    [_facebookEngine setUpPermissions:permissions];
}

- (void)shareViaFacebook:(FTShareFacebookData *)data {
    [_facebookEngine shareViaFacebook:data];
}

#pragma mark Email section

- (void)setUpEmailWithDelegate:(id<FTShareEmailDelegate>)delegate {
    [_emailEngine setUpEmailWithRefencedController:_referencedController andDlelegate:delegate];
}

- (void)shareViaEmail:(FTShareEmailData *)data {
    [_emailEngine shareViaMail:data];
}





#pragma mark --
#pragma mark UIActionSheet

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

#pragma mark ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *btnText = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([btnText isEqualToString:@"Mail"]) {
        //implement mail
        [_emailEngine shareViaMail:nil];
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
