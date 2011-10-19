//
//  AnyViewController.m
//  FTShareView
//
//  Created by Francesco on 19/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "AnyViewController.h"
#import "FTAppDelegate.h"
#import "Config.h"


@implementation AnyViewController




- (FTShare *)shareInstance {
    FTAppDelegate *appDel = (FTAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appDel.share setReferencedController:self];
    
    // set up sharing components
    [appDel.share setUpTwitterWithConsumerKey:kIKTwitterConsumerKey secret:kIKTwiiterPasscode andDelegate:self];
    [appDel.share setUpFacebookWithAppID:kIKFacebookAppID andDelegate:self];
    [appDel.share setMailDelegate:self];
    
    return appDel.share;
}

- (void)share:(id)sender {
    FTShare *share = [self shareInstance];
    
    [share showActionSheetWithtitle:@"Share With" andOptions:FTShareOptionsFacebook|FTShareOptionsTwitter|FTShareOptionsMail];

}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [btn setFrame:CGRectMake(290, 430, 20, 20)];
    [btn setTintColor:[UIColor redColor]];
    [btn setTitle:@"share" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

#pragma mark FTShare Facebook
/**
 * If using Action Sheet this is ised to set the data to share.
 *
 */
- (FTShareFacebookData *)facebookShareData {
    FTShareFacebookData *data = [[FTShareFacebookData alloc] init];
    [data setLink:@"http://www.fuerteint.com"];
    [data setCaption:@"Crazy for iOS apps!"];
    return [data autorelease];
}

/**
 * Called when Facebook finishes to login. Error is nil for successfull operation
 *
 */
- (void)facebookDidLogin:(NSError *)error {
    
}

/**
 * Called when FAcebook finishes to post. Error is nil for successfull operation
 *
 */
- (void)facebookDidPost:(NSError *)error {
    
}

#pragma mark FTShare Twitter

/**
 * If using Action Sheet this is ised to set the data to share.
 *
 */
- (FTShareTwitterData *)twitterData {
    FTShareTwitterData *data = [[FTShareTwitterData alloc] init];
    [data setMessage:@"Crazy for iOS apps! - http://www.fuerteint.com"];
    return data;
}

/**
 * Called when Twitter finishes to login. Error is nil for successfull operation
 *
 */
- (void)twitterDidLogin:(NSError *)error {
    //manage twitter finished login
}

/**
 * Called when Twitter finishes to post. Error is nil for successfull operation
 *
 */
- (void)twitterDidPost:(NSError *)error {
    //mange twitter finished post
}

#pragma mark FTShare Mail

/**
 * If using Action Sheet this is ised to set the data to share.
 *
 */
- (FTShareMailData *)mailShareData {
    FTShareMailData *data = [[FTShareMailData alloc] init];
    [data setSubject:@"check out this site"];
    [data setPlainBody:@"Crazy for iOS apps!\n http://www.fuerteint.com"];
    [data setHtmlBody:@"<h2>Crazy for iOS apps!</h2><a href='http://www.fuerteint.com'>fuerteint.com</a>"];
    
    return data;
}


/**
 * Called when main finishes to post.
 *
 */
- (void)mailSent:(MFMailComposeResult)result {
    //manage mail result
}



@end
