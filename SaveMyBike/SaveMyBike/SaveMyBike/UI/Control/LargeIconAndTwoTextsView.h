//
//  LargeIconAndTwoTextsView.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 08/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "STSGridLayoutView.h"

@interface LargeIconAndTwoTextsView : STSGridLayoutView

- (id)initWithIcon:(NSString *)sIcon shortText:(NSString *)sShortText longText:(NSString *)sLongText;

- (void)setIcon:(NSString *)sIcon shortText:(NSString *)sShortText longText:(NSString *)sLongText;

@end
