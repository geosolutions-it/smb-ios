//
//  STSSimpleTableViewCell.h
//
//  Created by Szymon Tomasz Stefanek on 7/2/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STSGridLayoutView.h"

// THIS IS A BASE CLASS FOR CELLS THAT USE A GRID LAYOUT AS CONTAINER.

// WARNING: the original imageView, textLabel and detailTextLabel are NOT usable here.

@interface STSSimpleTableViewCell : UITableViewCell
	@property(nonatomic) STSGridLayoutView * grid;
@end
