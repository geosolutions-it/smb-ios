//
//  STSPatchView.h
//  
//  Created by Szymon Tomasz Stefanek on 2/25/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _STSPatchViewPathFlags
{
	STSPatchViewPatchSpansAllColumns = 1
} STSPatchViewPathFlags;

@interface STSPatchView : UIView

- (id)init;
- (id)initWithFrame:(CGRect)frame;

- (void)setColumnCount:(unsigned int)uCount;

- (void)addView:(UIView *)pView;
- (void)addView:(UIView *)pView withFlags:(unsigned int)uFlags;
- (void)addView:(UIView *)pView inFixedColumn:(unsigned int)uColumn withFlags:(unsigned int)uFlags;
- (void)addView:(UIView *)pView inFixedColumn:(unsigned int)uColumn;

- (void)setColumn:(unsigned int)uColumn fixedWidth:(CGFloat)fWidth;
- (void)setColumn:(unsigned int)uColumn fixedWidthPercent:(CGFloat)fWidth;

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

- (void)setReduceColumnsIfNotEnoughItems:(BOOL)bReduce;

- (void)removeView:(UIView *)pView;
- (void)removeAllViews;

- (void)setNeedsLayout;

@end
