//
//  AYAppDelegate.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/5/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYAppDelegate.h"
#import "AYHomeViewController.h"
#import "AYLoginViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

@interface AYAppDelegate () <AYLoginViewControllerDelegate>

@end

@implementation AYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [GMSServices provideAPIKey:kGoogleMapAPIKey];
    [Parse setApplicationId:@"ec9LcU46uOfdLo3SkXDVZOpIcDmBaKdjuPKkM4uJ"
                  clientKey:@"32FyZmRZnmEWRj6gIKuRk4dlu49pAW5fiMyyJzxD"];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert];
//    [[NSUserDefaults standardUserDefaults] setObject:@"pablom" forKey:@"userName"];
//    [[NSUserDefaults standardUserDefaults] setObject:@"pablom" forKey:@"password"];

    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if (userName && password) {
        [self loadHomeViewController];
    }
    else {
        [self loadLoginViewController];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)loadHomeViewController
{
    AYHomeViewController *homeVC = [[AYHomeViewController alloc] initWithNibName:@"AYHomeViewController" bundle:nil];
    [self.window setRootViewController:homeVC];
}

- (void)loadLoginViewController
{
    NSString *nibName = kIsDeviceiPad ? @"AYLoginViewController~iPad" : @"AYLoginViewController";
    AYLoginViewController *loginVC = [[AYLoginViewController alloc] initWithNibName:nibName bundle:nil];
    [loginVC setDelegate:self];
    [self.window setRootViewController:loginVC];
}

#pragma mark - AYLoginViewController Delegate Methods
- (void)didUserLoggedInSuccessfully
{
    [self loadHomeViewController];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Notifications related methods
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenString  = [[[deviceToken description]
                                     stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                                    stringByReplacingOccurrencesOfString:@" "
                                    withString:@""];
    NSLog(@"Registered for Push Notification:%@", deviceTokenString);
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"DeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register for push Notifications with error:%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    if(application.applicationState==UIApplicationStateInactive) {
//    }
//    else {
    [PFPush handlePush:userInfo];

//        NSDictionary *apsDict=  [userInfo objectForKey:@"aps"];
//        NSDictionary *alertDict=  [apsDict objectForKey:@"alert"];
//        UIAlertView *_alert=[[UIAlertView alloc]initWithTitle:@"Delphino" message:[alertDict objectForKey:@"loc-key"] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
//        [_alert show];
 //   }
}

@end
