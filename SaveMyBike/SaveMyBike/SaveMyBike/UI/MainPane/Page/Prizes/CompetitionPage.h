//
//  ActiveCompetitionPage.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 08/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Page.h"
#import "Competition.h"
#import "CompetitionParticipation.h"

@interface CompetitionPage : Page

- (id)initWithCompetition:(Competition *)cmp andParticipation:(CompetitionParticipation *)cp;

@end

