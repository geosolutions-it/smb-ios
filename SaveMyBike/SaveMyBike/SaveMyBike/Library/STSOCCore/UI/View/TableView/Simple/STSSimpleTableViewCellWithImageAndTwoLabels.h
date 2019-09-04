//
//  STSSimpleTableViewCellWithImageAndTwoLabels.h
//
//  Created by Szymon Tomasz Stefanek on 7/2/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSimpleTableViewCell.h"

#import "STSImageView.h"
#import "STSLabel.h"

@interface STSSimpleTableViewCellWithImageAndTwoLabels : STSSimpleTableViewCell

// DO NOT USE imageView, textLabel and detailTextLabel.

@property(nonatomic) STSImageView * iconView;
@property(nonatomic) STSLabel * upperLabel;
@property(nonatomic) STSLabel * lowerLabel;

@end
