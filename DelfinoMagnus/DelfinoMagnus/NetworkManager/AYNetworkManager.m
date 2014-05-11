//
//  AYNetworkManager.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/7/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#define kMaxConcurrentOperations 5
#define kMaxRequestTimeOutinterval 30 //In sceonds

#import "AYNetworkManager.h"

@interface AYNetworkManager () <NSURLSessionDelegate> {
}

@property (strong, nonatomic) NSOperationQueue *networkQueue;
@property (strong, nonatomic) NSURLSession *urlSession;
@end

@implementation AYNetworkManager

static AYNetworkManager *sharedManager = nil;

+ (AYNetworkManager *)sharedInstance
{
    if (sharedManager) {
        return sharedManager;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedManager = [[AYNetworkManager alloc] init];
    });
    
    return sharedManager;
}

- (id)init
{
    if (self = [super init]) {
        self.networkQueue = [[NSOperationQueue alloc] init];
        [self.networkQueue setMaxConcurrentOperationCount:kMaxConcurrentOperations];
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    }
    
    return self;
}

#pragma mark - Public Methods
- (void)loginWithUsername:(NSString *)usernName password:(NSString *)password withCompletionHandler:(IDCompletionBlock)completionBlock
{
    [self.networkQueue addOperationWithBlock:^{
        
        NSURLRequest *request = [self getURLRequestUserLoginWithUserName:usernName andPassword:password];
        [self getDataForURLRequest:request withCompletionBlock:completionBlock];
    }];

}

- (void)getDevicesListWithFilter:(NSString *)filter andDateString:(NSString *)dateString withCompletionHandler:(IDCompletionBlock)completionBlock
{
    [self.networkQueue addOperationWithBlock:^{
        
        NSURLRequest *request = [self getURLRequestToGetDevicesWithFilter:filter andDateString:dateString];
        [self getDataForURLRequest:request withCompletionBlock:completionBlock];
    }];
}

- (void)getFavoritesListWithCompletionBlock:(IDCompletionBlock)completionBlock
{
    [self.networkQueue addOperationWithBlock:^{
        
        NSURLRequest *request = [self getURLRequestToGetFavoritesAndReservationListWithAction:@"listfav"];
        [self getDataForURLRequest:request withCompletionBlock:completionBlock];
    }];
}

- (void)getReservationListWithCompletionBlock:(IDCompletionBlock)completionBlock
{
    [self.networkQueue addOperationWithBlock:^{
        
        NSURLRequest *request = [self getURLRequestToGetFavoritesAndReservationListWithAction:@"listres"];
        [self getDataForURLRequest:request withCompletionBlock:completionBlock];
    }];
}

- (void)getDeviceDetailsWithDeviceId:(NSString *)deviceId andCompletionBlock:(IDCompletionBlock)completionBlock
{
    [self.networkQueue addOperationWithBlock:^{
        
        NSURLRequest *request = [self getURLRequestToGetDeviceDetailsWithDeviceId:deviceId];
        [self getDataForURLRequest:request withCompletionBlock:completionBlock];
    }];
}

- (void)addFavoritesDeviceWithId:(NSString *)deviceId andCompletionBlock:(IDCompletionBlock)completionBlock
{
    [self.networkQueue addOperationWithBlock:^{
        
        NSURLRequest *request = [self getURLRequestWithAction:@"addfav" andDeviceId:deviceId];
        [self getDataForURLRequest:request withCompletionBlock:completionBlock];
    }];
}

- (void)removeFavoritesDeviceWithId:(NSString *)deviceId andCompletionBlock:(IDCompletionBlock)completionBlock
{
    [self.networkQueue addOperationWithBlock:^{
        
        NSURLRequest *request = [self getURLRequestWithAction:@"delfav" andDeviceId:deviceId];
        [self getDataForURLRequest:request withCompletionBlock:completionBlock];
    }];
}

- (void)addResDeviceWithId:(NSString *)deviceId andCompletionBlock:(IDCompletionBlock)completionBlock
{
    [self.networkQueue addOperationWithBlock:^{
        
        NSURLRequest *request = [self getURLRequestWithAction:@"addres" andDeviceId:deviceId];
        [self getDataForURLRequest:request withCompletionBlock:completionBlock];
    }];
}

- (void)removeResDeviceWithId:(NSString *)deviceId andCompletionBlock:(IDCompletionBlock)completionBlock
{
    [self.networkQueue addOperationWithBlock:^{
        
        NSURLRequest *request = [self getURLRequestWithAction:@"delres" andDeviceId:deviceId];
        [self getDataForURLRequest:request withCompletionBlock:completionBlock];
    }];
}

#pragma mark - Private Methods
- (NSURLRequest *)getURLRequestUserLoginWithUserName:(NSString *)userName andPassword:(NSString *)password
{
    NSString * urlString = [NSString stringWithFormat:@"%@", kBaseServerURL];

    NSString *postString = [NSString stringWithFormat:@"action=userlogin&username=%@&password=%@&regid=%@", userName, password, kGoogleId];
    
  //  NSString *urlString = @"http://localhost/userDetails.json";

    NSMutableURLRequest *request = (NSMutableURLRequest *)[self getBaseURLRequestForURLString:urlString withMethod:@"POST"];
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}


