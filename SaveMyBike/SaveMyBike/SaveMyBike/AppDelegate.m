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
#import "STSTypeConversion.h"
#import "STSDelegateArray.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,FIRMessagingDelegate>
{
	STSDelegateArray * m_pNotificationDelegates;
}
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
	
	m_pNotificationDelegates = [STSDelegateArray new];


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
	
#if defined(TARGET_OS_SIMULATOR) && (TARGET_OS_SIMULATOR != 0)
	// Trick for buggy iOS simulators that do not refresh. The activity indicator is animating and does refresh.
	// This does not works for simulators that have the ugly notch in the status bar (iPhone X and friends)
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
#endif
	
	[STSNetworkAvailabilityChecker startWithInterval:30];
	
	return YES;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
	STS_CORE_LOG(@"Will present notification");
	// This is never called: they configured the "content-available" field in the notification which
	// causes it to be treated as "silent".
	completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^__strong _Nonnull)(void))completionHandler
{
	STS_CORE_LOG(@"Did receive notification response");
}

- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage
{
	STS_CORE_LOG(@"Remote message");
}

- (void)addNotificationDelegate:(id<NotificationDelegate>)d
{
	[m_pNotificationDelegates addDelegate:d];
}

- (void)removeNotificationDelegate:(id<NotificationDelegate>)d
{
	[m_pNotificationDelegates removeDelegate:d];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
	STS_CORE_LOG(@"Remote notification");
	for(NSString * key in userInfo.allKeys)
	{
		STS_CORE_LOG(@"Data: %@ -> %@",key,[userInfo objectForKey:key]);
	}
	completionHandler(UIBackgroundFetchResultNewData);
	
	NSString * sMessage = [STSTypeConversion objectInDictionaryToString:userInfo key:@"message_name" defaultValue:@""];

	if([sMessage isEqualToString:@"track_validated"])
	{
		if([STSTypeConversion objectInDictionaryToBool:userInfo key:@"is_valid" defaultValue:false])
			[self showNotificationWithTitle:__trCtx(@"Congratulations!",@"AppDelegate") body:__trCtx(@"Your track has been received and validated",@"AppDelegate")];
		else
			[self showNotificationWithTitle:__trCtx(@"Track Invalid",@"AppDelegate") body:__trCtx(@"The track you have sent did not pass our validation rules",@"AppDelegate")];
	} else if([sMessage isEqualToString:@"badge_won"])
	{
		[self showNotificationWithTitle:__trCtx(@"Congratulations!",@"AppDelegate") body:__trCtx(@"You've earned a new badge!",@"AppDelegate")];
	} else if([sMessage isEqualToString:@"prize_won"])
	{
		[self showNotificationWithTitle:__trCtx(@"Congratulations!",@"AppDelegate") body:__trCtx(@"You have won a competition!",@"AppDelegate")];
	} else if([sMessage isEqualToString:@"bike_observed"])
	{
		[self showNotificationWithTitle:__trCtx(@"Heads Up!",@"AppDelegate") body:__trCtx(@"Your bike has been observed!",@"AppDelegate")];
	}

	if(m_pNotificationDelegates.count > 0)
		[m_pNotificationDelegates performSelectorOnAllDelegates:@selector(onNotificationReceived:) withObject:sMessage];
}

- (void)showNotificationWithTitle:(NSString *)sTitle body:(NSString *)sBody
{
	UNMutableNotificationContent * c = [UNMutableNotificationContent new];
	c.title = sTitle;
	c.body = sBody;
	
	UNNotificationTrigger * t = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.1 repeats:false];
	
	NSString * tag = [NSString stringWithFormat:@"%d%ld%d",rand(),time(NULL),rand()];
	
	UNNotificationRequest * rq = [UNNotificationRequest requestWithIdentifier:tag content:c trigger:t];
	
	[[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:rq withCompletionHandler:nil];
}

/*
 
 2019-09-26 05:09:32.813195+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Remote notification
 2019-09-26 05:09:32.813296+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: track_id -> 475
 2019-09-26 05:09:32.813334+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: validation_errors -> ,segment_speed_too_high (max_speed: 8.915696553607683 - foot)
 2019-09-26 05:09:32.813414+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: aps -> {
 "content-available" = 1;
 }
 2019-09-26 05:09:32.813444+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: message_name -> track_validated
 2019-09-26 05:09:32.813473+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: is_valid -> false
 2019-09-26 05:09:32.813502+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: user_uuid -> 3377c67f-92cb-4f2b-9eec-15372fd72661
 2019-09-26 05:09:32.813531+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: gcm.message_id -> 1569467372028209
 2019-09-26 05:09:32.813589+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: session_id -> 1569467338116
 2019-09-26 05:09:32.813619+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: user -> 3377c67f-92cb-4f2b-9eec-15372fd72661
 (lldb)
 
 2019-09-26 05:11:28.164021+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Remote notification
 2019-09-26 05:11:28.164437+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: track_id -> 476
 2019-09-26 05:11:28.164511+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: validation_errors ->
 2019-09-26 05:11:28.164670+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: aps -> {
 "content-available" = 1;
 }
 2019-09-26 05:11:28.164798+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: message_name -> track_validated
 2019-09-26 05:11:28.164865+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: is_valid -> true
 2019-09-26 05:11:28.164926+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: user_uuid -> 3377c67f-92cb-4f2b-9eec-15372fd72661
 2019-09-26 05:11:28.164985+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: gcm.message_id -> 1569467487866874
 2019-09-26 05:11:28.165044+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: session_id -> 1569467460576
 2019-09-26 05:11:28.165102+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: user -> 3377c67f-92cb-4f2b-9eec-15372fd72661
 2019-09-26 05:11:36.491469+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Remote notification
 2019-09-26 05:11:36.491609+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: gcm.message_id -> 1569467488439705
 2019-09-26 05:11:36.491848+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: user -> 3377c67f-92cb-4f2b-9eec-15372fd72661
 2019-09-26 05:11:36.492362+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: message_name -> indexes_have_been_calculated
 2019-09-26 05:11:36.492492+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: track_id -> 476
 2019-09-26 05:11:36.492646+0200 SaveMyBike[745:150895] [-[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]:81aba700] Data: aps -> {
 "content-available" = 1;
 }
 
 */

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
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
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
	
	[m_pNotificationDelegates removeAllDelegates];
	m_pNotificationDelegates = nil;
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
