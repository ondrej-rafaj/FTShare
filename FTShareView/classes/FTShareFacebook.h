//
//  FTShareFacebook.h
//  FTShareView
//
//  Created by cescofry on 06/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//
//Use http://developers.facebook.com/docs/reference/dialogs/feed/ to see how to use those parameters

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "FTShareMessageController.h"

#pragma mark --
#pragma mark Data Type

typedef enum {
    FTShareFacebookPermissionNull       = 0 << 0,
    FTShareFacebookPermissionRead       = 1 << 0,
    FTShareFacebookPermissionPublish    = 1 << 1,
    FTShareFacebookPermissionOffLine    = 1 << 2
} FTShareFacebookPermission;

typedef enum {
    FTShareFacebookRequestTypePost,
    FTShareFacebookRequestTypeFriends,
    FTShareFacebookRequestTypeAlbum,
    FTShareFacebookRequestTypeOther
} FTShareFacebookRequestType;

typedef enum {
    FTShareFacebookHttpTypeGet,
    FTShareFacebookHttpTypePost,
    FTShareFacebookHttpTypeDelete,
} FTShareFacebookHttpType;

@interface FTShareFacebookPhoto : NSObject {
    UIImage *_photo;
    NSString *_album;
    NSString *_message;
    NSMutableArray *_tags;
    
}

@property (nonatomic, retain) UIImage *photo;
@property (nonatomic, retain) NSString *album;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSMutableArray *tags;

+ (id)facebookPhotoFromImage:(UIImage *)image;
- (void)addTagToUserID:(NSString *)userID atPoint:(CGPoint)point;
- (NSString *)tagsAsString;

@end

@interface FTShareFacebookData : NSObject {
    NSString *_message;
    NSString *_link;
    NSString *_name;
    NSString *_caption;
    NSString *_picture;
    NSString *_description;
    BOOL _hasControllerSupport;
    FTShareFacebookRequestType _type;
    FTShareFacebookHttpType _httpType;
    
    FTShareFacebookPhoto  *_uploadPhoto;
    
}

@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain) NSString *picture;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, assign) BOOL hasControllerSupport;
@property (nonatomic, retain) FTShareFacebookPhoto *uploadPhoto;
@property (nonatomic, assign) FTShareFacebookRequestType type;
@property (nonatomic, assign) FTShareFacebookHttpType httpType;

- (NSMutableDictionary *)dictionaryFromParams;
- (NSString *)graphPathForType;
- (NSString *)graphHttpTypeString;
- (BOOL)isRequestValid;

@end


#pragma mark --
#pragma mark Class

@protocol FTShareFacebookDelegate;
@interface FTShareFacebook : NSObject <FBRequestDelegate, FBSessionDelegate, FBDialogDelegate, FTShareMessageControllerDelegate> {
    Facebook *_facebook;
    id <FTShareFacebookDelegate> _facebookDelegate;
    id _referencedController;
    FTShareFacebookData *_params;
    NSArray *_permissions;
}

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, assign) id<FTShareFacebookDelegate> facebookDelegate;
@property (nonatomic, readonly) FTShareFacebookData *params;
@property (nonatomic, readonly) NSArray *permissions;

- (void)setUpFacebookWithAppID:(NSString *)appID referencedController:(id)referencedController andDelegate:(id<FTShareFacebookDelegate>)delegate;
- (void)setUpPermissions:(FTShareFacebookPermission)permission;
- (void)shareViaFacebook:(FTShareFacebookData *)data;
- (void)authorize;



#pragma mark --
#pragma mark Delegate

@end

@protocol FTShareFacebookDelegate <NSObject>

@optional

- (FTShareFacebookData *)facebookShareData;
- (NSString *)facebookPathForRequestofMethodType:(NSString **)httpMethod;
- (void)facebookLoginDialogController:(UIViewController *)controller;
- (void)facebookDidLogin:(NSError *)error;
- (void)facebookDidPost:(NSError *)error;
- (void)facebookDidReceiveResponse:(id)response;

@end