- (NSURLRequest *)getURLRequestToGetDevicesWithFilter:(NSString *)filter andDateString:(NSString *)dateString
{//action=listdevices&filter=fechamodif&data=2013-03-02&username=pablom&password=pablom
    NSString * urlString = [NSString stringWithFormat:@"%@", kBaseServerURL];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];

    NSString *postString = [NSString stringWithFormat:@"action=listdevices&filter=%@&data=%@&username=%@&password=%@", filter, dateString, userName, password];

   // NSString *urlString = @"http://localhost/deviceListJSON.json";
    NSMutableURLRequest *request = (NSMutableURLRequest *)[self getBaseURLRequestForURLString:urlString withMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSURLRequest *)getURLRequestToGetFavoritesAndReservationListWithAction:(NSString *)action
{   //action=listfav&username=pablom&password=pablom
    //action=listres&username=pablom&password=pablom
    
    NSString * urlString = [NSString stringWithFormat:@"%@", kBaseServerURL];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    NSString *postString = [NSString stringWithFormat:@"action=%@&username=%@&password=%@", action, userName, password];
    
    NSMutableURLRequest *request = (NSMutableURLRequest *)[self getBaseURLRequestForURLString:urlString withMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

- (NSURLRequest *)getURLRequestToGetDeviceDetailsWithDeviceId:(NSString *)deviceId
{//action=getdevice&data=15&username=pablom&password=pablom
    
    NSString * urlString = [NSString stringWithFormat:@"%@", kBaseServerURL];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    NSString *postString = [NSString stringWithFormat:@"action=getdevice&data=%@&username=%@&password=%@", deviceId, userName, password];
    
    NSMutableURLRequest *request = (NSMutableURLRequest *)[self getBaseURLRequestForURLString:urlString withMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

- (NSURLRequest *)getURLRequestWithAction:(NSString *)action andDeviceId:(NSString *)deviceId
{
    //action=addfav&data=1&username=pablom&password=pablom
    //action=delfav&data=1&username=pablom&password=pablom
    //action=addres&data=1&username=pablom&password=pablom
    // action=delres&data=1&username=pablom&password=pablom
    
    NSString * urlString = [NSString stringWithFormat:@"%@", kBaseServerURL];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    NSString *postString = [NSString stringWithFormat:@"action=%@&data=%@&username=%@&password=%@", action ,deviceId, userName, password];
    
    NSMutableURLRequest *request = (NSMutableURLRequest *)[self getBaseURLRequestForURLString:urlString withMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

- (NSURLRequest *)getBaseURLRequestForURLString:(NSString *)urlString withMethod:(NSString *)httpMethod
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    //  [request addValue: @"text/html; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    //[request addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
    [request setTimeoutInterval:kMaxRequestTimeOutinterval];
    [request setHTTPMethod:httpMethod];
    return request;
}

- (void)getDataForURLRequest:(NSURLRequest *)request withCompletionBlock:(IDCompletionBlock)block
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        [self getJSONDataUsingNSURLConnectionWithRequest:request andCompletionBlock:block];
    } else {
        [self getJSONDataUsingNSURLSessionWithRequest:request andCompletionBlock:block];
    }
}

- (void)getJSONDataUsingNSURLSessionWithRequest:(NSURLRequest*)request andCompletionBlock:(IDCompletionBlock)block
{
    NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        id retObj = nil;
        
        if (data) {
            retObj = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingMutableContainers
                                                       error:&error];
            if (error) {
                NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                if(data){
                    NSData *data2 = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
                    retObj = [NSJSONSerialization JSONObjectWithData:data2
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
                }
                LogTrace(@"\n\n\nError while convertingData to JSON object. URL is:%@ \nError is:%@\n\n\n", [request URL], [error description]);
            }
        }
        
        block (retObj);
    }];
    
    [dataTask resume];
}

- (void)getJSONDataUsingNSURLConnectionWithRequest:(NSURLRequest*)request andCompletionBlock:(IDCompletionBlock)block
{
    id retObj = nil;
    NSError *error= nil;
    
    NSData *data = [self sendSyncRequest:request];
    
    if (data) {
        retObj = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingMutableContainers
                                                   error:&error];
        if (error) {
            LogTrace(@"\n\n\nError while convertingData to JSON object. URL is:%@ \nError is:%@\n\n\n", [request URL], [error description]);
        }
    }
    
    block(retObj);
}

- (NSData*)sendSyncRequest:(NSURLRequest*)request
{
    LogTrace(@"sendSyncRequest: Start");
    
    __autoreleasing NSURLResponse *response = nil;
    __autoreleasing NSError *error = nil;
    
    LogDebug(@"***************************************************************************");
    LogDebug(@"Sending Req - %@ %@", [[request URL] absoluteString], [request HTTPMethod]);
    LogDebug(@"Headers - %@ ", [request allHTTPHeaderFields]);
    LogDebug(@"Body - %@ ", [[NSString alloc] initWithBytes:[[request HTTPBody] bytes]
                                                     length:[[request HTTPBody] length]
                                                   encoding:NSUTF8StringEncoding]);
    LogTrace(@"Before Sending sync request");
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    LogTrace(@"After Sending sync request");
    
    NSDictionary *respHeaders = [(NSHTTPURLResponse*)response allHeaderFields];
    
    LogDebug(@"Received Resp - %@", [[request URL] absoluteString]);
    LogDebug(@"Headers - %@ ", respHeaders);
    LogDebug(@"Body - %@ ", [[NSString alloc] initWithBytes:[data bytes]
                                                     length:[data length]
                                                   encoding:NSUTF8StringEncoding]);
    LogDebug(@"***************************************************************************");
    
    LogTrace(@"sendSyncRequest: End");
    
    return data;
}

@end
