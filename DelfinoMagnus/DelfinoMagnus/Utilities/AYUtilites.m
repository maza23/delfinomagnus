//
//  AYUtilites.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/12/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYUtilites.h"
#import "Tipo.h"

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
            
            [tipoDetails setObject:@{@"titleBGColor" : titleBGColor, @"tipoBGColor": tipoBGColor} forKey:tipo.tipoId];
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

@end
