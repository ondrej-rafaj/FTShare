//
//  FTShareDataObjects.h
//  IKEA_settings
//
//  Created by Francesco on 04/10/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>

//Use http://developers.facebook.com/docs/reference/dialogs/feed/ to see how to use those parameters

@interface FTShareTwitterData : NSObject {
    NSString *_message;
}

@property (nonatomic, retain) NSString *message;

- (BOOL)isRequestValid;

@end

@interface FTShareFacebookData : NSObject {
    NSString *_message;
    NSString *_link;
    NSString *_caption;
    NSString *_picture;
    NSString *_description;
    
    UIImage  *_uploadImage;
    
}

@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain) NSString *picture;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) UIImage *uploadImage;

- (NSMutableDictionary *)dictionaryFromParams;
- (BOOL)isRequestValid;

@end



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

@interface FTShareMailData : NSObject {
    NSString *_subject;
    NSString *_plainBody;
    NSString *_htmlBody;
@private
    NSMutableArray *_attachments;
}

@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *plainBody;
@property (nonatomic, retain) NSString *htmlBody;
@property (nonatomic, readonly, retain) NSMutableArray *attachments;

- (void)addAttachmentWithObject:(id)obj type:(NSString *)type andName:(NSString *)name;
- (BOOL)isRequestValid;

@end
