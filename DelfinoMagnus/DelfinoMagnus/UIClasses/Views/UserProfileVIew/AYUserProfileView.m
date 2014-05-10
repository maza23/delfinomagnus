//
//  AYUserProfileView.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/10/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYUserProfileView.h"
#import "NZCircularImageView.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface AYUserProfileView ()

@property (weak, nonatomic) IBOutlet NZCircularImageView *imgViewProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDesignation;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailId;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblImpressea;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) User *userDetails;
@end


@implementation AYUserProfileView

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
    self.userDetails = [[[LTCoreDataManager sharedInstance] getAllRecordsFromEntity:kUserEntityName] lastObject];
    
    if (self.userDetails) {
        [self loadUIFromUserDetails];
    }
}

- (void)loadUIFromUserDetails
{
    [self startDownloadingImage];
    [self.lblName setText:self.userDetails.nombre];
    [self.lblDesignation setText:self.userDetails.actividad];
    [self.lblEmailId setText:self.userDetails.email];
    [self.lblImpressea setText:self.userDetails.empresa];
    [self.lblAddress setText:self.userDetails.direccion];
}

- (void)startDownloadingImage
{
    NSString *urlString  = [NSString stringWithFormat:@"%@/%@", self.userDetails.urlimgs, self.userDetails.image_file];
    
    [self.imgViewProfilePic setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imgViewProfilePic setImage:image];
            [self.activityIndicator stopAnimating];
        });
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
        });
    }];
}


#pragma mark - IBAction Methods
- (IBAction)actionTopMenuButtonPressed:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)actionFavoritesButtonPressed:(id)sender {
}
@end
