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
#import "ReservedDevice.h"
#import "CalenderViewController.h"

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
@property (weak, nonatomic) IBOutlet UIView *viewFotoContainer;
@property (weak, nonatomic) IBOutlet UIView *viewCalendarContainer;

@property (strong, nonatomic) CalenderViewController *calendarVC;
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

    [self handleSwitchCalendarFotoButtonWithSender:self.btnPhoto];
    [self addCalendarView];
}

- (void)addCalendarView
{
    self.calendarVC = [[CalenderViewController alloc]  initWithNibName:@"CalenderViewController" bundle:nil];
    [self.viewCalendarContainer addSubview:self.calendarVC.view];
}

- (void)fetchAndLoadDeviceDetailsFromDataBase
{
    self.deviceDetails = [[[LTCoreDataManager sharedInstance] getRecordsFromEntity:kDeviceDetailsEntityName forAttribute:@"deviceId" withKey:self.device.deviceId] lastObject];
    
    if (!self.deviceDetails)
        return;
    
    [self.lblTitle setText:self.deviceDetails.titulo];
    [self.lblSubTitle setText:[[AYUtilites getTiposNameDictionary] objectForKey:self.deviceDetails.tipo]];
    [self.btnReservation setSelected:[self isCurrentDeviceAlreadyReserved]];
    [self.btnFavorites setSelected:[self isCurrentDeviceAlreadyFavorite]];
    
    [self loadScrollViewWithImages];
}

- (BOOL)isCurrentDeviceAlreadyReserved
{
    BOOL isRegitered = NO;
    
    NSArray *devices = [[LTCoreDataManager sharedInstance] getRecordsFromEntity:kReservedEntityName forAttribute:@"deviceId" withKey:self.deviceDetails.deviceId];
    
    if ([devices count]) {
        isRegitered = YES;
    }
    
    return isRegitered;
}

- (BOOL)isCurrentDeviceAlreadyFavorite
{
    BOOL isRegitered = NO;
    
    NSArray *devices = [[LTCoreDataManager sharedInstance] getRecordsFromEntity:kFavortiesEntityName forAttribute:@"deviceId" withKey:self.deviceDetails.deviceId];
    
    if ([devices count]) {
        isRegitered = YES;
    }
    
    return isRegitered;
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

- (void)showAlertWithMessage:(NSString *)message andTitle:(NSString *)title
{
    return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        UIAlertView *alertView = [[UIAlertView alloc]  initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
    });
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

- (IBAction)actionReservationButtonPressed:(UIButton *)sender {
    
    if (!self.deviceDetails.deviceId)
        return;
    
    __weak __typeof(self)weakSelf = self;
    
    [sender setSelected:![sender isSelected]];
    
    if ([sender isSelected])  {
        
        [[AYNetworkManager sharedInstance] addResDeviceWithId:self.deviceDetails.deviceId andCompletionBlock:^(id result) {
            
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                
                if ([[[result objectForKey:@"msgerr"] uppercaseString] isEqualToString:@"SUCCESS"]) {
                    [[LTCoreDataManager sharedInstance] insertReservedListIntoDBFromRawArray:[result objectForKey:@"devices"]];
                }
            }
            [weakSelf showAlertWithMessage:@"" andTitle:@""];
        }];
    }
    else {
        [[AYNetworkManager sharedInstance] removeResDeviceWithId:self.deviceDetails.deviceId andCompletionBlock:^(id result) {
            
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                
                if ([[[result objectForKey:@"msgerr"] uppercaseString] isEqualToString:@"SUCCESS"]) {
                    [[LTCoreDataManager sharedInstance] insertReservedListIntoDBFromRawArray:[result objectForKey:@"devices"]];
                    [weakSelf showAlertWithMessage:@"" andTitle:@""];

                }
                else {
                    [weakSelf showAlertWithMessage:@"" andTitle:@""];

                }
            }
            else {
                [weakSelf showAlertWithMessage:@"" andTitle:@""];

            }
        }];
    }
}

- (IBAction)actionFavoriteButtonPressed:(UIButton *)sender {
    if (!self.deviceDetails.deviceId)
        return;
    
    __weak __typeof(self)weakSelf = self;
    
    [sender setSelected:![sender isSelected]];
    
    if ([sender isSelected])  {
        
        [[AYNetworkManager sharedInstance] addFavoritesDeviceWithId:self.deviceDetails.deviceId andCompletionBlock:^(id result) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (result && [result isKindOfClass:[NSDictionary class]]) {
                    
                    if ([[result objectForKey:@"msgerr"] isEqualToString:@"Success"])
                        [[LTCoreDataManager sharedInstance] insertFavoritesListIntoDBFromRawResponse:[result objectForKey:@"devices"]];
                }
            });
            
            [weakSelf showAlertWithMessage:@"" andTitle:@""];
        }];
    }
    else {
        [[AYNetworkManager sharedInstance] removeFavoritesDeviceWithId:self.deviceDetails.deviceId andCompletionBlock:^(id result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (result && [result isKindOfClass:[NSDictionary class]]) {
                    
                    if ([[result objectForKey:@"msgerr"] isEqualToString:@"Success"])
                        [[LTCoreDataManager sharedInstance] insertFavoritesListIntoDBFromRawResponse:[result objectForKey:@"devices"]];
                }
            });

        }];
    }
}

- (IBAction)actionPhotoButtonPressed:(UIButton *)sender {
    
    [self handleSwitchCalendarFotoButtonWithSender:sender];
}

- (IBAction)actionCalendarButtonPressed:(UIButton *)sender {
    
    [self handleSwitchCalendarFotoButtonWithSender:sender];
}

- (void)handleSwitchCalendarFotoButtonWithSender:(UIButton *)sender
{
    if (sender.tag == 1 && ![sender isSelected]) {
        [sender setSelected:YES];
        [self.btnCalendar setSelected:NO];
        [self.viewCalendarContainer setHidden:YES];
        [self.viewFotoContainer setHidden:NO];
        [self.lblTopHeaderTitle setText:@"FOTOS"];
    }
    else if (sender.tag == 2 && ![sender isSelected]){
        [sender setSelected:YES];
        [self.btnPhoto setSelected:NO];
        [self.viewCalendarContainer setHidden:NO];
        [self.viewFotoContainer setHidden:YES];
        [self.lblTopHeaderTitle setText:@"CALENDARIO"];
    }
}

@end
