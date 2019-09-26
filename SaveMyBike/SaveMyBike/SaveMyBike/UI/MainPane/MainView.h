//
//  MainView.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 1/6/19.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STSPageStackView;
@class BeaconMapRoom;
@class ContentsWorkEx;
@class ContentsPathEx;
@class Competition;
@class CompetitionParticipation;
@class Track;
@class TracksPage;
@class Bike;

@interface MainView : UIView

- (id)initWithFrame:(CGRect)frame;

+ (MainView *)instance;

- (void)switchToAuthPage;
- (void)switchToHomePage;

- (void)switchToBadgesPage;
- (void)switchToCompetitionsPage;
- (void)switchToAboutPage;
- (void)switchToBikesPage;
- (void)switchToTracksPage;
- (void)switchToStatsPage;
- (void)switchToProfilePage;

- (void)pushBadgesPage;
- (void)pushCompetitionsPage;
- (void)pushBikesPage;
- (void)pushTracksPage;
- (void)pushCompetitionPage:(Competition *)cmp withParticipation:(CompetitionParticipation *)cp;
- (void)pushWonCompetitionPage:(Competition *)cmp withParticipation:(CompetitionParticipation *)cp;
- (void)pushTrackPage:(Track *)trk;
- (void)pushBikePage:(Bike *)bk;

- (void)popCurrentPage;

@end
