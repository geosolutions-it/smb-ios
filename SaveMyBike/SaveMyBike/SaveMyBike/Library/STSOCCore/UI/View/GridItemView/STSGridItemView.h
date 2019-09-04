//
//  STSGridItemView.h
//
//  Created by Szymon Tomasz Stefanek on 1/25/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STSGridItemViewDelegate.h"
#import "STSGridItemViewCell.h"

@interface STSGridItemView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

- (id)init;
- (id)initWithScrollDirection:(UICollectionViewScrollDirection)dir;
- (id)initWithGridItemViewDelegate:(__weak NSObject<STSGridItemViewDelegate> *)del;
- (id)initWithGridItemViewDelegate:(__weak NSObject<STSGridItemViewDelegate> *)del andScrollDirection:(UICollectionViewScrollDirection)dir;

// DO NOT USE @property delegate, nor setDelegate.
- (void)setGridItemViewDelegate:(__weak NSObject<STSGridItemViewDelegate> *)del;

- (void)setHorizontalSpacing:(CGFloat)fSpacing;
- (void)setVerticalSpacing:(CGFloat)fSpacing;
- (void)setMarginLeft:(CGFloat)fLeft top:(CGFloat)fTop right:(CGFloat)fRight bottom:(CGFloat)fBottom;
- (void)setMargin:(CGFloat)fMargin;

- (void)reloadData;

@end
