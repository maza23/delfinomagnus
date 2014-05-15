//
//  Calendar.h
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/15/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DeviceDetails;

@interface Calendar : NSManagedObject

@property (nonatomic, retain) NSString * fecha;
@property (nonatomic, retain) NSString * disponible;
@property (nonatomic, retain) NSString * deviceId;
@property (nonatomic, retain) DeviceDetails *device;

@end
