//
//  FTShare.m
//  IKEA_settings
//
//  Created by cescofry on 28/09/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTShare.h"
#import "FTLang.h"

@implementation FTShare

@synthesize facebook = _facebook;
@synthesize twitter = _twitter;
@synthesize twitterDelegate = _twitterDelegate;
@synthesize facebookDelegate = _facebookDelegate;
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
        _twitterParams = nil;
        _twitterDelegate = nil;
        
        _facebookParams = nil;
        _facebookGetParams = nil;
		_facebookGetParams = nil;
        _facebookDelegate = nil;
    }
    
    return self;
}

#pragma mark Memory management

- (void)dealloc {
    [_facebook release], _facebook = nil;
    [_twitter release], _twitter = nil;
    _twitterDelegate = nil;
    _facebookDelegate = nil;
    _mailDelegate = nil;
    _referencedController = nil;
    [_facebookParams release], _facebookParams = nil;
	[_facebookGetParams release], _facebookGetParams = nil;
    [_twitterParams release], _twitterParams = nil;
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

#pragma mark --
#pragma mark Twitter

// setting up twitter engine
- (void)setUpTwitterWithConsumerKey:(NSString *)consumerKey secret:(NSString *)secret andDelegate:(id<FTShareTwitterDelegate>)delegate {
    _twitter = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
    self.twitterDelegate = delegate;
    self.twitter.consumerKey = consumerKey;  
    self.twitter.consumerSecret = secret;
    [self.twitter clearAccessToken];
    self.twitterParams = nil;
}

- (void)shareViaTwitter:(FTShareTwitterData *)data {
    self.twitterParams = data;
    if(![self.twitter isAuthorized]){  
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:self.twitter delegate:self];  
        
        if (controller && self.referencedController){  
            [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [(UIViewController *)self.referencedController presentModalViewController:controller animated:YES];
        }
    }
    else {
        if (![self.twitterParams isRequestValid]) return;
        [self.twitter sendUpdate:self.twitterParams.message];
    }
}

#pragma mark SA_OAuthTwitterEngineDelegate 

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    
    [defaults setObject: data forKey: @"twitterAuthData"];  
    [defaults synchronize];  
}

- (void)clearCachedTwitterOAuthData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    
    [defaults setObject: nil forKey: @"twitterAuthData"];  
    [defaults synchronize];     
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {  
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"twitterAuthData"];  
}

#pragma mark TwitterEngineDelegate  
- (void) requestSucceeded: (NSString *) requestIdentifier {  
    NSLog(@"Request %@ succeeded", requestIdentifier); 
    if ([self.twitterDelegate respondsToSelector:@selector(twitterDidPost:)]) {
        [self.twitterDelegate twitterDidPost:nil];
    }
    
    self.twitter = nil;
    self.twitterDelegate = nil;
    self.twitterDelegate = nil;
}  

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {  
    NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
    if ([self.twitterDelegate respondsToSelector:@selector(twitterDidPost:)]) {
        [self.twitterDelegate twitterDidPost:error];
    }
    
    self.twitter = nil;
    self.twitterDelegate = nil;
    self.twitterDelegate = nil;
}

#pragma mark Twitter login

- (void)OAuthTwitterController:(SA_OAuthTwitterController *)controller authenticatedWithUsername:(NSString *)username {
    if ([self.twitterDelegate respondsToSelector:@selector(twitterDidLogin:)]) {
        [self.twitterDelegate twitterDidLogin:nil];
    }
    [self shareViaTwitter:self.twitterParams];
}

- (void)OAuthTwitterControllerFailed:(SA_OAuthTwitterController *)controller {
    NSError *error = [NSError errorWithDomain:@"com.fuerteint.FTShare" code:400 userInfo:[NSDictionary dictionaryWithObject:@"Couldn't share with twitter" forKey:@"description"]];
    if ([self.twitterDelegate respondsToSelector:@selector(twitterDidLogin:)]) {
        [self.twitterDelegate twitterDidLogin:error];
    }
    
    self.twitter = nil;
    self.twitterDelegate = nil;
    self.twitterDelegate = nil;
}

- (void)OAuthTwitterControllerCanceled:(SA_OAuthTwitterController *)controller {
    NSError *error = [NSError errorWithDomain:@"com.fuerteint.FTShare" code:400 userInfo:[NSDictionary dictionaryWithObject:@"Twitter Controller Canceled" forKey:@"description"]];
    if ([self.twitterDelegate respondsToSelector:@selector(twitterDidLogin:)]) {
        [self.twitterDelegate twitterDidLogin:error];
    }
    
    self.twitter = nil;
    self.twitterDelegate = nil;
    self.twitterDelegate = nil;
}

/**
 *
 * Facebook Section
 *
 */

#pragma mark --
#pragma mark Facebook

