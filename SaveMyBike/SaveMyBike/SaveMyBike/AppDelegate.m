#import "AppDelegate.h"

#import "Globals.h"
#import "Config.h"
#import "MainView.h"
#import "TopLevelViewController.h"
#import "Settings.h"
#import "STSI18N.h"
#import "AuthManager.h"
#import "TargetConditionals.h"
#import "Tracker.h"
#import "Database.h"
#import "UploadManager.h"
#import "NSData+Hashing.h"
#import "NSData+Base64.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Firebase.h>
#import "STSCore.h"
#import "NotificationManager.h"
#import <UserNotifications/UserNotifications.h>
#import "STSNetworkAvailabilityChecker.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,FIRMessagingDelegate>

@end

static AppDelegate * g_pAppDelegate = nil;

@implementation AppDelegate

+ (AppDelegate *)instance
{
	return g_pAppDelegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	g_pAppDelegate = self;


	[FIRApp configure];
	
	[FIRMessaging messaging].delegate = self;
	
	[Config init];
	[Globals init];
	[Database create];
	[[Database instance] attachToPath:[[Globals instance].dataDirectory stringByAppendingPathComponent:@"data.db"]];
	[AuthManager create];
	[Tracker create];
	[NotificationManager create];
	[UploadManager createWithDataPath:[[Globals instance].dataDirectory stringByAppendingPathComponent:@"uploads"]];

	[Settings create:[[Globals instance].dataDirectory stringByAppendingPathComponent:@"settings.dat"]];
	
	[[Settings instance] load];

	if((![Settings instance].uniqueId) || ([Settings instance].uniqueId.length < 1))
	{
		NSString * tmp = [NSString stringWithFormat:@"a%f%d%d%d%@",[NSDate timeIntervalSinceReferenceDate],rand(),rand(),rand(),[UIDevice currentDevice].name];
		NSData * data = [tmp dataUsingEncoding:NSUTF8StringEncoding];
		[Settings instance].uniqueId = [[data hashSHA256] base64EncodedString];
		[[Settings instance] save];
	}
	
	[self applyLanguage];

	//[application setStatusBarHidden:YES animated:NO];
	//application.statusBarHidden = true;

	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = [[TopLevelViewController alloc] init];

	[self.window makeKeyAndVisible];
	
	[[MainView instance] switchToAuthPage];
	
#if defined(TARGET_OS_SIMULATOR) && (TARGET_OS_SIMULATOR != 0)
	// Trick for buggy iOS simulators that do not refresh. The activity indicator is animating and does refresh.
	// This does not works for simulators that have the ugly notch in the status bar (iPhone X and friends)
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
#endif

	if ([UNUserNotificationCenter class] != nil) {
		// iOS 10 or later
		// For iOS 10 display notification (sent via APNS)
		[UNUserNotificationCenter currentNotificationCenter].delegate = self;
		UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
		[[UNUserNotificationCenter currentNotificationCenter]
		 requestAuthorizationWithOptions:authOptions
		 completionHandler:^(BOOL granted, NSError * _Nullable error) {
			 STS_CORE_LOG(@"User notification authorization completion granted=%d",granted);
		 }];
	} else {
		// iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
		UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
		UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
		[application registerUserNotificationSettings:settings];
	}
	
	[application registerForRemoteNotifications];
	
	[STSNetworkAvailabilityChecker startWithInterval:30];
	
	return YES;
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
	STS_CORE_LOG(@"Will present notification");
	completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
	STS_CORE_LOG(@"Did receive notification response");
}

- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage
{
	STS_CORE_LOG(@"Remote message");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
	STS_CORE_LOG(@"Remote notification");
	for(NSString * key in userInfo.allKeys)
	{
		STS_CORE_LOG(@"Data: %@ -> %@",key,[userInfo objectForKey:key]);
	}
	completionHandler(UIBackgroundFetchResultNoData);
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken
{
	if(!fcmToken)
		return; // doh?
	
	STS_CORE_LOG(@"Messaging reg token %@",fcmToken);
	
	[Globals instance].firebaseToken = fcmToken;
	
	[[NotificationManager instance] maybeStartNotificationRegistration];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	[FIRMessaging messaging].APNSToken = deviceToken;
	STS_CORE_LOG(@"Did register for remote notifications");
}


- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	[STSNetworkAvailabilityChecker startWithInterval:30];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	
	[STSNetworkAvailabilityChecker stop];
	[UploadManager destroy];
	[Tracker destroy];
	[NotificationManager destroy];
	[AuthManager destroy];
	[Settings destroy];
	[Database destroy];
	[Globals done];
	[Config done];
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applyLanguage
{
	NSString * szLanguage = [[NSLocale preferredLanguages] firstObject];
	
	[Globals instance].currentLanguage = szLanguage;
	
	if([szLanguage isEqualToString:@"it"] || ([szLanguage hasPrefix:@"it"] && (szLanguage.length > 2)))
	{
		[STSI18N loadCatalog:[[NSBundle mainBundle] pathForResource:@"SaveMyBike-it.po" ofType:nil]];
		//[[DataManager instance] setCurrentLanguage:@"it"];
	} else {
		[STSI18N unloadCatalog];
		//[[DataManager instance] setCurrentLanguage:@"en"];
	}
}


- (BOOL)application:(UIApplication *)app
			openURL:(NSURL *)url
			options:(NSDictionary<NSString *, id> *)options
{
	if([[AuthManager instance] handleOpenURL:url])
		return YES;
	
	return NO;
}


@end
