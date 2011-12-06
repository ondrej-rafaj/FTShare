//
//  AnyViewController.h
//  FTShareView
//
//  Created by Francesco on 19/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTShare.h"

@interface AnyViewController : UIViewController <FTShareTwitterDelegate, FTShareFacebookDelegate, FTShareEmailDelegate>

@end
