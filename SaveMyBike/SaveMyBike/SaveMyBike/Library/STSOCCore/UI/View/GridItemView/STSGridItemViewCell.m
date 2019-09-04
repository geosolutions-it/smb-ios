//
//  STSGridItemViewCell.m
//  
//  Created by Szymon Tomasz Stefanek on 1/25/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGridItemViewCell.h"

@interface STSGridItemViewCell()
{
	UIView * m_pSelectionOverlay;
}

@end

@implementation STSGridItemViewCell

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(!self)
		return nil;
	
	[self _internalInit];
	
	return self;
}

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	[self _internalInit];
	
	return self;
}

- (UIView *)selectionOverlay
{
	return m_pSelectionOverlay;
}

- (void)_internalInit
{
	m_pSelectionOverlay = [UIView new];
	m_pSelectionOverlay.backgroundColor = [UIColor blackColor];
	m_pSelectionOverlay.alpha = 0.0f;
	m_pSelectionOverlay.opaque = TRUE;
	//m_pSelectionOverlay.userInteractionEnabled = FALSE;
	
	[self.contentView addSubview:m_pSelectionOverlay];
}

- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
	[self.contentView bringSubviewToFront:m_pSelectionOverlay];
	m_pSelectionOverlay.alpha = selected ? 0.25f : 0.0f;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	m_pSelectionOverlay.frame = self.bounds;
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	m_pSelectionOverlay.alpha = self.selected ? 0.25f : 0.0f;
}

@end
