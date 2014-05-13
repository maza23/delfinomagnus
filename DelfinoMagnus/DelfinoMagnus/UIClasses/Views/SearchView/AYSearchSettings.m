//
//  AYSearchSettings.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/10/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYSearchSettings.h"

@implementation AYSearchSettings

- (id)init
{
    self = [super init];
    
    if (self) {
        [self doInitialization];
    }
    
    return self;
}

#pragma mark - Private Methods
- (void)doInitialization
{
    self.tipoCartel = NO;
    self.tipoMonocolumna = NO;
    self.tipoMediawall = NO;
    self.tipoTelon = NO;
    self.zonaCapitalFederal = NO;
    self.zonaNorte = NO;
    self.zonaOeste = NO;
    self.zonaSur = NO;
    self.disponible = YES;
}

@end
