//
//  FTShare.h
//  IKEA_settings
//
//  Created by cescofry on 28/09/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

/**
 * This class provide a simple way to integarate share functionalities on your application.
 * There are 2 main ways of usign this component. The first is to call the shareWith... method while the second is to show the UIActionSheet and then utilize the delegate methods.
 * The FTShare main instance have to be part of the application APPDelegate as it uses the handleURL method for the facebook callback.
 * Remember to set URL Types on the info plist in order for the facebook callback to work. 
 */

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "FTShareDataObjects.h"
#import "FBConnect.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"


enum {
    FTShareOptionsMail              = 1 << 0,
    FTShareOptionsFacebook          = 1 << 1,
    FTShareOptionsTwitter           = 1 << 2
};
typedef NSUInteger FTShareOptions;

@protocol FTShareTwitterDelegate;
@protocol FTShareFacebookDelegate;
@protocol FTShareMailDelegate;

@interface FTShare : NSObject <MFMailComposeViewControllerDelegate, SA_OAuthTwitterControllerDelegate, SA_OAuthTwitterEngineDelegate, FBRequestDelegate, FBSessionDelegate, FBDialogDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {
    
	Facebook *_facebook;
    SA_OAuthTwitterEngine *_twitter;
    id <FTShareTwitterDelegate> _twitterDelegate;
    id <FTShareFacebookDelegate> _facebookDelegate;
    id <FTShareMailDelegate> _mailDelegate;
    id _referencedController;
    FTShareFacebookData *_facebookParams;
    FTShareFacebookGetData *_facebookGetParams;
    FTShareTwitterData *_twitterParams;
    
}

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) SA_OAuthTwitterEngine *twitter;
@property (nonatomic, assign) id<FTShareTwitterDelegate> twitterDelegate;
@property (nonatomic, assign) id<FTShareFacebookDelegate> facebookDelegate;
@property (nonatomic, assign) id<FTShareMailDelegate> mailDelegate;

@property (nonatomic, assign) id referencedController;
@property (nonatomic, retain) FTShareFacebookData *facebookParams;
@property (nonatomic, retain) FTShareFacebookGetData *facebookGetParams;
@property (nonatomic, retain) FTShareTwitterData *twitterParams;


- (id)initWithReferencedController:(id)controller;
- (void)showActionSheetWithtitle:(NSString *)title andOptions:(FTShareOptions)options;

- (void)setUpTwitterWithConsumerKey:(NSString *)consumerKey secret:(NSString *)secret andDelegate:(id<FTShareTwitterDelegate>)delegate;
- (void)shareViaTwitter:(FTShareTwitterData *)data;

- (void)setUpFacebookWithAppID:(NSString *)appID andDelegate:(id<FTShareFacebookDelegate>)delegate;
- (void)shareViaFacebook:(FTShareFacebookData *)data;
- (void)getFacebookData:(FTShareFacebookGetData *)data;

- (void)shareViaMail:(FTShareMailData *)data;

@end


@protocol FTShareTwitterDelegate <NSObject>

@optional

- (FTShareTwitterData *)twitterData;
- (void)twitterLoginDialogController:(UIViewController *)controller;
- (void)twitterDidLogin:(NSError *)error;
- (void)twitterDidPost:(NSError *)error;

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


@protocol FTShareMailDelegate <NSObject>

@optional

- (FTShareMailData *)mailShareData;
- (void)mailSent:(MFMailComposeResult)result;

@end