//
//  AYFavoritesView.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/11/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYFavoritesView.h"
#import "Device.h"
#import "FavoriteDevice.h"
#import "ReservedDevice.h"
#import "AYDevicesListCell.h"
#import "AYFavoritesTipoCell.h"
#import "AYDeviceDetailsView.h"


@interface AYFavoritesView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewNumberOfFav;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfFavorites;
@property (weak, nonatomic) IBOutlet UITableView *tbleViewFavoritesList;
@property (strong, nonatomic) AYDeviceDetailsView *deviceDetailsView;

@property (strong, nonatomic) NSMutableArray *favoriteDevices;
@property (strong, nonatomic) NSMutableArray *expandedTipoArray;
@property (strong, nonatomic) NSArray *reservedDeviceIds;
@end

@implementation AYFavoritesView

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
    [self.viewNumberOfFav.layer setCornerRadius:self.viewNumberOfFav.frame.size.width/2];
    [self.viewNumberOfFav.layer setBorderColor:[[UIColor yellowColor] CGColor]];
    [self.viewNumberOfFav.layer setBorderWidth:2.0f];
    
    [self.tbleViewFavoritesList registerNib:[UINib nibWithNibName:@"AYDevicesListCell" bundle:nil] forCellReuseIdentifier:@"AYDevicesListCell"];
      [self.tbleViewFavoritesList registerNib:[UINib nibWithNibName:@"AYFavoritesTipoCell" bundle:nil] forCellReuseIdentifier:@"AYFavoritesTipoCell"];
    
    self.expandedTipoArray = [[NSMutableArray alloc]  initWithCapacity:0];
    
    [self fetchAndLoadFavoriteDevicesFromDB];
    [self getFavoritesListFromServer];
}

- (void)getFavoritesListFromServer
{
    [[AYNetworkManager sharedInstance] getFavoritesListWithCompletionBlock:^(id result) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                
                if ([[result objectForKey:@"msgerr"] isEqualToString:@"Success"])
                    [[LTCoreDataManager sharedInstance] insertFavoritesListIntoDBFromRawResponse:[result objectForKey:@"devices"]];
                
                [self fetchAndLoadFavoriteDevicesFromDB];
            }
        });
    }];
}

- (void)loadReservedIds
{
    NSArray *reservedDevices = [[LTCoreDataManager sharedInstance] getAllRecordsFromEntity:kReservedEntityName];
    
    NSMutableArray *deviceIds = [[NSMutableArray alloc]  initWithCapacity:0];
    
    for (ReservedDevice *device in reservedDevices) {
        [deviceIds addObject:device.deviceId];
    }

    self.reservedDeviceIds = deviceIds;
}

- (void)fetchAndLoadFavoriteDevicesFromDB
{
    NSArray *devices = [[LTCoreDataManager sharedInstance] getAllRecordsFromEntity:kFavortiesEntityName];
    [self loadReservedIds];
    
    NSMutableArray *cartelDevices = [[NSMutableArray alloc]  initWithCapacity:0];
    NSMutableArray *monocolumnaDevices = [[NSMutableArray alloc]  initWithCapacity:0];
    NSMutableArray *mediawallDevices = [[NSMutableArray alloc]  initWithCapacity:0];
    NSMutableArray *telonDevices = [[NSMutableArray alloc]  initWithCapacity:0];

    for (FavoriteDevice *favoriteDevice in devices) {
        
       Device *device = [[[LTCoreDataManager sharedInstance] getRecordsFromEntity:kDevicesEntityName forAttribute:@"deviceId" withKey:favoriteDevice.deviceId] lastObject];
        
        if (!device)
            continue;
        
        if ([device.tipo isEqualToString:@"1"]) {
            [cartelDevices addObject:device];
        }
        else if ([device.tipo isEqualToString:@"2"]) {
            [monocolumnaDevices addObject:device];
        }
        else if ([device.tipo isEqualToString:@"3"]) {
            [mediawallDevices addObject:device];
        }
        else {
            [telonDevices addObject:device];
        }
    }
    
    self.favoriteDevices = [[NSMutableArray alloc] initWithArray:@[@{@"Title" : @"CARTEL" , @"ImageName" : @"cartel.png", @"Devices" : cartelDevices},
                             @{@"Title" : @"MONOCOLUMNA" , @"ImageName" : @"monocolumna.png", @"Devices" : monocolumnaDevices},
                             @{@"Title" : @"MEDIAWALL" , @"ImageName" : @"mediawall.png", @"Devices" : mediawallDevices},
                             @{@"Title" : @"TELÓN" , @"ImageName" : @"telon.png", @"Devices" : telonDevices}
                             ]];
    
    [self.lblNumberOfFavorites setText:[NSString stringWithFormat:@"%d", [devices count]]];
    [self.expandedTipoArray removeAllObjects];
    [self.tbleViewFavoritesList reloadData];
}