- (void)setUpFacebookWithAppID:(NSString *)appID andDelegate:(id<FTShareFacebookDelegate>)delegate {
    _facebook = [[Facebook alloc] initWithAppId:appID andDelegate:self];
    self.facebookDelegate = delegate;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:appID forKey:@"FTShareFBAppID"];
    [defaults synchronize];
    
	if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
	}
    self.facebookParams = nil;
	NSLog(@"Facebook expiration date: %@", self.facebook.expirationDate);
}

- (void)facebookLogin {
	[self.facebook authorize:[NSArray arrayWithObjects:@"offline_access", @"read_stream", @"read_friendlists", @"read_insights", @"user_about_me", nil]];
}

- (void)facebookPublishLogin {
	[self.facebook authorize:[NSArray arrayWithObjects:@"publish_stream", nil]];
}

- (void)shareViaFacebook:(FTShareFacebookData *)data {
    self.facebookParams = data;
    if (![self.facebook isSessionValid]) {
        [self facebookPublishLogin];
    }
    else {
        if (![self.facebookParams isRequestValid]) return;
        UIImage *img = self.facebookParams.uploadImage;
        if (img && [img isKindOfClass:[UIImage class]]) {
            [self.facebook requestWithGraphPath:@"me/photos" andParams:[self.facebookParams dictionaryFromParams] andHttpMethod:@"POST" andDelegate:self];
        }
        else {
            [self.facebook dialog:@"feed" andParams:[self.facebookParams dictionaryFromParams] andDelegate:self]; 
        }
    }
}

- (void)getFacebookData:(FTShareFacebookGetData *)data withDelegate:(id <FBRequestDelegate>)delegate {
	self.facebookGetParams = data;
	if (![self.facebook isSessionValid]) {
        [self facebookLogin];
    }
    else {
        //if (![self.facebookParams isRequestValid]) return;
        [self.facebook requestWithGraphPath:@"me/friends" andParams:[self.facebookGetParams dictionaryFromParams] andHttpMethod:@"POST" andDelegate:self];
	}
}

#pragma mark Facebook dialog

- (void)dialogDidComplete:(FBDialog *)dialog {
	if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidPost:)]) {
        [self.facebookDelegate facebookDidPost:nil];
    }
    
    self.facebook = nil;
    self.facebookDelegate = nil;
    self.facebookParams = nil;
}

- (void)dialogDidNotComplete:(FBDialog *)dialog {
    NSDictionary *dict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:FTLangGet(@"Unknown error occured"), nil] forKeys:[NSArray arrayWithObjects:@"description", nil]];
    NSError *error= [NSError errorWithDomain:@"com.fuerte.FTShare" code:400 userInfo:dict];
    if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidPost:)]) {
        [self.facebookDelegate facebookDidPost:error];
    }
    
    self.facebook = nil;
    self.facebookDelegate = nil;
    self.facebookParams = nil;
}

#pragma mark Facebook login

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    NSLog(@"%@ %@", self.facebook.accessToken, self.facebook.expirationDate.description);
    
	
    if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidLogin:)]) {
        [self.facebookDelegate facebookDidLogin:nil];
    }
    
    if (self.facebookParams) {
        [self shareViaFacebook:self.facebookParams];
    }
    
}

-(void)fbDidNotLogin:(BOOL)cancelled {
    NSDictionary *dict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:@"Couldn't login with facebook", [NSNumber numberWithBool:cancelled], nil]
                                                     forKeys:[NSArray arrayWithObjects:@"description", @"cancelled", nil]];
    NSError *error= [NSError errorWithDomain:@"com.fuerte.FTShare" code:400 userInfo:dict];
    if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidLogin:)]) {
        [self.facebookDelegate facebookDidLogin:error];
    }
    
    self.facebook = nil;
    self.facebookDelegate = nil;
    self.facebookParams = nil;
}

#pragma mark Using Offline access

- (BOOL)canUseOfflineAccess {
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"FTShareCanUseOfflineAccess"];
}

- (void)setCanUseOfflineAccess:(BOOL)offline {
	[[NSUserDefaults standardUserDefaults] setBool:offline forKey:@"FTShareCanUseOfflineAccess"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Facebook request delegate

- (void)request:(FBRequest *)request didLoad:(id)result {
	NSLog(@"FB Result: %@", result);
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"FB Result: %@", response);
    if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidPost:)]) {
        [self.facebookDelegate facebookDidPost:nil];
    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"FB Result: %@", error);
    if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidPost:)]) {
        [self.facebookDelegate facebookDidPost:error];
    }
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
        if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookShareData)]) {
            FTShareFacebookData *data = [self.facebookDelegate facebookShareData];
            if (!data) return;
            [self shareViaFacebook:data];
        }
    }
    else  if ([btnText isEqualToString:@"Twitter"]) {
        //implement Twitter
        if (self.twitterDelegate && [self.twitterDelegate respondsToSelector:@selector(twitterData)]) {
            FTShareTwitterData *data = [self.twitterDelegate twitterData];
            [self shareViaTwitter:data];
        }
    }
}


@end
