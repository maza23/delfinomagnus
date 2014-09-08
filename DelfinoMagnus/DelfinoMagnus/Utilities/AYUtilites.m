//
//  AYUtilites.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/12/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYUtilites.h"
#import "Tipo.h"
#import "Zona.h"

@implementation AYUtilites

+ (NSDictionary *)getTiposMarkerImageNames
{
    static NSMutableDictionary *tipoDetails = nil;
    
    if (!tipoDetails) {
        
        NSArray *tipoArray = [[LTCoreDataManager sharedInstance] getAllRecordsFromEntity:kTipoEntityName];
        tipoDetails = [[NSMutableDictionary alloc]  initWithCapacity:0];
        
        for (Tipo *tipo in tipoArray) {
            
            NSString *imageName = @"telones_icon.png";
            
            if ([tipo.name isEqualToString:@"Cartel"]) {
                imageName = @"carteles_icon.png";
            }
            else if ([tipo.name isEqualToString:@"Mediawall"]) {
                imageName = @"mediawall_icon.png";
            }
            else if ([tipo.name isEqualToString:@"Monocolumna"]) {
                imageName = @"monocolumnas_icon.png";
            }
            else if ([tipo.name isEqualToString:@"Tel\u00f3n"]) {
                imageName = @"telones_icon.png";
            }
            
            [tipoDetails setObject:imageName forKey:tipo.tipoId];
        }
        
    }
    
    return tipoDetails;
}

+ (NSDictionary *)getTiposIconImageNames
{
    static NSMutableDictionary *tipoDetails = nil;
    
    if (!tipoDetails) {
        
        NSArray *tipoArray = [[LTCoreDataManager sharedInstance] getAllRecordsFromEntity:kTipoEntityName];
        tipoDetails = [[NSMutableDictionary alloc]  initWithCapacity:0];
        
        for (Tipo *tipo in tipoArray) {
            
            NSString *imageName = @"ico_pantalla_led_2.png";
            
            if ([tipo.name isEqualToString:@"Cartel"]) {
                imageName = @"cartel.png";
            }
            else if ([tipo.name isEqualToString:@"Mediawall"]) {
                imageName = @"mediawall.png";
            }
            else if ([tipo.name isEqualToString:@"Monocolumna"]) {
                imageName = @"monocolumna.png";
            }
//            else if ([tipo.name isEqualToString:@"Tel\u00f3n"]) {
//                imageName = @"telon.png";
//            }
            else if ([tipo.name isEqualToString:@"Pantalla LED"]) {
                imageName = @"ico_pantalla_led_2.png";
            }
            
            [tipoDetails setObject:imageName forKey:tipo.tipoId];
        }
        
    }
    
    return tipoDetails;
}

+ (NSDictionary *)getTiposBackgroundColors
{
    static NSMutableDictionary *tipoDetails = nil;
    
    if (!tipoDetails) {
        NSArray *tipoArray = [[LTCoreDataManager sharedInstance] getAllRecordsFromEntity:kTipoEntityName];
        tipoDetails = [[NSMutableDictionary alloc]  initWithCapacity:0];
        
        for (Tipo *tipo in tipoArray) {
            
            UIColor *titleBGColor = [UIColor redColor];
            UIColor *tipoBGColor = [UIColor yellowColor];
            
            if ([tipo.name isEqualToString:@"Cartel"]) {
                titleBGColor = [self colorFromHexString:@"#A1252A"];
                tipoBGColor = [self colorFromHexString:@"#EACA48"];
            }
            else if ([tipo.name isEqualToString:@"Mediawall"]) {
                titleBGColor = [self colorFromHexString:@"#EACA48"];
                tipoBGColor = [self colorFromHexString:@"#A1252A"];
            }
            else if ([tipo.name isEqualToString:@"Monocolumna"]) {
                titleBGColor = [self colorFromHexString:@"#F0F1F1"];
                tipoBGColor = [self colorFromHexString:@"#206C9B"];
            }
            else if ([tipo.name isEqualToString:@"Tel\u00f3n"]) {
                titleBGColor = [self colorFromHexString:@"#206C9B"];
                tipoBGColor = [self colorFromHexString:@"#A1252A"];
            }
            else if ([tipo.name isEqualToString:@"Pantalla LED"]) {
                titleBGColor = [self colorFromHexString:@"#206C9B"];
                tipoBGColor = [self colorFromHexString:@"#A1252A"];
            }
            
            [tipoDetails setObject:@{@"titleBGColor" : titleBGColor, @"tipoBGColor": tipoBGColor} forKey:tipo.tipoId];
        }
    }
    
    return tipoDetails;
}

