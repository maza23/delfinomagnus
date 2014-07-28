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
@property (weak, nonatomic) IBOutlet UILabel *lblTipoHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnCartel;
@property (weak, nonatomic) IBOutlet UIButton *btnMonocolumna;
@property (weak, nonatomic) IBOutlet UIButton *btnMediawall;
@property (weak, nonatomic) IBOutlet UIButton *btnTelon;
@property (weak, nonatomic) IBOutlet UILabel *lblZonaHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnCapitalFederal;
@property (weak, nonatomic) IBOutlet UIButton *btnNorte;
@property (weak, nonatomic) IBOutlet UIButton *btnOeste;
@property (weak, nonatomic) IBOutlet UIButton *btnSur;
@property (weak, nonatomic) IBOutlet UIButton *btnDisponible;
@property (weak, nonatomic) IBOutlet UIButton *btnNoDisponible;
@property (strong, nonatomic) AYSearchSettings *searchSettings;
@property (strong, nonatomic) AYDevicesListView *devicesListView;
@property (weak, nonatomic) IBOutlet UIButton *btnDisponibleSwitch;

- (IBAction)actionTipoButtonPressed:(id)sender;
- (IBAction)actionZonaButtonPressed:(id)sender;
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
}

#pragma mark - Private Methods
- (void)doInitialConfigurations
{
    self.searchSettings = [[AYSearchSettings alloc] init];

    UIFont *font = [AYUtilites fontWithSize:11.0 andiPadSize:15.0];
    [_txtFieldSearch setFont:font];
    [_lblTipoHeader setFont:[AYUtilites fontWithSize:15.0 andiPadSize:18.0f]];
    [_lblZonaHeader setFont:[AYUtilites fontWithSize:15.0 andiPadSize:18.0f]];
    [_btnCartel.titleLabel setFont:font];
    [_btnMonocolumna.titleLabel setFont:font];
    [_btnMediawall.titleLabel setFont:font];
    [_btnTelon.titleLabel setFont:font];
    [_btnCapitalFederal.titleLabel setFont:font];
    [_btnNorte.titleLabel setFont:font];
    [_btnOeste.titleLabel setFont:font];
    [_btnSur.titleLabel setFont:font];
    [_btnDisponible.titleLabel setFont:font];
    [_btnNoDisponible.titleLabel setFont:font];
}

- (void)searchDeviceIntoDataBaseWithTitleText:(NSString *)text
{
    NSArray *searchedDevices = nil;
    
    if ([text length]) {
        searchedDevices = [[LTCoreDataManager sharedInstance] getMatchedRecordFromEntity:kDevicesEntityName forColumnName:@"titulo" withValueToMatch:text];
    }
    else {
        searchedDevices = [[LTCoreDataManager sharedInstance] getAllRecordsFromEntity:kDevicesEntityName];
    }
    
    NSArray *filteredDevices = nil;
    
    if ([self isAnySettingsButtonSelected]) {
        filteredDevices =  [self getFilteredSearchDevicesFromArray:searchedDevices];
    }
    else {
        NSMutableArray *finalDevices = [[NSMutableArray alloc]  initWithCapacity:0];
        
        for (Device *device in searchedDevices) {
            if (_searchSettings.disponible && [[device.disponible uppercaseString] isEqualToString:@"SI"]) {
                [finalDevices addObject:device];
            }
            else if ((!_searchSettings.disponible) && (![[device.disponible uppercaseString] isEqualToString:@"SI"])) {
                [finalDevices addObject:device];
            }
        }
        
        filteredDevices = finalDevices;
    }
    
    if (![filteredDevices count]) {
        return;
    }
    
    [self loadDevicesListViewWithDevices:filteredDevices];
}

- (void)loadDevicesListViewWithDevices:(NSArray *)devices
{    
    self.devicesListView = [[[NSBundle mainBundle] loadNibNamed:@"AYDevicesListView" owner:self options:nil] lastObject];
    
    UIView *parentView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    CGRect frame = [parentView bounds];
    
    [self.devicesListView setFrame:frame];
    [parentView addSubview:self.devicesListView];
    
    [self.devicesListView loadDevicesListFromDevices:devices];

}

