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
#import "BZDownloadAlertView.h"

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
@property (weak, nonatomic) IBOutlet UIView *viewTitleHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTitleLabelTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCameraButtonBottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCalendarButtonLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFavotiesButtonRightSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintReserveButtonRightSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageContainerTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCalendarButtonBottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCalendarContainerTopSpace;
@property (nonatomic, strong) BZDownloadAlertView *downloadAlertView;


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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods
- (void)doInitialConfigurations
{
    [_lblTopHeaderTitle setFont:[UIFont fontWithName:@"century" size:(kIsDeviceiPad ? 16.0f : 14.0f)]];
    [_lblTitle setFont:[UIFont fontWithName:@"century" size:(kIsDeviceiPad ? 22.0f : 17.0f)]];
    [_lblSubTitle setFont:[UIFont fontWithName:@"century" size:(kIsDeviceiPad ? 20.0f : 15.0f)]];
    [(UILabel *)[self viewWithTag:21] setFont:[UIFont fontWithName:@"century" size:(kIsDeviceiPad ? 15.0f : 10.0f)]];
    [(UILabel *)[self viewWithTag:22] setFont:[UIFont fontWithName:@"century" size:(kIsDeviceiPad ? 15.0f : 10.0f)]];

    [self doAppearenceSettingsForOrientation:[[UIDevice currentDevice] orientation]];

    if (kIsDeviceiPad) {
        [self.btnClose setBackgroundImage:[[UIImage imageNamed:@"cerrar.png"] imageWithOverlayColor:[UIColor colorWithRed:225.0/255.0 green:164.0/255.0 blue:74.0/255.0 alpha:1.0]] forState:UIControlStateNormal];
    }
    else {
        [self.btnClose setImage:[[UIImage imageNamed:@"cerrar.png"] imageWithOverlayColor:[UIColor colorWithRed:225.0/255.0 green:164.0/255.0 blue:74.0/255.0 alpha:1.0]] forState:UIControlStateNormal];

    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangedOrientation:) name:kDeviceWillChangeOrientation object:nil];
    
    self.activitiesDict = [[NSMutableDictionary alloc] init];

    [self handleSwitchCalendarFotoButtonWithSender:self.btnPhoto];
    [self addCalendarView];
}

- (void)didChangedOrientation:(id)notifiObject
{
    NSInteger newOrientation = [[[notifiObject userInfo] objectForKey:@"NewOrientation"] integerValue];
    
    [self doAppearenceSettingsForOrientation:newOrientation];
}

- (void)doAppearenceSettingsForOrientation:(NSInteger)orientation
{
    if (kIsDeviceiPad) {
        [self layoutIfNeeded];

        [self performSelector:@selector(loadScrollViewWithImages) withObject:nil afterDelay:0.1f];
        return;
    }
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        [self.viewTitleHeader setHidden:YES];
        self.constraintTitleLabelTopSpace.constant = 5;
        self.constraintCameraButtonBottomSpace.constant = 180;
        self.constraintCalendarButtonLeftSpace.constant = 0;
        self.constraintReserveButtonRightSpace.constant = 10;
        self.constraintFavotiesButtonRightSpace.constant = 10;
        self.constraintImageContainerTopSpace.constant = 70;
        self.constraintImageContainerHeight.constant = 240;
        self.constraintCalendarButtonBottomSpace.constant = 50;
        self.constraintCalendarContainerTopSpace.constant = 70;
    }
    else {
        [self.viewTitleHeader setHidden:NO];
        self.constraintTitleLabelTopSpace.constant = 39;

        self.constraintCameraButtonBottomSpace.constant = 14;
        self.constraintCalendarButtonLeftSpace.constant = 232;
        self.constraintReserveButtonRightSpace.constant = 132;
        self.constraintFavotiesButtonRightSpace.constant = 132;
        self.constraintImageContainerTopSpace.constant = 158;
        self.constraintImageContainerHeight.constant = 302;
        self.constraintCalendarButtonBottomSpace.constant = 14;
        self.constraintCalendarContainerTopSpace.constant = 158;

    }
    
    [self layoutIfNeeded];
}

