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

@interface AYSearchView ()
@property (weak, nonatomic) IBOutlet UITextField *txtFieldSearch;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMainContainer;
@property (strong, nonatomic) AYSearchSettings *searchSettings;

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

#pragma mark - Private Methods
- (void)doInitialConfigurations
{
    self.searchSettings = [[AYSearchSettings alloc] init];
}

#pragma mark - IBAction Methods
- (IBAction)actionMenuButtonPressed:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)actionSearchButtonpressed:(UIButton *)sender {
}

- (IBAction)actionDisponibleButtonPressed:(UIButton *)sender {
    if (sender.tag == 1) {
        self.searchSettings.disponible = YES;
    }
    else if (sender.tag == 2) {
        self.searchSettings.disponible = YES;
    }
    else {
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
