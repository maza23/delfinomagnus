//
//  AYMapInfoView.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/8/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYMapInfoView.h"
#import "Device.h"

@interface AYMapInfoView ()
@property (weak, nonatomic) IBOutlet UIView *viewInfoContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (weak, nonatomic) IBOutlet UITextView *txtViewDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblDisponibleStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewDisponible;

@end


@implementation AYMapInfoView

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
    [self.viewInfoContainer.layer setCornerRadius:15.0];
}

#pragma mark - Public Methods
- (void)configureViewWithDeviceObject:(Device *)device
{
    NSLog(@"Device title is:%@", device.titulo);
    
    [self.lblTitle setText:device.titulo];
    [self.lblSubtitle setText:device.zona];
    [self.txtViewDescription setText:device.devicedescription];
    
    if ([device.disponible isEqualToString:@"SI"]) {
        [self.imgViewDisponible setImage:[UIImage imageNamed:@"disponible.png"]];
        [self.lblDisponibleStatus setText:@"Disponible"];
    }
    else {
        [self.imgViewDisponible setImage:[UIImage imageNamed:@"no_disponible.png"]];
        [self.lblDisponibleStatus setText:@"No Disponible"];
    }
    
}

@end
