//
//  STSGridItemViewCell.h
// 
//  Created by Szymon Tomasz Stefanek on 1/25/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

// Please note that you can use:
//   [pView registerClass:[this subclass] forReuseWithIdentifier:...]
// and then
//   [pView dequeueReusableCellForWhatever
// Path contains section and item (do NOT use row)
//
// The children must be added to the UIView exposed by the contentView property.
// Also remember to reimplement both initializer init: and initWithFrame:() because
// cocoa uses that to instantiate the cells via dequeueReusableShit:*.
@interface STSGridItemViewCell : UICollectionViewCell

- (id)init;
- (id)initWithFrame:(CGRect)frame;

- (UIView *)selectionOverlay;

@end
