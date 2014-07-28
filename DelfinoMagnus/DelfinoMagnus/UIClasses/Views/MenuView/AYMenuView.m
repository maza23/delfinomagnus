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
#import "AYLoginViewController.h"
#import "AYDeviceSearchView.h"
#import "AYDeviceSearchView.h"

@interface AYMenuView ()
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIView *viewProfileContainer;
@property (weak, nonatomic) IBOutlet UIView *viewFavoritesContainerView;
@property (weak, nonatomic) IBOutlet UIView *viewBuscarContainerView;
@property (weak, nonatomic) IBOutlet UIView *viewLogOutContainerView;

@property (strong, nonatomic) AYUserProfileView *profileView;
@property (strong, nonatomic) AYFavoritesView *favoritesView;
@property (strong, nonatomic) AYDeviceSearchView *searchView;

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
    [self.btnClose setImage:[[UIImage imageNamed:@"cerrar.png"] imageWithOverlayColor:[UIColor colorWithRed:225.0/255.0 green:164.0/255.0 blue:74.0/255.0 alpha:1.0]] forState:UIControlStateNormal];

    UIFont *font = [AYUtilites fontWithSize:12.0 andiPadSize:17.0];
    [(UILabel *)[self viewWithTag:11] setFont:[AYUtilites fontWithSize:15.0 andiPadSize:20.0]];
    [(UILabel *)[self viewWithTag:12] setFont:font];
    [(UILabel *)[self viewWithTag:13] setFont:font];
    [(UILabel *)[self viewWithTag:14] setFont:font];

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
        case 3:
            [self loadSearchView];
            break;
        case 4:
            [self logOutAndRedirectToLoginView];
            break;
        default:
            break;
    }
}

- (void)loadUserProfileView
{
    NSString *nibName = kIsDeviceiPad ? @"AYUserProfileView~iPad": @"AYUserProfileView";
    self.profileView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] lastObject];
    [self.profileView setFrame:self.bounds];
    [self addSubview:_profileView];
}

- (void)loadUserFavoritesView
{
    NSString *nibName = kIsDeviceiPad ? @"AYFavoritesView~iPad": @"AYFavoritesView";

    self.favoritesView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] lastObject];
    [self.favoritesView setFrame:self.bounds];
    [self addSubview:_favoritesView];
}

- (void)loadSearchView
{
    self.searchView = [[[NSBundle mainBundle]  loadNibNamed:@"AYDeviceSearchView" owner:self options:nil] lastObject];
    [self.searchView setFrame:self.bounds];
    [self addSubview:self.searchView];
    [self.searchView layoutIfNeeded];
}

- (void)logOutAndRedirectToLoginView
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"password"];
    [[NSUserDefaults standardUserDefaults]  synchronize];
    
    AYLoginViewController *loginVC = [[AYLoginViewController alloc] initWithNibName:@"AYLoginViewController" bundle:nil];
    [loginVC setDelegate:[[UIApplication sharedApplication] delegate]];
    [self.window setRootViewController:loginVC];
}

#pragma mark - IBAction Methods
- (IBAction)actionCloseButtonPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didPressedCloseButtonOnView:)]) {
        [self.delegate didPressedCloseButtonOnView:self];
    }
    
    [self removeFromSuperview];
}

@end
