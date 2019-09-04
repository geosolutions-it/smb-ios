//
//  STSGridItemViewDelegate.h
//  
//  Created by Szymon Tomasz Stefanek on 1/25/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#ifndef STSGridItemViewDelegate_h
#define STSGridItemViewDelegate_h

@class STSGridItemView;

#import "STSGridItemViewCell.h"

@protocol STSGridItemViewDelegate

- (NSInteger)gridItemView:(STSGridItemView * _Nonnull)pGridItemView numberOfItemsInSection:(NSInteger)iSection;

// Please note that you can use:
//   [pView registerClass:[some clas] forReuseWithIdentifier:...]
// and then
//   [pView dequeueReusableCellForWhatever
// Path contains section and item (do NOT use row)
- (STSGridItemViewCell * _Nullable)gridItemView:(STSGridItemView * _Nonnull)pGridItemView cellForItemAtIndexPath:(nonnull NSIndexPath *)path;
- (CGSize)sizeForCellsInGridItemView:(STSGridItemView * _Nonnull)pGridItemView;

@optional

- (NSInteger)numberOfSectionsInGridItemView:(STSGridItemView * _Nonnull)pGridItemView;
- (void)gridItemView:(STSGridItemView * _Nonnull)pGridItemView didSelectItemAtIndexPath:(nonnull NSIndexPath *)path;

@end

#endif /* STSGridItemViewDelegate_h */
