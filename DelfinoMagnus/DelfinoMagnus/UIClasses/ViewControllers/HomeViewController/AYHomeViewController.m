//
//  AYHomeViewController.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/5/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYHomeViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Device.h"
#import "AYMapInfoView.h"
#import "AYMenuView.h"
#import "AYDeviceSearchView.h"
#import "AYDeviceDetailsView.h"
#import "Tipo.h"

@interface AYHomeViewController () <GMSMapViewDelegate, AYBaseCloseDelegate>
@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) AYMenuView *menuView;
@property (strong, nonatomic) AYDeviceSearchView *searchView;
@property (strong, nonatomic) AYDeviceDetailsView *deviceDetailsView;
@property (strong, nonatomic) UIView *infoWindow;

@property (strong, nonatomic) NSArray *devices;
@property (strong, nonatomic) NSDictionary *tipos;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (assign, nonatomic) BOOL isInfoWindowLoadingInProgress;
@end

@implementation AYHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self doInitialConfigurations];
    [self getAndLoadDevicesFromServer];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self startSyncingData];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceWillChangeOrientation object:nil userInfo:@{@"NewOrientation" :[NSNumber numberWithInt:toInterfaceOrientation]}];
}


#pragma mark - Private Methods
- (void)doInitialConfigurations
{
    self.isInfoWindowLoadingInProgress = NO;
    NSString *latidudeString = nil;
    NSString *longitudeString = nil;
    
    latidudeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    longitudeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-34.62445030861076//[latidudeString floatValue]
                                                            longitude:-58.43372583389282//[longitudeString floatValue]
                                                                 zoom:12.0];
    GMSMapView *googleMapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    [googleMapView setDelegate:self];
    googleMapView.myLocationEnabled = YES;
    [self.view insertSubview:googleMapView atIndex:0];
    
    googleMapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-0-[googleMapView]-0-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(googleMapView)]];
    [self.view addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-0-[googleMapView]-0-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(googleMapView)]];
    [self.view layoutIfNeeded];
    
    self.mapView = googleMapView;
}

- (void)showMapWithMarkerDevices:(NSArray *)devicesList withToDo:(BOOL)showToDo
{
    [self.mapView clear];
    
    for (Device *device in devicesList) {
        
        if ((![device.disponible isEqualToString:@"SI"]) && !showToDo) {
            continue;
        }
        
        float latitude = [device.latitude floatValue];
        float longitude = [device.longitude floatValue];
        
        if (latitude == 0 || longitude == 0) {
            continue;
        }
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(latitude, longitude);
        marker.title = [NSString stringWithFormat:@"%d", [devicesList indexOfObject:device]];
        marker.icon = [UIImage imageNamed:[self.tipos objectForKey:device.tipo]];

        marker.map = self.mapView;
    }
}

- (void)getAndLoadDevicesFromServer
{
    [[AYNetworkManager sharedInstance] getDevicesListWithFilter:@"fechamodif" andDateString:@"2013-03-02" withCompletionHandler:^(id result) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
          
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                [[LTCoreDataManager sharedInstance] insertDevicesResultIntoDBFromRawResponse:result];
            }
            
            [self fetchAndLoadMarkersFromDataBase];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });

    }];
}

- (void)fetchAndLoadMarkersFromDataBase
{
    self.devices = [[LTCoreDataManager sharedInstance] getAllRecordsFromEntity:kDevicesEntityName];
    self.tipos = [AYUtilites getTiposMarkerImageNames];
    
    if ([self.devices count]) {
        [self showMapWithMarkerDevices:self.devices withToDo:NO];
    }
}

- (void)loadMenuView
{
    [self setActionButtonsHidden:YES];
    self.menuView = [[[NSBundle mainBundle] loadNibNamed:@"AYMenuView" owner:self options:nil] lastObject];
    [self.menuView setFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, self.view.bounds.size.height - 20)];
    [self.menuView setDelegate:self];
    [self.view addSubview:self.menuView];
}

- (void)loadDeviceDetailsViewWithDeviceObject:(id)deviceObject
{
    NSString *nibName = kIsDeviceiPad ? @"AYDeviceDetailsView~iPad": @"AYDeviceDetailsView";
    self.deviceDetailsView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] lastObject];
    [self.deviceDetailsView setFrame:self.view.bounds];
    [self.view addSubview:self.deviceDetailsView];
    [self.deviceDetailsView loadDeviceDetailsWithDeviceObject:deviceObject];
}

- (void)setActionButtonsHidden:(BOOL)setHidden
{
    [self.btnMenu setHidden:setHidden];
    [self.btnSearch setHidden:setHidden];
}

#pragma mark - IBAction Methods
- (IBAction)actionMenuButtonPressed:(id)sender {
    [self loadMenuView];
}

- (IBAction)actionSearchButtonPressed:(id)sender {

    [self setActionButtonsHidden:YES];

    NSString *nibName = kIsDeviceiPad ? @"AYDeviceSearchView~iPad": @"AYDeviceSearchView";
    self.searchView = [[[NSBundle mainBundle]  loadNibNamed:nibName owner:self options:nil] lastObject];
    [self.view addSubview:self.searchView];
    [self.searchView setDelegate:self];
    [self.searchView setFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, self.view.bounds.size.height - 20)];
    [self.searchView layoutIfNeeded];
}

- (IBAction)actionToDoButtonPressed:(UIButton *)sender {
    [sender setSelected:![sender isSelected]];
    
    [self showMapWithMarkerDevices:self.devices withToDo:[sender isSelected]];
}

#pragma mark - GoogleMapView Delegate Methods
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    

    if (self.isInfoWindowLoadingInProgress) {
        self.isInfoWindowLoadingInProgress = NO;
        return self.infoWindow;
    }
    
    self.isInfoWindowLoadingInProgress = NO;

    AYMapInfoView *view =  [[[NSBundle mainBundle] loadNibNamed:@"AYMapInfoView" owner:self options:nil] objectAtIndex:0];
    [view configureViewWithDeviceObject:self.devices[[marker.title integerValue]]];
    
    self.infoWindow = view;
    
    [self performSelector:@selector(reloadMapInfoWindowWithMarker:) withObject:marker afterDelay:1.0f];
    return view;
}

- (void)reloadMapInfoWindowWithMarker:(GMSMarker *)marker
{
    self.isInfoWindowLoadingInProgress = YES;
    [self.mapView setSelectedMarker:marker];
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    [self loadDeviceDetailsViewWithDeviceObject:self.devices[[marker.title integerValue]]];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
	CGPoint point = [mapView.projection pointForCoordinate:marker.position];
	point.y = 200;
	GMSCameraUpdate *camera = [GMSCameraUpdate setTarget:[mapView.projection coordinateForPoint:point]];
	[mapView animateWithCameraUpdate:camera];
	
	mapView.selectedMarker = marker;
	return YES;
}

#pragma mark - Data Syncing Methods
- (void)startSyncingData
{
    [[AYNetworkManager sharedInstance] getReservationListWithCompletionBlock:^(id result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (result && [result isKindOfClass:[NSDictionary class]]) {
              
                if ([[result objectForKey:@"msgerr"] isEqualToString:@"Success"]) {
                    
                    [[LTCoreDataManager sharedInstance]  insertReservedListIntoDBFromRawArray:[result objectForKey:@"devices"]];
                }
            }
        });
    }];
}

#pragma mark - Base Close Delegate Methods
- (void)didPressedCloseButtonOnView:(UIView *)view
{
    [self setActionButtonsHidden:NO];
}

@end