- (BOOL)isAnySettingsButtonSelected
{
    if (_searchSettings.tipoCartel) { return YES;}
    else if (_searchSettings.tipoMediawall) { return YES;}
    else if (_searchSettings.tipoMonocolumna) { return YES;}
    else if (_searchSettings.tipoTelon) { return YES;}
    else if (_searchSettings.zonaCapitalFederal) { return YES;}
    else if (_searchSettings.zonaNorte) { return YES;}
    else if (_searchSettings.zonaOeste) { return YES;}
    else if (_searchSettings.zonaSur ) { return YES;}
   
    return NO;
}

- (NSArray *)getFilteredSearchDevicesFromArray:(NSArray *)searchedDevices
{
    NSMutableArray *finalDevices = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *prefinalDevices = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *filteredDevices = [[NSMutableArray alloc]  initWithCapacity:0];
    NSDictionary *tipoNames = [AYUtilites getTiposIdAsObjectAndNameAsDictKeys];
    NSDictionary *zonaNames = [AYUtilites getZonaIdAsObjectAndNameAsDictKeys];
    if(!_searchSettings.tipoCartel && !_searchSettings.tipoMediawall && !_searchSettings.tipoMonocolumna && !_searchSettings.tipoTelon){
        [filteredDevices addObjectsFromArray:searchedDevices];
    }
    else{
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
            else if (_searchSettings.tipoTelon && [device.tipo isEqualToString:[tipoNames objectForKey:@"Telon"]]) {
                [filteredDevices addObject:device];
            }
        }
    }
    if (!_searchSettings.zonaCapitalFederal && !_searchSettings.zonaNorte && !_searchSettings.zonaOeste && !_searchSettings.zonaSur) {
        [prefinalDevices addObjectsFromArray:filteredDevices];
    }
    else{
        for (Device *device in filteredDevices) {
            
            if (_searchSettings.zonaCapitalFederal && [device.zona isEqualToString:[zonaNames objectForKey:@"CapitalFederal"]]) {
                [prefinalDevices addObject:device];
                
            }
            else if (_searchSettings.zonaNorte && [device.zona isEqualToString:[zonaNames objectForKey:@"Norte"]]) {
                    [prefinalDevices addObject:device];
                }
            else if (_searchSettings.zonaOeste && [device.zona isEqualToString:[zonaNames objectForKey:@"Oeste"]]) {
                
                    [prefinalDevices addObject:device];
                        }
            else if (_searchSettings.zonaSur && [device.zona isEqualToString:[zonaNames objectForKey:@"Sur"]]) {
                
                    [prefinalDevices addObject:device];
                
            }
        }
    }
    for (Device *device in prefinalDevices) {
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
- (IBAction)actionBottomSearchButtonPressed:(id)sender {
    
    [self.txtFieldSearch resignFirstResponder];
    [self searchDeviceIntoDataBaseWithTitleText:self.txtFieldSearch.text];
}

- (IBAction)actionTopSearchButtonPressed:(id)sender {
   
    [self.txtFieldSearch resignFirstResponder];

    NSArray *searchedDevices = [[LTCoreDataManager sharedInstance] getMatchedRecordFromEntity:kDevicesEntityName forColumnName:@"titulo" withValueToMatch:self.txtFieldSearch.text];
    
    if (![searchedDevices count]) {
        return;
    }
    
    [self loadDevicesListViewWithDevices:searchedDevices];
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
        case ZonaTypeNorte:
            self.searchSettings.zonaNorte = !self.searchSettings.zonaNorte;
            break;
        case ZonaTypeOeste:
            self.searchSettings.zonaOeste = !self.searchSettings.zonaOeste;
            break;
        case ZonaTypeSur:
            self.searchSettings.zonaSur = !self.searchSettings.zonaSur;
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
