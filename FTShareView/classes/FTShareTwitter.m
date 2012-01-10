//
//  FTShareTwitter.m
//  FTShareView
//
//  Created by cescofry on 06/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTShareTwitter.h"

#pragma mark --
#pragma mark Data Type

@implementation FTShareTwitterData 

@synthesize message = _message;
@synthesize hasControllerSupport = _hasControllerSupport;

- (BOOL)isRequestValid {
    BOOL valid = (self.message && [self.message length] > 0);
    if (!valid) NSLog(@"Twitter request seams not valid");
    return valid;
}

- (void)dealloc {
    
    [_message release], _message = nil;
    [super dealloc];
}

@end


#pragma mark --
#pragma mark Class

@implementation FTShareTwitter

@synthesize twitterDelegate = _twitterDelegate;
@synthesize twitterParams = _twitterParams;

- (id)init {
    self = [super init];
    if (self) {
        _twitterDelegate = nil;
    }
    return self;
}

- (void)dealloc {
    _twitterDelegate = nil;
    _twitterParams = nil;
    [super dealloc];
}



// setting up twitter engine
- (void)setUpTwitterWithConsumerKey:(NSString *)consumerKey secret:(NSString *)secret referencedController:(id)referencedController andDelegate:(id<FTShareTwitterDelegate>)delegate {
    _twitter = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
    _referencedController = referencedController;
    self.twitterDelegate = delegate;
    _twitter.consumerKey = consumerKey;  
    _twitter.consumerSecret = secret;
    [_twitter clearAccessToken];
    _twitterParams = nil;
}

- (void)shareViaTwitter:(FTShareTwitterData *)data {
    if (![data isRequestValid] || [data hasControllerSupport]) {
        if (self.twitterDelegate && [self.twitterDelegate respondsToSelector:@selector(twitterData)]) {
            data = [self.twitterDelegate twitterData];
            if (![data isRequestValid] || [data hasControllerSupport]) {
                FTShareMessageController *messageController = [[FTShareMessageController alloc] initWithMessage:data.message type:FTShareMessageControllerTypeTwitter andelegate:self];
                UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:messageController];
                [_referencedController presentModalViewController:nc animated:YES];
                return;
            }
        }
        
    }
    _twitterParams = [data retain];
    if(![_twitter isAuthorized]){  
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_twitter delegate:self];  
        
        if (controller && _referencedController){  
            [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [(UIViewController *)_referencedController presentModalViewController:controller animated:YES];
        }
    }
    else {
        if (![_twitterParams isRequestValid]) return;
        [_twitter sendUpdate:_twitterParams.message];
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
    
    _twitter = nil;
    self.twitterDelegate = nil;
    self.twitterDelegate = nil;
}  

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {  
    NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
    if ([self.twitterDelegate respondsToSelector:@selector(twitterDidPost:)]) {
        [self.twitterDelegate twitterDidPost:error];
    }
    
    _twitter = nil;
    self.twitterDelegate = nil;
    self.twitterDelegate = nil;
}

#pragma mark Twitter login

- (void)OAuthTwitterController:(SA_OAuthTwitterController *)controller authenticatedWithUsername:(NSString *)username {
    if ([self.twitterDelegate respondsToSelector:@selector(twitterDidLogin:)]) {
        [self.twitterDelegate twitterDidLogin:nil];
    }
    [self shareViaTwitter:_twitterParams];
}

- (void)OAuthTwitterControllerFailed:(SA_OAuthTwitterController *)controller {
    NSError *error = [NSError errorWithDomain:@"com.fuerteint.FTShare" code:400 userInfo:[NSDictionary dictionaryWithObject:@"Couldn't share with twitter" forKey:@"description"]];
    if ([self.twitterDelegate respondsToSelector:@selector(twitterDidLogin:)]) {
        [self.twitterDelegate twitterDidLogin:error];
    }
    
    _twitter = nil;
    self.twitterDelegate = nil;
    self.twitterDelegate = nil;
}

- (void)OAuthTwitterControllerCanceled:(SA_OAuthTwitterController *)controller {
    NSError *error = [NSError errorWithDomain:@"com.fuerteint.FTShare" code:400 userInfo:[NSDictionary dictionaryWithObject:@"Twitter Controller Canceled" forKey:@"description"]];
    if ([self.twitterDelegate respondsToSelector:@selector(twitterDidLogin:)]) {
        [self.twitterDelegate twitterDidLogin:error];
    }
    
    _twitter = nil;
    self.twitterDelegate = nil;
    self.twitterDelegate = nil;
}

#pragma mark sharemessagcontroller delgate

- (void)shareMessageController:(FTShareMessageController *)controller didFinishWithMessage:(NSString *)message {

}

-(void)shareMessageController:(FTShareMessageController *)controller didDisappearWithMessage:(NSString *)message {
    if (!message || message.length == 0) return;
    FTShareTwitterData *data = [[FTShareTwitterData alloc] init];
    [data setMessage:message];
    [data setHasControllerSupport:NO];
    [self shareViaTwitter:data];    
}

- (void)shareMessageControllerDidCancel:(FTShareMessageController *)controller {
    
}

@end
