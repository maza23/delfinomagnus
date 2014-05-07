//
//  AYHomeViewController.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/5/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYHomeViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface AYHomeViewController () <GMSMapViewDelegate>
@property (strong, nonatomic) GMSMapView *mapView;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doInitialConfigurations
{
    NSString *latidudeString = nil;
    NSString *longitudeString = nil;
    
    latidudeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    longitudeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[latidudeString floatValue]
                                                            longitude:[longitudeString floatValue]
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

- (void)showMapWithLocations:(NSArray *)storeDetails
{
    
    for (NSDictionary *store in storeDetails) {
        // Creates a marker in the center of the map.
        
        float latitude = [[store objectForKey:@"latitude"] floatValue];
        float longitude = [[store objectForKey:@"logitude"] floatValue];
        
        if (latitude == 0 || longitude == 0) {
            continue;
        }
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(latitude, longitude);
        marker.icon = [UIImage imageNamed:@"marker_icon.png"];
        marker.title = [store objectForKey:@"name"];
        marker.snippet = [store objectForKey:@"address"];
        marker.map = self.mapView;
    }
}


#pragma mark - IBAction Methods
- (IBAction)actionMenuButtonPressed:(id)sender {
}

- (IBAction)actionSearchButtonPressed:(id)sender {
}

- (IBAction)actionToDoButtonPressed:(UIButton *)sender {
    [sender setSelected:![sender isSelected]];
}

#pragma mark - GoogleMapView Delegate Methods
//- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
//    LTMapInfoView *view =  [[[NSBundle mainBundle] loadNibNamed:@"LTMapInfoView" owner:self options:nil] objectAtIndex:0];
//    
//    self.currentActiveStorePhoneNumbers = [view showStoreInfoAndReturnPhoneNumberFromObject:[self.storesArray objectAtIndex:[marker.snippet integerValue]]];
//    
//    return view;
//}
//
//- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
//    
//    self.popUpView = [LTPopUpView getPopViewWithType:LTPopUpViewTypeMoreInfo andOwner:self];
//    [self.popUpView setDelegate:self];
//    //[self.popUpView showDetailsFromUserInfo:@{@"HeaderTitle" : @"Llamar al establecimiento", @"Message": self.currentActiveStorePhoneNumber}];
//    
//    UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//    [self.popUpView setFrame:rootVC.view.bounds];
//    [rootVC.view addSubview:self.popUpView];
//    
//}

@end
