//
//  AYFavoritesTipoCell.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/11/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYFavoritesTipoCell.h"

@interface AYFavoritesTipoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgVIewTipo;
@property (weak, nonatomic) IBOutlet UILabel *lblTipoName;
@property (weak, nonatomic) IBOutlet UIView *viewNumberOfDevices;
@property (weak, nonatomic) IBOutlet UILabel *lblNumerOfDevices;
@end

@implementation AYFavoritesTipoCell

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
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self doInitialConfigurations];
}

#pragma mark - Public Methods
- (void)configureCellWithObject:(NSDictionary *)object
{
    [self.imgVIewTipo setImage:[UIImage imageNamed:[object objectForKey:@"ImageName"]]];
    [self.lblTipoName setText:[object objectForKey:@"Title"]];
    [self.lblNumerOfDevices setText:[NSString stringWithFormat:@"%d", [[object objectForKey:@"Devices"] count]]];
    
    [self layoutIfNeeded];
}

- (NSString *)getTitleText
{
    return self.lblTipoName.text;
}


#pragma mark - Private Methods
- (void)doInitialConfigurations
{
    [self.viewNumberOfDevices.layer setCornerRadius:self.viewNumberOfDevices.frame.size.width/2];
}

@end
