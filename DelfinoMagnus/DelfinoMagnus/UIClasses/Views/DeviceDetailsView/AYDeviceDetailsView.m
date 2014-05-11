//
//  AYDeviceDetailsView.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/11/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYDeviceDetailsView.h"
#import "Device.h"
#import "DeviceDetails.h"
#import "UIImageView+AFNetworking.h"
#import "Images.h"
#import "Tipo.h"

@interface AYDeviceDetailsView ()
@property (strong, nonatomic) Device *device;
@property (strong, nonatomic) DeviceDetails *deviceDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblTopHeaderTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnFavorites;
@property (weak, nonatomic) IBOutlet UIButton *btnReservation;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnCalendar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlViewImageContainer;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSMutableDictionary *activitiesDict;

@end

@implementation AYDeviceDetailsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self doInitialConfigurations];
}

#pragma mark - Private Methods
- (void)doInitialConfigurations
{
    self.activitiesDict = [[NSMutableDictionary alloc] init];

    [self.lblTopHeaderTitle setText:@"FOTO"];
}

- (void)fetchAndLoadDeviceDetailsFromDataBase
{
    self.deviceDetails = [[[LTCoreDataManager sharedInstance] getRecordsFromEntity:kDeviceDetailsEntityName forAttribute:@"deviceId" withKey:self.device.deviceId] lastObject];
    
    if (!self.deviceDetails)
        return;
    
    Tipo *tipos = [[[LTCoreDataManager sharedInstance] getRecordsFromEntity:kTipoEntityName forAttribute:@"tipoId" withKey:self.deviceDetails.tipo] lastObject];
    
    [self.lblTitle setText:self.deviceDetails.titulo];
    [self.lblSubTitle setText:tipos.name];
    
    [self loadScrollViewWithImages];
    NSLog(@"Got device with ID:%@ and title:%@", self.deviceDetails.deviceId, self.deviceDetails.titulo);
}

- (void)getDeviceDetailsFromServer
{
    if (!self.deviceDetails)
        [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    [[AYNetworkManager sharedInstance] getDeviceDetailsWithDeviceId:self.device.deviceId andCompletionBlock:^(id result) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                [[LTCoreDataManager sharedInstance] insertDeviceDetalisIntoDBFromRawResponse:result];
                [self fetchAndLoadDeviceDetailsFromDataBase];
            }
            
            [MBProgressHUD hideAllHUDsForView:self animated:YES];
            
        });
    }];
}

- (void)loadScrollViewWithImages
{
    NSArray *imagesArray = [self.deviceDetails.images allObjects];
    if ([imagesArray count]) {
        for (UIImageView *imageView in self.scrlViewImageContainer.subviews) {
            [imageView removeFromSuperview];
        }
    }
    
    for (Images *image in imagesArray) {
        
        CGRect frame = self.scrlViewImageContainer.frame;
        frame.origin.y = 0;
        frame.origin.x = self.scrlViewImageContainer.frame.size.width * [imagesArray indexOfObject:image];
        UIImageView *imageView = [[UIImageView alloc]  initWithFrame:frame];
        
        [self downloadImageFromURLString:[NSString stringWithFormat:@"%@/%@", self.deviceDetails.urlimgs, image.archivo] andSetToImageView:imageView];
        [self.scrlViewImageContainer addSubview:imageView];
    }
    
    [self.scrlViewImageContainer setContentSize:CGSizeMake(self.scrlViewImageContainer.frame.size.width * [imagesArray count], self.scrlViewImageContainer.frame.size.height)];
    
    [self.pageControl setNumberOfPages:[imagesArray count]];
}

- (void)downloadImageFromURLString:(NSString *)imageURLString andSetToImageView:(UIImageView *)imageView
{
    if (!imageURLString) {
        return;
    }
    
    __block __weak UIImageView *localImageView = imageView;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageURLString]];
    [request setHTTPShouldHandleCookies:NO];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    NSString *keyForActivity = [[request URL] absoluteString];
    UIActivityIndicatorView *activity = [self getActivityIndicatorAfterAddingOnImageView:imageView];
    
    [self.activitiesDict setObject:activity forKey:keyForActivity];
    
    [localImageView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [localImageView setImage:image];
                                           [self stopActivityFromActivitiesDictWithKey:keyForActivity withResult:YES];
                                       });
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       [self stopActivityFromActivitiesDictWithKey:[[request URL] absoluteString] withResult:NO];
                                        });
                                   }];
}

- (UIActivityIndicatorView *)getActivityIndicatorAfterAddingOnImageView:(UIImageView *)imageView
{
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity setCenter:CGPointMake(imageView.frame.size.width / 2, imageView.frame.size.height / 2)];
    [activity setHidesWhenStopped:YES];
    [imageView addSubview:activity];
    [activity startAnimating];
    
    return activity;
}


- (void)stopActivityFromActivitiesDictWithKey:(NSString *)key withResult:(BOOL)success
{
    UIActivityIndicatorView *activity = [_activitiesDict objectForKey:key];
    [activity stopAnimating];
    [self.activitiesDict removeObjectForKey:key];
    
}

#pragma mark - Public Methods
- (void)loadDeviceDetailsWithDeviceObject:(Device *)deviceObject
{
    self.device = deviceObject;
    [self fetchAndLoadDeviceDetailsFromDataBase];
    [self getDeviceDetailsFromServer];
}

#pragma mark -IBAction Methods
- (IBAction)actionCloseButtonPressed:(id)sender {
    [self removeFromSuperview];
}

@end
