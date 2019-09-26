#import <UIKit/UIKit.h>

@protocol NotificationDelegate

- (void)onNotificationReceived:(NSString *)sMessage;

@end


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)applyLanguage;

+ (AppDelegate *)instance;

- (void)addNotificationDelegate:(id<NotificationDelegate>)d;
- (void)removeNotificationDelegate:(id<NotificationDelegate>)d;

@end

