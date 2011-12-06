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
    [appDel.share setUpFacebookWithAppID:kIKFacebookAppID permissions:FTShareFacebookPermissionRead|FTShareFacebookPermissionPublish andDelegate:self];
    [appDel.share setUpEmailWithDelegate:self];
    
    return appDel.share;
}

- (void)share:(id)sender {
    FTShare *share = [self shareInstance];
    
    [share showActionSheetWithtitle:@"Share With" andOptions:FTShareOptionsFacebook|FTShareOptionsTwitter|FTShareOptionsMail];

}

- (void)getUSerFriends {
    FTShare *share = [self shareInstance];
    FTShareFacebookData *fbData = [[FTShareFacebookData alloc] init];
    [fbData setType:FTShareFacebookRequestTypeFriends];
    [fbData setHttpType:FTShareFacebookHttpTypeGet];
    [share shareViaFacebook:fbData];
}

- (void)testFBWithNoPath {
    FTShare *share = [self shareInstance];
    [share shareViaFacebook:nil];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //some text. Not important!
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 200)];
    [lbl setText:@"Curabitur blandit tempus porttitor. Aenean lacinia bibendum nulla sed consectetur. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Donec ullamcorper nulla non metus auctor fringilla. Maecenas faucibus mollis interdum."];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setNumberOfLines:0];
    [lbl setLineBreakMode:UILineBreakModeWordWrap];
    [self.view addSubview:lbl];
    [lbl release];
    
    
    //add button to share
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [btn setFrame:CGRectMake(290, 430, 20, 20)];
    [btn setTintColor:[UIColor redColor]];
    [btn setTitle:@"share" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn1 setTitle:@"friends" forState:UIControlStateNormal];
    [btn1 setFrame:CGRectMake(10, 430, 100, 20)];
    [btn1 addTarget:self action:@selector(getUSerFriends) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn2 setTitle:@"no path" forState:UIControlStateNormal];
    [btn2 setFrame:CGRectMake(150, 430, 100, 20)];
    [btn2 addTarget:self action:@selector(testFBWithNoPath) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
}

#pragma mark FTShare Facebook
/**
 * If using Action Sheet this is ised to set the data to share.
 *
 */
- (FTShareFacebookData *)facebookShareData {
    FTShareFacebookData *data = [[FTShareFacebookData alloc] init];
    [data setLink:@"http://www.fuerteint.com"];
    [data setCaption:@"Latest test using Graph"];
    [data setType:FTShareFacebookRequestTypePost];
    [data setHttpType:FTShareFacebookHttpTypePost];
    return [data autorelease];
}

/**
 * Called if facebook request had no type. Provide path like "me/feeds" and override httpMethod with GET, POST or DELETE
 *
 */
- (NSString *)facebookPathForRequestofMethodType:(NSString **)httpMethod {
    *httpMethod = @"GET";
    return @"me/friends";
}

/**
 * Called when Facebook finishes to login. Error is nil for successfull operation
 *
 */
- (void)facebookDidLogin:(NSError *)error {
        NSLog(@"Facebook did %@ login with Error: [%@]",(error == nil)? @"" : @"NOT", [error localizedDescription]);
}

/**
 * Called when FAcebook finishes to post. Error is nil for successfull operation
 *
 */
- (void)facebookDidPost:(NSError *)error {
    NSLog(@"Facebook has %@ posted with Error: [%@]",(error == nil)? @"" : @"NOT", [error localizedDescription]);
}

/**
 * Called when FAcebook finishes a request with data.
 *
 */
- (void)facebookDidReceiveResponse:(id)response {
    NSLog(@"Facebook Response: %@", [response description]);
}

#pragma mark FTShare Twitter

/**
 * If using Action Sheet this is ised to set the data to share.
 *
 */
- (FTShareTwitterData *)twitterData {
    FTShareTwitterData *data = [[FTShareTwitterData alloc] init];
    [data setMessage:@"This guys are crazy for iOS apps! - http://www.fuerteint.com"];
    return data;
}

/**
 * Called when Twitter finishes to login. Error is nil for successfull operation
 *
 */
- (void)twitterDidLogin:(NSError *)error {
    //manage twitter finished login
    NSLog(@"Twitter did %@ login with Error: [%@]",(error == nil)? @"" : @"NOT", [error localizedDescription]);
}

/**
 * Called when Twitter finishes to post. Error is nil for successfull operation
 *
 */
- (void)twitterDidPost:(NSError *)error {
    //mange twitter finished post
    NSLog(@"Twitter has %@ posted with Error: [%@]",(error == nil)? @"" : @"NOT", [error localizedDescription]);
}

#pragma mark FTShare Mail

/**
 * If using Action Sheet this is ised to set the data to share.
 *
 */
- (FTShareEmailData *)mailShareData {
    FTShareEmailData *data = [[FTShareEmailData alloc] init];
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
    NSLog(@"Mail %@ sent", (result == MFMailComposeResultSent)? @"" : @"NOT");
}



@end
