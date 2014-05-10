//
//  AYMenuView.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/8/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import "AYMenuView.h"
#import "AYUserProfileView.h"
#import "AYFavoritesView.h"

@interface AYMenuView ()
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIView *viewProfileContainer;
@property (weak, nonatomic) IBOutlet UIView *viewFavoritesContainerView;
@property (weak, nonatomic) IBOutlet UIView *viewBuscarContainerView;
@property (weak, nonatomic) IBOutlet UIView *viewLogOutContainerView;

@property (strong, nonatomic) AYUserProfileView *profileView;
@property (strong, nonatomic) AYFavoritesView *favoritesView;

@end


@implementation AYMenuView

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
    [self.btnClose setImage:[[UIImage imageNamed:@"cerrar.png"] imageWithOverlayColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *singleTapProfile = [[UITapGestureRecognizer alloc] init];
    [singleTapProfile addTarget:self action:@selector(didTappedOnMenu:)];
    [self.viewProfileContainer addGestureRecognizer:singleTapProfile];
    
    UITapGestureRecognizer *singleTapFavorites = [[UITapGestureRecognizer alloc] init];
    [singleTapFavorites addTarget:self action:@selector(didTappedOnMenu:)];
    [self.viewFavoritesContainerView addGestureRecognizer:singleTapFavorites];
    
    UITapGestureRecognizer *singleTapBuscar = [[UITapGestureRecognizer alloc] init];
    [singleTapBuscar addTarget:self action:@selector(didTappedOnMenu:)];
    [self.viewBuscarContainerView addGestureRecognizer:singleTapBuscar];
    
    UITapGestureRecognizer *singleTapLogout = [[UITapGestureRecognizer alloc] init];
    [singleTapLogout addTarget:self action:@selector(didTappedOnMenu:)];
    [self.viewLogOutContainerView addGestureRecognizer:singleTapLogout];
}

- (void)didTappedOnMenu:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.view.tag) {
        case 1:
            [self loadUserProfileView];
            break;
        case 2:
            [self loadUserFavoritesView];
            break;
        default:
            break;
    }
}

- (void)loadUserProfileView
{
    self.profileView = [[[NSBundle mainBundle] loadNibNamed:@"AYUserProfileView" owner:self options:nil] lastObject];
    [self.profileView setFrame:self.bounds];
    [self addSubview:_profileView];
}

- (void)loadUserFavoritesView
{
    self.favoritesView = [[[NSBundle mainBundle] loadNibNamed:@"AYFavoritesView" owner:self options:nil] lastObject];
    [self.favoritesView setFrame:self.bounds];
    [self addSubview:_favoritesView];
}

#pragma mark - IBAction Methods
- (IBAction)actionCloseButtonPressed:(id)sender {
    [self removeFromSuperview];
}

@end
