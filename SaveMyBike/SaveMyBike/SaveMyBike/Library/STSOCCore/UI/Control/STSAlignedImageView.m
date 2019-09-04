//
//  UIImageViewAligned.m
//  awards
//
//  Created by Andrei Stanescu on 7/29/13.
//

#import "STSAlignedImageView.h"

@implementation STSAlignedImageView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		[self commonInit];
	}
	return self;
}

- (id)init
{
	self = [super init];
	if (self)
	{
		[self commonInit];
	}
	return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self commonInit];
    return self;
}

- (void)commonInit
{
    _enableScaleDown = TRUE;
    _enableScaleUp = TRUE;
    
    _alignment = STSImageViewAlignmentMaskCenter;
    
    _realImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _realImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _realImageView.contentMode = self.contentMode;
    [self addSubview:_realImageView];
}

- (UIImage*)image
{
    return _realImageView.image;
}

- (void)setImage:(UIImage *)image
{
    [_realImageView setImage:image];
    [self setNeedsLayout];
}

- (void)setContentMode:(UIViewContentMode)contentMode
{
    [super setContentMode:contentMode];
    _realImageView.contentMode = contentMode;
    [self setNeedsLayout];
}

- (void)setAlignment:(STSImageViewAlignmentMask)alignment
{
    if (_alignment == alignment)
        return ;
    
    _alignment = alignment;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    CGSize realsize = [self realContentSize];
    
    // Start centered
    CGRect realframe = CGRectMake((self.bounds.size.width - realsize.width)/2, (self.bounds.size.height - realsize.height) / 2, realsize.width, realsize.height);
    
    if ((_alignment & STSImageViewAlignmentMaskLeft) != 0)
        realframe.origin.x = 0;
    else if ((_alignment & STSImageViewAlignmentMaskRight) != 0)
        realframe.origin.x = CGRectGetMaxX(self.bounds) - realframe.size.width;
    
    if ((_alignment & STSImageViewAlignmentMaskTop) != 0)
        realframe.origin.y = 0;
    else if ((_alignment & STSImageViewAlignmentMaskBottom) != 0)
        realframe.origin.y = CGRectGetMaxY(self.bounds) - realframe.size.height;
    
    _realImageView.frame = realframe;
}

- (CGSize)realContentSize
{
    CGSize size = self.bounds.size;

    if (self.image == nil)
        return size;

    switch (self.contentMode)
    {
        case UIViewContentModeScaleAspectFit:
        {
            float scalex = self.bounds.size.width / _realImageView.image.size.width;
            float scaley = self.bounds.size.height / _realImageView.image.size.height;
            float scale = MIN(scalex, scaley);

            if ((scale > 1.0f && !_enableScaleUp) ||
                (scale < 1.0f && !_enableScaleDown))
                scale = 1.0f;
            size = CGSizeMake(_realImageView.image.size.width * scale, _realImageView.image.size.height * scale);
            break;
        }
            
        case UIViewContentModeScaleAspectFill:
        {
            float scalex = self.bounds.size.width / _realImageView.image.size.width;
            float scaley = self.bounds.size.height / _realImageView.image.size.height;
            float scale = MAX(scalex, scaley);
            
            if ((scale > 1.0f && !_enableScaleUp) ||
                (scale < 1.0f && !_enableScaleDown))
                scale = 1.0f;
            
            size = CGSizeMake(_realImageView.image.size.width * scale, _realImageView.image.size.height * scale);
            break;
        }
            
        case UIViewContentModeScaleToFill:
        {
            float scalex = self.bounds.size.width / _realImageView.image.size.width;
            float scaley = self.bounds.size.height / _realImageView.image.size.height;

            if ((scalex > 1.0f && !_enableScaleUp) ||
                (scalex < 1.0f && !_enableScaleDown))
                scalex = 1.0f;
            if ((scaley > 1.0f && !_enableScaleUp) ||
                (scaley < 1.0f && !_enableScaleDown))
                scaley = 1.0f;
            
            size = CGSizeMake(_realImageView.image.size.width * scalex, _realImageView.image.size.height * scaley);
            break;
        }

        default:
            size = _realImageView.image.size;
            break;
    }

    return size;
}


#pragma mark - Properties needed for Interface Builder

- (BOOL)alignLeft
{
    return (_alignment & STSImageViewAlignmentMaskLeft) != 0;
}
- (void)setAlignLeft:(BOOL)alignLeft
{
    if (alignLeft)
        self.alignment |= STSImageViewAlignmentMaskLeft;
    else
        self.alignment &= ~STSImageViewAlignmentMaskLeft;
}

- (BOOL)alignRight
{
    return (_alignment & STSImageViewAlignmentMaskRight) != 0;
}
- (void)setAlignRight:(BOOL)alignRight
{
    if (alignRight)
        self.alignment |= STSImageViewAlignmentMaskRight;
    else
        self.alignment &= ~STSImageViewAlignmentMaskRight;
}


- (BOOL)alignTop
{
    return (_alignment & STSImageViewAlignmentMaskTop) != 0;
}
- (void)setAlignTop:(BOOL)alignTop
{
    if (alignTop)
        self.alignment |= STSImageViewAlignmentMaskTop;
    else
        self.alignment &= ~STSImageViewAlignmentMaskTop;
}

- (BOOL)alignBottom
{
    return (_alignment & STSImageViewAlignmentMaskBottom) != 0;
}
- (void)setAlignBottom:(BOOL)alignBottom
{
    if (alignBottom)
        self.alignment |= STSImageViewAlignmentMaskBottom;
    else
        self.alignment &= ~STSImageViewAlignmentMaskBottom;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self.realImageView sizeThatFits:size];
}

- (CGSize)intrinsicContentSize
{
	return [self.realImageView intrinsicContentSize];
}

@end
