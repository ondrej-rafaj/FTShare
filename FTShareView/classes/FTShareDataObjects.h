//
//  FTShareDataObjects.h
//  IKEA_settings
//
//  Created by Francesco on 04/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+Resize.h"







typedef enum {
	
	FTShareFacebookGetDataReadTypeMePhotos,
	FTShareFacebookGetDataReadTypeMeFriends
	
} FTShareFacebookGetDataReadType;

@interface FTShareFacebookGetData : NSObject {
    
	NSString *_message;
	
	FTShareFacebookGetDataReadType readType;
    
}

@property (nonatomic, retain) NSString *message;
@property (nonatomic) FTShareFacebookGetDataReadType readType;

- (NSMutableDictionary *)dictionaryFromParams;
- (BOOL)isRequestValid;

@end

