//
//  Device.h
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/8/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Device : NSManagedObject

@property (nonatomic, retain) NSString * deviceId;
@property (nonatomic, retain) NSString * disponible;
@property (nonatomic, retain) NSString * fechaalta;
@property (nonatomic, retain) NSString * fechamodif;
@property (nonatomic, retain) NSString * htmldescripcion;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * orden;
@property (nonatomic, retain) NSString * tipo;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSString * zona;
@property (nonatomic, retain) NSString * devicedescription;

@end
