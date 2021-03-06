//
//  AYUtilites.h
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/12/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AYUtilites : NSObject
+ (NSDictionary *)getTiposMarkerImageNames;
+ (NSDictionary *)getTiposIconImageNames;
+ (NSDictionary *)getTiposBackgroundColors;
+ (NSDictionary *)getTiposNameDictionary;
+ (NSDictionary *)getTiposIdAsObjectAndNameAsDictKeys;
+ (NSDictionary *)getZonaIdAsObjectAndNameAsDictKeys;
+ (UIFont *)fontWithSize:(float)iPhoneFontSize andiPadSize:(float)iPadFontSize;
@end
