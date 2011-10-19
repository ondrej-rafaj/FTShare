//
//  FTFacebook.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 22/08/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FBConnect.h"


@class FTFacebook;

@protocol FTFacebookProtocol <NSObject>

- (void)shareOnFacebook;

- (void)facebookAuthenticationFailed;

@end


@interface FTFacebook : Facebook {
	
}

@property (nonatomic, assign) id <FTFacebookProtocol> facebookProtocol;


@end
