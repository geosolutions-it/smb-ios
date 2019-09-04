//
//  STSTabView.h
//  
//  Created by Szymon Tomasz Stefanek on 17/06/2019.
//  Copyright © 2019 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGridLayoutView.h"

#import "STSSegmentedControl.h"

@class STSViewStack;

@interface STSTabViewTab : NSObject

@property(nonatomic) NSString * text; // required
@property(nonatomic) NSString * icon; // optional
@property(nonatomic) NSString * selectedIcon; // optional
@property(nonatomic) UIView * view; // optional, may conform to the STSViewStackView protocol
@property(nonatomic,copy) UIView * (^createView)(); // required if view is nil

@end

@class STSTabView;

@protocol STSTabViewCurrentTabWatcher
- (void)onTabView:(STSTabView *)view currentTabChanged:(STSTabViewTab *)cur;
@end

@interface STSTabView : STSGridLayoutView

@property(nonatomic,readonly) STSSegmentedControl * segmentedControl;
@property(nonatomic,readonly) STSViewStack * viewStack;

- (id)init;
- (id)initWithSegmentedControlType:(STSSegmentedControlType)eType;
- (id)initWithTabsAbove:(bool)bAbove;
- (id)initWithTabsAbove:(bool)bAbove andSegmentedControlType:(STSSegmentedControlType)eType;

- (void)addTab:(STSTabViewTab *)tab;

- (STSTabViewTab *)currentTab;

- (void)setCurrentTab:(STSTabViewTab *)tab;
- (void)setCurrentTabByIndex:(int)iIndex;

- (void)addCurrentTabWatcher:(id<STSTabViewCurrentTabWatcher>)d;
- (void)removeCurrentTabWatcher:(id<STSTabViewCurrentTabWatcher>)d;

@end

