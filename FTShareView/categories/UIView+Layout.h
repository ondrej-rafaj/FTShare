//
//  UIView+Layout.h
//  FTLibrary
//
//  Created by Simon Lee on 21/12/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIView (Layout)

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)bottomPosition;
- (void)setBottomPosition:(CGFloat)position;

- (CGFloat)rightPosition;

- (CGSize)size;
- (void)setSize:(CGSize)size;

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)point;

- (CGFloat)xPosition;
- (CGFloat)yPosition;
- (CGFloat)baselinePosition;

- (void)positionAtX:(CGFloat)xValue;
- (void)positionAtY:(CGFloat)yValue;
- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue;

- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue withWidth:(CGFloat)width;
- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue withHeight:(CGFloat)height;

- (void)positionAtX:(CGFloat)xValue withHeight:(CGFloat)height;

- (void)removeSubviews;

- (void)centerInSuperView;
- (void)aestheticCenterInSuperView;
- (void)centerAtX;
- (void)centerAtXQuarter;
- (void)centerAtX3Quarter;
- (void)setCenter:(CGPoint)center allowSubpixel:(BOOL)allowSubpixels;
- (void)makeMarginInSuperViewWithTopMargin:(CGFloat)topMargin leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin andBottomMargin:(CGFloat)bottomMargin;
- (void)makeMarginInSuperViewWithTopMargin:(CGFloat)topMargin andSideMargin:(CGFloat)sideMargin;
- (void)makeMarginInSuperView:(CGFloat)margin;

- (void)bringToFront;
- (void)sendToBack;

- (CGFloat)bottomMargin;
- (void)setBottomMargin:(CGFloat)bottomMargin;

- (CGFloat)rightMargin;
- (void)setRightMargin:(CGFloat)rightMargin;

@end
