//
//  TitleImageAndDescriptionView.h
//  SaveMyBike
//
//  Created by Pragma on 26/09/2019.
//  Copyright © 2019 STS. All rights reserved.
//

#import "STSGridLayoutView.h"


@interface TitleImageAndDescriptionView : STSGridLayoutView

@property(nonatomic) NSString * openURL;

- (id)initWithTitle:(NSString *)sTitle imageURL:(NSString *)sURL placeholder:(NSString *)sPlaceholder description:(NSString *)sDescription;

@end

