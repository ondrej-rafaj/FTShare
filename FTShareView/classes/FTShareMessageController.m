//
//  UBTiwtterMessageView.m
//  UBMMedia
//
//  Created by Francesco on 09/01/2012.
//  Copyright (c) 2012 Lost Bytes. All rights reserved.
//

#import "FTShareMessageController.h"
#import "UIColor+Tools.h"

#define MAX_TWITTER_CHARS   160
#define ALERT_TWITTER_CHARS 10


@implementation FTShareMessageController

@synthesize textView = _textView;
@synthesize delegate = _delegate;
@synthesize message = _message;
@synthesize charsLeftLabel = _charsLeftLabel;
@synthesize type = _type;


#pragma mark actions

- (void)tweetAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareMessageController:didFinishWithMessage:)]) {
        [self.delegate shareMessageController:self didFinishWithMessage:self.message];
    }
    [self dismissModalViewControllerAnimated:YES];    
}

- (void)cancelAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareMessageControllerDidCancel:)]) {
        [self.delegate shareMessageControllerDidCancel:self];
    }
    [self dismissModalViewControllerAnimated:YES];
    self.message = nil;
}

#pragma mark setters

- (NSInteger)twitterCharactersForString:(NSString *)string {
    static NSString *httpRegEx = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?";
    
    if (string.length ==0) return 0;
    int subtruct = 0;
    NSRange range = NSMakeRange(0, 0);
    while (YES) {
        int start = range.location + range.length;
        int length = (string.length - start);
        range = [string rangeOfString:httpRegEx options:NSRegularExpressionSearch range:NSMakeRange(start, length)];
        if (range.location != NSNotFound) {
            if (range.length > 20) subtruct += (range.length - 20);
        }
        else return (string.length - subtruct);
    }
    
    
}

- (void)setMessage:(NSString *)message {
    [_message release];
    _message = [message retain];
    
    NSInteger length = (self.type == FTShareMessageControllerTypeTwitter)? [self twitterCharactersForString:message] : message.length;
    NSInteger remaining = MAX_TWITTER_CHARS - length;
    
    if (self.type == FTShareMessageControllerTypeTwitter) {
        [self.charsLeftLabel setText:[NSString stringWithFormat:@"%d", remaining]];
        UIColor *color = (remaining <= ALERT_TWITTER_CHARS)? [UIColor redColor] : [UIColor blackColor];
        [self.charsLeftLabel setTextColor:color];
    }
    [self.navigationItem.rightBarButtonItem setEnabled:(remaining >= 0 || (self.type == FTShareMessageControllerTypeFacebook))];
}

#pragma mark initialize

- (id)initWithMessage:(NSString *)message type:(FTShareMessageControllerType)type andelegate:(id)delegate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Initialization code
        self.message = message;
        _delegate = delegate;
        self.type = type;
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = self.view.bounds;
    frame.size.height = 200;
    _textView = [[UITextView alloc] initWithFrame:frame];
    [self.textView setText:self.message];
    [self.textView setDelegate:self];
    [self.textView setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:self.textView];
    [self.textView becomeFirstResponder];
    
    self.charsLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(220 - 5, 174, 100, 30)];
    [self.charsLeftLabel setBackgroundColor:[UIColor clearColor]];
    [self.charsLeftLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [self.charsLeftLabel setTextAlignment:UITextAlignmentRight]; 
    [self.view addSubview:self.charsLeftLabel];
    [self.charsLeftLabel setHidden:(self.type != FTShareMessageControllerTypeTwitter)];
    
    UIBarButtonItem *sendBtn = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleBordered target:self action:@selector(tweetAction)];
    [self.navigationItem setRightBarButtonItem:sendBtn];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelAction)];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
    
    [self.navigationItem.rightBarButtonItem setEnabled:(self.message.length > 0)];
    self.message = self.message;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareMessageController:didDisappearWithMessage:)]) {
        [self.delegate shareMessageController:self didDisappearWithMessage:self.message];
    }
}



#pragma mark textview delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *resultString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    //int lenght = [self twitterCharactersForString:resultString];

    self.message = resultString;
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    [self resignFirstResponder];
    return YES;
    
}

@end
