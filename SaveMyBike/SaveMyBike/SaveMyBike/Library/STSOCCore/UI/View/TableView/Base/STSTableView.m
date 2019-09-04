//
//  STSTableView.m
//
//  Created by Szymon Tomasz Stefanek on 5/8/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSTableView.h"

@implementation STSTableView

-(void)layoutSubviews
{
	[super layoutSubviews];
	
	if ([self respondsToSelector:@selector(setSeparatorInset:)])
		[self setSeparatorInset:UIEdgeInsetsZero];
	if ([self respondsToSelector:@selector(setLayoutMargins:)])
		[self setLayoutMargins:UIEdgeInsetsZero];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([cell respondsToSelector:@selector(setSeparatorInset:)])
		[cell setSeparatorInset:UIEdgeInsetsZero];
	if ([cell respondsToSelector:@selector(setLayoutMargins:)])
		[cell setLayoutMargins:UIEdgeInsetsZero];
}

@end
