//
//  DeviceDetails.h
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/15/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Calendar, Images;

@interface DeviceDetails : NSManagedObject

@property (nonatomic, retain) NSString * deviceDescription;
@property (nonatomic, retain) NSString * deviceId;
@property (nonatomic, retain) NSString * disponible;
@property (nonatomic, retain) NSString * fechaalta;
@property (nonatomic, retain) NSString * fechamodif;
@property (nonatomic, retain) NSString * htmlDescription;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * orden;
@property (nonatomic, retain) NSString * tipo;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSString * urlimgs;
@property (nonatomic, retain) NSString * zona;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) NSSet *calendars;
@end

@interface DeviceDetails (CoreDataGeneratedAccessors)

- (void)addImagesObject:(Images *)value;
- (void)removeImagesObject:(Images *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addCalendarsObject:(Calendar *)value;
- (void)removeCalendarsObject:(Calendar *)value;
- (void)addCalendars:(NSSet *)values;
- (void)removeCalendars:(NSSet *)values;

@end
