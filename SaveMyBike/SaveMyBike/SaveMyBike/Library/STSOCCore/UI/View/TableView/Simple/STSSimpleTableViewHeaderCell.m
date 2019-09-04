//
//  STSSimpleTableViewHeaderCell.m
//
//  Created by Szymon Tomasz Stefanek on 9/10/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All righs reserved.
//

#import "STSSimpleTableViewHeaderCell.h"

@implementation STSSimpleTableViewHeaderCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithReuseIdentifier:reuseIdentifier];
	if(!self)
		return nil;
	
	self.grid = [STSGridLayoutView new];
	
	[self.contentView addSubview:self.grid];

	/*
	[super imageView].hidden = true;
	self.textLabel.hidden = true;
	self.detailTextLabel.hidden = true;
	*/

	return self;
}

- (void)layoutSubviews
{
	CGSize s = self.frame.size;
	self.contentView.frame = CGRectMake(0,0,s.width,s.height);
	self.grid.frame = CGRectMake(0,0,s.width,s.height);
	[self.grid layoutSubviews];
}

- (void)setNeedsLayout
{
	[super setNeedsLayout];
	[self.grid setNeedsLayout];
}

- (CGSize)intrinsicContentSize
{
	return [self.grid intrinsicContentSize];
}

- (CGSize)sizeThatFits:(CGSize)size
{
	return [self.grid sizeThatFits:size];
}

@end
