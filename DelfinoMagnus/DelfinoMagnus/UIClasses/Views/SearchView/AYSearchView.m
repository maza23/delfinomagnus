//
//  AYSearchView.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/9/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

typedef enum
{
    TipoTypeCartel = 1,
    TipoTypeMonocolumna,
    TipoTypeMediawall,
    TipoTypeTelon
}TipoType;

typedef enum
{
    ZonaTypeCapitalFederal = 1,
    ZonaTypeNorte,
    ZonaTypeOeste,
    ZonaTypeSur
}ZonaType;

#import "AYSearchView.h"
#import "AYSearchSettings.h"
#import "Device.h"
#import "AYDevicesListView.h"

@interface AYSearchView ()
@property (weak, nonatomic) IBOutlet UITextField *txtFieldSearch;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMainContainer;
@property (strong, nonatomic) AYSearchSettings *searchSettings;
@property (strong, nonatomic) AYDevicesListView *devicesListView;
@property (weak, nonatomic) IBOutlet UIButton *btnDisponibleSwitch;

- (IBAction)actionTipoButtonPressed:(id)sender;
- (IBAction)actionZonaButtonPressed:(id)sender;
- (IBAction)actionSearchButtonpressed:(id)sender;
- (IBAction)actionDisponibleButtonPressed:(id)sender;
@end

@implementation AYSearchView

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

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
//    CGRect scrollViewFrame = frame;
//    scrollViewFrame.origin.y = 40;
//    scrollViewFrame.size.height -= 40;
//    [self.scrollViewMainContainer setFrame:scrollViewFrame];

}

#pragma mark - Private Methods
- (void)doInitialConfigurations
{
    self.searchSettings = [[AYSearchSettings alloc] init];
}

- (void)searchDeviceIntoDataBaseWithTitleText:(NSString *)text
{
    NSArray *searchedDevices = [[LTCoreDataManager sharedInstance] getMatchedRecordFromEntity:kDevicesEntityName forColumnName:@"titulo" withValueToMatch:text];
    NSArray *filteredDevices = [self getFilteredSearchDevicesFromArray:searchedDevices];
    
    if (![filteredDevices count]) {
        return;
    }
    
    self.devicesListView = [[[NSBundle mainBundle] loadNibNamed:@"AYDevicesListView" owner:self options:nil] lastObject];
    
    UIView *parentView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    CGRect frame = [parentView bounds];

    [self.devicesListView setFrame:frame];
    [parentView addSubview:self.devicesListView];
    
    [self.devicesListView loadDevicesListFromDevices:filteredDevices];
}

- (NSArray *)getFilteredSearchDevicesFromArray:(NSArray *)searchedDevices
{
    NSMutableArray *finalDevices = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *filteredDevices = [[NSMutableArray alloc]  initWithCapacity:0];
    NSDictionary *tipoNames = [AYUtilites getTiposIdAsObjectAndNameAsDictKeys];
    NSDictionary *zonaNames = [AYUtilites getZonaIdAsObjectAndNameAsDictKeys];
    
    for (Device *device in searchedDevices) {

        if (_searchSettings.tipoCartel && [device.tipo isEqualToString:[tipoNames objectForKey:@"Cartel"]]) {
            [filteredDevices addObject:device];
        }
        else if (_searchSettings.tipoMediawall && [device.tipo isEqualToString:[tipoNames objectForKey:@"Mediawall"]]) {
            [filteredDevices addObject:device];
        }
        else if (_searchSettings.tipoMonocolumna && [device.tipo isEqualToString:[tipoNames objectForKey:@"Monocolumna"]]) {
            [filteredDevices addObject:device];
        }
        else if (_searchSettings.tipoTelon && [device.tipo isEqualToString:[tipoNames objectForKey:@"Telanas"]]) {
            [filteredDevices addObject:device];
        }
    }
    
    
    for (Device *device in searchedDevices) {
        
        if (_searchSettings.zonaCapitalFederal && [device.zona isEqualToString:[zonaNames objectForKey:@"CapitalFederal"]]) {
            if (![filteredDevices containsObject:device]) {
                [filteredDevices addObject:device];
            }
        }
        else if (_searchSettings.zonaNorte && [device.zona isEqualToString:[zonaNames objectForKey:@"Norte"]]) {
            if (![filteredDevices containsObject:device]) {
                [filteredDevices addObject:device];
            }        }
        else if (_searchSettings.zonaOeste && [device.zona isEqualToString:[zonaNames objectForKey:@"Oeste"]]) {
            if (![filteredDevices containsObject:device]) {
                [filteredDevices addObject:device];
            }        }
        else if (_searchSettings.zonaSur && [device.zona isEqualToString:[zonaNames objectForKey:@"Sur"]]) {
            if (![filteredDevices containsObject:device]) {
                [filteredDevices addObject:device];
            }
        }
    }
    
    for (Device *device in filteredDevices) {
        if (_searchSettings.disponible && [[device.disponible uppercaseString] isEqualToString:@"SI"]) {
            [finalDevices addObject:device];
        }
        else if ((!_searchSettings.disponible) && (![[device.disponible uppercaseString] isEqualToString:@"SI"])) {
            [finalDevices addObject:device];
        }
    }
    
    return finalDevices;
}


#pragma mark - IBAction Methods
- (IBAction)actionSearchButtonpressed:(UIButton *)sender {
   
    [self.txtFieldSearch resignFirstResponder];
    [self searchDeviceIntoDataBaseWithTitleText:self.txtFieldSearch.text];
}

- (IBAction)actionDisponibleButtonPressed:(UIButton *)sender {
    if (sender.tag == 1) {
        [self.btnDisponibleSwitch setSelected:YES];
        self.searchSettings.disponible = YES;
    }
    else if (sender.tag == 2) {
        [self.btnDisponibleSwitch setSelected:NO];
        self.searchSettings.disponible = YES;
    }
    else {
        [self.btnDisponibleSwitch setSelected:![sender isSelected]];
        self.searchSettings.disponible = !self.searchSettings.disponible;
    }
}

- (IBAction)actionTipoButtonPressed:(UIButton *)sender {
    [sender setSelected:![sender isSelected]];
    
    switch (sender.tag) {
        case TipoTypeCartel:
            self.searchSettings.tipoCartel = !self.searchSettings.tipoCartel;
            break;
        case TipoTypeMediawall:
            self.searchSettings.tipoMediawall = !self.searchSettings.tipoMediawall;
            break;
        case TipoTypeMonocolumna:
            self.searchSettings.tipoMonocolumna = !self.searchSettings.tipoMonocolumna;
            break;
        case TipoTypeTelon:
            self.searchSettings.tipoTelon = !self.searchSettings.tipoTelon;
            break;
    }
}

- (IBAction)actionZonaButtonPressed:(UIButton *)sender {
    [sender setSelected:![sender isSelected]];
    
    switch (sender.tag) {
        case ZonaTypeCapitalFederal:
            self.searchSettings.zonaCapitalFederal = !self.searchSettings.zonaCapitalFederal;
            break;
        case TipoTypeMediawall:
            self.searchSettings.zonaNorte = !self.searchSettings.zonaNorte;
            break;
        case TipoTypeMonocolumna:
            self.searchSettings.zonaOeste = !self.searchSettings.zonaOeste;
            break;
        case TipoTypeTelon:
            self.searchSettings.zonaSur = !self.searchSettings.zonaSur;
            break;
    }
}

@end
