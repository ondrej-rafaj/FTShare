//
//  UIView+Layout.m
//  FTLibrary
//
//  Created by Simon Lee on 21/12/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import "UIView+Layout.h"


@implementation UIView (Layout)

- (void)removeSubviews {
	for(UIView *view in self.subviews) {
		[view removeFromSuperview];
	}
}

- (CGFloat)width {
	return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)value {
	CGRect frame = [self frame];
	frame.size.width = roundf(value);
	[self setFrame:frame];
}

- (CGFloat)height {
	return CGRectGetHeight(self.frame);	
}

- (void)setHeight:(CGFloat)value {
	CGRect frame = [self frame];
	frame.size.height = roundf(value);
	[self setFrame:frame];
}

- (CGFloat)bottomPosition {
	return CGRectGetMaxY(self.frame);
}

- (void)setBottomPosition:(CGFloat)position {
	CGRect frame = self.frame;
	frame.origin.y = position - frame.size.height;
	self.frame = frame;
}

- (CGFloat)rightPosition {
	return CGRectGetMaxX(self.frame);
}

- (void)setRightPosition:(CGFloat)position {
	CGRect frame = self.frame;
	frame.origin.x = position - frame.size.width;
	self.frame = frame;
}

- (void)setSize:(CGSize)size {
	CGRect frame = [self frame];
	frame.size.width = roundf(size.width);
	frame.size.height = roundf(size.height);
	[self setFrame:frame];
}

- (CGSize)size {
	CGRect frame = [self frame];
	return frame.size;
}

- (CGPoint)origin {
	CGRect frame = [self frame];
	return frame.origin;
}

- (void)setOrigin:(CGPoint)point {
	CGRect frame = [self frame];
	frame.origin.x = roundf(point.x);
	frame.origin.y = roundf(point.y);
	[self setFrame:frame];
}

- (CGFloat)xPosition {
	return CGRectGetMinX(self.frame);
}

- (CGFloat)yPosition {
	return CGRectGetMinY(self.frame);
}

- (CGFloat)baselinePosition {
	return CGRectGetMaxX(self.frame);
}

- (void)positionAtX:(CGFloat)xValue {
	CGRect frame = [self frame];
	frame.origin.x = roundf(xValue);
	[self setFrame:frame];
}

- (void)positionAtY:(CGFloat)yValue {
	CGRect frame = [self frame];
	frame.origin.y = roundf(yValue);
	[self setFrame:frame];
}

- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue {
	CGRect frame = [self frame];
	frame.origin.x = roundf(xValue);
	frame.origin.y = roundf(yValue);
	[self setFrame:frame];
}

- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue withWidth:(CGFloat)width {
	CGRect frame = [self frame];
	frame.origin.x = roundf(xValue);
	frame.origin.y = roundf(yValue);
	frame.size.width = width;
	[self setFrame:frame];	
}

- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue withHeight:(CGFloat)height {
	CGRect frame = [self frame];
	frame.origin.x = roundf(xValue);
	frame.origin.y = roundf(yValue);
	frame.size.height = height;
	[self setFrame:frame];	
}

- (void)positionAtX:(CGFloat)xValue withHeight:(CGFloat)height {
	CGRect frame = [self frame];
	frame.origin.x = roundf(xValue);
	frame.size.height = height;
	[self setFrame:frame];	
}

- (void)centerInSuperView {
	if (self.superview) {
		CGFloat xPos = roundf((self.superview.frame.size.width - self.frame.size.width) / 2.f);
		CGFloat yPos = roundf((self.superview.frame.size.height - self.frame.size.height) / 2.f);	
		[self positionAtX:xPos andY:yPos];
	}
}

- (void)aestheticCenterInSuperView {
	if (self.superview) {
		CGFloat xPos = roundf(([self.superview width] - [self width]) / 2.0);
		CGFloat yPos = roundf(([self.superview height] - [self height]) / 2.0) - ([self.superview height] / 8.0);
		[self positionAtX:xPos andY:yPos];	
	}
}

- (void)makeMarginInSuperViewWithTopMargin:(CGFloat)topMargin leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin andBottomMargin:(CGFloat)bottomMargin {
	if (self.superview) {
		CGRect r = self.superview.bounds;
		r.origin.x = leftMargin;
		r.origin.y = topMargin;
		r.size.width -= (leftMargin + rightMargin);
		r.size.height -= (topMargin + bottomMargin);
		[self setFrame:r];
	}
}

- (void)makeMarginInSuperViewWithTopMargin:(CGFloat)topMargin andSideMargin:(CGFloat)sideMargin {
	if (self.superview) [self makeMarginInSuperViewWithTopMargin:topMargin leftMargin:sideMargin rightMargin:sideMargin andBottomMargin:topMargin];
}

- (void)makeMarginInSuperView:(CGFloat)margin {
	if (self.superview) [self makeMarginInSuperViewWithTopMargin:margin andSideMargin:margin];
}

- (void)bringToFront {
	[self.superview bringSubviewToFront:self];	
}

- (void)sendToBack {
	[self.superview sendSubviewToBack:self];	
}

- (void)centerAtX {
    CGFloat xPos = roundf((self.superview.frame.size.width - self.frame.size.width) / 2.0);
    [self positionAtX:xPos];
}

- (void)centerAtXQuarter{
    CGFloat xPos = roundf((self.superview.frame.size.width / 4) - (self.frame.size.width / 2));
    [self positionAtX:xPos];    
}

- (void)centerAtX3Quarter{
    [self centerAtXQuarter];
    CGFloat xPos = roundf((self.superview.frame.size.width / 2) + self.frame.origin.x);
    [self positionAtX:xPos];
}

- (void)setCenter:(CGPoint)center allowSubpixel:(BOOL)allowSubpixels
{
	self.center = center;
	if (!allowSubpixels) self.frame = CGRectIntegral(self.frame);
}

- (CGFloat)bottomMargin
{
	if (self.superview) {
		return self.superview.height - self.bottomPosition;	
	}
	return 0;
}

- (void)setBottomMargin:(CGFloat)bottomMargin
{
	if (self.superview) {
		CGRect frame = self.frame;
		frame.origin.y = self.superview.height - bottomMargin - self.height;
		self.frame = frame;
	}
}

- (CGFloat)rightMargin
{
	if (self.superview) {
		return self.superview.width - self.rightPosition;	
	}
	return 0;
}

- (void)setRightMargin:(CGFloat)rightMargin
{
	if (self.superview) {
		CGRect frame = self.frame;
		frame.origin.x = self.superview.width - rightMargin - self.width;
		self.frame = frame;
	}
}

@end
