//
//  STSGridLayoutView.h
//  
//  Created by Szymon Tomasz Stefanek on 1/20/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STSMargins.h"

// How we should consider the intrinsicContentsSize ?
typedef enum _STSSizePolicy
{
	// intrinsicContentsSize is ignored, the view takes the space defined by other views
	STSSizePolicyIgnore,
	// intrinsicContentsSize should be enforced as much as possible
	STSSizePolicyFixed,
	// intrinsicContentsSize is preferred, but the view can shrink and expand
	STSSizePolicyCanShrinkAndExpand,
	// intrinsicContentsSize is minimum and preferred, the view can eventualy expand
	STSSizePolicyCanExpand,
	// intrinsicContentsSize is preferred and the view should take more space if possible
	STSSizePolicyCanShrinkButShouldExpand,
	// intrinsicContentsSize is minimum and the view should take more space if possible
	STSSizePolicyShouldExpand,
	// intrinsicContentsSize is maximum and preferred, the view can eventually shrink
	STSSizePolicyCanShrink
} STSSizePolicy;

@interface STSGridLayoutView : UIView

- (id)init;
- (id)initWithFrame:(CGRect)frame;
- (void)dealloc;

- (void)addView:(UIView *)pView row:(int)iRow column:(int)iColumn;
- (void)addView:(UIView *)pView row:(int)iRow column:(int)iColumn rowSpan:(int)iRowSpan columnSpan:(int)iColumnSpan;
- (void)addView:(UIView *)pView row:(int)iRow column:(int)iColumn rowSpan:(int)iRowSpan columnSpan:(int)iColumnSpan verticalSizePolicy:(STSSizePolicy)eVerticalSizePolicy horizontalSizePolicy:(STSSizePolicy)eHorizontalSizePolicy;
- (void)addView:(UIView *)pView row:(int)iRow column:(int)iColumn verticalSizePolicy:(STSSizePolicy)eVerticalSizePolicy horizontalSizePolicy:(STSSizePolicy)eHorizontalSizePolicy;

- (void)removeView:(UIView *)pView;
- (void)removeAllViews;
- (void)removeAllViewsFromLayoutButKeepThemAttachedToView;

- (void)clear;

- (void)setRow:(int)iRow minimumHeight:(CGFloat)fHeight;
- (void)setRow:(int)iRow maximumHeight:(CGFloat)fHeight;
- (void)setRow:(int)iRow fixedHeight:(CGFloat)fHeight;
- (void)setRow:(int)iRow minimumHeightPercent:(CGFloat)fHeight;
- (void)setRow:(int)iRow maximumHeightPercent:(CGFloat)fHeight;
- (void)setRow:(int)iRow fixedHeightPercent:(CGFloat)fHeight;

// Default weight is 1 + average weight of views in this row
- (void)setRow:(int)iRow expandWeight:(CGFloat)fWeight;
- (void)setRow:(int)iRow shrinkWeight:(CGFloat)fWeight;

- (void)setColumn:(int)iColumn minimumWidth:(CGFloat)fWidth;
- (void)setColumn:(int)iColumn maximumWidth:(CGFloat)fWidth;
- (void)setColumn:(int)iColumn fixedWidth:(CGFloat)fWidth;
- (void)setColumn:(int)iColumn minimumWidthPercent:(CGFloat)fWidth;
- (void)setColumn:(int)iColumn maximumWidthPercent:(CGFloat)fWidth;
- (void)setColumn:(int)iColumn fixedWidthPercent:(CGFloat)fWidth;
// Default weight is 1 + average weight of views in this column
- (void)setColumn:(int)iColumn expandWeight:(CGFloat)fWeight;
- (void)setColumn:(int)iColumn shrinkWeight:(CGFloat)fWeight;

- (void)removeAllConstraints;

- (void)setMarginLeft:(CGFloat)fLeftMargin top:(CGFloat)fTopMargin right:(CGFloat)fRightMargin bottom:(CGFloat)fBottomMargin;
- (void)setLeftMargin:(CGFloat)fLeftMargin;
- (void)setRightMargin:(CGFloat)fRightMargin;
- (void)setBottomMargin:(CGFloat)fBottomMargin;
- (void)setTopMargin:(CGFloat)fTopMargin;
- (void)setMargin:(CGFloat)fAllMargins;

- (void)setColumnSpacing:(CGFloat)fColumnSpacing;
- (void)setRowSpacing:(CGFloat)fRowSpacing;
- (void)setSpacing:(CGFloat)fAllSpacings;

- (void)setView:(UIView *)pView margins:(STSMargins *)pMargins;

- (void)setNeedsLayout;

- (CGSize)intrinsicContentSize;
- (CGSize)sizeThatFits:(CGSize)size;
- (void)sizeToFit;

@end
