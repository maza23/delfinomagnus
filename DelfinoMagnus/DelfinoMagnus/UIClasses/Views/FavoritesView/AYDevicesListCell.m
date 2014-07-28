//
//  AYDevicesListCell.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/11/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYDevicesListCell.h"
#import "Device.h"

@interface AYDevicesListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewDeviceType;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceName;
@property (strong, nonatomic) NSString *cellType;
@end


@implementation AYDevicesListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    float fontSize = kIsDeviceiPad ? 17.0f : 14.0f;
    [_lblDeviceName setFont:[UIFont fontWithName:@"century" size:fontSize]];
}

#pragma mark - Public Methods
- (void)configureCellWithObject:(Device *)object  isDeviceReserved:(BOOL)isReserved
{
    NSString *imageName = isReserved ? @"marker.png" : @"marker_un.png";
    [self.lblDeviceName setText:object.titulo];
    [self.imgViewDeviceType setImage:[UIImage imageNamed:imageName]];
    self.cellType = object.tipo;
    
    [self layoutIfNeeded];
}

@end
