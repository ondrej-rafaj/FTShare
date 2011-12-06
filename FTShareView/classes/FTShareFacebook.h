//
//  FTShareFacebook.h
//  FTShareView
//
//  Created by cescofry on 06/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

typedef enum {
    FTShareFacebookPermissionNull       = 0 << 0,
    FTShareFacebookPermissionRead       = 1 << 0,
    FTShareFacebookPermissionPublish    = 1 << 1,
} FTShareFacebookPermission;

typedef enum {
    FTShareFacebookGetTypeNull,
    FTShareFacebookGetTypeName,
    FTShareFacebookGetTypePhoto
} FTShareFacebookGetType;


@interface FTShareFacebookData : NSObject {
    NSString *_message;
    NSString *_link;
    NSString *_name;
    NSString *_caption;
    NSString *_picture;
    NSString *_description;
    FTShareFacebookGetType _type;
    
    UIImage  *_uploadImage;
    
}

@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain) NSString *picture;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) UIImage *uploadImage;
@property (nonatomic, assign) FTShareFacebookGetType type;

- (NSMutableDictionary *)dictionaryFromParams;
- (BOOL)isRequestValid;

@end




@protocol FTShareFacebookDelegate;
@interface FTShareFacebook : NSObject <FBRequestDelegate, FBSessionDelegate, FBDialogDelegate> {
    Facebook *_facebook;
    id <FTShareFacebookDelegate> _facebookDelegate;
    id _referencedController;
    FTShareFacebookData *_params;
    NSArray *_permissions;
}

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, assign) id<FTShareFacebookDelegate> facebookDelegate;

- (void)setUpFacebookWithAppID:(NSString *)appID referencedController:(id)referencedController andDelegate:(id<FTShareFacebookDelegate>)delegate;
- (void)setUpPermissions:(FTShareFacebookPermission)permission;
- (void)shareViaFacebook:(FTShareFacebookData *)data;
- (void)authorize;





@end

@protocol FTShareFacebookDelegate <NSObject>

@optional

- (FTShareFacebookData *)facebookShareData;
- (void)facebookLoginDialogController:(UIViewController *)controller;
- (void)facebookDidLogin:(NSError *)error;
- (void)facebookDidPost:(NSError *)error;
- (void)facebookDidReceiveResponse:(id)response;

@end


