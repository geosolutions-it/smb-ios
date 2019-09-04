//
//  STSSimpleTableViewHeaderCell.h
//
//  Created by Szymon Tomasz Stefanek on 9/10/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STSGridLayoutView.h"

// THIS IS A BASE CLASS FOR HEADERS THAT USE A GRID LAYOUT AS CONTAINER.

// WARNING: the original subviews are NOT usable here.

@interface STSSimpleTableViewHeaderCell : UITableViewHeaderFooterView
	@property(nonatomic) STSGridLayoutView * grid;
@end
