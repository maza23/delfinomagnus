//
//  AYSearchedDeviceCell.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/13/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYSearchedDeviceCell.h"
#import "Device.h"

@interface AYSearchedDeviceCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblDeviceTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewTipoType;
@end

@implementation AYSearchedDeviceCell

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
    [_lblDeviceTitle setFont:[UIFont fontWithName:@"Century Gothic" size:fontSize]];
}

#pragma mark - Public Methods
- (void)configureCellWithObject:(Device *)object
{
    [self.lblDeviceTitle setText:object.titulo];
    [self.imgViewTipoType setImage:[UIImage imageNamed:[[AYUtilites getTiposIconImageNames] objectForKey:object.tipo]]];
}

@end
