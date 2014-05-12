//
//  AYNetworkManager.h
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/7/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

typedef void (^IDCompletionBlock) (id result);


#import <Foundation/Foundation.h>

@interface AYNetworkManager : NSObject

+ (AYNetworkManager *)sharedInstance;
- (void)loginWithUsername:(NSString *)usernName password:(NSString *)password withCompletionHandler:(IDCompletionBlock)completionBlock;

- (void)getDevicesListWithFilter:(NSString *)filter andDateString:(NSString *)dateString withCompletionHandler:(IDCompletionBlock)completionBlock;
- (void)getDeviceDetailsWithDeviceId:(NSString *)deviceId andCompletionBlock:(IDCompletionBlock)completionBlock;

- (void)getFavoritesListWithCompletionBlock:(IDCompletionBlock)completionBlock;
- (void)getReservationListWithCompletionBlock:(IDCompletionBlock)completionBlock;


- (void)addFavoritesDeviceWithId:(NSString *)deviceId andCompletionBlock:(IDCompletionBlock)completionBlock;
- (void)removeFavoritesDeviceWithId:(NSString *)deviceId andCompletionBlock:(IDCompletionBlock)completionBlock;

- (void)addResDeviceWithId:(NSString *)deviceId andCompletionBlock:(IDCompletionBlock)completionBlock;
- (void)removeResDeviceWithId:(NSString *)deviceId andCompletionBlock:(IDCompletionBlock)completionBlock;

- (void)generateasswordForMailId:(NSString *)mailId andCompletionBlock:(IDCompletionBlock)completionBlock;
@end
