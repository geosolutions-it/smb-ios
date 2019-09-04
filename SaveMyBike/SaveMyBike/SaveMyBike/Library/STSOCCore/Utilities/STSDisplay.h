//
//  STSDisplay.h
//  
//  Created by Szymon Tomasz Stefanek on 1/21/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface STSDisplay : NSObject

+(STSDisplay *)instance;

-(CGFloat)centimetersToScreenUnits:(CGFloat)fCentimeters;
-(CGFloat)millimetersToScreenUnits:(CGFloat)fMillimeters;
-(CGFloat)screenUnitsToMillimeters:(CGFloat)fScreenUnits;
-(CGFloat)screenUnitsToCentimeters:(CGFloat)fScreenUnits;

-(CGFloat)minorScreenDimensionFractionToScreenUnits:(CGFloat)fFraction;
-(CGFloat)majorScreenDimensionFractionToScreenUnits:(CGFloat)fFraction;
-(CGFloat)minorScreenDimensionFractionToCentimeters:(CGFloat)fFraction;
-(CGFloat)majorScreenDimensionFractionToCentimeters:(CGFloat)fFraction;

-(CGFloat)minorScreenDimensionFractionToScreenUnits:(CGFloat)fFraction notLessThanCM:(CGFloat)fMinCM notMoreThanCM:(CGFloat)fMaxCM;
-(CGFloat)majorScreenDimensionFractionToScreenUnits:(CGFloat)fFraction notLessThanCM:(CGFloat)fMinCM notMoreThanCM:(CGFloat)fMaxCM;

-(CGFloat)centimetersToFontUnits:(CGFloat)fCentimeters;
-(CGFloat)millimetersToFontUnits:(CGFloat)fMillimeters;

@end
