//
//  STSSimpleTableView.m
//
//  Created by Szymon Tomasz Stefanek on 12/30/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSimpleTableView.h"

#import "STSSimpleTableViewCell.h"

@interface STSSimpleTableView()<UITableViewDataSource,UITableViewDelegate>
{
	BOOL m_bInitDone;
	
	CGFloat m_fCellHeight;
}

@end

@implementation STSSimpleTableView

- (id)initWithDataProvider:(id<STSSimpleTableViewDataProvider>)pProvider
{
	self = [super initWithFrame:CGRectMake(0,0,100,100) style:UITableViewStylePlain];
	if(!self)
		return nil;
	[self _initSimpleTableView];
	self.dataProvider = pProvider;
	return self;
}

- (id)init
{
	self = [super initWithFrame:CGRectMake(0,0,100,100) style:UITableViewStylePlain];
	if(!self)
		return nil;
	[self _initSimpleTableView];
	return self;
}

- (id)initWithFrame:(CGRect)r
{
	self = [super initWithFrame:r style:UITableViewStylePlain];
	if(!self)
		return nil;
	[self _initSimpleTableView];
	return self;
}

- (id)initWithFrame:(CGRect)r style:(UITableViewStyle)eStyle
{
	self = [super initWithFrame:r style:eStyle];
	if(!self)
		return nil;
	[self _initSimpleTableView];
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithFrame:CGRectMake(0,0,100,100) style:UITableViewStylePlain];
	if(!self)
		return nil;
	[self _initSimpleTableView];
	return self;
}

- (void)_initSimpleTableView
{
	self.delegate = self;
	self.dataSource = self;
	m_bInitDone = true;
	m_fCellHeight = 0.0;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
	if(m_bInitDone)
	{
		NSException * crap = [NSException exceptionWithName:@"BadUsageException" reason:@"Don't set delegate on STSSimpleTableView. Set dataProvider instead." userInfo:nil];
		@throw crap;
		return;
	}
	
	[super setDelegate:delegate];
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
	if(m_bInitDone)
	{
		NSException * crap = [NSException exceptionWithName:@"BadUsageException" reason:@"Don't set dataSource on STSSimpleTableView. Set dataProvider instead." userInfo:nil];
		@throw crap;
		return;
	}
	
	[super setDataSource:dataSource];
}

- (void)setNeedsLayout
{
	m_fCellHeight = 0.0; // recompute
	[super setNeedsLayout];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(!_dataProvider)
		return 0;
	
	return [_dataProvider simpleTableViewGetRowCount:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(!_dataProvider)
		return nil;
	
	return [_dataProvider simpleTableView:self createCellForRow:(int)indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(!_dataProvider)
		return;
	
	if(![_dataProvider respondsToSelector:@selector(simpleTableViewSelectionChanged:)])
		return;
	
	[_dataProvider simpleTableViewSelectionChanged:self];
}

- (int)selectedRow
{
	NSIndexPath * p = [self indexPathForSelectedRow];
	if(!p)
		return -1;
	return (int)p.row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(m_fCellHeight > 0.0)
		return m_fCellHeight;

	if(_dataProvider && [_dataProvider respondsToSelector:@selector(simpleTableViewGetCellHeight:)])
	{
		m_fCellHeight = [_dataProvider simpleTableViewGetCellHeight:self];
		return m_fCellHeight;
	}
	
	UITableViewCell * c = [self tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	if(!c)
		return UITableViewAutomaticDimension;
	
	if(![c isKindOfClass:[STSSimpleTableViewCell class]])
		return UITableViewAutomaticDimension;
	
	m_fCellHeight = [c intrinsicContentSize].height;
	return m_fCellHeight;
}

@end
