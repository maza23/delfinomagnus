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
#import "AYFavoritesView.h"

@interface AYUserProfileView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDesignation;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailId;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblImpressea;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) AYFavoritesView *favoritesView;

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
    
    [self.imgViewProfilePic.layer setBorderColor:[[UIColor redColor] CGColor]];
    [self.imgViewProfilePic.layer setBorderWidth:2.0f];
    [self.imgViewProfilePic.layer setCornerRadius:self.imgViewProfilePic.frame.size.width/2];
}

- (void)startDownloadingImage
{
    NSString *urlString  = [NSString stringWithFormat:@"%@/%@", self.userDetails.urlimgs, self.userDetails.image_file];
    
    [self.imgViewProfilePic setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [self.imgViewProfilePic setImage:image];
            [self.activityIndicator stopAnimating];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [self.activityIndicator stopAnimating];
    }];
}

- (void)loadUserFavoritesView
{
    self.favoritesView = [[[NSBundle mainBundle] loadNibNamed:@"AYFavoritesView" owner:self options:nil] lastObject];
    [self.favoritesView setFrame:self.bounds];
    [self addSubview:_favoritesView];
}

#pragma mark - IBAction Methods
- (IBAction)actionTopMenuButtonPressed:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)actionFavoritesButtonPressed:(id)sender {
    [self loadUserFavoritesView];
}

@end
