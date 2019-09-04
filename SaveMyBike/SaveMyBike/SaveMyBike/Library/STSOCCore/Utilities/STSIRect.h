//
//  STSIRect.h
//
//  Created by Szymon Tomasz Stefanek on 22/03/2013.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSIRect : NSObject
{
@private
	int m_iX;
	int m_iY;
	int m_iW;
	int m_iH;
}

- (id)init;

- (id)initWithX:(int)iX y:(int)iY width:(int)iWidth height:(int)iHeight;

@property (nonatomic) int x;
@property (nonatomic) int y;
@property (nonatomic) int width;
@property (nonatomic) int height;

+ (STSIRect *)rectWithX:(int)iX y:(int)iY width:(int)iWidth height:(int)iHeight;

- (void)intersectWithX:(int)iX y:(int)iY width:(int)iWidth height:(int)iHeight;

- (bool)isEmpty;

@end