- (void)addCalendarView
{
    NSString *nibName = kIsDeviceiPad ? @"CalenderViewController~iPad" : @"CalenderViewController";
    self.calendarVC = [[CalenderViewController alloc]  initWithNibName:nibName bundle:nil];
    [self layoutIfNeeded];
    [self.viewCalendarContainer addSubview:self.calendarVC.view];
    self.calendarVC.view.center = CGPointMake(self.viewCalendarContainer.frame.size.width/2, self.viewCalendarContainer.frame.size.height/2);
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
    [self.calendarVC reloadCalendarWithCalendarObjects:[self.deviceDetails.calendars allObjects]];
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
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
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
                                           [localImageView setImage:image];
                                           [self stopActivityFromActivitiesDictWithKey:keyForActivity withResult:YES];
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                       
                                       [self stopActivityFromActivitiesDictWithKey:[[request URL] absoluteString] withResult:NO];
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
    dispatch_async(dispatch_get_main_queue(), ^{
       
        UIAlertView *alertView = [[UIAlertView alloc]  initWithTitle:title message:message delegate:nil cancelButtonTitle:@"despedir" otherButtonTitles:nil];
        [alertView show];
    });
}

- (void)showToastWithMessage:(NSString *)message
{
    if (!self.downloadAlertView) {
        self.downloadAlertView = [[BZDownloadAlertView alloc] init];
    }
    
    [self.downloadAlertView displayAlertViewWithMessage:message andAlertStyle:BZDownloadAlertViewAlertStyleCompleted];
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
                    [weakSelf showAlertWithMessage:@"En la brevedad un representante se pondrá en contacto." andTitle:@"LA LOCACIÓN SE HA RESERVADO CON ÉXITO"];                }
                else {
                    [weakSelf showAlertWithMessage:@"Algunos error ha ocurrido. Por favor, inténtelo de nuevo más tarde." andTitle:@"triste"];
                }
            }
            else {
               // [weakSelf showAlertWithMessage:@"Some error has occured. Please try again later" andTitle:@"Sorry"];
            }
        }];
    }
    else {
        [[AYNetworkManager sharedInstance] removeResDeviceWithId:self.deviceDetails.deviceId andCompletionBlock:^(id result) {
            
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                
                if ([[[result objectForKey:@"msgerr"] uppercaseString] isEqualToString:@"SUCCESS"]) {
                    [[LTCoreDataManager sharedInstance] insertReservedListIntoDBFromRawArray:[result objectForKey:@"devices"]];
                    [self showToastWithMessage:@"Reserva cancelada"];

                }
                else {
                    [weakSelf showAlertWithMessage:@"Algunos error ha ocurrido. Por favor, inténtelo de nuevo más tarde." andTitle:@"triste"];
                }
            }
            else {
                //[weakSelf showAlertWithMessage:@"Some error has occured. Please try again later" andTitle:@"Sorry"];
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
                    [weakSelf showToastWithMessage:@"Agregado a favoritos"];
                }
                else {
                    [weakSelf showAlertWithMessage:@"Algunos error ha ocurrido. Por favor, inténtelo de nuevo más tarde." andTitle:@"triste"];
                }
            });
            
          //  [weakSelf showAlertWithMessage:@"Some error has occured. Please try again later" andTitle:@"Sorry"];
        }];
    }
    else {
        [[AYNetworkManager sharedInstance] removeFavoritesDeviceWithId:self.deviceDetails.deviceId andCompletionBlock:^(id result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (result && [result isKindOfClass:[NSDictionary class]]) {
                    
                    if ([[result objectForKey:@"msgerr"] isEqualToString:@"Success"]) {
                        [[LTCoreDataManager sharedInstance] insertFavoritesListIntoDBFromRawResponse:[result objectForKey:@"devices"]];
                    [weakSelf showToastWithMessage:@"Removido de favoritos"];
                    }
                    else {
                        [weakSelf showAlertWithMessage:@"Algunos error ha ocurrido. Por favor, inténtelo de nuevo más tarde." andTitle:@"triste"];
                    }
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
