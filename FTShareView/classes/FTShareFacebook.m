//
//  FTShareFacebook.m
//  FTShareView
//
//  Created by cescofry on 06/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTShareFacebook.h"

#pragma mark --
#pragma mark Data Type

@implementation FTShareFacebookData

@synthesize message = _message;
@synthesize link = _link;
@synthesize name = _name;
@synthesize caption = _caption;
@synthesize picture = _picture;
@synthesize description = _description;
@synthesize uploadImage = _uploadImage;
@synthesize type = _type;
@synthesize httpType = _httpType;



- (BOOL)isRequestValid {
    BOOL isValidMessage = (self.message && [self.message length] > 0);
    BOOL isValidImage = (!self.uploadImage || (self.uploadImage && !CGSizeEqualToSize(self.uploadImage.size, CGSizeZero)));
    BOOL valid = (isValidMessage || isValidImage);
    if (!valid) NSLog(@"Facebook request seams not valid");
    return valid;
}

- (NSMutableDictionary *)dictionaryFromParams {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.message) [dict setObject:self.message forKey:@"message"];
    if (self.link) [dict setObject:self.link forKey:@"link"];
	if (self.name) [dict setObject:self.name forKey:@"name"];
    if (self.caption) [dict setObject:self.caption forKey:@"caption"];
    if (self.picture) [dict setObject:self.picture forKey:@"picture"];
    if (self.description) [dict setObject:self.description forKey:@"description"];
    if (self.uploadImage && !CGSizeEqualToSize(self.uploadImage.size, CGSizeZero)) [dict setObject:self.uploadImage forKey:@"uploadImage"];
    
    return dict;
}

- (NSString *)graphPathForType {
    NSString *path;
    switch (self.type) {
        case FTShareFacebookRequestTypePost:
            path = @"me/feed";
            break;
        case FTShareFacebookRequestTypeAlbum:
            path = @"me/photos";
            break;
        case FTShareFacebookRequestTypeFriends:
            path = @"me/friends";
            break;
        case FTShareFacebookRequestTypeOther:
        default:
            path = nil; // leave nill as delegate will fill with path
            break;
    }
    return path;
}

- (NSString *)graphHttpTypeString {
    NSString *path;
    switch (self.httpType) {
        case FTShareFacebookHttpTypeGet:
            path = @"GET";
            break;
        case FTShareFacebookHttpTypePost:
            path = @"POST";
            break;
        case FTShareFacebookHttpTypeDelete:
            path = @"DELETE";
            break;
        default:
            path = nil; // leave nill as delegate will fill with path
            break;
    }
    return path;    
}

- (void)dealloc {
    
    [_message release], _message = nil;
    [_link release], _link = nil;
    [_name release], _name = nil;
    [_caption release], _caption = nil;
    [_picture release], _picture = nil;
    [_description release], _description = nil;
    [_uploadImage release], _uploadImage = nil;
    [super dealloc];
}

@end



#pragma mark --
#pragma mark Class

@implementation FTShareFacebook

@synthesize facebook = _facebook;
@synthesize facebookDelegate = _facebookDelegate;

- (void)setUpFacebookWithAppID:(NSString *)appID referencedController:(id)referencedController andDelegate:(id<FTShareFacebookDelegate>)delegate {
    
    _facebook = [[Facebook alloc] initWithAppId:appID andDelegate:self];
    self.facebookDelegate = delegate;
    _referencedController = referencedController;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:appID forKey:@"FTShareFBAppID"];
    [defaults synchronize];
    
	if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        _facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        _facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
	}
    _params = nil;
	// NSLog(@"Facebook expiration date: %@", _facebook.expirationDate);
}


- (void)setUpPermissions:(FTShareFacebookPermission)permission {
    NSMutableArray *options = [NSMutableArray array];
   
    if (permission & FTShareFacebookPermissionRead) {
        [options addObjectsFromArray:[NSArray arrayWithObjects:@"offline_access", @"read_stream", @"read_friendlists", @"read_insights", @"user_about_me", nil]];
    }
    if (permission & FTShareFacebookPermissionPublish){
        [options addObject:@"publish_stream"];
    } 
    
    if ([options count] > 0) {
        _permissions = nil;
        _permissions = (NSArray *) options;   
    }
}


