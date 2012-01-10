//
//  FTShareTwitter.h
//  FTShareView
//
//  Created by cescofry on 06/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import "FTShareMessageController.h"

#pragma mark --
#pragma mark Data Type

@interface FTShareTwitterData : NSObject {
    NSString *_message;
    BOOL _hasControllerSupport;
}

@property (nonatomic, retain) NSString *message;
@property (nonatomic, assign) BOOL hasControllerSupport;

- (BOOL)isRequestValid;

@end



#pragma mark --
#pragma mark Class


@protocol FTShareTwitterDelegate;
@interface FTShareTwitter : NSObject <SA_OAuthTwitterControllerDelegate, SA_OAuthTwitterEngineDelegate, FTShareMessageControllerDelegate> {
    SA_OAuthTwitterEngine *_twitter;
    id <FTShareTwitterDelegate> _twitterDelegate;
    FTShareTwitterData *_twitterParams;
    id _referencedController;
}

@property (nonatomic, assign) id<FTShareTwitterDelegate> twitterDelegate;
@property (nonatomic, readonly) FTShareTwitterData *twitterParams;

- (void)setUpTwitterWithConsumerKey:(NSString *)consumerKey secret:(NSString *)secret referencedController:(id)referencedController andDelegate:(id<FTShareTwitterDelegate>)delegate;
- (void)shareViaTwitter:(FTShareTwitterData *)data;
@end



#pragma mark --
#pragma mark Delegate

@protocol FTShareTwitterDelegate <NSObject>

@optional

- (FTShareTwitterData *)twitterData;
- (void)twitterLoginDialogController:(UIViewController *)controller;
- (void)twitterDidLogin:(NSError *)error;
- (void)twitterDidPost:(NSError *)error;

@end
