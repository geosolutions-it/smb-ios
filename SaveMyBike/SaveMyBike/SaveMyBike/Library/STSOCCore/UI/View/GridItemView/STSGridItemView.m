//
//  STSGridItemView.m
//  
//  Created by Szymon Tomasz Stefanek on 1/25/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGridItemView.h"

@interface STSGridItemView()
{
	__weak NSObject<STSGridItemViewDelegate> * m_pDelegate;
	UICollectionViewFlowLayout * m_pLayout;
	CGSize m_aLastReloadDataSize;
}

@end

@implementation STSGridItemView

- (id)init
{
	UICollectionViewFlowLayout * l = [UICollectionViewFlowLayout new];
	
	l.minimumLineSpacing = 0.0f;
	l.minimumInteritemSpacing = 0.0f;
	
	l.scrollDirection = UICollectionViewScrollDirectionVertical;
	
	self = [super initWithFrame:CGRectNull collectionViewLayout:l];
	if(!self)
		return nil;
	
	m_pLayout = l;
	m_pDelegate = nil;
	
	self.delegate = self;
	self.dataSource = self;
	
	m_aLastReloadDataSize = CGSizeMake(0,0);
	
	return self;
}

- (id)initWithScrollDirection:(UICollectionViewScrollDirection)dir
{
	UICollectionViewFlowLayout * l = [UICollectionViewFlowLayout new];
	
	l.minimumLineSpacing = 0.0f;
	l.minimumInteritemSpacing = 0.0f;
	
	l.scrollDirection = dir;
	
	self = [super initWithFrame:CGRectNull collectionViewLayout:l];
	if(!self)
		return nil;
	
	m_pLayout = l;
	m_pDelegate = nil;
	
	self.delegate = self;
	self.dataSource = self;
	
	return self;
}

- (id)initWithGridItemViewDelegate:(__weak NSObject<STSGridItemViewDelegate> *)del
{
	UICollectionViewFlowLayout * l = [UICollectionViewFlowLayout new];
	
	l.minimumLineSpacing = 0.0f;
	l.minimumInteritemSpacing = 0.0f;
	
	l.scrollDirection = UICollectionViewScrollDirectionVertical;

	self = [super initWithFrame:CGRectNull collectionViewLayout:l];
	if(!self)
		return nil;
	
	m_pLayout = l;
	m_pDelegate = del;
	
	self.delegate = self;
	self.dataSource = self;
	
	return self;
}

- (id)initWithGridItemViewDelegate:(__weak NSObject<STSGridItemViewDelegate> *)del andScrollDirection:(UICollectionViewScrollDirection)dir
{
	UICollectionViewFlowLayout * l = [UICollectionViewFlowLayout new];
	
	l.minimumLineSpacing = 0.0f;
	l.minimumInteritemSpacing = 0.0f;
	
	l.scrollDirection = dir;
	
	self = [super initWithFrame:CGRectNull collectionViewLayout:l];
	if(!self)
		return nil;
	
	m_pLayout = l;
	m_pDelegate = del;
	
	self.delegate = self;
	self.dataSource = self;
	
	return self;
}

- (void)dealloc
{
	m_pDelegate = nil;
}

- (void)setGridItemViewDelegate:(__weak NSObject<STSGridItemViewDelegate> *)del;
{
	m_pDelegate = del;
}

- (void)setMarginLeft:(CGFloat)fLeft top:(CGFloat)fTop right:(CGFloat)fRight bottom:(CGFloat)fBottom
{
	UICollectionViewFlowLayout * l = (UICollectionViewFlowLayout *)self.collectionViewLayout;
	l.sectionInset = UIEdgeInsetsMake(fTop,fLeft,fBottom,fRight);
}

- (void)setMargin:(CGFloat)fMargin
{
	UICollectionViewFlowLayout * l = (UICollectionViewFlowLayout *)self.collectionViewLayout;
	l.sectionInset = UIEdgeInsetsMake(fMargin, fMargin, fMargin, fMargin);
}

- (void)setHorizontalSpacing:(CGFloat)fSpacing
{
	UICollectionViewFlowLayout * l = (UICollectionViewFlowLayout *)self.collectionViewLayout;
	l.minimumInteritemSpacing = fSpacing;
}

- (void)setVerticalSpacing:(CGFloat)fSpacing
{
	UICollectionViewFlowLayout * l = (UICollectionViewFlowLayout *)self.collectionViewLayout;
	l.minimumLineSpacing = fSpacing;
	
}

- (void)layoutSubviews
{
	// This view is usually sensitive to size.
	// If sizeForCellsInGridItemView is called when this view is hidden or not properly sized
	// then our item size may be wrong. Forcibly reload data if size changes.
	if(m_pDelegate && ((m_aLastReloadDataSize.width != self.bounds.size.width) || (m_aLastReloadDataSize.height != self.bounds.size.height)))
		[self reloadData];
	[super layoutSubviews];
}

- (void)reloadData
{
	if(m_pDelegate)
		m_pLayout.itemSize = [m_pDelegate sizeForCellsInGridItemView:self];
	else
		m_pLayout.itemSize = CGSizeMake(50.0,50.0);
	m_aLastReloadDataSize = self.bounds.size;
	[super reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	if(!m_pDelegate)
		return 1;
	if(![m_pDelegate respondsToSelector:@selector(numberOfSectionsInGridItemView:)])
		return 1;
	return [m_pDelegate numberOfSectionsInGridItemView:self];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	if(!m_pDelegate)
		return 0;
	return [m_pDelegate gridItemView:self numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
	if(!m_pDelegate)
		return nil;

	return [m_pDelegate gridItemView:self cellForItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if(!m_pDelegate)
		return;
	if(![m_pDelegate respondsToSelector:@selector(gridItemView:didSelectItemAtIndexPath:)])
		return;
	[m_pDelegate gridItemView:self didSelectItemAtIndexPath:indexPath];
}

@end
