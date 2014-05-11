//
//  Images.h
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/11/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DeviceDetails;

@interface Images : NSManagedObject

@property (nonatomic, retain) NSString * archivo;
@property (nonatomic, retain) NSString * height;
@property (nonatomic, retain) NSString * width;
@property (nonatomic, retain) NSString * minHeight;
@property (nonatomic, retain) NSString * minWidth;
@property (nonatomic, retain) NSString * fechahora;
@property (nonatomic, retain) NSString * imageId;
@property (nonatomic, retain) NSString * orden;
@property (nonatomic, retain) NSString * deviceId;
@property (nonatomic, retain) DeviceDetails *device;

@end