+ (NSDictionary *)getTiposIdAsObjectAndNameAsDictKeys
{
    static NSMutableDictionary *tipoDetails = nil;
    
    if (!tipoDetails) {
        
        NSArray *tipoArray = [[LTCoreDataManager sharedInstance] getAllRecordsFromEntity:kTipoEntityName];
        tipoDetails = [[NSMutableDictionary alloc]  initWithCapacity:0];
        
        for (Tipo *tipo in tipoArray) {
            
            NSString *tipoName = @"";
            
            if ([tipo.name isEqualToString:@"Cartel"]) {
                tipoName = @"Cartel";
            }
            else if ([tipo.name isEqualToString:@"Mediawall"]) {
                tipoName = @"Mediawall";
            }
            else if ([tipo.name isEqualToString:@"Monocolumna"]) {
                tipoName = @"Monocolumna";
            }
            else if ([tipo.name isEqualToString:@"Tel\u00f3n"]) {
                tipoName = @"Telon";
            }
            else if ([tipo.name isEqualToString:@"Pantalla LED"]) {
                tipoName = @"Pantalla LED";
            }
            
            [tipoDetails setObject:tipo.tipoId forKey:tipoName];
        }
        
    }
    
    return tipoDetails;
}

/*
 "zonas": [
 {
 "id": "1",
 "nombre": "Ciudad Aut\u00f3noma de Buenos Aires"
 },
 {
 "id": "2",
 "nombre": "Zona Norte"
 },
 {
 "id": "3",
 "nombre": "Zona Oeste"
 },
 {
 "id": "4",
 "nombre": "Zona Sur"
 },
 {
 "id": "5",
 "nombre": "Rosario"
 },
 {
 "id": "6",
 "nombre": "San Miguel de Tucum\u00e1n"
 }
 ],
 */
+ (NSDictionary *)getZonaIdAsObjectAndNameAsDictKeys
{
    static NSMutableDictionary *tipoDetails = nil;
    
    if (!tipoDetails) {
        
        NSArray *zonaArray = [[LTCoreDataManager sharedInstance] getAllRecordsFromEntity:kZonaEntityName];
        tipoDetails = [[NSMutableDictionary alloc]  initWithCapacity:0];
        
        for (Zona *zona in zonaArray) {
            
            NSString *zonaName = @"";
            
            if ([zona.name isEqualToString:@"Ciudad Aut\u00f3noma de Buenos Aires"]) {
                zonaName = @"CapitalFederal";
            }
            else if ([zona.name isEqualToString:@"Zona Norte"]) {
                zonaName = @"Norte";
            }
            else if ([zona.name isEqualToString:@"Zona Sur"]) {
                zonaName = @"Sur";
            }
            else if ([zona.name isEqualToString:@"Zona Oeste"]) {
                zonaName = @"Oeste";
            }
            
            [tipoDetails setObject:zona.zonaId forKey:zonaName];
        }
        
    }
    
    return tipoDetails;
}

+ (NSDictionary *)getTiposNameDictionary
{
    static NSMutableDictionary *tipoDetails = nil;
    
    if (!tipoDetails) {
        
        NSArray *tipoArray = [[LTCoreDataManager sharedInstance] getAllRecordsFromEntity:kTipoEntityName];
        tipoDetails = [[NSMutableDictionary alloc]  initWithCapacity:0];
        
        for (Tipo *tipo in tipoArray) {
            [tipoDetails setObject:tipo.name forKey:tipo.tipoId];
        }
    }
    
    return tipoDetails;
}

+ (UIColor *) colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIFont *)fontWithSize:(float)iPhoneFontSize andiPadSize:(float)iPadFontSize
{
    return [UIFont fontWithName:@"Century Gothic" size:(kIsDeviceiPad ? iPadFontSize: iPhoneFontSize)];
}

@end
