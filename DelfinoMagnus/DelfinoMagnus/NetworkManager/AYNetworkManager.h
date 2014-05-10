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

- (void)getFavoritesListWithCompletionBlock:(IDCompletionBlock)completionBlock;
@end