- (void)loadDeviceDetailsViewWithDeviceObject:(id)deviceObject
{
    self.deviceDetailsView = [[[NSBundle mainBundle] loadNibNamed:@"AYDeviceDetailsView" owner:self options:nil] lastObject];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [self.deviceDetailsView setFrame:keyWindow.bounds];
    [keyWindow addSubview:self.deviceDetailsView];
    [self.deviceDetailsView loadDeviceDetailsWithDeviceObject:deviceObject];
}

- (BOOL)isDeviceReserved:(Device *)device
{
    if ([self.reservedDeviceIds containsObject:device.deviceId]) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - IBAction Methods
- (IBAction)actionTopMenuButtonPressed:(id)sender {
    [self removeFromSuperview];
}

#pragma mark - UITableView Datasource and delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.favoriteDevices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    id object = self.favoriteDevices[[indexPath row]];
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AYFavoritesTipoCell"];
        [(AYFavoritesTipoCell *)cell configureCellWithObject:object];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AYDevicesListCell"];
        
        [(AYDevicesListCell *)cell configureCellWithObject:object isDeviceReserved:[self isDeviceReserved:object]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = self.favoriteDevices[[indexPath row]];
    
    if ([object isKindOfClass:[NSDictionary class]])
        return 110.0;
    else
        return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[AYFavoritesTipoCell class]]) {
       
        NSString *title = [(AYFavoritesTipoCell *)cell getTitleText];
        
        if ([self.expandedTipoArray containsObject:title]) {
            NSArray *devices = [self.favoriteDevices[[indexPath row]] objectForKey:@"Devices"];
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([indexPath row] + 1, [devices count])];
            [self.favoriteDevices removeObjectsAtIndexes:indexSet];
            [self.expandedTipoArray removeObject:title];
            
            NSMutableArray *indexPathsToRemove = [[NSMutableArray alloc] initWithCapacity:0];
            for (int index = [indexPath row] + 1; index <= ([indexPath row] + [devices count]); index ++) {
                [indexPathsToRemove addObject:[NSIndexPath indexPathForRow:index inSection:0]];
            }

            [self.tbleViewFavoritesList deleteRowsAtIndexPaths:indexPathsToRemove withRowAnimation:UITableViewRowAnimationBottom];
        }
        else {
            [self.expandedTipoArray addObject:title];
            
            NSArray *devices = [self.favoriteDevices[[indexPath row]] objectForKey:@"Devices"];
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([indexPath row] + 1, [devices count])];
            [self.favoriteDevices insertObjects:devices atIndexes:indexSet];
            
            NSMutableArray *indexPathsToRemove = [[NSMutableArray alloc] initWithCapacity:0];
            for (int index = [indexPath row] + 1; index <= ([indexPath row] + [devices count]); index ++) {
                [indexPathsToRemove addObject:[NSIndexPath indexPathForRow:index inSection:0]];
            }
            
            [self.tbleViewFavoritesList insertRowsAtIndexPaths:indexPathsToRemove withRowAnimation:UITableViewRowAnimationTop];
        }
        
        //[tableView reloadData];
    }
    else {
        [self loadDeviceDetailsViewWithDeviceObject:self.favoriteDevices[[indexPath row]]];
    }
}

@end
