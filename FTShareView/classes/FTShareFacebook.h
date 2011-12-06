//
//  FTShareFacebook.h
//  FTShareView
//
//  Created by cescofry on 06/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface FTShareFacebookData : NSObject {
    NSString *_message;
    NSString *_link;
    NSString *_name;
    NSString *_caption;
    NSString *_picture;
    NSString *_description;
    
    UIImage  *_uploadImage;
    
}

@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain) NSString *picture;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) UIImage *uploadImage;

- (NSMutableDictionary *)dictionaryFromParams;
- (BOOL)isRequestValid;

@end




typedef enum {
    FTShareFacebookPermissionNull       = 0 << 0,
    FTShareFacebookPermissionRead       = 1 << 0,
    FTShareFacebookPermissionPublish    = 1 << 1,
} FTShareFacebookPermission;



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





@end

@protocol FTShareFacebookDelegate <NSObject>

@optional

- (FTShareFacebookData *)facebookShareData;
- (void)facebookLoginDialogController:(UIViewController *)controller;
- (void)facebookDidLogin:(NSError *)error;
- (void)facebookDidPost:(NSError *)error;

@end


@protocol FTShareFacebookGetDelegate <NSObject>

@optional

- (FTShareFacebookData *)facebookShareData;
- (void)facebookLoginDialogController:(UIViewController *)controller;
- (void)facebookDidLogin:(NSError *)error;
- (void)facebookDidPost:(NSError *)error;

@end
