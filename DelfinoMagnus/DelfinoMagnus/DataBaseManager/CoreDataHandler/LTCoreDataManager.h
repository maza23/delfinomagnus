//
//  LTCoreDataManager.h
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/8/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#define kDevicesEntityName          @"Device"
#define kUserEntityName             @"User"
#define kFavortiesEntityName        @"FavoriteDevice"
#define kDeviceDetailsEntityName    @"DeviceDetails"
#define kImagesEnityName            @"Images"
#define kZonaEntityName             @"Zona"
#define kTipoEntityName             @"Tipo"
#define kReservedEntityName         @"ReservedDevice"
#define kCalendarEntityName         @"Calendar"

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface LTCoreDataManager : NSManagedObject {
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (LTCoreDataManager *)sharedInstance;

//Methods to call
- (void)insertDevicesResultIntoDBFromRawResponse:(NSDictionary *)rawResponse;
- (void)insertDeviceDetalisIntoDBFromRawResponse:(NSDictionary *)rawResponse;
- (void)insertUserDetailsIntoDBFromRawResponse:(NSDictionary *)rawResponse;
- (void)insertFavoritesListIntoDBFromRawResponse:(NSArray *)devicesList;
- (void)insertReservedListIntoDBFromRawArray:(NSArray *)reservedDevices;

//Data base INternal Methods
- (BOOL)saveContext;
- (BOOL)insertToEntity:(NSString*)entityName withDetails:(NSDictionary *)details;

- (NSArray *)getAllRecordsFromEntity:(NSString *)entityName;
- (NSArray *)getRecordsFromEntity:(NSString *)entityName forAttribute:(NSString *)attributeName withKey:(NSString *)key;
- (NSArray *)getRecordsFromEntity:(NSString *)entityName forColumn1:(NSString *)columnName withValue1:(NSString *)value1 andColumn2:(NSString *)columnName2 withValue2:(NSString *)value2;
- (NSArray *)getMatchedRecordFromEntity:(NSString *)entityName forColumnName:(NSString *)columnName withValueToMatch:(NSString *)valueToMatch;

- (void)removeAllRowsFromEntity:(NSString*)entityName;
- (void)removeFromEntity:(NSString*)entityName forAttribute:(NSString *)attributeName recordWithKey:(id)key;

- (BOOL)updateEntity:(NSString *)entityName setDetails:(NSDictionary *)details whereAttribute:(NSString *)attributeName isEqualToValue:(id)key;


@end