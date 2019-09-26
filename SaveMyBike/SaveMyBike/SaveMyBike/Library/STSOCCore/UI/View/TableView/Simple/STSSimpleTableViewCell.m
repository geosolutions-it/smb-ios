//
//  STSSimpleTableViewCell.m
//
//  Created by Szymon Tomasz Stefanek on 7/2/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSimpleTableViewCell.h"

@implementation STSSimpleTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
	if(!self)
		return nil;
	
	_topOuterMargin = 0.0;
	_bottomOuterMargin = 0.0;
	_leftOuterMargin = 0.0;
	_rightOuterMargin = 0.0;
	_grid = [STSGridLayoutView new];
	
	[self.contentView addSubview:_grid];

	/*
	[super imageView].hidden = true;
	self.textLabel.hidden = true;
	self.detailTextLabel.hidden = true;
	*/

	return self;
}

- (CGSize)intrinsicContentSize;
{
	CGSize s = [self.grid intrinsicContentSize];
	
	return CGSizeMake(s.width + _leftOuterMargin + _rightOuterMargin, s.height + _topOuterMargin + _bottomOuterMargin);
}

- (void)layoutSubviews
{
	CGSize s = self.frame.size;
	self.contentView.frame = CGRectMake(0,0,s.width,s.height);
	self.grid.frame = CGRectMake(_leftOuterMargin,_topOuterMargin,s.width - _rightOuterMargin - _leftOuterMargin,s.height - _topOuterMargin - _bottomOuterMargin);
	[self.grid layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setNeedsLayout
{
	[super setNeedsLayout];
	[self.grid setNeedsLayout];
}

- (CGSize)sizeThatFits:(CGSize)size
{
	return [self.grid sizeThatFits:CGSizeMake(size.width - _leftOuterMargin - _rightOuterMargin, size.height - _topOuterMargin - _bottomOuterMargin)];
}

@end
