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


#import "FTShareTwitter.h"
#import "FTShareFacebook.h"
#import "FTShareEmail.h"


enum {
    FTShareOptionsMail              = 1 << 0,
    FTShareOptionsFacebook          = 1 << 1,
    FTShareOptionsTwitter           = 1 << 2
};
typedef NSUInteger FTShareOptions;




@interface FTShare : NSObject <UIActionSheetDelegate> {
    
    FTShareTwitter *_twitterEngine;
    FTShareFacebook *_facebookEngine;
    FTShareEmail *_emailEngine;
    
    id _referencedController;
}

@property (nonatomic, retain) Facebook *facebook; // needs to be pubblic for UIApplication
@property (nonatomic, assign) id referencedController;


- (id)initWithReferencedController:(id)controller;
- (void)showActionSheetWithtitle:(NSString *)title andOptions:(FTShareOptions)options;

- (void)setUpTwitterWithConsumerKey:(NSString *)consumerKey secret:(NSString *)secret andDelegate:(id<FTShareTwitterDelegate>)delegate;
- (void)shareViaTwitter:(FTShareTwitterData *)data;



- (void)setUpFacebookWithAppID:(NSString *)appID permissions:(FTShareFacebookPermission)permissions andDelegate:(id<FTShareFacebookDelegate>)delegate;
- (void)shareViaFacebook:(FTShareFacebookData *)data;

- (void)setUpEmailWithDelegate:(id<FTShareEmailDelegate>)delegate;
- (void)shareViaEmail:(FTShareEmailData *)data;

@end
