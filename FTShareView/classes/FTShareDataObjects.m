//
//  FTShareDataObjects.m
//  IKEA_settings
//
//  Created by Francesco on 04/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTShareDataObjects.h"

#pragma mark Twitter Data Structure

#pragma mark Facebook Data Structure




@implementation FTShareFacebookGetData

@synthesize message = _message;
@synthesize readType;

- (id)init {
	self = [super init];
	if (self) {
		readType = FTShareFacebookGetDataReadTypeMePhotos;
	}
	return self;
}

- (BOOL)isRequestValid {
    BOOL isValidMessage = (self.message && [self.message length] > 0);
    BOOL isValidImage = YES;
    BOOL valid = (isValidMessage || isValidImage);
    if (!valid) NSLog(@"Facebook request seams not valid");
    return valid;
}

- (NSMutableDictionary *)dictionaryFromParams {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //if (self.message) [dict setObject:self.message forKey:@"message"];
    return dict;
}

- (void)dealloc {
    [_message release], _message = nil;
    [super dealloc];
}

@end


#pragma mark Mail Data Structure

