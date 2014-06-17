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

@interface AYAppDelegate () <AYLoginViewControllerDelegate>

@end

@implementation AYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [GMSServices provideAPIKey:kGoogleMapAPIKey];
    
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
    AYHomeViewController *homeVC = [[AYHomeViewController alloc] initWithNibName:@"AYHomeViewController" bundle:nil isHomeScreen:YES];
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

@end
