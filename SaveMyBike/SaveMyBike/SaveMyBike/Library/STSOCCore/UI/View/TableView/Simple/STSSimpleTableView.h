//
//  STSSimpleTableView.h
//
//  Created by Szymon Tomasz Stefanek on 12/30/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "STSTableView.h"

@class STSSimpleTableView;

@protocol STSSimpleTableViewDataProvider<NSObject>

- (int)simpleTableViewGetRowCount:(STSSimpleTableView *)stv;
- (UITableViewCell *)simpleTableView:(STSSimpleTableView *)stv createCellForRow:(int)iRow;

@optional

- (void)simpleTableViewSelectionChanged:(STSSimpleTableView *)stv;
- (CGFloat)simpleTableViewGetCellHeight:(STSSimpleTableView *)stv;

@end

@interface STSSimpleTableView : STSTableView

- (id)initWithDataProvider:(id<STSSimpleTableViewDataProvider>)pProvider;

- (int)selectedRow;

@property (nonatomic) id<STSSimpleTableViewDataProvider> dataProvider;

@end
