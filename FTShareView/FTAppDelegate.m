//
//  FTAppDelegate.m
//  FTShareView
//
//  Created by Francesco on 19/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTAppDelegate.h"
#import "AnyViewController.h"

@implementation FTAppDelegate

@synthesize window = _window;
@synthesize share = _share;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.share = [[FTShare alloc] initWithReferencedController:nil];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    AnyViewController *anyVC = [[AnyViewController alloc] init];
    [self.window setRootViewController:anyVC];
    [anyVC release];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (self.share.facebook) {
        return [self.share.facebook handleOpenURL:url];
    }
    return YES;
}

@end
