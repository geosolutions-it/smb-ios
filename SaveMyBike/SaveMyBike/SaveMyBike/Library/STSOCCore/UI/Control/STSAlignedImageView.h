//
//  STSAlignedImageView.h
//
//  Created by Andrei Stanescu on 7/29/13.
//

#import <UIKit/UIKit.h>

typedef enum
{
    STSImageViewAlignmentMaskCenter = 0,
    
    STSImageViewAlignmentMaskLeft   = 1,
    STSImageViewAlignmentMaskRight  = 2,
    STSImageViewAlignmentMaskTop    = 4,
    STSImageViewAlignmentMaskBottom = 8,
    
    STSImageViewAlignmentMaskBottomLeft = STSImageViewAlignmentMaskBottom | STSImageViewAlignmentMaskLeft,
    STSImageViewAlignmentMaskBottomRight = STSImageViewAlignmentMaskBottom | STSImageViewAlignmentMaskRight,
    STSImageViewAlignmentMaskTopLeft = STSImageViewAlignmentMaskTop | STSImageViewAlignmentMaskLeft,
    STSImageViewAlignmentMaskTopRight = STSImageViewAlignmentMaskTop | STSImageViewAlignmentMaskRight,
    
} STSImageViewAlignmentMask;

typedef STSImageViewAlignmentMask UIImageViewAignmentMask __attribute__((deprecated("Use STSImageViewAlignmentMask. Use of UIImageViewAignmentMask (misspelled) is deprecated.")));



@interface STSAlignedImageView : UIView

// This property holds the current alignment
@property (nonatomic) STSImageViewAlignmentMask alignment;

// Properties needed for Interface Builder quick setup
@property (nonatomic) BOOL alignLeft;
@property (nonatomic) BOOL alignRight;
@property (nonatomic) BOOL alignTop;
@property (nonatomic) BOOL alignBottom;

// Make the UIImageView scale only up or down
// This are used only if the content mode is Scaled
@property (nonatomic) BOOL enableScaleUp;
@property (nonatomic) BOOL enableScaleDown;

// Just in case you need access to the inner image view
@property (nonatomic, readonly) UIImageView* realImageView;

@property (nonatomic) UIImage * image;

@end
