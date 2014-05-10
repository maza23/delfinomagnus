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

#pragma mark - Public Methods
- (void)configureCellWithObject:(Device *)object
{
    [self.lblDeviceName setText:object.titulo];
    [self.imgViewDeviceType setImage:[UIImage imageNamed:@"marker_un.png"]];
    [self layoutIfNeeded];
}

@end
