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

@interface AYHomeViewController () <GMSMapViewDelegate>
@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) NSArray *devices;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)doInitialConfigurations
{
    NSString *latidudeString = nil;
    NSString *longitudeString = nil;
    
    latidudeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    longitudeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-34.62445030861076//[latidudeString floatValue]
                                                            longitude:-58.43372583389282//[longitudeString floatValue]
                                                                 zoom:15.0];
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
        marker.icon = [UIImage imageNamed:@"mediawall_icon.png"];
        marker.title = [NSString stringWithFormat:@"%d", [devicesList indexOfObject:device]];
        marker.map = self.mapView;
    }
}

- (void)getAndLoadDevicesFromServer
{
    [[AYNetworkManager sharedInstance] getDevicesListWithFilter:@"fechamodif" andDateString:@"2013-03-02" withCompletionHandler:^(id result) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
          
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                [[LTCoreDataManager sharedInstance] insertDevicesResultIntoDBFromRawResponse:result];
                [self fetchAndLoadMarkersFromDataBase];
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });

    }];
}

- (void)fetchAndLoadMarkersFromDataBase
{
    self.devices = [[LTCoreDataManager sharedInstance] getAllRecordsFromEntity:kDevicesEntityName];
    
    if ([self.devices count]) {
        [self showMapWithMarkerDevices:self.devices withToDo:NO];
    }
}

#pragma mark - IBAction Methods
- (IBAction)actionMenuButtonPressed:(id)sender {
}

- (IBAction)actionSearchButtonPressed:(id)sender {
}

- (IBAction)actionToDoButtonPressed:(UIButton *)sender {
    [sender setSelected:![sender isSelected]];
    
    [self showMapWithMarkerDevices:self.devices withToDo:[sender isSelected]];

}

#pragma mark - GoogleMapView Delegate Methods
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    AYMapInfoView *view =  [[[NSBundle mainBundle] loadNibNamed:@"AYMapInfoView" owner:self options:nil] objectAtIndex:0];
    [view configureViewWithDeviceObject:self.devices[[marker.title integerValue]]];
    
    return view;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    
}

@end