- (void)authorize {
    [_facebook authorize:_permissions];
}


#pragma mark Requests


- (void)shareViaFacebook:(FTShareFacebookData *)data {
    if (![data isRequestValid]) {
        if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookShareData)]) {
            data = [self.facebookDelegate facebookShareData];
            if (![data isRequestValid]) [NSException raise:@"Facebook cannot post empy data" format:nil];
        }
    }
    _params = data;
    if (![_facebook isSessionValid]) {
        [self authorize];
    }
    
    // check http method
    NSString *httpMethod = [_params graphHttpTypeString];
    
    //check path
    NSString *path = [_params graphPathForType];
    if (!path) {
        if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookPathForRequestofMethodType:)]) {
            path = [self.facebookDelegate facebookPathForRequestofMethodType:&httpMethod];
            if (!path) [NSException raise:@"Facebook request with not type will have no path either" format:nil];
        }
    }
    
    [_facebook requestWithGraphPath:path andParams:[_params dictionaryFromParams] andHttpMethod:httpMethod andDelegate:self];
    
}




- (void)getFacebookData:(NSString *)message ofType:(FTShareFacebookRequestType)type withDelegate:(id <FBRequestDelegate>)delegate {
	_params = nil;
    _params.message = message;
    _params.type = type;
	if (![self.facebook isSessionValid]) {
        [self authorize];
    }
    else {
        [self.facebook requestWithGraphPath:@"me/friends" andParams:[_params dictionaryFromParams] andHttpMethod:@"POST" andDelegate:self];
	}
}


#pragma mark Facebook dialog

/*
#warning DEPRECATED!
- (void)dialogDidComplete:(FBDialog *)dialog {
	if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidPost:)]) {
        [self.facebookDelegate facebookDidPost:nil];
    }
    
    _facebook = nil;
    self.facebookDelegate = nil;
    _params = nil;
}

- (void)dialogDidNotComplete:(FBDialog *)dialog {
    NSDictionary *dict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:@"Unknown error occured", nil] forKeys:[NSArray arrayWithObjects:@"description", nil]];
    NSError *error= [NSError errorWithDomain:@"com.fuerte.FTShare" code:400 userInfo:dict];
    if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidPost:)]) {
        [self.facebookDelegate facebookDidPost:error];
    }
    
    _facebook = nil;
    self.facebookDelegate = nil;
    _params = nil;
}

*/
 
 
#pragma mark Facebook login

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[_facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[_facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    NSLog(@"%@ %@", _facebook.accessToken, _facebook.expirationDate.description);
    
	
    if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidLogin:)]) {
        [self.facebookDelegate facebookDidLogin:nil];
    }
    
    if (_params) {
        [self shareViaFacebook:_params];
    }
    
}

-(void)fbDidNotLogin:(BOOL)cancelled {
    NSDictionary *dict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:@"Couldn't login with facebook", [NSNumber numberWithBool:cancelled], nil]
                                                     forKeys:[NSArray arrayWithObjects:@"description", @"cancelled", nil]];
    NSError *error= [NSError errorWithDomain:@"com.fuerte.FTShare" code:400 userInfo:dict];
    if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidLogin:)]) {
        [self.facebookDelegate facebookDidLogin:error];
    }
    
    _facebook = nil;
    self.facebookDelegate = nil;
    _params = nil;
}

/*
#pragma mark Using Offline access

- (BOOL)canUseOfflineAccess {
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"FTShareCanUseOfflineAccess"];
}

- (void)setCanUseOfflineAccess:(BOOL)offline {
	[[NSUserDefaults standardUserDefaults] setBool:offline forKey:@"FTShareCanUseOfflineAccess"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
*/

#pragma mark Facebook request delegate

- (void)request:(FBRequest *)request didLoad:(id)result {
    if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidReceiveResponse:)]) {
        [self.facebookDelegate facebookDidReceiveResponse:result];
    }   
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidPost:)]) {
        [self.facebookDelegate facebookDidPost:nil];
    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    if (self.facebookDelegate && [self.facebookDelegate respondsToSelector:@selector(facebookDidPost:)]) {
        [self.facebookDelegate facebookDidPost:error];
    }
}




@end
