//
//  UBTiwtterMessageView.h
//  UBMMedia
//
//  Created by Francesco on 09/01/2012.
//  Copyright (c) 2012 Lost Bytes. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FTShareMessageControllerTypeFacebook,
    FTShareMessageControllerTypeTwitter
} FTShareMessageControllerType;

@protocol FTShareMessageControllerDelegate;
@interface FTShareMessageController : UIViewController <UITextViewDelegate> {
    UITextView *_textView;
    id<FTShareMessageControllerDelegate> _delegate;
    NSString *_message;
    UILabel *_charsLeftLabel;
    FTShareMessageControllerType _type;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, assign) id<FTShareMessageControllerDelegate> delegate;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) UILabel *charsLeftLabel;
@property (nonatomic, assign) FTShareMessageControllerType type;

- (id)initWithMessage:(NSString *)message type:(FTShareMessageControllerType)type andelegate:(id)delegate;

@end

@protocol FTShareMessageControllerDelegate <NSObject>

- (void)shareMessageController:(FTShareMessageController *)controller didFinishWithMessage:(NSString *)message;
- (void)shareMessageControllerDidCancel:(FTShareMessageController *)controller;
- (void)shareMessageController:(FTShareMessageController *)controller didDisappearWithMessage:(NSString *)message;

@end
