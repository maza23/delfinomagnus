//
//  AYConstants.h
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/6/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//


//Common Header files to include
#import "AYNetworkManager.h"
#import "MBProgressHUD.h"
#import "BZLogger.h"
#import "LTCoreDataManager.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+ISOverlayColor.h"
#import "AYUtilites.h"

#define kGoogleMapAPIKey @"AIzaSyC_Lr5AgnLf9RKI7Nki0KXV9dlLA9uZ4BE"// AIzaSyChjm9vvi4U9DJ3SW6Kv3u6q98dePgbuH0
#define kGoogleId        @"20f0ee83976d9716bc3975acb6398745692873645"// currently using for login

//URL constants
#define kBaseServerURL          @"http://delfinomagnus.com/api/"


#define kIsDeviceiPad   UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()
#define kIsOrientationLandscape UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)
#define kIsDeviceScreen4Inches  ([[UIScreen mainScreen] bounds].size.height == 568)

#define kDeviceWillChangeOrientation  @"DeviceWillChangeOrientation"