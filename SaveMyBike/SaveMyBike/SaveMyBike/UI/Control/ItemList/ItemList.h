//
//  ItemList.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 19/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "STSGridLayoutView.h"
#import "STSSimpleTableViewCellWithImageAndTwoLabels.h"
#import "LargeIconAndTwoTextsView.h"

@class STSSimpleTableView;

@interface ItemList : STSGridLayoutView

@property(nonatomic) NSMutableArray<NSObject *> * items;

- (id)init;

- (STSSimpleTableView *)tableView;

- (void)addCentralView:(UIView *)pView;
- (void)switchToCentralView:(UIView *)pView;

- (void)setItems:(NSMutableArray<NSObject *> *)pItems;

- (void)switchToTableView;
- (void)switchToWaitView;
- (void)switchToNothingHereYetView;
- (void)showErrorWithTitle:(NSString *)sTitle andMessage:(NSString *)sMessage;

- (CGFloat)onComputeTableViewCellHeight;
- (STSSimpleTableViewCell *)onCreateTableViewCell;
- (void)onSetupTableItemCell:(STSSimpleTableViewCell *)cell withItem:(NSObject *)ob;
- (void)onItemSelected:(NSObject *)ob;
- (LargeIconAndTwoTextsView *)onCreateNothingHereYetView;

@end

